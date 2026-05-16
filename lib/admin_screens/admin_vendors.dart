import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'admin_store.dart';

const Color kPrimary = Color(0xffB4245D);

class AdminVendorsPage extends StatelessWidget {
  const AdminVendorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xff0F0F14) : const Color(0xffF4F7FA);

    return AnimatedBuilder(
      animation: adminStore,
      builder: (context, _) => Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: kPrimary,
          title: const Text(
            'Vendors',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: adminStore.firestoreVendors.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No vendors yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Registered vendors will appear here',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: adminStore.firestoreVendors.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final v = adminStore.firestoreVendors[i];
                  final status =
                      adminStore.vendorStatus[v.id] ??
                      (v.approved
                          ? VendorStatus.approved
                          : VendorStatus.pending);
                  final primaryService =
                      adminStore.vendorPrimaryService[v.id] ?? v.category;
                  final bool isPending = status == VendorStatus.pending;

                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminVendorDetailPage(
                          vendorId: v.id,
                          vendorName: v.name,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xff1A1A24) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isPending
                              ? Colors.amber.withValues(alpha: 0.35)
                              : (isDark
                                    ? Colors.white10
                                    : Colors.black.withValues(alpha: 0.05)),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: kPrimary.withValues(alpha: 0.1),
                            child: Text(
                              v.name.substring(0, 1),
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        v.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    _StatusChip(status: status),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${v.city} · ${v.phone}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? Colors.white38
                                        : Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: kPrimary.withValues(alpha: 0.10),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Service: $primaryService',
                                        style: const TextStyle(
                                          color: kPrimary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _SmallActionButton(
                                      label: 'Set service',
                                      icon: Icons.tune,
                                      onTap: () async {
                                        final picked =
                                            await showModalBottomSheet<String>(
                                              context: context,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            20,
                                                          ),
                                                        ),
                                                  ),
                                              builder: (ctx) =>
                                                  _ServicePickerSheet(
                                                    vendorName: v.businessName,
                                                    services: [v.category],
                                                    selected: primaryService,
                                                  ),
                                            );
                                        if (picked == null) return;
                                        adminStore.setVendorPrimaryService(
                                          v.id,
                                          picked,
                                        );
                                      },
                                    ),
                                    if (status == VendorStatus.pending)
                                      _SmallActionButton(
                                        label: 'Approve',
                                        icon: Icons.verified,
                                        tone: _ButtonTone.success,
                                        onTap: () async {
                                          adminStore.setVendorStatus(
                                            v.id,
                                            VendorStatus.approved,
                                          );
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(v.id)
                                              .update({'approved': true});
                                        },
                                      ),
                                    if (status == VendorStatus.approved)
                                      _SmallActionButton(
                                        label: 'Suspend',
                                        icon: Icons.block,
                                        tone: _ButtonTone.danger,
                                        onTap: () async {
                                          adminStore.setVendorStatus(
                                            v.id,
                                            VendorStatus.suspended,
                                          );
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(v.id)
                                              .update({
                                                'approved': false,
                                                'suspended': true,
                                              });
                                        },
                                      ),
                                    if (status == VendorStatus.suspended)
                                      _SmallActionButton(
                                        label: 'Re-approve',
                                        icon: Icons.restart_alt,
                                        tone: _ButtonTone.success,
                                        onTap: () async {
                                          adminStore.setVendorStatus(
                                            v.id,
                                            VendorStatus.approved,
                                          );
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(v.id)
                                              .update({
                                                'approved': true,
                                                'suspended': false,
                                              });
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final VendorStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case VendorStatus.pending:
        return _chip('Pending', Colors.amber);
      case VendorStatus.approved:
        return _chip('Approved', Colors.green);
      case VendorStatus.suspended:
        return _chip('Suspended', Colors.red);
    }
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}

enum _ButtonTone { normal, success, danger }

class _SmallActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final _ButtonTone tone;

  const _SmallActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.tone = _ButtonTone.normal,
  });

  @override
  Widget build(BuildContext context) {
    Color fg;
    Color bg;
    switch (tone) {
      case _ButtonTone.success:
        fg = Colors.green;
        bg = Colors.green.withValues(alpha: 0.12);
        break;
      case _ButtonTone.danger:
        fg = Colors.red;
        bg = Colors.red.withValues(alpha: 0.12);
        break;
      case _ButtonTone.normal:
        fg = kPrimary;
        bg = kPrimary.withValues(alpha: 0.10);
        break;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminVendorDetailPage extends StatefulWidget {
  final String vendorId;
  final String vendorName;
  const AdminVendorDetailPage({
    super.key,
    required this.vendorId,
    required this.vendorName,
  });

  @override
  State<AdminVendorDetailPage> createState() => _AdminVendorDetailPageState();
}

class _AdminVendorDetailPageState extends State<AdminVendorDetailPage> {
  Map<String, dynamic> _data = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.vendorId)
          .get();
      if (!mounted) return;
      setState(() {
        _data = doc.data() ?? {};
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color surface = isDark ? const Color(0xff1A1A24) : Colors.white;
    final Color bg = isDark ? const Color(0xff0F0F14) : const Color(0xffF4F7FA);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Text(
          widget.vendorName,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kPrimary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Profile Info ──
                  _sectionLabel('Business Info', isDark),
                  _infoCard(surface, [
                    _infoRow(
                      Icons.store_outlined,
                      'Business Name',
                      _data['businessName'] ?? '—',
                      isDark,
                    ),
                    _infoRow(
                      Icons.category_outlined,
                      'Category',
                      _data['businessCategory'] ?? '—',
                      isDark,
                    ),
                    _infoRow(
                      Icons.location_on_outlined,
                      'City',
                      _data['city'] ?? '—',
                      isDark,
                    ),
                    _infoRow(
                      Icons.phone_outlined,
                      'Phone',
                      _data['phone'] ?? '—',
                      isDark,
                    ),
                    _infoRow(
                      Icons.email_outlined,
                      'Email',
                      _data['email'] ?? '—',
                      isDark,
                    ),
                    _infoRow(
                      Icons.chat_outlined,
                      'WhatsApp',
                      _data['whatsapp'] ?? '—',
                      isDark,
                    ),
                    _infoRow(
                      Icons.work_outline,
                      'Experience',
                      _data['yearsExperience'] != null
                          ? '${_data['yearsExperience']} years'
                          : '—',
                      isDark,
                    ),
                    _infoRow(
                      Icons.currency_rupee,
                      'Starting Price',
                      _data['startingPrice'] != null
                          ? 'PKR ${_data['startingPrice']}'
                          : '—',
                      isDark,
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // ── Business Documents ──
                  // ── Business Documents ──
                  _sectionLabel('Business Documents', isDark),
                  _infoCard(surface, [
                    _infoRow(
                      Icons.credit_card_outlined,
                      'CNIC Number',
                      (_data['businessDocuments']
                              as Map<String, dynamic>?)?['cnic'] ??
                          '—',
                      isDark,
                    ),
                    _infoRow(
                      Icons.receipt_long_outlined,
                      'NTN Number',
                      (_data['businessDocuments']
                              as Map<String, dynamic>?)?['ntn'] ??
                          '—',
                      isDark,
                    ),
                    _infoRow(
                      Icons.business_outlined,
                      'Business Reg. No.',
                      (_data['businessDocuments']
                              as Map<
                                String,
                                dynamic
                              >?)?['registrationNumber'] ??
                          '—',
                      isDark,
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // ── Social Media ──
                  _sectionLabel('Social Media', isDark),
                  _infoCard(surface, [
                    _infoRow(
                      Icons.camera_alt_outlined,
                      'Instagram',
                      _data['instagram'] ?? '—',
                      isDark,
                    ),
                    _infoRow(
                      Icons.facebook,
                      'Facebook',
                      _data['facebook'] ?? '—',
                      isDark,
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // ── Services ──
                  if (_data['services'] is List &&
                      (_data['services'] as List).isNotEmpty) ...[
                    _sectionLabel('Services Offered', isDark),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (_data['services'] as List)
                            .map(
                              (s) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: kPrimary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  s.toString(),
                                  style: const TextStyle(
                                    color: kPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _sectionLabel(String text, bool isDark) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: kPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    ),
  );

  Widget _infoCard(Color surface, List<Widget> rows) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(children: rows),
  );

  Widget _infoRow(IconData icon, String label, String value, bool isDark) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: kPrimary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white38 : Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _ServicePickerSheet extends StatelessWidget {
  final String vendorName;
  final List<String> services;
  final String selected;

  const _ServicePickerSheet({
    required this.vendorName,
    required this.services,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Select primary service',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              vendorName,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ...services.map((s) {
              final isSel = s == selected;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: kPrimary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.work_outline, color: kPrimary),
                ),
                title: Text(
                  s,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                trailing: isSel
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () => Navigator.pop(context, s),
              );
            }),
          ],
        ),
      ),
    );
  }
}
