// import 'package:flutter/material.dart';
// import 'drawer.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   bool isDarkMode = false;
//   bool notificationsEnabled = true;
//   bool twoFactorEnabled = false;
//   String selectedCity = 'Lahore';
//   String selectedLanguage = 'English';

//   final Color primaryColor = const Color(0xffB4245D);

//   void _showLogoutDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Log out?'),
//         content: const Text(
//             'You\'ll need to sign in again to access your account and bookings.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel',
//                 style: TextStyle(color: Colors.black54)),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xffB4245D),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8)),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               // TODO: Clear session and navigate to LoginPage
//             },
//             child: const Text('Log Out',
//                 style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeleteAccountDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Delete account?'),
//         content: const Text(
//             'This will permanently erase all your bookings, quotes and saved vendors. This cannot be undone.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel',
//                 style: TextStyle(color: Colors.black54)),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8)),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               // TODO: Delete account API call
//             },
//             child: const Text('Delete',
//                 style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showCityPicker() {
//     final cities = ['Lahore', 'Karachi', 'Islamabad', 'Multan', 'Peshawar'];
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (context) => Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(16),
//             child: Text('Select Default City',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//           ),
//           ...cities.map((city) => ListTile(
//                 title: Text(city),
//                 trailing: selectedCity == city
//                     ? Icon(Icons.check, color: primaryColor)
//                     : null,
//                 onTap: () {
//                   setState(() => selectedCity = city);
//                   Navigator.pop(context);
//                 },
//               )),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   Widget _sectionLabel(String text) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
//       child: Text(
//         text.toUpperCase(),
//         style: const TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.w600,
//           color: Colors.grey,
//           letterSpacing: 0.8,
//         ),
//       ),
//     );
//   }

//   Widget _settingsCard(List<Widget> children) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.withOpacity(0.15)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: Column(children: children),
//     );
//   }

//   Widget _settingsTile({
//     required IconData icon,
//     required Color iconBg,
//     required String title,
//     String? subtitle,
//     Widget? trailing,
//     VoidCallback? onTap,
//     bool showDivider = true,
//     Color titleColor = Colors.black87,
//   }) {
//     return Column(
//       children: [
//         ListTile(
//           onTap: onTap,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//           leading: Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: iconBg,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, size: 18, color: iconBg.computeLuminance() > 0.5
//                 ? Colors.black54
//                 : Colors.white),
//           ),
//           title: Text(title,
//               style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                   color: titleColor)),
//           subtitle: subtitle != null
//               ? Text(subtitle,
//                   style:
//                       const TextStyle(fontSize: 12, color: Colors.black45))
//               : null,
//           trailing: trailing ??
//               const Icon(Icons.chevron_right,
//                   color: Colors.black26, size: 20),
//         ),
//         if (showDivider)
//           const Divider(height: 1, indent: 68, endIndent: 16),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
//       child: Scaffold(

//         appBar: const CommonAppBar(),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
// ////////////// back arrow
//               Padding(
//   padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//   child: Row(
//     children: [
//       GestureDetector(
//         onTap: () => Navigator.pop(context),
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.grey.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: const Icon(Icons.arrow_back),
//         ),
//       ),
//       const SizedBox(width: 10),
//       const Text(
//         'Back',
//         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       )
//     ],
//   ),
// ),
//               // ─── Profile Card ───────────────────────────────────────
//               Container(
//                 margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: primaryColor.withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(
//                       color: primaryColor.withOpacity(0.2)),
//                 ),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundColor: primaryColor,
//                       child: const Text('A',
//                           style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white)),
//                     ),
//                     const SizedBox(width: 14),
//                     const Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Ali',
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600)),
//                           SizedBox(height: 2),
//                           Text('user@email.com',
//                               style: TextStyle(
//                                   fontSize: 13, color: Colors.black54)),
//                         ],
//                       ),
//                     ),
//                     OutlinedButton(
//                       style: OutlinedButton.styleFrom(
//                         side: BorderSide(color: primaryColor),
//                         foregroundColor: primaryColor,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                       ),
//                       onPressed: () {},
//                       child: const Text('Edit',
//                           style: TextStyle(fontSize: 13)),
//                     ),
//                   ],
//                 ),
//               ),

