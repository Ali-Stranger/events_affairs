import 'package:flutter/material.dart';
import 'drawer.dart';
import 'venuecontact.dart';
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
  });
}

// ═══════════════════════════════════════════════════════════════
//  VENDOR DATA
// ═══════════════════════════════════════════════════════════════

const List<EventPlannerVendor> allVendors = [
  EventPlannerVendor(
    name: "Al-Noor Events",
    location: "Lahore",
    category: "Wedding",
    rating: 4.9,
    reviews: 212,
    price: "PKR 80,000",
    priceValue: 80000,
    experience: "8 years",
    image: "assets/images/download.jpg",
    phone: "+92 300 1234567",
    services: ["Full Event Planning", "Decoration", "Catering Coordination"],
    description:
        "Al-Noor Events is Lahore's most trusted wedding planning company with over 8 years of experience crafting unforgettable celebrations.",
  ),
  EventPlannerVendor(
    name: "Dream Décor Co.",
    location: "Karachi",
    category: "Decoration",
    rating: 4.7,
    reviews: 145,
    price: "PKR 50,000",
    priceValue: 50000,
    experience: "5 years",
    image: "assets/images/download.jpg",
    phone: "+92 321 9876543",
    services: ["Stage Décor", "Floral Arrangements", "Lighting"],
    description:
        "Dream Décor Co. transforms venues into magical spaces using fresh flowers, creative lighting, and bespoke stage designs.",
  ),
  EventPlannerVendor(
    name: "Lens & Light Studio",
    location: "Islamabad",
    category: "Photography",
    rating: 4.8,
    reviews: 98,
    price: "PKR 120,000",
    priceValue: 120000,
    experience: "6 years",
    image: "assets/images/download.jpg",
    phone: "+92 333 5556677",
    services: ["Photography", "Videography", "Drone Shots", "Albums"],
    description:
        "Lens & Light Studio captures your most precious moments with cinematic precision and artistic storytelling.",
  ),
  EventPlannerVendor(
    name: "Spice Garden Catering",
    location: "Lahore",
    category: "Catering",
    rating: 4.6,
    reviews: 310,
    price: "PKR 35,000",
    priceValue: 35000,
    experience: "10 years",
    image: "assets/images/download.jpg",
    phone: "+92 42 1234567",
    services: ["Full Buffet", "Live Stations", "Dessert Bar", "Staffing"],
    description:
        "Spice Garden has been delighting guests for over a decade with authentic Pakistani cuisine and premium continental menus.",
  ),
  EventPlannerVendor(
    name: "Grand Marquee Events",
    location: "Multan",
    category: "Wedding",
    rating: 4.5,
    reviews: 87,
    price: "PKR 200,000",
    priceValue: 200000,
    experience: "12 years",
    image: "assets/images/download.jpg",
    phone: "+92 61 9998887",
    services: ["Venue", "Catering", "Decoration", "Photography Package"],
    description:
        "Grand Marquee Events offers complete wedding packages in Multan, taking care of every detail from venue to farewell.",
  ),
  EventPlannerVendor(
    name: "Bloom Florists",
    location: "Karachi",
    category: "Decoration",
    rating: 4.8,
    reviews: 176,
    price: "PKR 30,000",
    priceValue: 30000,
    experience: "7 years",
    image: "assets/images/download.jpg",
    phone: "+92 300 7778889",
    services: ["Floral Installations", "Bridal Bouquets", "Table Centerpieces"],
    description:
        "Bloom Florists specialises in breathtaking floral designs, from ceiling installations to intricate bridal bouquets.",
  ),
  EventPlannerVendor(
    name: "Capital Clicks",
    location: "Islamabad",
    category: "Photography",
    rating: 4.6,
    reviews: 64,
    price: "PKR 75,000",
    priceValue: 75000,
    experience: "4 years",
    image: "assets/images/download.jpg",
    phone: "+92 51 3334445",
    services: ["Photography", "Same-Day Edit", "Highlight Reel"],
    description:
        "Capital Clicks delivers stunning same-day edits and highlight reels, so you can relive your event before the night ends.",
  ),
  EventPlannerVendor(
    name: "Punjab Caterers",
    location: "Lahore",
    category: "Catering",
    rating: 4.4,
    reviews: 230,
    price: "PKR 20,000",
    priceValue: 20000,
    experience: "15 years",
    image: "assets/images/download.jpg",
    phone: "+92 300 2223334",
    services: ["Traditional Menu", "Biryani Counter", "Desi Desserts"],
    description:
        "Punjab Caterers brings authentic desi flavours to your event — the biryani alone is worth booking them for.",
  ),
];

// ═══════════════════════════════════════════════════════════════
//  CONSTANTS
// ═══════════════════════════════════════════════════════════════

const Color kPrimary = Color(0xffB4245D);

const List<String> kLocations = [
  "Lahore",
  "Karachi",
  "Islamabad",
  "Multan",
];

