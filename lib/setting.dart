


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'drawer.dart';
// import 'theme_notifier.dart'; // 👈 import the global notifier

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
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
//           'You\'ll need to sign in again to access your account and bookings.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xffB4245D),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               // TODO: clear session, navigate to LoginPage
//             },
//             child: const Text('Log Out', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showChangePasswordDialog() {
//     final currentCtrl = TextEditingController();
//     final newCtrl = TextEditingController();
//     final confirmCtrl = TextEditingController();
//     bool isLoading = false;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (ctx) => StatefulBuilder(
//         builder: (context, setModalState) => Padding(
//           padding: EdgeInsets.only(
//             left: 24,
//             right: 24,
//             top: 24,
//             bottom: MediaQuery.of(context).viewInsets.bottom + 24,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Change Password',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: currentCtrl,
//                 obscureText: true,
//                 cursorColor: primaryColor,
//                 decoration: InputDecoration(
//                   labelText: 'Current Password',
//                   prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
//                   floatingLabelStyle: TextStyle(color: primaryColor),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: primaryColor, width: 1.8),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: newCtrl,
//                 obscureText: true,
//                 cursorColor: primaryColor,
//                 decoration: InputDecoration(
//                   labelText: 'New Password',
//                   prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
//                   floatingLabelStyle: TextStyle(color: primaryColor),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: primaryColor, width: 1.8),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: confirmCtrl,
//                 obscureText: true,
//                 cursorColor: primaryColor,
//                 decoration: InputDecoration(
//                   labelText: 'Confirm New Password',
//                   prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
//                   floatingLabelStyle: TextStyle(color: primaryColor),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: primaryColor, width: 1.8),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: primaryColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: isLoading
//                       ? null
//                       : () async {
//                           if (newCtrl.text != confirmCtrl.text) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Passwords do not match'),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                             return;
//                           }
//                           if (newCtrl.text.length < 6) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                   'Password must be at least 6 characters',
//                                 ),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                             return;
//                           }
//                           setModalState(() => isLoading = true);
//                           try {
//                             final user = FirebaseAuth.instance.currentUser!;
//                             final cred = EmailAuthProvider.credential(
//                               email: user.email!,
//                               password: currentCtrl.text,
//                             );
//                             await user.reauthenticateWithCredential(cred);
//                             await user.updatePassword(newCtrl.text);
//                             if (!context.mounted) return;
//                             Navigator.pop(context);
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Password changed successfully!'),
//                                 backgroundColor: Colors.green,
//                                 behavior: SnackBarBehavior.floating,
//                               ),
//                             );
//                           } on FirebaseAuthException catch (e) {
//                             setModalState(() => isLoading = false);
//                             String msg = 'Failed to change password.';
//                             if (e.code == 'wrong-password') {
//                               msg = 'Current password is incorrect.';
//                             }
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(msg),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                           }
//                         },
//                   child: isLoading
//                       ? const SizedBox(
//                           height: 22,
//                           width: 22,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2.5,
//                           ),
//                         )
//                       : const Text(
//                           'Change Password',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
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
//           'This will permanently erase all your bookings, quotes and saved vendors. This cannot be undone.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               // TODO: delete account API call
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.white)),
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
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(16),
//             child: Text(
//               'Select Default City',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//           ),
//           ...cities.map(
//             (city) => ListTile(
//               title: Text(city),
//               trailing: selectedCity == city
//                   ? Icon(Icons.check, color: primaryColor)
//                   : null,
//               onTap: () {
//                 setState(() => selectedCity = city);
//                 Navigator.pop(context);
//               },
//             ),
//           ),
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
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.withOpacity(0.15)),
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
//     Color? titleColor,
//   }) {
//     return Column(
//       children: [
//         ListTile(
//           onTap: onTap,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 4,
//           ),
//           leading: Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: iconBg,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, size: 18),
//           ),
//           title: Text(
//             title,
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w500,
//               color: titleColor,
//             ),
//           ),
//           subtitle: subtitle != null
//               ? Text(
//                   subtitle,
//                   style: const TextStyle(fontSize: 12, color: Colors.grey),
//                 )
//               : null,
//           trailing:
//               trailing ??
//               const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
//         ),
//         if (showDivider) const Divider(height: 1, indent: 68, endIndent: 16),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CommonAppBar(),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /////// Back Button
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Icon(Icons.arrow_back),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   const Text(
//                     'Back',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//             ),

//             // ─── Profile Card ──────────────────────────────────────────
//             Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: primaryColor.withOpacity(0.08),
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: primaryColor.withOpacity(0.2)),
//               ),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundColor: primaryColor,
//                     child: const Text(
//                       'AK',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 14),
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Ali',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         SizedBox(height: 2),
//                         Text(
//                           'ali@email.com',
//                           style: TextStyle(fontSize: 13, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                   OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       side: BorderSide(color: primaryColor),
//                       foregroundColor: primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     onPressed: () {},
//                     child: const Text('Edit', style: TextStyle(fontSize: 13)),
//                   ),
//                 ],
//               ),
//             ),

