// import 'package:flutter/material.dart';

// import 'vendor_bookings.dart';
// import 'vendor_other_screens.dart';

// const Color kPrimary = Color(0xffB4245D);

// // ═══════════════════════════════════════════════════════════════
// //  VENDOR DASHBOARD
// // ═══════════════════════════════════════════════════════════════

// class VendorDashboardPage extends StatefulWidget {
//   const VendorDashboardPage({super.key});

//   @override
//   State<VendorDashboardPage> createState() => _VendorDashboardPageState();
// }

// class _VendorDashboardPageState extends State<VendorDashboardPage> {
//   int _unreadNotifs = 5;

// Future<void> _openNotifications() async {
//   await showModalBottomSheet(
//     context: context,
//     backgroundColor: Theme.of(context).cardColor,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (_) => const _NotificationsSheet(), // remove onRead
//   );

//   setState(() => _unreadNotifs = 0); // mark after closing
// }
//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: cs.surface,
//       appBar: AppBar(
//         backgroundColor: kPrimary,
//         title: const Text(
//           'Vendor Dashboard',
//           style: TextStyle(color: Colors.white, fontSize: 16),
//         ),
//         automaticallyImplyLeading: false,
//         actions: [
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.notifications_outlined, color: Colors.white),
//                 onPressed: _openNotifications,
//               ),
//               if (_unreadNotifs > 0)
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: const BoxDecoration(
//                       color: Colors.amber,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Text(
//                       '$_unreadNotifs',
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 9,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _ProfileHeader(isDark: isDark),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 children: const [
//                   _StatCard(value: '23', label: 'Inquiries\nThis Month'),
//                   SizedBox(width: 10),
//                   _StatCard(value: '8', label: 'Leads\nReceived'),
//                   SizedBox(width: 10),
//                   _StatCard(value: '4.8 ★', label: 'Average\nRating'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const _SectionHeading('Quick Actions'),
//                   const SizedBox(height: 10),
//                   GridView.count(
//                     crossAxisCount: 3,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     children: [
//                       _QuickAction(
//                         icon: Icons.event_note_outlined,
//                         label: 'Bookings',
//                         onTap: () => Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => const VendorBookingsPage())),
//                       ),
//                       _QuickAction(
//                         icon: Icons.photo_library_outlined,
//                         label: 'Gallery',
//                         onTap: () => Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => const VendorGalleryPage())),
//                       ),
//                       _QuickAction(
//                         icon: Icons.star_outline,
//                         label: 'Reviews',
//                         onTap: () => Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => const VendorReviewsPage())),
//                       ),
//                       _QuickAction(
//                         icon: Icons.bar_chart_outlined,
//                         label: 'Analytics',
//                         onTap: () => Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => const VendorAnalyticsPage())),
//                       ),
//                       _QuickAction(
//                         icon: Icons.edit_outlined,
//                         label: 'Edit Profile',
//                         onTap: () => Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => const VendorProfileEditPage())),
//                       ),
//                       _QuickAction(
//                         icon: Icons.settings_outlined,
//                         label: 'Settings',
//                         onTap: () => Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => const VendorSettingsPage())),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       const _SectionHeading('Recent Inquiries'),
//                       const Spacer(),
//                       TextButton(
//                         onPressed: () => Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => const VendorBookingsPage())),
//                         child: const Text(
//                           'View All',
//                           style: TextStyle(color: kPrimary, fontSize: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   ..._sampleInquiries.map((inq) => _InquiryTile(inquiry: inq)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             const _ProfileCompleteness(),
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Data class ──────────────────────────────────────────────────────────────

// class _Inquiry {
//   final String name, event, date, city;
//   final double budget;
//   const _Inquiry({
//     required this.name,
//     required this.event,
//     required this.date,
//     required this.city,
//     required this.budget,
//   });
// }

// const List<_Inquiry> _sampleInquiries = [
//   _Inquiry(name: 'Ali Khan',  event: 'Wedding Décor',      date: 'May 15', city: 'Lahore',  budget: 60000),
//   _Inquiry(name: 'Sara Raza', event: 'Stage Setup',         date: 'Jun 2',  city: 'Karachi', budget: 45000),
//   _Inquiry(name: 'M. Bilal',  event: 'Floral Arrangement',  date: 'May 28', city: 'Karachi', budget: 25000),
// ];

// class _NotificationsSheet extends StatelessWidget {
//   const _NotificationsSheet();

//   static const _notifs = [
//     _NotifData('New inquiry from Ali Khan for Wedding Décor on May 15', '2 min ago', true),
//     _NotifData('Sara Raza has been connected with you — reach out directly', '1 hr ago', true),
//     _NotifData('New review posted: 5 stars by Nadia Farooq', '3 hrs ago', true),
//     _NotifData('Your profile is now visible in Karachi search results', 'Yesterday', false),
//     _NotifData('Profile completeness reached 92% — almost there!', '2 days ago', false),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const SizedBox(height: 12),
//         Container(
//           width: 40,
//           height: 4,
//           decoration: BoxDecoration(
//             color: Colors.grey.shade300,
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//           child: Row(
//             children: [
//               Text(
//                 'Notifications',
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleMedium
//                     ?.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//         const Divider(height: 1),
//         ListView.separated(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: _notifs.length,
//           separatorBuilder: (_, __) => const Divider(height: 1, indent: 44),
//           itemBuilder: (_, i) => _NotifTile(data: _notifs[i]),
//         ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }
// }

// class _NotifData {
//   final String text, time;
//   final bool unread;
//   const _NotifData(this.text, this.time, this.unread);
// }

// class _NotifTile extends StatelessWidget {
//   final _NotifData data;
//   const _NotifTile({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Container(
//         width: 8, height: 8,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: data.unread ? kPrimary : Colors.transparent,
//           border: data.unread
//               ? null
//               : Border.all(color: Colors.grey.shade400),
//         ),
//       ),
//       title: Text(data.text, style: const TextStyle(fontSize: 13)),
//       subtitle: Text(
//         data.time,
//         style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
//       ),
//     );
//   }
// }

// // ── Profile header ──────────────────────────────────────────────────────────

// class _ProfileHeader extends StatelessWidget {
//   final bool isDark;
//   const _ProfileHeader({required this.isDark});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: isDark
//             ? Colors.white.withOpacity(0.05)
//             : kPrimary.withOpacity(0.06),
//         border: Border(
//           bottom: BorderSide(
//             color: isDark
//                 ? Colors.white.withOpacity(0.1)
//                 : kPrimary.withOpacity(0.15),
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 28,
//             backgroundColor: kPrimary,
//             child: const Text(
//               'DD',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Dream Décor Co.',
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   'Decoration · Karachi',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   children: [
//                     const Icon(Icons.star, color: Colors.amber, size: 14),
//                     const SizedBox(width: 3),
//                     const Text(
//                       '4.8',
//                       style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       '(176 reviews)',
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.14),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Text(
//                         'Live',
//                         style: TextStyle(
//                           color: Colors.green,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Stat card ───────────────────────────────────────────────────────────────

// class _StatCard extends StatelessWidget {
//   final String value, label;
//   const _StatCard({required this.value, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: Theme.of(context).dividerColor.withOpacity(0.4),
//           ),
//         ),
//         child: Column(
//           children: [
//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: kPrimary,
//               ),
//             ),
//             const SizedBox(height: 3),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 10,
//                 color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Quick action ────────────────────────────────────────────────────────────

// class _QuickAction extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//   const _QuickAction({required this.icon, required this.label, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: Theme.of(context).dividerColor.withOpacity(0.4),
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: kPrimary.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, color: kPrimary, size: 20),
//             ),
//             const SizedBox(height: 7),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.w500,
//                 color: Theme.of(context).colorScheme.onSurface,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Inquiry tile ────────────────────────────────────────────────────────────

// class _InquiryTile extends StatelessWidget {
//   final _Inquiry inquiry;
//   const _InquiryTile({required this.inquiry});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Theme.of(context).dividerColor.withOpacity(0.4),
//         ),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 20,
//             backgroundColor: kPrimary.withOpacity(0.12),
//             child: Text(
//               inquiry.name[0],
//               style: const TextStyle(
//                 color: kPrimary,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   inquiry.name,
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   '${inquiry.event} · ${inquiry.date} · ${inquiry.city}',
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             'PKR ${inquiry.budget.toStringAsFixed(0)}',
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Theme.of(context).colorScheme.onSurface,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Profile completeness ────────────────────────────────────────────────────

// class _ProfileCompleteness extends StatelessWidget {
//   const _ProfileCompleteness();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Theme.of(context).dividerColor.withOpacity(0.4),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const _SectionHeading('Profile Completeness'),
//               const Spacer(),
//               Text(
//                 '92%',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green.shade600,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(4),
//             child: LinearProgressIndicator(
//               value: 0.92,
//               backgroundColor: Theme.of(context).dividerColor.withOpacity(0.3),
//               valueColor: const AlwaysStoppedAnimation(Colors.green),
//               minHeight: 7,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             'A complete profile appears higher in search results.',
//             style: TextStyle(
//               fontSize: 12,
//               color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
//             ),
//           ),
//           const SizedBox(height: 8),
//           const _TodoItem(text: 'Add WhatsApp number', done: false),
//           const _TodoItem(text: 'Add business hours',  done: false),
//           const _TodoItem(text: 'Upload CNIC',         done: true),
//           const _TodoItem(text: 'Add portfolio photos (6+)', done: true),
//         ],
//       ),
//     );
//   }
// }

// // ── Todo item ───────────────────────────────────────────────────────────────

// class _TodoItem extends StatelessWidget {
//   final String text;
//   final bool done;
//   const _TodoItem({required this.text, required this.done});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Row(
//         children: [
//           Icon(
//             done ? Icons.check_circle : Icons.radio_button_unchecked,
//             color: done ? Colors.green : Colors.grey.shade400,
//             size: 16,
//           ),
//           const SizedBox(width: 8),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 12,
//               color: done
//                   ? Theme.of(context).colorScheme.onSurface.withOpacity(0.35)
//                   : Theme.of(context).colorScheme.onSurface,
//               decoration: done ? TextDecoration.lineThrough : null,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Section heading ─────────────────────────────────────────────────────────

// class _SectionHeading extends StatelessWidget {
//   final String text;
//   const _SectionHeading(this.text);

//   @override
//   Widget build(BuildContext context) => Text(
//         text,
//         style: TextStyle(
//           fontSize: 15,
//           fontWeight: FontWeight.bold,
//           color: Theme.of(context).colorScheme.onSurface,
//         ),
//       );
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ← ADD
import 'package:cloud_firestore/cloud_firestore.dart'; // ← ADD
import 'vendor_bookings.dart';
import 'vendor_other_screens.dart';

const Color kPrimary = Color(0xffB4245D);

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

  @override
  void initState() {
    super.initState();
    _loadVendorData();
  }

  Future<void> _loadVendorData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (doc.exists) {
      setState(() {
        _vendorName = doc.data()?['name'] ?? 'Vendor';
        _businessName = doc.data()?['businessName'] ?? 'My Business';
        _category = doc.data()?['businessCategory'] ?? '';
        _city = doc.data()?['city'] ?? '';
      });
    }
  }

  Future<void> _openNotifications() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent, // Allow custom shape/color in builder
      isScrollControlled: true,
      builder: (_) => const _NotificationsSheet(),
    );
    setState(() => _unreadNotifs = 0);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Better Dark Mode Colors
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
              businessName: _businessName,
              category: _category,
              city: _city,
            ),
            const SizedBox(height: 16),

            // Statistics Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _StatCard(
                    value: '23',
                    label: 'Inquiries',
                    isDark: isDark,
                    surface: surfaceColor,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    value: '8',
                    label: 'Leads',
                    isDark: isDark,
                    surface: surfaceColor,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    value: '4.8 ★',
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
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VendorProfileEditPage(),
                          ),
                        ),
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
            _ProfileCompleteness(surface: surfaceColor, isDark: isDark),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Components ──────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final bool isDark;
  final String vendorName;
  final String businessName;
  final String category;
  final String city;

  const _ProfileHeader({
    required this.isDark,
    required this.vendorName,
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
                vendorName.isNotEmpty ? vendorName[0].toUpperCase() : 'V',
                style: const TextStyle(
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
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '4.8',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
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
          const _NotifTile(
            text: 'New inquiry from Ali Khan',
            time: 'Just now',
            unread: true,
          ),
          const _NotifTile(
            text: 'Sara Raza connected with you',
            time: '1 hr ago',
            unread: true,
          ),
          const _NotifTile(
            text: 'Profile visible in Karachi',
            time: 'Yesterday',
            unread: false,
          ),
          const _NotifTile(
            text: 'Profile completeness reached 92% — almost there!',
            time: '2 days ago',
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

class _ProfileCompleteness extends StatelessWidget {
  final Color surface;
  final bool isDark;
  const _ProfileCompleteness({required this.surface, required this.isDark});

  @override
  Widget build(BuildContext context) {
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
              const Text(
                '92%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.92,
              minHeight: 6,
              backgroundColor: Colors.black12,
              valueColor: AlwaysStoppedAnimation(Colors.green),
            ),
          ),
          const SizedBox(height: 16),
          const _TodoItem(text: 'Add WhatsApp number', done: false),
          const _TodoItem(text: 'Upload CNIC Verification', done: true),
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