const List<String> kCategories = [
  "All",
  "Wedding",
  "Catering",
  "Photography",
  "Decoration",
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
  // Filters
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String? _selectedLocation;
  String _selectedCategory = 'All';
  double _maxPrice = 1000000;
  String _sortBy = 'Recommended';
  final Set<String> _favorites = {};

  // ── Filtered & sorted vendor list ────────────────────────────────────────
  List<EventPlannerVendor> get _filteredVendors {
    List<EventPlannerVendor> list = allVendors.where((v) {
      final matchSearch = _searchQuery.isEmpty ||
          v.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchLoc =
          _selectedLocation == null || v.location == _selectedLocation;
      final matchCat =
          _selectedCategory == 'All' || v.category == _selectedCategory;
      final matchPrice = v.priceValue <= _maxPrice;
      return matchSearch && matchLoc && matchCat && matchPrice;
    }).toList();

    switch (_sortBy) {
      case 'Price: Low to High':
        list.sort((a, b) => a.priceValue.compareTo(b.priceValue));
        break;
      case 'Price: High to Low':
        list.sort((a, b) => b.priceValue.compareTo(a.priceValue));
        break;
      case 'Top Rated':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Most Reviewed':
        list.sort((a, b) => b.reviews.compareTo(a.reviews));
        break;
    }
    return list;
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

  String _formatPrice(double v) {
    if (v >= 1000000) return 'PKR 10,00,000';
    return 'PKR ${v.round().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        )}';
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendors = _filteredVendors;

    return Scaffold(
      drawer: const CommonDrawer(),
      appBar: const CommonAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Header ─────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Builder(
                          builder: (ctx) => IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () => Scaffold.of(ctx).openDrawer(),
                          ),
                        ),
                        Image.asset('assets/images/logo.png',
                            width: 80, height: 80),
                      ],
                    ),
                  ),

                  // ── Title banner ────────────────────────────────────
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kPrimary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kPrimary.withOpacity(0.3)),
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
                          '${allVendors.length} verified vendors across Pakistan',
                          style: TextStyle(
                              color: kPrimary.withOpacity(0.7), fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Search bar ──────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Search vendors by name...',
                        prefixIcon:
                            const Icon(Icons.search, color: kPrimary, size: 20),
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
                            borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: kPrimary, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: kPrimary.withOpacity(0.3)),
                        ),
                        filled: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Category chips ──────────────────────────────────
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: kCategories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final cat = kCategories[i];
                        final isSelected = _selectedCategory == cat;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
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
                                color: isSelected ? Colors.white : kPrimary,
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

                  // ── Location + Sort row ────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // Location dropdown
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
                        // Sort dropdown
                        Expanded(
                          child: _filterDropdown<String>(
                            value: _sortBy,
                            hint: 'Sort By',
                            icon: Icons.sort,
                            items: kSortOptions,
                            onChanged: (v) =>
                                setState(() => _sortBy = v ?? 'Recommended'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Price slider ────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: kPrimary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: kPrimary.withOpacity(0.2)),
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
                                    horizontal: 10, vertical: 3),
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
                              Text('PKR 10,000',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500)),
                              Text('PKR 10,00,000',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Results row ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          '${vendors.length} vendor${vendors.length == 1 ? '' : 's'} found',
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
                            icon: const Icon(Icons.refresh,
                                size: 14, color: kPrimary),
                            label: const Text('Reset',
                                style: TextStyle(
                                    color: kPrimary, fontSize: 12)),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── Vendor cards ────────────────────────────────────
                  vendors.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.search_off,
                                    size: 64,
                                    color: Colors.grey.shade300),
                                const SizedBox(height: 12),
                                const Text('No vendors found',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey)),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: _resetFilters,
                                  child: const Text('Clear all filters',
                                      style: TextStyle(color: kPrimary)),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: vendors.length,
                          itemBuilder: (ctx, i) => _VendorCard(
                            vendor: vendors[i],
                            isFavorite: _favorites.contains(vendors[i].name),
                            onFavoriteToggle: () {
                              setState(() {
                                if (_favorites.contains(vendors[i].name)) {
                                  _favorites.remove(vendors[i].name);
                                } else {
                                  _favorites.add(vendors[i].name);
                                }
                              });
                            },
                          ),
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
                hint: Text(hint,
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
                items: items
                    .map((v) => DropdownMenuItem<T>(
                          value: v as T,
                          child: Text(v, style: const TextStyle(fontSize: 12)),
                        ))
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
//  VENDOR CARD
// ═══════════════════════════════════════════════════════════════

class _VendorCard extends StatelessWidget {
  final EventPlannerVendor vendor;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const _VendorCard({
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
      capacity: 'N/A',
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

              // ── Image ─────────────────────────────────────────────
              Stack(
                children: [
                  Image.asset(
                    vendor.image,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 160,
                      color: kPrimary.withOpacity(0.1),
                      child: const Icon(Icons.image,
                          size: 50, color: Colors.grey),
                    ),
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
                          horizontal: 10, vertical: 4),
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
                                blurRadius: 4),
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
                  // Rating bottom
                  Positioned(
                    bottom: 8,
                    left: 10,
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          '${vendor.rating} (${vendor.reviews})',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  // Price
                  Positioned(
                    bottom: 8,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
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

              // ── Details ───────────────────────────────────────────
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
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: kPrimary, size: 14),
                            const SizedBox(width: 2),
                            Text(vendor.location,
                                style: const TextStyle(
                                    color: kPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.work_outline,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${vendor.experience} experience',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Services
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: vendor.services.map((s) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: kPrimary.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: kPrimary.withOpacity(0.2)),
                          ),
                          child: Text(s,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: kPrimary,
                                  fontWeight: FontWeight.w500)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    // CTA
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
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
      capacity: 'N/A',
      amenities: vendor.services,
      description: vendor.description,
    ),
  ),
),
                        icon: const Icon(Icons.visibility_outlined,
                            color: Colors.white, size: 16),
                        label: const Text('View Details',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
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
}