//             // ─── Preferences ──────────────────────────────────────────
//             _sectionLabel('Preferences'),
//             _settingsCard([
//               _settingsTile(
//                 icon: Icons.dark_mode_outlined,
//                 iconBg: primaryColor.withOpacity(0.13),
//                 title: 'Dark Mode',
//                 subtitle: 'Switch app appearance',
//                 // ValueListenableBuilder so only the Switch rebuilds
//                 trailing: ValueListenableBuilder<ThemeMode>(
//                   valueListenable: themeNotifier,
//                   builder: (context, mode, _) => Switch(
//                     value: mode == ThemeMode.dark,
//                     activeThumbColor: primaryColor,
//                     onChanged: (val) {
//                       // 👇 This one line updates EVERY screen in the app
//                       themeNotifier.value = val
//                           ? ThemeMode.dark
//                           : ThemeMode.light;
//                     },
//                   ),
//                 ),
//               ),
//               _settingsTile(
//                 icon: Icons.notifications_outlined,
//                 iconBg: Colors.blue.withOpacity(0.13),
//                 title: 'Notifications',
//                 subtitle: 'Quotes, updates & offers',
//                 trailing: Switch(
//                   value: notificationsEnabled,
//                   activeThumbColor: primaryColor,
//                   onChanged: (val) =>
//                       setState(() => notificationsEnabled = val),
//                 ),
//               ),
//               _settingsTile(
//                 icon: Icons.location_on_outlined,
//                 iconBg: Colors.green.withOpacity(0.13),
//                 title: 'Default City',
//                 subtitle: selectedCity,
//                 onTap: _showCityPicker,
//               ),
//               _settingsTile(
//                 icon: Icons.language_outlined,
//                 iconBg: Colors.teal.withOpacity(0.13),
//                 title: 'Language',
//                 subtitle: selectedLanguage,
//                 showDivider: false,
//                 onTap: () {},
//               ),
//             ]),

//             // ─── Account ──────────────────────────────────────────────
//             _sectionLabel('Account'),
//             _settingsCard([
//               _settingsTile(
//                 icon: Icons.person_outline,
//                 iconBg: primaryColor.withOpacity(0.13),
//                 title: 'Personal Information',
//                 subtitle: 'Name, phone, email',
//                 onTap: () {},
//               ),
//               _settingsTile(
//                 icon: Icons.lock_outline,
//                 iconBg: Colors.orange.withOpacity(0.13),
//                 title: 'Change Password',
//                 subtitle: 'Update your password',
//                 onTap: _showChangePasswordDialog,
//               ),
//               _settingsTile(
//                 icon: Icons.bookmark_border,
//                 iconBg: Colors.purple.withOpacity(0.13),
//                 title: 'My Bookings',
//                 subtitle: 'View all vendor bookings',
//                 onTap: () {},
//               ),
//               _settingsTile(
//                 icon: Icons.favorite_border,
//                 iconBg: Colors.red.withOpacity(0.13),
//                 title: 'Saved Vendors',
//                 subtitle: 'Your favourites list',
//                 onTap: () {},
//               ),
//               _settingsTile(
//                 icon: Icons.description_outlined,
//                 iconBg: Colors.blue.withOpacity(0.13),
//                 title: 'My Quotes',
//                 subtitle: 'Submitted event requests',
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 2,
//                       ),
//                       decoration: BoxDecoration(
//                         color: primaryColor,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Text(
//                         '3',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     const Icon(
//                       Icons.chevron_right,
//                       color: Colors.grey,
//                       size: 20,
//                     ),
//                   ],
//                 ),
//                 showDivider: false,
//                 onTap: () {},
//               ),
//             ]),

