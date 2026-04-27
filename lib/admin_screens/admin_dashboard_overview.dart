import 'package:flutter/material.dart';

import '../blogs.dart';
import '../eventplanner.dart';
import 'admin_settings.dart';
import 'admin_store.dart';

const Color kPrimary = Color(0xffB4245D);

class AdminDashboardOverviewPage extends StatefulWidget {
  const AdminDashboardOverviewPage({super.key});

  @override
  State<AdminDashboardOverviewPage> createState() =>
      _AdminDashboardOverviewPageState();
}

class _AdminDashboardOverviewPageState extends State<AdminDashboardOverviewPage> {
  int _unreadNotifs = 3;

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
    final Color bg = isDark ? const Color(0xff0F0F14) : const Color(0xffF4F7FA);
    final Color surface = isDark ? const Color(0xff1A1A24) : Colors.white;

    return AnimatedBuilder(
      animation: adminStore,
      builder: (context, _) {
        final unassignedBlogs = allBlogs
            .where((b) => (adminStore.blogEvents[b.id] ?? const <String>{}).isEmpty)
            .length;

        final pendingVendors = adminStore.pendingVendorsCount;
        final totalLeads = adminStore.leads.length;

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: kPrimary,
            elevation: 0,
            title: const Text(
              'Admin Portal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminSettingsPage()),
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: Colors.white),
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
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroHeader(
                  isDark: isDark,
                  pendingVendors: pendingVendors,
                  unassignedBlogs: unassignedBlogs,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _MetricCard(
                        surface: surface,
                        isDark: isDark,
                        icon: Icons.storefront_outlined,
                        title: 'Vendors',
                        value: '${allVendors.length}',
                        subtitle: pendingVendors > 0
                            ? '$pendingVendors pending approval'
                            : 'All approved',
                        accent: kPrimary,
                      ),
                      const SizedBox(width: 10),
                      _MetricCard(
                        surface: surface,
                        isDark: isDark,
                        icon: Icons.inbox_outlined,
                        title: 'Leads',
                        value: '$totalLeads',
                        subtitle: 'Inquiries only',
                        accent: Colors.blue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _MetricCard(
                        surface: surface,
                        isDark: isDark,
                        icon: Icons.article_outlined,
                        title: 'Blogs',
                        value: '${allBlogs.length}',
                        subtitle: unassignedBlogs > 0
                            ? '$unassignedBlogs need event assignment'
                            : 'All assigned',
                        accent: Colors.deepPurple,
                      ),
                      const SizedBox(width: 10),
                      _MetricCard(
                        surface: surface,
                        isDark: isDark,
                        icon: Icons.rule_outlined,
                        title: 'Model',
                        value: 'Lead',
                        subtitle: 'No revenue tracking',
                        accent: Colors.green,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SectionTitle(
                    title: 'Action Required',
                    subtitle: 'Keep the platform clean and organized',
                    isDark: isDark,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _ActionRow(
                        surface: surface,
                        isDark: isDark,
                        icon: Icons.verified_outlined,
                        title: 'Vendor approvals',
                        subtitle: pendingVendors > 0
                            ? '$pendingVendors vendors pending'
                            : 'No pending approvals',
                        badgeText:
                            pendingVendors > 0 ? '$pendingVendors' : null,
                        onTap: () {
                          // bottom-nav already has vendors tab; keep this as a hint
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Open Vendors tab to approve.'),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _ActionRow(
                        surface: surface,
                        isDark: isDark,
                        icon: Icons.event_available_outlined,
                        title: 'Blog → Event mapping',
                        subtitle: unassignedBlogs > 0
                            ? '$unassignedBlogs blogs not assigned'
                            : 'All blogs assigned',
                        badgeText: unassignedBlogs > 0 ? '$unassignedBlogs' : null,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Open Blogs tab to assign events.'),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SectionTitle(
                    title: 'Recent Leads',
                    subtitle: 'Users shared contact number with vendors',
                    isDark: isDark,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: adminStore.leads
                        .take(3)
                        .map((l) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _LeadPreviewTile(
                                surface: surface,
                                isDark: isDark,
                                name: l.name,
                                subtitle:
                                    '${l.service} · ${l.city} · ${l.eventDate}',
                                phone: l.phone,
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final bool isDark;
  final int pendingVendors;
  final int unassignedBlogs;

  const _HeroHeader({
    required this.isDark,
    required this.pendingVendors,
    required this.unassignedBlogs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xff8B1A3E),
            kPrimary,
            const Color(0xffD4456E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: const Icon(Icons.admin_panel_settings_outlined,
                color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Connect users to vendors',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bookings are leads only — vendors contact users directly.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _HeroPill(
                      text: pendingVendors > 0
                          ? '$pendingVendors vendor approvals pending'
                          : 'No pending approvals',
                      icon: Icons.verified_outlined,
                    ),
                    _HeroPill(
                      text: unassignedBlogs > 0
                          ? '$unassignedBlogs blogs need event'
                          : 'Blogs mapped to events',
                      icon: Icons.event_available_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final String text;
  final IconData icon;

  const _HeroPill({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final Color surface;
  final bool isDark;
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color accent;

  const _MetricCard({
    required this.surface,
    required this.isDark,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: kPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white38 : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDark;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final Color surface;
  final bool isDark;
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badgeText;
  final VoidCallback onTap;

  const _ActionRow({
    required this.surface,
    required this.isDark,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: kPrimary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: kPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            if (badgeText != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  badgeText!,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right,
                color: isDark ? Colors.white38 : Colors.black26),
          ],
        ),
      ),
    );
  }
}

class _LeadPreviewTile extends StatelessWidget {
  final Color surface;
  final bool isDark;
  final String name;
  final String subtitle;
  final String phone;

  const _LeadPreviewTile({
    required this.surface,
    required this.isDark,
    required this.name,
    required this.subtitle,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: kPrimary.withValues(alpha: 0.12),
            child: Text(
              name.substring(0, 1),
              style: const TextStyle(
                color: kPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: kPrimary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              phone,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: kPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color sheetBg = isDark ? const Color(0xff1C1C26) : Colors.white;

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
              color: Colors.grey.withValues(alpha: 0.2),
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
          const _NotifTile(
            text: 'New lead submitted (user shared contact number)',
            time: 'Just now',
            unread: true,
          ),
          const _NotifTile(
            text: 'Vendor approval required',
            time: '1 hr ago',
            unread: true,
          ),
          const _NotifTile(
            text: 'Blog event assignment pending',
            time: 'Yesterday',
            unread: false,
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

