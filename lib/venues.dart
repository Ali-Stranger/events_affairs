import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'app_localizations.dart';
import 'footer.dart';
import 'eventplanner.dart';
import 'drawer.dart';
import 'saved_vendors_repository.dart';

// ═══════════════════════════════════════════════════════════════
//  VENUES PAGE — same vendor accounts as Eventplanner (Firestore users)
// ═══════════════════════════════════════════════════════════════

class VenuesPage extends StatefulWidget {
  const VenuesPage({super.key});

  @override
  State<VenuesPage> createState() => _VenuesPageState();
}

class _VenuesPageState extends State<VenuesPage> {
  static const Color primary = Color(0xffB4245D);

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _vendorDocs = [];
  bool _isLoading = true;
  String? _error;

  String _searchQuery = '';
  String _selectedLocation = 'All';
  String _selectedCategory = 'All';
  Set<String> _favoriteVendorIds = {};
  final TextEditingController _searchCtrl = TextEditingController();

  static const List<String> _fallbackLocations = [
    'All',
    'Lahore',
    'Karachi',
    'Islamabad',
    'Multan',
    'Peshawar',
    'Faisalabad',
    'Rawalpindi',
    'Quetta',
  ];

  List<String> get _locationOptions {
    final fromData =
        _vendorDocs
            .map((d) => EventPlannerVendor.fromFirestore(d.data()).location)
            .toSet()
            .toList()
          ..sort();
    if (fromData.isEmpty) return _fallbackLocations;
    return ['All', ...fromData];
  }

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
      final t = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.translate('couldNotUpdateSavedVendors')),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _fetchVendors() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'vendor')
          .get();

      final docs = snapshot.docs
          .cast<QueryDocumentSnapshot<Map<String, dynamic>>>()
          .where((doc) => _isVisibleVendor(doc.data()))
          .toList();

      if (!mounted) return;
      setState(() {
        _vendorDocs = docs;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final t = AppLocalizations.of(context);
      setState(() {
        _error = t.translate('failedToLoadVendors');
        _isLoading = false;
      });
    }
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> get _filteredVendorDocs {
    return _vendorDocs.where((doc) {
      final v = EventPlannerVendor.fromFirestore(doc.data());
      final matchLoc =
          _selectedLocation == 'All' || v.location == _selectedLocation;
      final matchCat =
          _selectedCategory == 'All' || v.category == _selectedCategory;
      final q = _searchQuery.toLowerCase();
      final matchSearch =
          _searchQuery.isEmpty ||
          v.name.toLowerCase().contains(q) ||
          v.location.toLowerCase().contains(q) ||
          v.description.toLowerCase().contains(q);
      return matchLoc && matchCat && matchSearch;
    }).toList();
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
    final listingValue = data['listingPaused'];
    final bool isListingPaused =
        listingValue == true ||
        (listingValue is String && listingValue.toLowerCase() == 'true');
    return isApproved && !isSuspended && !isListingPaused;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Widget _buildLoadingState() {
    final t = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: primary),
          const SizedBox(height: 16),
          Text(
            t.translate('loadingVendors'),
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final t = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              _error ?? t.translate('somethingWentWrong'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _fetchVendors,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(
                t.translate('retry'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final vendorDocs = _filteredVendorDocs;
    final locations = _locationOptions;
    final vendorCountText = vendorDocs.length == 1
        ? '${vendorDocs.length} ${t.translate('vendorFound')}'
        : '${vendorDocs.length} ${t.translate('vendorsFound')}';

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

                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: primary.withOpacity(0.3)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                t.translate('findEventVendors'),
                                style: const TextStyle(
                                  color: primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_vendorDocs.length} ${t.translate('verifiedVendorsAcrossPakistan')}',
                                style: TextStyle(
                                  color: primary.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (v) => setState(() => _searchQuery = v),
                            decoration: InputDecoration(
                              hintText: t.translate(
                                'searchVendorsByNameCityOrDetails',
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: primary,
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
                                borderSide: BorderSide(
                                  color: primary.withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: primary,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: primary.withOpacity(0.25),
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

                        SizedBox(
                          height: 38,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: locations.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (_, i) {
                              final loc = locations[i];
                              final isSelected = _selectedLocation == loc;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedLocation = loc),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primary
                                        : primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? primary
                                          : primary.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    loc,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 8),

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
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.indigo
                                        : Colors.indigo.withOpacity(0.07),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.indigo
                                          : Colors.indigo.withOpacity(0.25),
                                    ),
                                  ),
                                  child: Text(
                                    cat,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.indigo,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            vendorCountText,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        vendorDocs.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(40),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.storefront_outlined,
                                        size: 60,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        t.translate('noVendorsFound'),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _vendorDocs.isEmpty
                                            ? t.translate('noVendorAccountsYet')
                                            : t.translate(
                                                'tryAdjustingFiltersOrSearch',
                                              ),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: vendorDocs.length,
                                itemBuilder: (ctx, i) {
                                  final doc = vendorDocs[i];
                                  final v = EventPlannerVendor.fromFirestore(
                                    doc.data(),
                                  );
                                  return EventPlannerVendorCard(
                                    vendor: v,
                                    isFavorite: _favoriteVendorIds.contains(
                                      doc.id,
                                    ),
                                    onFavoriteToggle: () =>
                                        _toggleFavorite(doc.id),
                                  );
                                },
                              ),

                        const SizedBox(height: 16),

                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const Eventplanner(),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.explore_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                label: Text(
                                  t.translate('exploreAllVendors'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        const AppFooter(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
