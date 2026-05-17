import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'vendor_bookings.dart';
import 'vendor_other_screens.dart';

const Color kPrimary = Color(0xffB4245D);

/// Matches `VendorProfileEditPage` fields in `vendor_other_screens.dart`.
class _VendorProfileCompletion {
  final int percent;
  final List<String> missingHints;

  _VendorProfileCompletion({required this.percent, required this.missingHints});

  static bool _nonEmpty(dynamic v) => (v?.toString().trim() ?? '').isNotEmpty;

  static bool _hasServicesList(dynamic v) {
    if (v is! List) return false;
    return v.any((e) => e.toString().trim().isNotEmpty);
  }

  factory _VendorProfileCompletion.fromUserData(Map<String, dynamic> d) {
    final checks = <String, bool>{
      'Business name': _nonEmpty(d['businessName']),
      'Tagline': _nonEmpty(d['tagline']),
      'Starting price.You will be filter on the basis of this': _nonEmpty(
        d['startingPrice'],
      ),
      'Years of experience': _nonEmpty(d['yearsExperience']),
      'Phone number': _nonEmpty(d['phone']),
      'WhatsApp': _nonEmpty(d['whatsapp']),
      'Instagram': _nonEmpty(d['instagram']),
      'Facebook': _nonEmpty(d['facebook']),
      'Services offered': _hasServicesList(d['services']),
    };
    final done = checks.values.where((v) => v).length;
    final total = checks.length;
    final percent = total == 0 ? 0 : ((done / total) * 100).round();
    final missing = checks.entries
        .where((e) => !e.value)
        .map((e) => e.key)
        .toList();
    return _VendorProfileCompletion(percent: percent, missingHints: missing);
  }
}

String _vendorNameInitials(String fullName) {
  final trimmed = fullName.trim();
  if (trimmed.isEmpty) return 'V';
  final parts = trimmed
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.length >= 2) {
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
  return parts.first[0].toUpperCase();
}

// ═══════════════════════════════════════════════════════════════
//  VENDOR DASHBOARD PAGE
// ═══════════════════════════════════════════════════════════════

class VendorDashboardPage extends StatefulWidget {
  const VendorDashboardPage({super.key});

  @override
  State<VendorDashboardPage> createState() => _VendorDashboardPageState();
}

class _VendorDashboardPageState extends State<VendorDashboardPage> {
  int _unreadNotifs = 5;
  String _vendorName = 'Loading...';
  String _businessName = 'Loading...';
  String _category = '';
  String _city = '';
  int _profileCompletenessPercent = 0;
  List<String> _profileMissingHints = [];
  int _inquiriesCount = 0;
  int _leadsCount = 0;
  String _ratingDisplay = '—';

  // Business documents state
  bool _docsLoaded = false;
  bool _hasAllDocs = false;
  DateTime? _accountCreatedAt;

  @override
  void initState() {
    super.initState();
    _loadVendorData();
  }

  Future<void> _loadVendorData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final results = await Future.wait<Object>([
        FirebaseFirestore.instance.collection('users').doc(uid).get(),
        FirebaseFirestore.instance
            .collection('quotes')
            .where('vendorId', isEqualTo: uid)
            .get(),
        FirebaseFirestore.instance
            .collection('reviews')
            .where('vendorId', isEqualTo: uid)
            .get(),
        // Load business documents
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('businessDocuments')
            .doc('identity')
            .get(),
      ]);

      final doc = results[0] as DocumentSnapshot<Map<String, dynamic>>;
      final quotesSnap = results[1] as QuerySnapshot<Map<String, dynamic>>;
      final reviewsSnap = results[2] as QuerySnapshot<Map<String, dynamic>>;
      final docsSnap = results[3] as DocumentSnapshot<Map<String, dynamic>>;

