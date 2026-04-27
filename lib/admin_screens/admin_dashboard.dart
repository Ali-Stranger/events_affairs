import 'package:flutter/material.dart';

import '../blogs.dart';
import '../eventplanner.dart';
import 'admin_blogs.dart';
import 'admin_leads.dart';
import 'admin_settings.dart';
import 'admin_vendors.dart';

const Color kPrimary = Color(0xffB4245D);

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _unreadNotifs = 3;

  // Sample data for demonstration - in production these would come from backend
  int get _totalVendors => allVendors.length;
  int get _totalBlogs => allBlogs.length;
  int get _totalLeads => 156; // Demo value
  int get _totalUsers => 89; // Demo value
  int get _pendingVendors => 12; // Demo value
  int get _pendingLeads => 8; // Demo value

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
    final Color scaffoldBg =
        isDark ? const Color(0xff0F0F14) : const Color(0xffF4F7FA);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: const Text(
          'Admin Dashboard',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileHeader(isDark: isDark),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeading('Platform Overview', isDark: isDark),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StatCard(
                        value: '$_totalVendors',
                        label: 'Vendors',
                        isDark: isDark,
                        surface: surfaceColor,
                        icon: Icons.storefront,
                        trend: '+5 this week',
                        trendUp: true,
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        value: '$_totalUsers',
                        label: 'Users',
                        isDark: isDark,
                        surface: surfaceColor,
                        icon: Icons.people,
                        trend: '+12 this week',
                        trendUp: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _StatCard(
                        value: '$_totalLeads',
                        label: 'Total Leads',
                        isDark: isDark,
                        surface: surfaceColor,
                        icon: Icons.assignment_ind,
                        trend: '$_pendingLeads pending',
                        trendUp: false,
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        value: '$_totalBlogs',
                        label: 'Blog Posts',
                        isDark: isDark,
                        surface: surfaceColor,
                        icon: Icons.article,
                        trend: 'Active',
                        trendUp: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeading('Pending Actions', isDark: isDark),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        _PendingItem(
                          icon: Icons.storefront_outlined,
                          title: 'Vendor Approvals',
                          subtitle: '$_pendingVendors vendors waiting for review',
                          color: Colors.orange,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AdminVendorsPage()),
                          ),
                        ),
                        const Divider(height: 1, indent: 56),
                        _PendingItem(
                          icon: Icons.inbox_outlined,
                          title: 'Lead Inquiries',
                          subtitle: '$_pendingLeads new leads need attention',
                          color: Colors.blue,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AdminLeadsPage()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
                        icon: Icons.groups_2_outlined,
                        label: 'Vendors',
                        surface: surfaceColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AdminVendorsPage()),
                        ),
                      ),
                      _QuickAction(
                        icon: Icons.inbox_outlined,
                        label: 'Leads',
                        surface: surfaceColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AdminLeadsPage()),
                        ),
                      ),
                      _QuickAction(
                        icon: Icons.article_outlined,
                        label: 'Blogs',
                        surface: surfaceColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AdminBlogsPage()),
                        ),
                      ),
                      _QuickAction(
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                        surface: surfaceColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AdminSettingsPage()),
                        ),
                      ),
                      _QuickAction(
                        icon: Icons.people_outline,
                        label: 'Users',
                        surface: surfaceColor,
                        onTap: () => _toast(context,
                            'Users screen not wired yet (demo data only).'),
                      ),
                      _QuickAction(
                        icon: Icons.shield_outlined,
                        label: 'Moderate',
                        surface: surfaceColor,
                        onTap: () => _toast(context,
                            'Moderation tools coming next (blog/event mapping is live).'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeading('What this app does', isDark: isDark),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Text(
                      'We connect users to vendors. Bookings are treated as leads/inquiries only. '
                      'Vendors contact users directly via their phone number. '
                      'Revenue/confirmation is not tracked in the app.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

void _toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );
}

class _ProfileHeader extends StatelessWidget {
  final bool isDark;
  const _ProfileHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1A1A24) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
            child: const CircleAvatar(
              radius: 28,
              backgroundColor: kPrimary,
              child: Text(
                'AD',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
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
                  'Admin Panel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Middleman portal · Leads only',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Live',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
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
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final bool isDark;
  final Color surface;
  final IconData? icon;
  final String? trend;
  final bool? trendUp;
  const _StatCard({
    required this.value,
    required this.label,
    required this.isDark,
    required this.surface,
    this.icon,
    this.trend,
    this.trendUp,
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
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            if (icon != null) ...[
              Icon(icon, color: kPrimary, size: 20),
              const SizedBox(height: 8),
            ],
            Text(
              value,
              style: TextStyle(
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
            if (trend != null) ...[
              const SizedBox(height: 6),
              Text(
                trend!,
                style: TextStyle(
                  fontSize: 9,
                  color: trendUp == true ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration:
                  BoxDecoration(color: kPrimary.withValues(alpha: 0.1), shape: BoxShape.circle),
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

class _SectionHeading extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionHeading(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }
}

class _PendingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _PendingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
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
              unread: true),
          const _NotifTile(
              text: 'Vendor updated profile details',
              time: '2 hrs ago',
              unread: true),
          const _NotifTile(
              text: 'Blog post edited — event assignment pending',
              time: 'Yesterday',
              unread: false),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final String text, time;
  final bool unread;
  const _NotifTile({required this.text, required this.time, required this.unread});

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
                Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