//               // ─── Preferences ────────────────────────────────────────
//               _sectionLabel('Preferences'),
//               _settingsCard([
//                 _settingsTile(
//                   icon: Icons.dark_mode_outlined,
//                   iconBg: primaryColor.withOpacity(0.8),
//                   title: 'Dark Mode',
//                   subtitle: 'Switch app appearance',
//                   trailing: Switch(
//                     value: isDarkMode,
//                     activeColor: primaryColor,
//                     onChanged: (val) => setState(() => isDarkMode = val),
//                   ),
//                 ),
//                 _settingsTile(
//                   icon: Icons.notifications_outlined,
//                   iconBg: Colors.blue.withOpacity(0.8),
//                   title: 'Notifications',
//                   subtitle: 'Quotes, updates & offers',
//                   trailing: Switch(
//                     value: notificationsEnabled,
//                     activeColor: primaryColor,
//                     onChanged: (val) =>
//                         setState(() => notificationsEnabled = val),
//                   ),
//                 ),
//                 _settingsTile(
//                   icon: Icons.location_on_outlined,
//                   iconBg: Colors.green.withOpacity(0.8),
//                   title: 'Default City',
//                   subtitle: selectedCity,
//                   onTap: _showCityPicker,
//                 ),
//                 _settingsTile(
//                   icon: Icons.language_outlined,
//                   iconBg: Colors.teal.withOpacity(0.8),
//                   title: 'Language',
//                   subtitle: selectedLanguage,
//                   showDivider: false,
//                   onTap: () {},
//                 ),
//               ]),

//               // ─── Account ────────────────────────────────────────────
//               _sectionLabel('Account'),
//               _settingsCard([
//                 _settingsTile(
//                   icon: Icons.person_outline,
//                   iconBg: primaryColor.withOpacity(0.8),
//                   title: 'Personal Information',
//                   subtitle: 'Name, phone, email',
//                   onTap: () {},
//                 ),
//                 _settingsTile(
//                   icon: Icons.lock_outline,
//                   iconBg: Colors.orange.withOpacity(0.8),
//                   title: 'Change Password',
//                   subtitle: 'Update your password',
//                   onTap: () {},
//                 ),
//                 _settingsTile(
//                   icon: Icons.bookmark_border,
//                   iconBg: Colors.purple.withOpacity(0.8),
//                   title: 'My Bookings',
//                   subtitle: 'View all vendor bookings',
//                   onTap: () {},
//                 ),
//                 _settingsTile(
//                   icon: Icons.favorite_border,
//                   iconBg: Colors.red.withOpacity(0.8),
//                   title: 'Saved Vendors',
//                   subtitle: 'Your favourites list',
//                   onTap: () {},
//                 ),
//                 _settingsTile(
//                   icon: Icons.description_outlined,
//                   iconBg: Colors.blue.withOpacity(0.8),
//                   title: 'My Quotes',
//                   subtitle: 'Submitted event requests',
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: primaryColor,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: const Text('3',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold)),
//                       ),
//                       const SizedBox(width: 8),
//                       const Icon(Icons.chevron_right,
//                           color: Colors.black26, size: 20),
//                     ],
//                   ),
//                   showDivider: false,
//                   onTap: () {},
//                 ),
//               ]),

//               // ─── Privacy & Security ─────────────────────────────────
//               _sectionLabel('Privacy & Security'),
//               _settingsCard([
//                 _settingsTile(
//                   icon: Icons.security,
//                   iconBg: primaryColor.withOpacity(0.8),
//                   title: 'Two-Factor Auth',
//                   subtitle: 'Protect your account',
//                   trailing: Switch(
//                     value: twoFactorEnabled,
//                     activeColor: primaryColor,
//                     onChanged: (val) =>
//                         setState(() => twoFactorEnabled = val),
//                   ),
//                 ),
//                 _settingsTile(
//                   icon: Icons.visibility_outlined,
//                   iconBg: Colors.green.withOpacity(0.8),
//                   title: 'Profile Visibility',
//                   subtitle: 'Public',
//                   onTap: () {},
//                 ),
//                 _settingsTile(
//                   icon: Icons.shield_outlined,
//                   iconBg: Colors.purple.withOpacity(0.8),
//                   title: 'Data & Privacy',
//                   subtitle: 'Manage your data',
//                   showDivider: false,
//                   onTap: () {},
//                 ),
//               ]),