      // Counts
      final inquiries = quotesSnap.docs.length;
      var leads = 0;
      for (final q in quotesSnap.docs) {
        final status = (q.data()['status'] ?? 'pending')
            .toString()
            .toLowerCase()
            .trim();
        if (status == 'pending' || status == 'new') leads++;
      }

      // Rating
      var ratingSum = 0.0;
      var ratingCount = 0;
      for (final r in reviewsSnap.docs) {
        final val = r.data()['rating'];
        if (val is num) {
          ratingSum += val.toDouble();
          ratingCount++;
        }
      }
      final ratingStr = ratingCount == 0
          ? '—'
          : '${(ratingSum / ratingCount).toStringAsFixed(1)} ★';

      // Business documents check
      bool hasAllDocs = false;
      if (docsSnap.exists) {
        final d = docsSnap.data() ?? {};
        final cnic = (d['cnicNumber'] ?? '').toString().trim();
        final ntn = (d['ntnNumber'] ?? '').toString().trim();
        final biz = (d['businessRegNumber'] ?? '').toString().trim();
        hasAllDocs = cnic.isNotEmpty && ntn.isNotEmpty && biz.isNotEmpty;
      }

      // Account creation time
      DateTime? createdAt;
      if (doc.exists) {
        final ts = doc.data()?['createdAt'];
        if (ts is Timestamp) createdAt = ts.toDate();
      }

      if (!doc.exists) {
        if (!mounted) return;
        setState(() {
          _inquiriesCount = inquiries;
          _leadsCount = leads;
          _ratingDisplay = ratingStr;
          _docsLoaded = true;
          _hasAllDocs = hasAllDocs;
          _accountCreatedAt = createdAt;
        });
        return;
      }

      final data = doc.data()!;
      final completion = _VendorProfileCompletion.fromUserData(data);