//             // ─── Privacy & Security ───────────────────────────────────
//             _sectionLabel('Privacy & Security'),
//             _settingsCard([
//               _settingsTile(
//                 icon: Icons.security,
//                 iconBg: primaryColor.withOpacity(0.13),
//                 title: 'Two-Factor Auth',
//                 subtitle: 'Protect your account',
//                 trailing: Switch(
//                   value: twoFactorEnabled,
//                   activeThumbColor: primaryColor,
//                   onChanged: (val) => setState(() => twoFactorEnabled = val),
//                 ),
//               ),
//               _settingsTile(
//                 icon: Icons.visibility_outlined,
//                 iconBg: Colors.green.withOpacity(0.13),
//                 title: 'Profile Visibility',
//                 subtitle: 'Public',
//                 onTap: () {},
//               ),
//               _settingsTile(
//                 icon: Icons.shield_outlined,
//                 iconBg: Colors.purple.withOpacity(0.13),
//                 title: 'Data & Privacy',
//                 subtitle: 'Manage your data',
//                 showDivider: false,
//                 onTap: () {},
//               ),
//             ]),

//             // ─── Support ──────────────────────────────────────────────
//             _sectionLabel('Support'),
//             _settingsCard([
//               _settingsTile(
//                 icon: Icons.help_outline,
//                 iconBg: Colors.blue.withOpacity(0.13),
//                 title: 'Help & FAQ',
//                 subtitle: 'Common questions',
//                 onTap: () {},
//               ),
//               _settingsTile(
//                 icon: Icons.support_agent,
//                 iconBg: Colors.green.withOpacity(0.13),
//                 title: 'Contact Support',
//                 subtitle: 'Report an issue',
//                 onTap: () {},
//               ),
//               _settingsTile(
//                 icon: Icons.star_outline,
//                 iconBg: Colors.amber.withOpacity(0.13),
//                 title: 'Rate the App',
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 2,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Text(
//                         'New',
//                         style: TextStyle(
//                           color: Colors.green,
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     const Icon(
//                       Icons.chevron_right,
//                       color: Colors.grey,
//                       size: 20,
//                     ),
//                   ],
//                 ),
//                 onTap: () {},
//               ),
//               _settingsTile(
//                 icon: Icons.article_outlined,
//                 iconBg: Colors.purple.withOpacity(0.13),
//                 title: 'Terms & Privacy Policy',
//                 showDivider: false,
//                 onTap: () {},
//               ),
//             ]),

//             // ─── Danger Zone ──────────────────────────────────────────
//             _sectionLabel('Danger Zone'),
//             _settingsCard([
//               _settingsTile(
//                 icon: Icons.delete_outline,
//                 iconBg: Colors.red.withOpacity(0.13),
//                 title: 'Delete Account',
//                 subtitle: 'Permanently remove your data',
//                 titleColor: Colors.red,
//                 trailing: const Icon(
//                   Icons.chevron_right,
//                   color: Colors.red,
//                   size: 20,
//                 ),
//                 showDivider: false,
//                 onTap: _showDeleteAccountDialog,
//               ),
//             ]),

//             // ─── Logout Button ────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: OutlinedButton.icon(
//                   style: OutlinedButton.styleFrom(
//                     side: const BorderSide(color: Colors.red, width: 1.5),
//                     foregroundColor: Colors.red,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: _showLogoutDialog,
//                   icon: const Icon(Icons.logout),
//                   label: const Text(
//                     'Log Out',
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//             ),

//             // ─── Version ──────────────────────────────────────────────
//             const Center(
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: 24),
//                 child: Text(
//                   'Events Affairs v1.0.0 · Made with love in Pakistan',
//                   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';
import 'theme_notifier.dart';
import 'app_localizations.dart';
import 'login.dart';
import 'my_bookings.dart';
import 'saved_vendors.dart';
import 'saved_blogs.dart';
import 'couple_profile_edit.dart';
import 'account_deletion.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool twoFactorEnabled = false;
  String selectedCity = 'Lahore';
  String selectedLanguage = AppLocalizations.languageNameFromCode(localeNotifier.value.languageCode);
  /// Display name from Firestore `users.name` when set.
  String? _profileNameFromFirestore;

  final Color primaryColor = const Color(0xffB4245D);
  late final List<String> _languageOptions = AppLocalizations.languageNames.values.toList();

  @override
  void initState() {
    super.initState();
    _loadUserProfileFromFirestore();
  }

  /// Loads `users/{uid}` name + city for profile header and default city picker.
  Future<void> _loadUserProfileFromFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!mounted || !doc.exists) {
        setState(() => _profileNameFromFirestore = null);
        return;
      }
      final d = doc.data()!;
      final city = (d['city'] ?? '').toString().trim();
      final name = (d['name'] ?? '').toString().trim();
      setState(() {
        _profileNameFromFirestore = name.isNotEmpty ? name : null;
        if (city.isNotEmpty) selectedCity = city;
      });
    } catch (_) {}
  }

  String _profileDisplayTitle() {
    final u = user;
    return _profileNameFromFirestore ??
        u?.displayName ??
        (u?.email != null ? u!.email!.split('@').first : 'User');
  }

  Future<void> _openCoupleProfileEdit() async {
    if (FirebaseAuth.instance.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to edit your profile.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const CoupleProfileEditPage(),
      ),
    );
    if (mounted) await _loadUserProfileFromFirestore();
  }

  Future<void> _persistDefaultCity(String city) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
        {'city': city},
        SetOptions(merge: true),
      );
    } catch (_) {}
  }

