import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'drawer.dart';
import 'eventplanner.dart';
import 'venuecontact.dart';

const Color _kPrimary = Color(0xffB4245D);

/// Vendors the logged-in user contacted via [VenueContactPage] (quotes with `vendorId`).
class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  bool _loading = true;
  String? _error;
  List<_VendorInquiryRow> _rows = [];

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
        _error = 'Please sign in to see your inquiries.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final quotesSnap = await FirebaseFirestore.instance
          .collection('quotes')
          .where('customerId', isEqualTo: uid)
          .get();

      final latestByVendor = <String, DateTime>{};
      for (final q in quotesSnap.docs) {
        final d = q.data();
        final vid = d['vendorId']?.toString().trim();
        if (vid == null || vid.isEmpty) continue;

        DateTime? dt;
        final raw = d['createdAt'];
        if (raw is Timestamp) dt = raw.toDate();

        final prev = latestByVendor[vid];
        if (dt != null) {
          if (prev == null || dt.isAfter(prev)) latestByVendor[vid] = dt;
        } else if (!latestByVendor.containsKey(vid)) {
          latestByVendor[vid] = DateTime.fromMillisecondsSinceEpoch(0);
        }
      }

      if (latestByVendor.isEmpty) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _rows = [];
        });
        return;
      }

      final sortedIds = latestByVendor.entries.toList()
        ..sort(
          (a, b) => b.value.compareTo(a.value),
        );

      final futures = sortedIds.map((e) async {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(e.key)
            .get();
        return _VendorInquiryRow(
          vendorId: e.key,
          lastInquiry: latestByVendor[e.key],
          userDoc: doc,
        );
      });

      final rows = await Future.wait(futures);

      if (!mounted) return;
      setState(() {
        _loading = false;
        _rows = rows.where((r) => r.userDoc.exists).toList();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load inquiries. Please try again.';
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

  String _formatWhen(DateTime? d) {
    if (d == null ||
        d.millisecondsSinceEpoch == 0) {
      return 'Date unknown';
    }
    final day = d.day.toString().padLeft(2, '0');
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month]} $day, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      drawer: const CommonDrawer(),
      appBar: AppBar(
        backgroundColor: _kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Bookings',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        color: _kPrimary,
        backgroundColor: scheme.surfaceContainerHigh,
        onRefresh: _load,
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = scheme.onSurfaceVariant;
    final cardBg = isDark ? const Color(0xff1E1E28) : scheme.surfaceContainerLow;
    final borderColor = scheme.outline.withOpacity(isDark ? 0.28 : 0.14);

    if (_loading) {
      return Center(
        child: CircularProgressIndicator(color: scheme.primary),
      );
    }
    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.lock_outline, size: 48, color: muted.withOpacity(0.65)),
          const SizedBox(height: 16),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurface, fontSize: 15),
          ),
        ],
      );
    }
    if (_rows.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.mail_outline, size: 56, color: muted.withOpacity(0.55)),
          const SizedBox(height: 16),
          Text(
            'No vendor inquiries yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When you contact a vendor from a listing, they appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 14, height: 1.35),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _rows.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final row = _rows[i];
        final data = row.userDoc.data()!;
        final name =
            (data['businessName'] ?? data['name'] ?? 'Vendor').toString();
        final category =
            (data['businessCategory'] ?? data['category'] ?? '').toString();
        final city = (data['city'] ?? '').toString();

        return Material(
          color: cardBg,
          elevation: isDark ? 0 : 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: _kPrimary.withOpacity(isDark ? 0.22 : 0.12),
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
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (category.isNotEmpty || city.isNotEmpty)
                    Text(
                      [category, city].where((s) => s.isNotEmpty).join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: muted),
                    ),
                  Text(
                    'Inquiry · ${_formatWhen(row.lastInquiry)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: muted.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: muted.withOpacity(0.7)),
            onTap: () => _openVendor(data),
          ),
        );
      },
    );
  }
}

class _VendorInquiryRow {
  final String vendorId;
  final DateTime? lastInquiry;
  final DocumentSnapshot<Map<String, dynamic>> userDoc;

  _VendorInquiryRow({
    required this.vendorId,
    required this.lastInquiry,
    required this.userDoc,
  });
}