//               // ─── Support ────────────────────────────────────────────
//               _sectionLabel('Support'),
//               _settingsCard([
//                 _settingsTile(
//                   icon: Icons.help_outline,
//                   iconBg: Colors.blue.withOpacity(0.8),
//                   title: 'Help & FAQ',
//                   subtitle: 'Common questions',
//                   onTap: () {},
//                 ),
//                 _settingsTile(
//                   icon: Icons.support_agent,
//                   iconBg: Colors.green.withOpacity(0.8),
//                   title: 'Contact Support',
//                   subtitle: 'Report an issue',
//                   onTap: () {},
//                 ),
//                 _settingsTile(
//                   icon: Icons.star_outline,
//                   iconBg: Colors.amber.withOpacity(0.8),
//                   title: 'Rate the App',
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.green.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: const Text('New',
//                             style: TextStyle(
//                                 color: Colors.green,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold)),
//                       ),
//                       const SizedBox(width: 8),
//                       const Icon(Icons.chevron_right,
//                           color: Colors.black26, size: 20),
//                     ],
//                   ),
//                   onTap: () {},
//                 ),
//                 _settingsTile(
//                   icon: Icons.article_outlined,
//                   iconBg: Colors.purple.withOpacity(0.8),
//                   title: 'Terms & Privacy Policy',
//                   showDivider: false,
//                   onTap: () {},
//                 ),
//               ]),

//               // ─── Danger Zone ────────────────────────────────────────
//               _sectionLabel('Danger Zone'),
//               _settingsCard([
//                 _settingsTile(
//                   icon: Icons.delete_outline,
//                   iconBg: Colors.red.withOpacity(0.8),
//                   title: 'Delete Account',
//                   subtitle: 'Permanently remove your data',
//                   titleColor: Colors.red,
//                   trailing: const Icon(Icons.chevron_right,
//                       color: Colors.red, size: 20),
//                   showDivider: false,
//                   onTap: _showDeleteAccountDialog,
//                 ),
//               ]),

//               // ─── Logout Button ──────────────────────────────────────
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 52,
//                   child: OutlinedButton.icon(
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Colors.red, width: 1.5),
//                       foregroundColor: Colors.red,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     onPressed: _showLogoutDialog,
//                     icon: const Icon(Icons.logout),
//                     label: const Text('Log Out',
//                         style: TextStyle(
//                             fontSize: 15, fontWeight: FontWeight.w600)),
//                   ),
//                 ),
//               ),

