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
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: adminStore.firestoreVendors.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final v = adminStore.firestoreVendors[i];
            final status =
                adminStore.vendorStatus[v.id] ??
                (v.approved ? VendorStatus.approved : VendorStatus.pending);
            final primaryService =
                adminStore.vendorPrimaryService[v.id] ?? v.category;
            final bool isPending = status == VendorStatus.pending;

            return Container(
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
                                  color: isDark ? Colors.white : Colors.black87,
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
                            color: isDark ? Colors.white38 : Colors.black54,
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
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (ctx) => _ServicePickerSheet(
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
                                onTap: () => adminStore.setVendorStatus(
                                  v.id,
                                  VendorStatus.approved,
                                ),
                              ),
                            if (status == VendorStatus.approved)
                              _SmallActionButton(
                                label: 'Suspend',
                                icon: Icons.block,
                                tone: _ButtonTone.danger,
                                onTap: () => adminStore.setVendorStatus(
                                  v.id,
                                  VendorStatus.suspended,
                                ),
                              ),
                            if (status == VendorStatus.suspended)
                              _SmallActionButton(
                                label: 'Re-approve',
                                icon: Icons.restart_alt,
                                tone: _ButtonTone.success,
                                onTap: () => adminStore.setVendorStatus(
                                  v.id,
                                  VendorStatus.approved,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
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
