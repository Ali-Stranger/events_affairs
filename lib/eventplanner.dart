

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'drawer.dart';
import 'venuecontact.dart';
import 'saved_vendors_repository.dart';

// ═══════════════════════════════════════════════════════════════
//  DATA MODEL
// ═══════════════════════════════════════════════════════════════

class EventPlannerVendor {
  final String name;
  final String location;
  final String category;
  final double rating;
  final int reviews;
  final String price;
  final double priceValue;
  final String experience;
  final String image;
  final List<String> services;
  final String phone;
  final String description;
  final String capacity;

  const EventPlannerVendor({
    required this.name,
    required this.location,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.priceValue,
    required this.experience,
    required this.image,
    required this.services,
    required this.phone,
    required this.description,
    required this.capacity,
  });

  /// Factory constructor to build from a Firestore document snapshot
  factory EventPlannerVendor.fromFirestore(Map<String, dynamic> data) {
    // Parse services — stored as List<String> or fallback to empty list
    List<String> servicesList = [];
    if (data['services'] != null) {
      servicesList = List<String>.from(data['services']);
    }

    String? startingPriceRaw;
    double parsedPriceValue = 0;

    if (data['startingPrice'] != null) {
      final sp = data['startingPrice'];
      if (sp is num) {
        startingPriceRaw = sp.toString();
        parsedPriceValue = sp.toDouble();
      } else {
        startingPriceRaw = sp.toString().trim();
        final cleaned = startingPriceRaw
            .replaceAll(RegExp(r'pkR', caseSensitive: false), '')
            .replaceAll(RegExp(r'rs\\.?', caseSensitive: false), '')
            .replaceAll(',', '')
            .replaceAll(' ', '')
            .trim();
        parsedPriceValue = double.tryParse(cleaned) ?? 0;
      }
    }

    if (parsedPriceValue == 0 && data['priceValue'] != null) {
      try {
        parsedPriceValue = (data['priceValue'] as num).toDouble();
      } catch (_) {
        parsedPriceValue = 0;
      }
    }

    if (parsedPriceValue == 0 && data['price'] != null) {
      try {
        final priceStr = data['price'].toString();
        final cleaned = priceStr
            .replaceAll(RegExp(r'pkR', caseSensitive: false), '')
            .replaceAll(RegExp(r'rs\\.?', caseSensitive: false), '')
            .replaceAll(',', '')
            .replaceAll(' ', '')
            .trim();
        parsedPriceValue = double.tryParse(cleaned) ?? 0;
      } catch (_) {
        parsedPriceValue = 0;
      }
    }

    String capacityStr = (data['capacity'] ?? '').toString().trim();
    if (capacityStr.isEmpty) {
      capacityStr = 'Contact for guest capacity';
    }

    String priceLabel = data['price']?.toString() ?? 'Contact for price';
    if (startingPriceRaw != null && startingPriceRaw.isNotEmpty) {
      final lower = startingPriceRaw.toLowerCase();
      if (lower.contains('pkr') ||
          lower.startsWith('rs') ||
          lower.contains('rs ')) {
        priceLabel = startingPriceRaw;
      } else {
        priceLabel = 'PKR $startingPriceRaw';
      }
    }

    return EventPlannerVendor(
      name: data['businessName'] ?? data['name'] ?? 'Unknown Vendor',
      location: data['city'] ?? data['location'] ?? 'Pakistan',
      category: data['businessCategory'] ?? data['category'] ?? 'Event Planner',
      rating: data['rating'] != null ? (data['rating'] as num).toDouble() : 0.0,
      reviews: data['reviews'] != null ? (data['reviews'] as num).toInt() : 0,
      price: priceLabel,
      priceValue: parsedPriceValue,
      experience: data['experience'] ?? 'New',
      image: data['image'] ?? 'assets/images/download.jpg',
      services: servicesList,
      phone: data['phone'] ?? '',
      description: data['description'] ?? '',
      capacity: capacityStr,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  CONSTANTS
// ═══════════════════════════════════════════════════════════════

const Color kPrimary = Color(0xffB4245D);

const List<String> kLocations = [
  "Lahore",
  "Karachi",
  "Islamabad",
  "Multan",
  "Peshawar",
  "Faisalabad",
  "Rawalpindi",
  "Quetta",
];

const List<String> kCategories = [
  "All",
  "Event Planner",
  "Catering",
  "Photography",
  "Decoration / Florist",
  "Banquet Hall",
  "Marquee",
  "Farm House",
  "Videography",
  "Makeup Artist",
  "DJ / Entertainment",
];

const List<String> kSortOptions = [
  "Recommended",
  "Price: Low to High",
  "Price: High to Low",
  "Top Rated",
  "Most Reviewed",
];

// ═══════════════════════════════════════════════════════════════
//  EVENTPLANNER PAGE
// ═══════════════════════════════════════════════════════════════

class Eventplanner extends StatefulWidget {
  const Eventplanner({super.key});

  @override
  State<Eventplanner> createState() => _EventplannerState();
}

class _EventplannerState extends State<Eventplanner> {
  // Firestore data (vendor account doc id → model)
  Map<String, EventPlannerVendor> _vendorById = {};
  List<String> _vendorIdsInOrder = [];
  bool _isLoading = true;
  String? _error;

  // Filters
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String? _selectedLocation;
  String _selectedCategory = 'All';
  double _maxPrice = 1000000;
  String _sortBy = 'Recommended';
  Set<String> _favoriteVendorIds = {};

  @override
  void initState() {
    super.initState();
    _fetchVendors();
    _loadFavoriteIds();
  }

  Future<void> _loadFavoriteIds() async {
    final ids = await SavedVendorsRepository.loadIdSet();
    if (mounted) setState(() => _favoriteVendorIds = ids);
  }

  Future<void> _toggleFavorite(String vendorDocId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign in to save vendors to your list.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final remove = _favoriteVendorIds.contains(vendorDocId);
    try {
      if (remove) {
        await SavedVendorsRepository.removeVendor(vendorDocId);
      } else {
        await SavedVendorsRepository.addVendor(vendorDocId);
      }
      if (!mounted) return;
      setState(() {
        if (remove) {
          _favoriteVendorIds.remove(vendorDocId);
        } else {
          _favoriteVendorIds.add(vendorDocId);
        }
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not update saved vendors.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ── Fetch vendors from Firestore ──────────────────────────────────────────
  Future<void> _fetchVendors() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Query the 'users' collection where role == 'vendor'
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'vendor')
          .get();

      final docs = snapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return _isVisibleVendor(data);
      }).toList();
      final byId = <String, EventPlannerVendor>{
        for (final doc in docs)
          doc.id: EventPlannerVendor.fromFirestore(
            doc.data() as Map<String, dynamic>,
          ),
      };
      final order = docs.map((d) => d.id).toList();

      setState(() {
        _vendorById = byId;
        _vendorIdsInOrder = order;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load vendors. Please try again.';
        _isLoading = false;
      });
    }
  }

  // ── Filtered & sorted vendor ids ─────────────────────────────────────────
  List<String> get _filteredVendorIds {
    final ids = _vendorIdsInOrder.where((id) {
      final v = _vendorById[id]!;
      final matchSearch =
          _searchQuery.isEmpty ||
          v.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchLoc =
          _selectedLocation == null || v.location == _selectedLocation;
      final matchCat =
          _selectedCategory == 'All' || v.category == _selectedCategory;
      // Only show vendors with a valid price within the budget
      final matchPrice = v.priceValue > 0 && v.priceValue <= _maxPrice;
      return matchSearch && matchLoc && matchCat && matchPrice;
    }).toList();

    switch (_sortBy) {
      case 'Price: Low to High':
        ids.sort(
          (a, b) =>
              _vendorById[a]!.priceValue.compareTo(_vendorById[b]!.priceValue),
        );
        break;
      case 'Price: High to Low':
        ids.sort(
          (a, b) =>
              _vendorById[b]!.priceValue.compareTo(_vendorById[a]!.priceValue),
        );
        break;
      case 'Top Rated':
        ids.sort(
          (a, b) => _vendorById[b]!.rating.compareTo(_vendorById[a]!.rating),
        );
        break;
      case 'Most Reviewed':
        ids.sort(
          (a, b) => _vendorById[b]!.reviews.compareTo(_vendorById[a]!.reviews),
        );
        break;
    }
    return ids;
  }

  void _resetFilters() {
    _searchCtrl.clear();
    setState(() {
      _searchQuery = '';
      _selectedLocation = null;
      _selectedCategory = 'All';
      _maxPrice = 1000000;
      _sortBy = 'Recommended';
    });
  }

  bool _isVisibleVendor(Map<String, dynamic> data) {
    final approvedValue = data['approved'];
    final bool isApproved =
        approvedValue == true ||
        (approvedValue is String && approvedValue.toLowerCase() == 'true');
    final suspendedValue = data['suspended'];
    final bool isSuspended =
        suspendedValue == true ||
        (suspendedValue is String && suspendedValue.toLowerCase() == 'true');
    return isApproved && !isSuspended;
  }

  String _formatPrice(double v) {
    if (v >= 1000000) return 'PKR 10,00,000';
    return 'PKR ${v.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendorIds = _filteredVendorIds;

    return Scaffold(
      drawer: const CommonDrawer(),
      appBar: const CommonAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _error != null
                ? _buildErrorState()
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header ──────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Builder(
                                builder: (ctx) => IconButton(
                                  icon: const Icon(Icons.menu),
                                  onPressed: () =>
                                      Scaffold.of(ctx).openDrawer(),
                                ),
                              ),
                              Image.asset(
                                'assets/images/logo.png',
                                width: 80,
                                height: 80,
                              ),
                            ],
                          ),
                        ),

                        // ── Title banner ─────────────────────────────────
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kPrimary.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: kPrimary.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Find Event Vendors',
                                style: TextStyle(
                                  color: kPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_vendorIdsInOrder.length} verified vendors across Pakistan',
                                style: TextStyle(
                                  color: kPrimary.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Search bar ───────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (v) => setState(() => _searchQuery = v),
                            decoration: InputDecoration(
                              hintText: 'Search vendors by name...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: kPrimary,
                                size: 20,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 18),
                                      onPressed: () {
                                        _searchCtrl.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: kPrimary,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: kPrimary.withOpacity(0.3),
                                ),
                              ),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── Category chips ────────────────────────────────
                        SizedBox(
                          height: 38,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: kCategories.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (_, i) {
                              final cat = kCategories[i];
                              final isSelected = _selectedCategory == cat;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedCategory = cat),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? kPrimary
                                        : kPrimary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? kPrimary
                                          : kPrimary.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    cat,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : kPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── Location + Sort row ───────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: _filterDropdown<String>(
                                  value: _selectedLocation,
                                  hint: 'All Cities',
                                  icon: Icons.location_on_outlined,
                                  items: kLocations,
                                  onChanged: (v) =>
                                      setState(() => _selectedLocation = v),
                                  showClear: _selectedLocation != null,
                                  onClear: () =>
                                      setState(() => _selectedLocation = null),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _filterDropdown<String>(
                                  value: _sortBy,
                                  hint: 'Sort By',
                                  icon: Icons.sort,
                                  items: kSortOptions,
                                  onChanged: (v) => setState(
                                    () => _sortBy = v ?? 'Recommended',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ── Price slider ──────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: kPrimary.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Max Budget',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: kPrimary,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: kPrimary,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _formatPrice(_maxPrice),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Slider(
                                  value: _maxPrice,
                                  min: 10000,
                                  max: 1000000,
                                  divisions: 99,
                                  activeColor: kPrimary,
                                  inactiveColor: kPrimary.withOpacity(0.15),
                                  onChanged: (v) =>
                                      setState(() => _maxPrice = v),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'PKR 10,000',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    Text(
                                      'PKR 10,00,000',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── Results row ───────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text(
                                '${vendorIds.length} vendor${vendorIds.length == 1 ? '' : 's'} found',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              if (_searchQuery.isNotEmpty ||
                                  _selectedLocation != null ||
                                  _selectedCategory != 'All' ||
                                  _maxPrice < 1000000)
                                TextButton.icon(
                                  onPressed: _resetFilters,
                                  icon: const Icon(
                                    Icons.refresh,
                                    size: 14,
                                    color: kPrimary,
                                  ),
                                  label: const Text(
                                    'Reset',
                                    style: TextStyle(
                                      color: kPrimary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ── Vendor cards ──────────────────────────────────
                        vendorIds.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 40,
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'No vendors found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextButton(
                                        onPressed: _resetFilters,
                                        child: const Text(
                                          'Clear all filters',
                                          style: TextStyle(color: kPrimary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: vendorIds.length,
                                itemBuilder: (ctx, i) {
                                  final id = vendorIds[i];
                                  final vendor = _vendorById[id]!;
                                  return EventPlannerVendorCard(
                                    vendor: vendor,
                                    isFavorite: _favoriteVendorIds.contains(id),
                                    onFavoriteToggle: () => _toggleFavorite(id),
                                  );
                                },
                              ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Loading state ─────────────────────────────────────────────────────────
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: kPrimary),
          SizedBox(height: 16),
          Text(
            'Loading vendors...',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ── Error state ───────────────────────────────────────────────────────────
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              _error ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _fetchVendors,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Filter dropdown widget ────────────────────────────────────────────────
  Widget _filterDropdown<T>({
    required T? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required ValueChanged<T?> onChanged,
    bool showClear = false,
    VoidCallback? onClear,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: kPrimary.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: kPrimary),
          const SizedBox(width: 4),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                hint: Text(
                  hint,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                items: items
                    .map(
                      (v) => DropdownMenuItem<T>(
                        value: v as T,
                        child: Text(v, style: const TextStyle(fontSize: 12)),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
          if (showClear)
            GestureDetector(
              onTap: onClear,
              child: const Icon(Icons.close, size: 16, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  VENDOR CARD (shared with VenuesPage)
// ═══════════════════════════════════════════════════════════════

class EventPlannerVendorCard extends StatelessWidget {
  final EventPlannerVendor vendor;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const EventPlannerVendorCard({
    super.key,
    required this.vendor,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VenueContactPage(
            name: vendor.name,
            location: vendor.location,
            price: vendor.price,
            image: vendor.image,
            category: vendor.category,
            rating: vendor.rating,
            reviews: vendor.reviews,
            capacity: vendor.capacity,
            amenities: vendor.services,
            description: vendor.description,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ──────────────────────────────────────────────
              Stack(
                children: [
                  // Use network image if URL, else asset
                  vendor.image.startsWith('http')
                      ? Image.network(
                          vendor.image,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _imagePlaceholder(),
                        )
                      : Image.asset(
                          vendor.image,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _imagePlaceholder(),
                        ),
                  // Gradient
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.55),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Category badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        vendor.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Favorite
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  // Rating bottom-left
                  Positioned(
                    bottom: 8,
                    left: 10,
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          vendor.rating > 0
                              ? '${vendor.rating} (${vendor.reviews})'
                              : 'New',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Price bottom-right
                  Positioned(
                    bottom: 8,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        vendor.price,
                        style: const TextStyle(
                          color: kPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ── Details ────────────────────────────────────────────
              Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            vendor.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: kPrimary,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              vendor.location,
                              style: const TextStyle(
                                color: kPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (vendor.experience.isNotEmpty &&
                        vendor.experience != 'New')
                      Row(
                        children: [
                          const Icon(
                            Icons.work_outline,
                            size: 13,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${vendor.experience} experience',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    // Services chips
                    vendor.services.isEmpty
                        ? Text(
                            vendor.description.isNotEmpty
                                ? vendor.description
                                : 'Contact for more details',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          )
                        : Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: vendor.services.map((s) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: kPrimary.withOpacity(0.07),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: kPrimary.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  s,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: kPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                    const SizedBox(height: 12),
                    // CTA button
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VenueContactPage(
                              name: vendor.name,
                              location: vendor.location,
                              price: vendor.price,
                              image: vendor.image,
                              category: vendor.category,
                              rating: vendor.rating,
                              reviews: vendor.reviews,
                              capacity: vendor.capacity,
                              amenities: vendor.services,
                              description: vendor.description,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.visibility_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                        label: const Text(
                          'View Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 160,
      color: kPrimary.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.store_rounded, size: 50, color: kPrimary),
          const SizedBox(height: 8),
          Text(
            vendor.name,
            style: const TextStyle(color: kPrimary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