//               // ─── Version ────────────────────────────────────────────
//               const Center(
//                 child: Padding(
//                   padding: EdgeInsets.only(bottom: 24),
//                   child: Text(
//                     'Events Affairs v1.0.0 · Made with love in Pakistan',
//                     style: TextStyle(fontSize: 12, color: Colors.black38),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'drawer.dart';
import 'theme_notifier.dart'; // 👈 import the global notifier
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool twoFactorEnabled = false;
  String selectedCity = 'Lahore';
  String selectedLanguage = 'English';

  final Color primaryColor = const Color(0xffB4245D);

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log out?'),
        content: const Text(
          'You\'ll need to sign in again to access your account and bookings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffB4245D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete account?'),
        content: const Text(
          'This will permanently erase all your bookings, quotes and saved vendors. This cannot be undone.',
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
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              // TODO: delete account API call
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCityPicker() {
    final cities = ['Lahore', 'Karachi', 'Islamabad', 'Multan', 'Peshawar'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Select Default City',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          ...cities.map(
            (city) => ListTile(
              title: Text(city),
              trailing: selectedCity == city
                  ? Icon(Icons.check, color: primaryColor)
                  : null,
              onTap: () {
                setState(() => selectedCity = city);
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
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
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Column(children: children),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required Color iconBg,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showDivider = true,
    Color? titleColor,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: titleColor,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                )
              : null,
          trailing:
              trailing ??
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ),
        if (showDivider) const Divider(height: 1, indent: 68, endIndent: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /////// Back Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Back',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            // ─── Profile Card ──────────────────────────────────────────
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor,
                    child: const Text(
                      'AK',
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
                          'Ali',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'ali@email.com',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primaryColor),
                      foregroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Edit', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),

            // ─── Preferences ──────────────────────────────────────────
            _sectionLabel('Preferences'),
            _settingsCard([
              _settingsTile(
                icon: Icons.dark_mode_outlined,
                iconBg: primaryColor.withOpacity(0.13),
                title: 'Dark Mode',
                subtitle: 'Switch app appearance',
                // ValueListenableBuilder so only the Switch rebuilds
                trailing: ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (context, mode, _) => Switch(
                    value: mode == ThemeMode.dark,
                    activeThumbColor: primaryColor,
                    onChanged: (val) {
                      // 👇 This one line updates EVERY screen in the app
                      themeNotifier.value = val
                          ? ThemeMode.dark
                          : ThemeMode.light;
                    },
                  ),
                ),
              ),
              _settingsTile(
                icon: Icons.notifications_outlined,
                iconBg: Colors.blue.withOpacity(0.13),
                title: 'Notifications',
                subtitle: 'Quotes, updates & offers',
                trailing: Switch(
                  value: notificationsEnabled,
                  activeThumbColor: primaryColor,
                  onChanged: (val) =>
                      setState(() => notificationsEnabled = val),
                ),
              ),
              _settingsTile(
                icon: Icons.location_on_outlined,
                iconBg: Colors.green.withOpacity(0.13),
                title: 'Default City',
                subtitle: selectedCity,
                onTap: _showCityPicker,
              ),
              _settingsTile(
                icon: Icons.language_outlined,
                iconBg: Colors.teal.withOpacity(0.13),
                title: 'Language',
                subtitle: selectedLanguage,
                showDivider: false,
                onTap: () {},
              ),
            ]),

            // ─── Account ──────────────────────────────────────────────
            _sectionLabel('Account'),
            _settingsCard([
              _settingsTile(
                icon: Icons.person_outline,
                iconBg: primaryColor.withOpacity(0.13),
                title: 'Personal Information',
                subtitle: 'Name, phone, email',
                onTap: () {},
              ),
              _settingsTile(
                icon: Icons.lock_outline,
                iconBg: Colors.orange.withOpacity(0.13),
                title: 'Change Password',
                subtitle: 'Update your password',
                onTap: () {},
              ),
              _settingsTile(
                icon: Icons.bookmark_border,
                iconBg: Colors.purple.withOpacity(0.13),
                title: 'My Bookings',
                subtitle: 'View all vendor bookings',
                onTap: () {},
              ),
              _settingsTile(
                icon: Icons.favorite_border,
                iconBg: Colors.red.withOpacity(0.13),
                title: 'Saved Vendors',
                subtitle: 'Your favourites list',
                onTap: () {},
              ),
              _settingsTile(
                icon: Icons.description_outlined,
                iconBg: Colors.blue.withOpacity(0.13),
                title: 'My Quotes',
                subtitle: 'Submitted event requests',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
                showDivider: false,
                onTap: () {},
              ),
            ]),

            // ─── Privacy & Security ───────────────────────────────────
            _sectionLabel('Privacy & Security'),
            _settingsCard([
              _settingsTile(
                icon: Icons.security,
                iconBg: primaryColor.withOpacity(0.13),
                title: 'Two-Factor Auth',
                subtitle: 'Protect your account',
                trailing: Switch(
                  value: twoFactorEnabled,
                  activeThumbColor: primaryColor,
                  onChanged: (val) => setState(() => twoFactorEnabled = val),
                ),
              ),
              _settingsTile(
                icon: Icons.visibility_outlined,
                iconBg: Colors.green.withOpacity(0.13),
                title: 'Profile Visibility',
                subtitle: 'Public',
                onTap: () {},
              ),
              _settingsTile(
                icon: Icons.shield_outlined,
                iconBg: Colors.purple.withOpacity(0.13),
                title: 'Data & Privacy',
                subtitle: 'Manage your data',
                showDivider: false,
                onTap: () {},
              ),
            ]),

            // ─── Support ──────────────────────────────────────────────
            _sectionLabel('Support'),
            _settingsCard([
              _settingsTile(
                icon: Icons.help_outline,
                iconBg: Colors.blue.withOpacity(0.13),
                title: 'Help & FAQ',
                subtitle: 'Common questions',
                onTap: () {},
              ),
              _settingsTile(
                icon: Icons.support_agent,
                iconBg: Colors.green.withOpacity(0.13),
                title: 'Contact Support',
                subtitle: 'Report an issue',
                onTap: () {},
              ),
              _settingsTile(
                icon: Icons.star_outline,
                iconBg: Colors.amber.withOpacity(0.13),
                title: 'Rate the App',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'New',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
                onTap: () {},
              ),
              _settingsTile(
                icon: Icons.article_outlined,
                iconBg: Colors.purple.withOpacity(0.13),
                title: 'Terms & Privacy Policy',
                showDivider: false,
                onTap: () {},
              ),
            ]),

            // ─── Danger Zone ──────────────────────────────────────────
            _sectionLabel('Danger Zone'),
            _settingsCard([
              _settingsTile(
                icon: Icons.delete_outline,
                iconBg: Colors.red.withOpacity(0.13),
                title: 'Delete Account',
                subtitle: 'Permanently remove your data',
                titleColor: Colors.red,
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.red,
                  size: 20,
                ),
                showDivider: false,
                onTap: _showDeleteAccountDialog,
              ),
            ]),

            // ─── Logout Button ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red, width: 1.5),
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _showLogoutDialog,
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            // ─── Version ──────────────────────────────────────────────
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Text(
                  'Events Affairs v1.0.0 · Made with love in Pakistan',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
