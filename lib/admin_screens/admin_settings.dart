import 'package:flutter/material.dart';

import '../theme_notifier.dart';

const Color kPrimary = Color(0xffB4245D);

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _leadNotifications = true;
  bool _vendorUpdates = true;
  bool _blogNotifications = true;
  bool _userAlerts = true;
  bool _autoApproveVendors = false;
  bool _requireBlogApproval = true;
  int _leadsPerPage = 20;
  String _defaultCity = 'Lahore';

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _settingsCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: Column(children: children),
    );
  }

  void _showCityPicker() {
    final cities = ['Lahore', 'Karachi', 'Islamabad', 'Multan', 'Peshawar', 'Faisalabad', 'Quetta', 'Sialkot'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Select Default City',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          ...cities.map((city) => ListTile(
                title: Text(city),
                trailing: _defaultCity == city
                    ? Icon(Icons.check, color: kPrimary)
                    : null,
                onTap: () {
                  setState(() => _defaultCity = city);
                  Navigator.pop(context);
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showLeadsPerPagePicker() {
    final options = [10, 20, 50, 100];
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Leads Per Page',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          ...options.map((count) => ListTile(
                title: Text('$count leads'),
                trailing: _leadsPerPage == count
                    ? Icon(Icons.check, color: kPrimary)
                    : null,
                onTap: () {
                  setState(() => _leadsPerPage = count);
                  Navigator.pop(context);
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.event, color: kPrimary),
            ),
            const SizedBox(width: 12),
            const Text('Events Affairs'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(label: 'Version', value: '1.0.0'),
            _InfoRow(label: 'Build', value: '2024.04.27'),
            _InfoRow(label: 'Platform', value: 'Flutter (Android/iOS)'),
            SizedBox(height: 12),
            Text(
              'We connect users to vendors. Bookings are treated as leads/inquiries only. '
              'Vendors contact users directly via their phone number.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: kPrimary)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.logout, color: Colors.red),
            ),
            const SizedBox(width: 12),
            const Text('Log Out'),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out of the admin panel? You\'ll need to sign in again to access admin features.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              // TODO: Clear admin session and navigate to login
              _toast(context, 'Logged out successfully');
            },
            child: const Text('Log Out',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: const Text(
          'Admin Settings',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kPrimary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: kPrimary,
                    child: Text(
                      'AD',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Platform management',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _sectionLabel('Preferences'),
            _settingsCard([
              _SettingsTile(
                icon: Icons.dark_mode_outlined,
                iconBg: kPrimary.withValues(alpha: 0.13),
                title: 'Dark Mode',
                subtitle: 'Switch app appearance',
                trailing: ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (context, mode, _) => Switch(
                    value: mode == ThemeMode.dark,
                    activeThumbColor: kPrimary,
                    onChanged: (val) => themeNotifier.value =
                        val ? ThemeMode.dark : ThemeMode.light,
                  ),
                ),
              ),
              _SettingsTile(
                icon: Icons.location_city_outlined,
                iconBg: Colors.teal.withValues(alpha: 0.13),
                title: 'Default City',
                subtitle: _defaultCity,
                onTap: _showCityPicker,
              ),
              _SettingsTile(
                icon: Icons.format_list_numbered,
                iconBg: Colors.indigo.withValues(alpha: 0.13),
                title: 'Leads Per Page',
                subtitle: '$_leadsPerPage leads',
                onTap: _showLeadsPerPagePicker,
                showDivider: false,
              ),
            ]),
            _sectionLabel('Notifications'),
            _settingsCard([
              _SettingsTile(
                icon: Icons.notifications_outlined,
                iconBg: Colors.orange.withValues(alpha: 0.13),
                title: 'Lead notifications',
                subtitle: 'New lead alerts',
                trailing: Switch(
                  value: _leadNotifications,
                  activeThumbColor: kPrimary,
                  onChanged: (v) => setState(() => _leadNotifications = v),
                ),
              ),
              _SettingsTile(
                icon: Icons.storefront_outlined,
                iconBg: Colors.blue.withValues(alpha: 0.13),
                title: 'Vendor updates',
                subtitle: 'New vendor registrations',
                trailing: Switch(
                  value: _vendorUpdates,
                  activeThumbColor: kPrimary,
                  onChanged: (v) => setState(() => _vendorUpdates = v),
                ),
              ),
              _SettingsTile(
                icon: Icons.article_outlined,
                iconBg: Colors.purple.withValues(alpha: 0.13),
                title: 'Blog notifications',
                subtitle: 'New blog posts',
                trailing: Switch(
                  value: _blogNotifications,
                  activeThumbColor: kPrimary,
                  onChanged: (v) => setState(() => _blogNotifications = v),
                ),
              ),
              _SettingsTile(
                icon: Icons.people_outline,
                iconBg: Colors.green.withValues(alpha: 0.13),
                title: 'User alerts',
                subtitle: 'New user registrations',
                trailing: Switch(
                  value: _userAlerts,
                  activeThumbColor: kPrimary,
                  onChanged: (v) => setState(() => _userAlerts = v),
                ),
                showDivider: false,
              ),
            ]),
            _sectionLabel('Moderation'),
            _settingsCard([
              _SettingsTile(
                icon: Icons.verified_outlined,
                iconBg: Colors.cyan.withValues(alpha: 0.13),
                title: 'Auto-approve vendors',
                subtitle: 'Skip manual verification',
                trailing: Switch(
                  value: _autoApproveVendors,
                  activeThumbColor: kPrimary,
                  onChanged: (v) => setState(() => _autoApproveVendors = v),
                ),
              ),
              _SettingsTile(
                icon: Icons.rate_review_outlined,
                iconBg: Colors.amber.withValues(alpha: 0.13),
                title: 'Require blog approval',
                subtitle: 'Moderate before publishing',
                trailing: Switch(
                  value: _requireBlogApproval,
                  activeThumbColor: kPrimary,
                  onChanged: (v) => setState(() => _requireBlogApproval = v),
                ),
                showDivider: false,
              ),
            ]),
            _sectionLabel('Data Management'),
            _settingsCard([
              _SettingsTile(
                icon: Icons.backup_outlined,
                iconBg: Colors.blueGrey.withValues(alpha: 0.13),
                title: 'Export Data',
                subtitle: 'Download all records',
                onTap: () => _toast(context, 'Export feature coming soon'),
              ),
              _SettingsTile(
                icon: Icons.refresh,
                iconBg: Colors.teal.withValues(alpha: 0.13),
                title: 'Clear Cache',
                subtitle: 'Free up storage space',
                onTap: () => _toast(context, 'Cache cleared successfully'),
                showDivider: false,
              ),
            ]),
            _sectionLabel('About'),
            _settingsCard([
              _SettingsTile(
                icon: Icons.info_outline,
                iconBg: Colors.green.withValues(alpha: 0.13),
                title: 'Platform Info',
                subtitle: 'Version and build details',
                onTap: _showAboutDialog,
                showDivider: false,
              ),
            ]),
            _sectionLabel('Account'),
            _settingsCard([
              _SettingsTile(
                icon: Icons.logout,
                iconBg: Colors.red.withValues(alpha: 0.13),
                title: 'Log Out',
                subtitle: 'Sign out of admin account',
                onTap: _showLogoutDialog,
                showDivider: false,
              ),
            ]),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24, top: 20),
                child: Text(
                  'Events Affairs · Admin Portal',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconBg;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const _SettingsTile({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconBg,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          subtitle: subtitle != null
              ? Text(subtitle!, style: const TextStyle(fontSize: 12, color: Colors.grey))
              : null,
          trailing: trailing ??
              (onTap != null ? const Icon(Icons.chevron_right, color: Colors.grey, size: 20) : null),
        ),
        if (showDivider) const Divider(height: 1, indent: 70, endIndent: 16),
      ],
    );
  }
}

