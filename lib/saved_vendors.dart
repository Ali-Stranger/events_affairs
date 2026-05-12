import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'drawer.dart';
import 'eventplanner.dart';
import 'saved_vendors_repository.dart';
import 'venuecontact.dart';

const Color _kPrimary = Color(0xffB4245D);

/// Lists vendors saved from Venues / Event Planner / Venue contact bookmark.
class SavedVendorsPage extends StatefulWidget {
  const SavedVendorsPage({super.key});

  @override
  State<SavedVendorsPage> createState() => _SavedVendorsPageState();
}

class _SavedVendorsPageState extends State<SavedVendorsPage> {
  bool _loading = true;
  String? _error;
  List<DocumentSnapshot<Map<String, dynamic>>> _vendorDocs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() {
        _loading = false;
        _error = 'Please sign in to see saved vendors.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final ids = await SavedVendorsRepository.loadOrderedIds();
      if (ids.isEmpty) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _vendorDocs = [];
        });
        return;
      }

      final snaps = await Future.wait(
        ids.map(
          (id) =>
              FirebaseFirestore.instance.collection('users').doc(id).get(),
        ),
      );

      final docs = snaps.where((s) => s.exists).toList();

      if (!mounted) return;
      setState(() {
        _loading = false;
        _vendorDocs = docs;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load saved vendors. Please try again.';
      });
    }
  }

  void _openVendor(Map<String, dynamic> data) {
    final v = EventPlannerVendor.fromFirestore(data);
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => VenueContactPage(
          name: v.name,
          location: v.location,
          price: v.price,
          image: v.image,
          category: v.category,
          rating: v.rating,
          reviews: v.reviews,
          capacity: v.capacity,
          amenities: v.services,
          description: v.description,
        ),
      ),
    );
  }

  Future<void> _removeSaved(String vendorId) async {
    try {
      await SavedVendorsRepository.removeVendor(vendorId);
      if (!mounted) return;
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from saved'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not update. Try again.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CommonDrawer(),
      appBar: AppBar(
        backgroundColor: _kPrimary,
        foregroundColor: Colors.white,
        title: const Text(
          'Saved Vendors',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        color: _kPrimary,
        onRefresh: _load,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: _kPrimary),
      );
    }
    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.lock_outline, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
          ),
        ],
      );
    }
    if (_vendorDocs.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.favorite_border, size: 56, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No saved vendors yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart on a listing or the bookmark on a vendor profile.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _vendorDocs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final doc = _vendorDocs[i];
        final data = doc.data()!;
        final name =
            (data['businessName'] ?? data['name'] ?? 'Vendor').toString();
        final category =
            (data['businessCategory'] ?? data['category'] ?? '').toString();
        final city = (data['city'] ?? '').toString();

        return Material(
          color: Colors.white,
          elevation: 0.5,
          borderRadius: BorderRadius.circular(12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: _kPrimary.withOpacity(0.12),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: _kPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: category.isNotEmpty || city.isNotEmpty
                ? Text(
                    [category, city].where((s) => s.isNotEmpty).join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Remove from saved',
                  icon: Icon(Icons.favorite, color: Colors.red.shade400),
                  onPressed: () => _removeSaved(doc.id),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            onTap: () => _openVendor(data),
          ),
        );
      },
    );
  }
}