User? get user => FirebaseAuth.instance.currentUser;
String getInitials(String? name, String? email) {
  if (name != null && name.trim().isNotEmpty) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
  }

  if (email != null && email.isNotEmpty) {
    return email[0].toUpperCase();
  }

  return 'U';
}
  void _showLogoutDialog() {
    final t = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.translate('logout')), 
        content: Text(t.translate('logoutDialogMessage')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.translate('cancel'), style: const TextStyle(color: Colors.grey)),
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
            child: Text(t.translate('logout'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Change Password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: currentCtrl,
                obscureText: true,
                cursorColor: primaryColor,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                  floatingLabelStyle: TextStyle(color: primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 1.8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newCtrl,
                obscureText: true,
                cursorColor: primaryColor,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                  floatingLabelStyle: TextStyle(color: primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 1.8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmCtrl,
                obscureText: true,
                cursorColor: primaryColor,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                  floatingLabelStyle: TextStyle(color: primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 1.8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (newCtrl.text != confirmCtrl.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Passwords do not match'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (newCtrl.text.length < 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Password must be at least 6 characters',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          setModalState(() => isLoading = true);
                          try {
                            final user = FirebaseAuth.instance.currentUser!;
                            final cred = EmailAuthProvider.credential(
                              email: user.email!,
                              password: currentCtrl.text,
                            );
                            await user.reauthenticateWithCredential(cred);
                            await user.updatePassword(newCtrl.text);
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password changed successfully!'),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            setModalState(() => isLoading = false);
                            String msg = 'Failed to change password.';
                            if (e.code == 'wrong-password') {
                              msg = 'Current password is incorrect.';
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(msg),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Change Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    promptDeleteAccount(
      context,
      title: 'Delete account?',
      message:
          'This will permanently remove your profile, saved vendors list, '
          'and inquiries you sent to vendors. This cannot be undone.',
    );
  }

  void _showLanguagePicker() {
    final t = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              t.translate('selectLanguage'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          ..._languageOptions.map(
            (language) => ListTile(
              title: Text(language),
              trailing: selectedLanguage == language
                  ? Icon(Icons.check, color: primaryColor)
                  : null,
              onTap: () {
                final code = AppLocalizations.languageCodeFromName(language);
                setState(() {
                  selectedLanguage = language;
                });
                localeNotifier.value = AppLocalizations.localeFromLanguageCode(code);
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showCityPicker() {
    final t = AppLocalizations.of(context);
    final cities = ['Lahore', 'Karachi', 'Islamabad', 'Multan', 'Peshawar'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              t.translate('selectDefaultCity'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          ...cities.map(
            (city) => ListTile(
              title: Text(city),
              trailing: selectedCity == city
                  ? Icon(Icons.check, color: primaryColor)
                  : null,
              onTap: () async {
                setState(() => selectedCity = city);
                Navigator.pop(context);
                await _persistDefaultCity(city);
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
          trailing: trailing ??
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
            // ─── Back Button ───────────────────────────────────────────
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
                  Text(
                    AppLocalizations.of(context).translate('back'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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

                  // CircleAvatar(
                  //   radius: 30,
                  //   backgroundColor: primaryColor,
                  //   child: const Text(
                  //     'AK',
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),

                  CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor,
                    child: Text(
                      getInitials(
                        _profileNameFromFirestore ?? user?.displayName,
                        user?.email,
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // const Expanded(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         'Ali',
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //       SizedBox(height: 2),
                  //       Text(
                  //         'ali@email.com',
                  //         style: TextStyle(fontSize: 13, color: Colors.grey),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        _profileDisplayTitle(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        user?.email ?? '',
        style: const TextStyle(fontSize: 13, color: Colors.grey),
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
                    onPressed: _openCoupleProfileEdit,
                    child: Text(AppLocalizations.of(context).translate('edit'), style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),

            // ─── Preferences ──────────────────────────────────────────
            _sectionLabel(AppLocalizations.of(context).translate('preferences')),
            _settingsCard([
              _settingsTile(
                icon: Icons.dark_mode_outlined,
                iconBg: primaryColor.withOpacity(0.13),
                title: AppLocalizations.of(context).translate('darkMode'),
                subtitle: AppLocalizations.of(context).translate('switchAppAppearance'),
                trailing: ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (context, mode, _) => Switch(
                    value: mode == ThemeMode.dark,
                    activeThumbColor: primaryColor,
                    onChanged: (val) {
                      themeNotifier.value =
                          val ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                ),
              ),
              _settingsTile(
                icon: Icons.notifications_outlined,
                iconBg: Colors.blue.withOpacity(0.13),
                title: AppLocalizations.of(context).translate('notifications'),
                subtitle: AppLocalizations.of(context).translate('notificationsSubtitle'),
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
                title: AppLocalizations.of(context).translate('defaultCity'),
                subtitle: selectedCity,
                onTap: _showCityPicker,
              ),
              _settingsTile(
                icon: Icons.language_outlined,
                iconBg: Colors.teal.withOpacity(0.13),
                title: AppLocalizations.of(context).translate('language'),
                subtitle: selectedLanguage,
                showDivider: false,
                onTap: _showLanguagePicker,
              ),
            ]),

            // ─── Account ──────────────────────────────────────────────
            _sectionLabel(AppLocalizations.of(context).translate('account')),
            _settingsCard([
              _settingsTile(
                icon: Icons.person_outline,
                iconBg: primaryColor.withOpacity(0.13),
                title: AppLocalizations.of(context).translate('personalInformation'),
                subtitle: AppLocalizations.of(context).translate('namePhoneEmail'),
                onTap: _openCoupleProfileEdit,
              ),
              _settingsTile(
                icon: Icons.lock_outline,
                iconBg: Colors.orange.withOpacity(0.13),
                title: AppLocalizations.of(context).translate('changePassword'),
                subtitle: AppLocalizations.of(context).translate('updateYourPassword'),
                onTap: _showChangePasswordDialog,
              ),
              _settingsTile(
                icon: Icons.bookmark_border,
                iconBg: Colors.purple.withOpacity(0.13),
                title: AppLocalizations.of(context).translate('myBookings'),
                subtitle: AppLocalizations.of(context).translate('viewVendorBookings'),
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const MyBookingsPage(),
                    ),
                  );
                },
              ),
              _settingsTile(
                icon: Icons.favorite_border,
                iconBg: Colors.red.withOpacity(0.13),
                title: AppLocalizations.of(context).translate('savedVendors'),
                subtitle: AppLocalizations.of(context).translate('savedVendorsSubtitle'),
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const SavedVendorsPage(),
                    ),
                  );
                },
              ),
              _settingsTile(
                icon: Icons.bookmark_border,
                iconBg: Colors.amber.withOpacity(0.13),
                title: AppLocalizations.of(context).translate('savedBlogs'),
                subtitle: AppLocalizations.of(context).translate('articlesSavedForReading'),
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const SavedBlogsPage(),
                    ),
                  );
                },
              ),
              // _settingsTile(
              //   icon: Icons.description_outlined,
              //   iconBg: Colors.blue.withOpacity(0.13),
              //   title: 'My Quotes',
              //   subtitle: 'Submitted event requests',
              //   trailing: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Container(
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 8,
              //           vertical: 2,
              //         ),
              //         decoration: BoxDecoration(
              //           color: primaryColor,
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //         child: const Text(
              //           '3',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 11,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //       const SizedBox(width: 8),
              //       const Icon(
              //         Icons.chevron_right,
              //         color: Colors.grey,
              //         size: 20,
              //       ),
              //     ],
              //   ),
              //   showDivider: false,
              //   onTap: () {},
              // ),
            ]),

            // ─── Privacy & Security ───────────────────────────────────
            _sectionLabel('Privacy & Security'),
            _settingsCard([
              _settingsTile(
                icon: Icons.security,
                iconBg: primaryColor.withOpacity(0.13),
                title:  AppLocalizations.of(context).translate('TwoFactorAuth'),
                subtitle: AppLocalizations.of(context).translate('protectYourAccount'),
                trailing: Switch(
                  value: twoFactorEnabled,
                  activeThumbColor: primaryColor,
                  onChanged: (val) => setState(() => twoFactorEnabled = val),
                ),
              ),
              _settingsTile(
                icon: Icons.visibility_outlined,
                iconBg: Colors.green.withOpacity(0.13),
                title: AppLocalizations.of(context).translate('profileVisibility'),
                subtitle: AppLocalizations.of(context).translate('public'),
                onTap: () {},
              ),
              _settingsTile(
                icon: Icons.shield_outlined,
                iconBg: Colors.purple.withOpacity(0.13),
                title: AppLocalizations.of(context).translate('dataPrivacy'),
                subtitle: AppLocalizations.of(context).translate('manageYourData'),
                showDivider: false,
                onTap: () {},
              ),
            ]),

            // ─── Support ──────────────────────────────────────────────
            _sectionLabel(AppLocalizations.of(context).translate('support')),
            _settingsCard([
              _settingsTile(
                icon: Icons.help_outline,
                iconBg: Colors.blue.withOpacity(0.13),
                title: AppLocalizations.of(context).translate('helpFaq'),
                subtitle: AppLocalizations.of(context).translate('commonQuestions'),
                onTap: () {},
              ),
              _settingsTile(
                icon: Icons.support_agent,
                iconBg: Colors.green.withOpacity(0.13),
                title: AppLocalizations.of(context).translate('contactSupport'),
                subtitle: AppLocalizations.of(context).translate('reportAnIssue'),
                onTap: () {},
              ),
              _settingsTile(
                icon: Icons.star_outline,
                iconBg: Colors.amber.withOpacity(0.13),
                title: AppLocalizations.of(context).translate('rateApp'),
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
                title: AppLocalizations.of(context).translate('TermsConditions'),
                showDivider: false,
                onTap: () {},
              ),
            ]),

            // ─── Danger Zone ──────────────────────────────────────────
            _sectionLabel(AppLocalizations.of(context).translate('dangerZone')),
            _settingsCard([
              _settingsTile(
                icon: Icons.delete_outline,
                iconBg: Colors.red.withOpacity(0.13),
                title: AppLocalizations.of(context).translate('deleteAccount'),
                subtitle: AppLocalizations.of(context).translate('deleteAccountSubtitle'),
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
                  label: Text(
                    AppLocalizations.of(context).translate('logout'),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