      if (!mounted) return;
      setState(() {
        _vendorName = data['name'] ?? 'Vendor';
        _businessName = data['businessName'] ?? 'My Business';
        _category = data['businessCategory'] ?? '';
        _city = data['city'] ?? '';
        _profileCompletenessPercent = completion.percent;
        _profileMissingHints = completion.missingHints;
        _inquiriesCount = inquiries;
        _leadsCount = leads;
        _ratingDisplay = ratingStr;
        _docsLoaded = true;
        _hasAllDocs = hasAllDocs;
        _accountCreatedAt = createdAt;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _inquiriesCount = 0;
        _leadsCount = 0;
        _ratingDisplay = '—';
        _docsLoaded = true;
        _hasAllDocs = false;
      });
    }
  }

  Future<void> _openNotifications() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _NotificationsSheet(),
    );
    setState(() => _unreadNotifs = 0);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color surfaceColor = isDark ? const Color(0xff1A1A24) : Colors.white;
    final Color scaffoldBg = isDark
        ? const Color(0xff0F0F14)
        : const Color(0xffF4F7FA);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: const Text(
          'Vendor Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
                onPressed: _openNotifications,
              ),
              if (_unreadNotifs > 0)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                      border: Border.all(color: kPrimary, width: 1),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileHeader(
              isDark: isDark,
              vendorName: _vendorName,
              nameInitials: _vendorNameInitials(_vendorName),
              businessName: _businessName,
              category: _category,
              city: _city,
            ),
            const SizedBox(height: 16),

            // Statistics
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _StatCard(
                    value: '$_inquiriesCount',
                    label: 'Inquiries',
                    isDark: isDark,
                    surface: surfaceColor,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    value: '$_leadsCount',
                    label: 'Leads',
                    isDark: isDark,
                    surface: surfaceColor,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    value: _ratingDisplay,
                    label: 'Rating',
                    isDark: isDark,
                    surface: surfaceColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeading('Quick Actions', isDark: isDark),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _QuickAction(
                        icon: Icons.event_note_outlined,
                        label: 'Bookings',
                        surface: surfaceColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VendorBookingsPage(),
                          ),
                        ),
                      ),
                      _QuickAction(
                        icon: Icons.photo_library_outlined,
                        label: 'Gallery',
                        surface: surfaceColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VendorGalleryPage(),
                          ),
                        ),
                      ),
                      _QuickAction(
                        icon: Icons.star_outline,
                        label: 'Reviews',
                        surface: surfaceColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VendorReviewsPage(),
                          ),
                        ),
                      ),
                      _QuickAction(
                        icon: Icons.bar_chart_outlined,
                        label: 'Analytics',
                        surface: surfaceColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VendorAnalyticsPage(),
                          ),
                        ),
                      ),
                      _QuickAction(
                        icon: Icons.edit_outlined,
                        label: 'Edit Profile',
                        surface: surfaceColor,
                        onTap: () async {
                          await Navigator.push<void>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const VendorProfileEditPage(),
                            ),
                          );
                          if (mounted) await _loadVendorData();
                        },
                      ),
                      _QuickAction(
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                        surface: surfaceColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VendorSettingsPage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Inquiries
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SectionHeading('Recent Inquiries', isDark: isDark),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            color: kPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._sampleInquiries.map(
                    (inq) => _InquiryTile(
                      inquiry: inq,
                      surface: surfaceColor,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Profile Completeness
            _ProfileCompleteness(
              surface: surfaceColor,
              isDark: isDark,
              percent: _profileCompletenessPercent,
              missingHints: _profileMissingHints,
            ),

            const SizedBox(height: 16),

            // ── NEW: Business Documents Section ──────────────────
            if (_docsLoaded)
              _BusinessDocumentsSection(
                surface: surfaceColor,
                isDark: isDark,
                hasAllDocs: _hasAllDocs,
                accountCreatedAt: _accountCreatedAt,
                onDocsSaved: () {
                  // Refresh dashboard after saving docs
                  _loadVendorData();
                },
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BUSINESS DOCUMENTS SECTION  (NEW)
// ═══════════════════════════════════════════════════════════════

class _BusinessDocumentsSection extends StatelessWidget {
  final Color surface;
  final bool isDark;
  final bool hasAllDocs;
  final DateTime? accountCreatedAt;
  final VoidCallback onDocsSaved;

  const _BusinessDocumentsSection({
    required this.surface,
    required this.isDark,
    required this.hasAllDocs,
    required this.accountCreatedAt,
    required this.onDocsSaved,
  });

  String _getTimeRemaining() {
    if (accountCreatedAt == null) return '24 hours';
    final deadline = accountCreatedAt!.add(const Duration(hours: 24));
    final remaining = deadline.difference(DateTime.now());
    if (remaining.isNegative) return '0 hours';
    if (remaining.inHours >= 1) {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m';
    }
    return '${remaining.inMinutes} minutes';
  }

  bool get _isUrgent {
    if (accountCreatedAt == null) return false;
    final deadline = accountCreatedAt!.add(const Duration(hours: 24));
    final remaining = deadline.difference(DateTime.now());
    return remaining.inHours < 6 && !remaining.isNegative;
  }

  bool get _isExpired {
    if (accountCreatedAt == null) return false;
    final deadline = accountCreatedAt!.add(const Duration(hours: 24));
    return DateTime.now().isAfter(deadline);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // ── Warning Banner (only if docs not submitted) ──────
          if (!hasAllDocs) ...[
            _SuspensionWarningBanner(
              isDark: isDark,
              timeRemaining: _getTimeRemaining(),
              isUrgent: _isUrgent,
              isExpired: _isExpired,
            ),
            const SizedBox(height: 12),
          ],

          // ── Document Card ────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(20),
              border: !hasAllDocs
                  ? Border.all(
                      color:
                          (_isExpired
                                  ? Colors.red
                                  : _isUrgent
                                  ? Colors.orange
                                  : Colors.orange.shade300)
                              .withOpacity(0.4),
                      width: 1.5,
                    )
                  : Border.all(
                      color: Colors.green.withOpacity(0.3),
                      width: 1.5,
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: hasAllDocs
                            ? Colors.green.withOpacity(0.1)
                            : kPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        hasAllDocs
                            ? Icons.verified_outlined
                            : Icons.description_outlined,
                        color: hasAllDocs ? Colors.green : kPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Business Documents',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            hasAllDocs
                                ? 'All documents submitted ✓'
                                : 'Required for account verification',
                            style: TextStyle(
                              fontSize: 11,
                              color: hasAllDocs
                                  ? Colors.green
                                  : isDark
                                  ? Colors.white54
                                  : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: hasAllDocs
                            ? Colors.green.withOpacity(0.12)
                            : Colors.orange.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        hasAllDocs ? 'Verified' : 'Pending',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: hasAllDocs
                              ? Colors.green
                              : Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Divider(
                  color: isDark
                      ? Colors.white12
                      : Colors.black.withOpacity(0.06),
                ),
                const SizedBox(height: 12),

                // Document checklist
                _DocCheckItem(
                  label: 'CNIC Number',
                  isDark: isDark,
                  isSubmitted: hasAllDocs,
                ),
                const SizedBox(height: 8),
                _DocCheckItem(
                  label: 'NTN Number',
                  isDark: isDark,
                  isSubmitted: hasAllDocs,
                ),
                const SizedBox(height: 8),
                _DocCheckItem(
                  label: 'Business Registration No.',
                  isDark: isDark,
                  isSubmitted: hasAllDocs,
                ),

                const SizedBox(height: 16),

                // Action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasAllDocs ? Colors.green : kPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: Icon(
                      hasAllDocs ? Icons.edit_outlined : Icons.upload_outlined,
                      size: 18,
                    ),
                    label: Text(
                      hasAllDocs
                          ? 'Update Documents'
                          : 'Add Business Documents',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.push<void>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BusinessDocumentsPage(),
                        ),
                      );
                      onDocsSaved();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Suspension Warning Banner ────────────────────────────────────────────────

class _SuspensionWarningBanner extends StatelessWidget {
  final bool isDark;
  final String timeRemaining;
  final bool isUrgent;
  final bool isExpired;

  const _SuspensionWarningBanner({
    required this.isDark,
    required this.timeRemaining,
    required this.isUrgent,
    required this.isExpired,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isExpired
        ? Colors.red.shade50
        : isUrgent
        ? Colors.orange.shade50
        : const Color(0xFFFFF3E0);
    final Color borderColor = isExpired
        ? Colors.red.shade300
        : isUrgent
        ? Colors.orange.shade400
        : Colors.orange.shade300;
    final Color iconColor = isExpired
        ? Colors.red.shade600
        : isUrgent
        ? Colors.orange.shade700
        : Colors.orange.shade600;
    final Color textColor = isExpired
        ? Colors.red.shade800
        : isUrgent
        ? Colors.orange.shade900
        : Colors.orange.shade900;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.orange.withOpacity(0.08) : bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isExpired ? Icons.block_outlined : Icons.warning_amber_rounded,
            color: iconColor,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isExpired
                      ? '⚠️ Account Suspension Risk'
                      : '⏰ Action Required',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isExpired
                      ? 'Your verification window has passed. Please submit your business documents immediately to avoid account suspension.'
                      : 'Add your business documents within $timeRemaining or your account will be suspended.',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.85),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Document Check Item ──────────────────────────────────────────────────────

class _DocCheckItem extends StatelessWidget {
  final String label;
  final bool isDark;
  final bool isSubmitted;

  const _DocCheckItem({
    required this.label,
    required this.isDark,
    required this.isSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isSubmitted ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: isSubmitted ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isSubmitted
                ? (isDark ? Colors.white38 : Colors.black38)
                : (isDark ? Colors.white70 : Colors.black87),
            decoration: isSubmitted ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BUSINESS DOCUMENTS PAGE  (NEW SCREEN)
// ═══════════════════════════════════════════════════════════════

class BusinessDocumentsPage extends StatefulWidget {
  const BusinessDocumentsPage({super.key});

  @override
  State<BusinessDocumentsPage> createState() => _BusinessDocumentsPageState();
}

class _BusinessDocumentsPageState extends State<BusinessDocumentsPage> {
  final _formKey = GlobalKey<FormState>();
  final _cnicCtrl = TextEditingController();
  final _ntnCtrl = TextEditingController();
  final _bizRegCtrl = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _loadExistingDocs();
  }

  @override
  void dispose() {
    _cnicCtrl.dispose();
    _ntnCtrl.dispose();
    _bizRegCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadExistingDocs() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('businessDocuments')
          .doc('identity')
          .get();

      if (doc.exists) {
        final d = doc.data()!;
        _cnicCtrl.text = d['cnicNumber'] ?? '';
        _ntnCtrl.text = d['ntnNumber'] ?? '';
        _bizRegCtrl.text = d['businessRegNumber'] ?? '';
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _saveDocuments() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _saving = false);
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('businessDocuments')
          .doc('identity')
          .set({
            'cnicNumber': _cnicCtrl.text.trim(),
            'ntnNumber': _ntnCtrl.text.trim(),
            'businessRegNumber': _bizRegCtrl.text.trim(),
            'submittedAt': FieldValue.serverTimestamp(),
            'status': 'pending_review',
          }, SetOptions(merge: true));

      // Also flag on the main user doc so dashboard/admin can check easily
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'documentsSubmitted': true,
        'documentsSubmittedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      setState(() {
        _saving = false;
        _saved = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Documents saved successfully!'),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Pop back after a short delay so vendor sees the snackbar
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to save. Please try again.'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xff0F0F14)
          : const Color(0xffF4F7FA),
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: const Text(
          'Business Documents',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : _saveDocuments,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kPrimary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info banner
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: kPrimary.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kPrimary.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: kPrimary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your documents are stored securely and only visible to admins for verification.',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white70 : Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section label
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 18,
                          decoration: BoxDecoration(
                            color: kPrimary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Identity Documents',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kPrimary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // CNIC
                    _DocField(
                      controller: _cnicCtrl,
                      label: 'CNIC Number',
                      hint: 'e.g. 35202-1234567-1',
                      icon: Icons.credit_card_outlined,
                      isDark: isDark,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'CNIC number is required';
                        }
                        if (v.trim().replaceAll('-', '').length < 13) {
                          return 'Enter a valid 13-digit CNIC number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    // NTN
                    _DocField(
                      controller: _ntnCtrl,
                      label: 'NTN Number',
                      hint: 'National Tax Number',
                      icon: Icons.receipt_long_outlined,
                      isDark: isDark,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'NTN number is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    // Business Registration
                    _DocField(
                      controller: _bizRegCtrl,
                      label: 'Business Registration No.',
                      hint: 'e.g. 0123456',
                      icon: Icons.business_outlined,
                      isDark: isDark,
                      keyboardType: TextInputType.text,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Business registration number is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _saving ? null : _saveDocuments,
                        child: _saving
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Save Documents',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Privacy note
                    Center(
                      child: Text(
                        '🔒  Encrypted & visible only to admins',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// ── Doc Field Widget ─────────────────────────────────────────────────────────

class _DocField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool isDark;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  const _DocField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.isDark,
    required this.keyboardType,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: kPrimary,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: kPrimary, size: 20),
        labelStyle: const TextStyle(color: kPrimary, fontSize: 13),
        floatingLabelStyle: const TextStyle(color: kPrimary),
        hintStyle: TextStyle(
          color: isDark ? Colors.white30 : Colors.black26,
          fontSize: 13,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xff1A1A24) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: validator,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  UNCHANGED COMPONENTS BELOW
// ═══════════════════════════════════════════════════════════════

class _ProfileHeader extends StatelessWidget {
  final bool isDark;
  final String vendorName;
  final String nameInitials;
  final String businessName;
  final String category;
  final String city;

  const _ProfileHeader({
    required this.isDark,
    required this.vendorName,
    required this.nameInitials,
    required this.businessName,
    required this.category,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1A1A24) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: kPrimary,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: kPrimary,
              child: Text(
                nameInitials,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: nameInitials.length >= 2 ? 15 : 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  businessName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$category · $city',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final bool isDark;
  final Color surface;
  const _StatCard({
    required this.value,
    required this.label,
    required this.isDark,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: kPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? Colors.white38 : Colors.black45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color surface;
  final VoidCallback onTap;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: kPrimary, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InquiryTile extends StatelessWidget {
  final _Inquiry inquiry;
  final Color surface;
  final bool isDark;
  const _InquiryTile({
    required this.inquiry,
    required this.surface,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: kPrimary.withOpacity(0.1),
            child: Text(
              inquiry.name[0],
              style: const TextStyle(
                color: kPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inquiry.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  '${inquiry.event} · ${inquiry.date}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'PKR ${inquiry.budget.toInt()}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: kPrimary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet();

  String _formatTime(Timestamp? ts) {
    if (ts == null) return '';
    final diff = DateTime.now().difference(ts.toDate());
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color sheetBg = isDark ? const Color(0xff1C1C26) : Colors.white;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          if (uid == null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Not signed in',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            )
          else
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('notifications')
                  .orderBy('createdAt', descending: true)
                  .limit(5)
                  .get(),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(
                      color: kPrimary,
                      strokeWidth: 2,
                    ),
                  );
                }
                if (snap.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Failed to load notifications.',
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                  );
                }
                final docs = snap.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 40,
                          color: isDark ? Colors.white30 : Colors.black26,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No notifications yet',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  children: docs.map((doc) {
                    final d = doc.data();
                    return _NotifTile(
                      text: (d['title'] ?? '').toString(),
                      time: _formatTime(d['createdAt'] as Timestamp?),
                      unread: !(d['read'] ?? false),
                    );
                  }).toList(),
                );
              },
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final String text, time;
  final bool unread;
  const _NotifTile({
    required this.text,
    required this.time,
    required this.unread,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: unread ? kPrimary : Colors.transparent,
              border: unread ? null : Border.all(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: unread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCompleteness extends StatelessWidget {
  final Color surface;
  final bool isDark;
  final int percent;
  final List<String> missingHints;

  const _ProfileCompleteness({
    required this.surface,
    required this.isDark,
    required this.percent,
    required this.missingHints,
  });

  @override
  Widget build(BuildContext context) {
    final p = percent.clamp(0, 100);
    final progress = p / 100.0;
    final Color accent = p >= 90
        ? Colors.green
        : (p >= 50 ? Colors.orange : kPrimary);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SectionHeading('Profile Completeness', isDark: isDark),
              Text(
                '$p%',
                style: TextStyle(fontWeight: FontWeight.bold, color: accent),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            p >= 100
                ? 'Your edit-profile sections are complete. Great job!'
                : 'Complete the items below in Edit Profile to reach 100%.',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          if (p >= 100)
            const _TodoItem(text: 'All tracked fields are filled', done: true)
          else ...[
            ...missingHints
                .take(6)
                .map((hint) => _TodoItem(text: 'Add: $hint', done: false)),
            if (missingHints.length > 6)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '+ ${missingHints.length - 6} more in Edit Profile',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _TodoItem extends StatelessWidget {
  final String text;
  final bool done;
  const _TodoItem({required this.text, required this.done});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: done ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: done ? Colors.grey : null,
              decoration: done ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionHeading(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : Colors.black87,
    ),
  );
}

class _Inquiry {
  final String name, event, date, city;
  final double budget;
  const _Inquiry({
    required this.name,
    required this.event,
    required this.date,
    required this.city,
    required this.budget,
  });
}

const List<_Inquiry> _sampleInquiries = [];
