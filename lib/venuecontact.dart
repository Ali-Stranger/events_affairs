// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'footer.dart';
// import 'drawer.dart';

// // ── Global notification plugin ──────────────────────────────────────────────
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // ═══════════════════════════════════════════════════════════════
// //  VENUE CONTACT PAGE
// // ═══════════════════════════════════════════════════════════════

// class VenueContactPage extends StatefulWidget {
//   final String name;
//   final String location;
//   final String price;
//   final String image;
//   final String category;
//   final double rating;
//   final int reviews;
//   final String capacity;
//   final List<String> amenities;
//   final String description;

//   const VenueContactPage({
//     super.key,
//     required this.name,
//     required this.location,
//     required this.price,
//     required this.image,
//     required this.category,
//     required this.rating,
//     required this.reviews,
//     required this.capacity,
//     required this.amenities,
//     required this.description,
//   });

//   @override
//   State<VenueContactPage> createState() => _VenueContactPageState();
// }

// class _VenueContactPageState extends State<VenueContactPage> {
//   static const Color primary = Color(0xffB4245D);

//   // Form
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _phoneCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _messageCtrl = TextEditingController();
//   DateTime? _selectedDate;

//   // State
//   bool _isSubmitting = false;
//   bool _isSubmitted = false;
//   bool _isBookmarked = false;

//   @override
//   void initState() {
//     super.initState();
//     _initNotifications();
//   }

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _phoneCtrl.dispose();
//     _emailCtrl.dispose();
//     _messageCtrl.dispose();
//     super.dispose();
//   }

//   // ── Notifications ──────────────────────────────────────────────────────────
//   Future<void> _initNotifications() async {
//     const AndroidInitializationSettings android =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     await flutterLocalNotificationsPlugin.initialize(
//   settings: InitializationSettings(
//     android: android,
//   ),
// );
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
//   }

//   Future<void> _showNotification() async {
//     const AndroidNotificationDetails android = AndroidNotificationDetails(
//       'venue_channel',
//       'Venue Requests',
//       channelDescription: 'Notifications for venue contact requests',
//       importance: Importance.max,
//       priority: Priority.high,
//       icon: '@mipmap/ic_launcher',
//     );
//     await flutterLocalNotificationsPlugin.show(
//   id: 0,
//   title: '✅ Request Sent to ${widget.name}',
//   body: 'The vendor will contact you shortly on ${_phoneCtrl.text}.',
//   notificationDetails: NotificationDetails(
//     android: android,
//   ),
// );
//   }

//   // ── Date picker ────────────────────────────────────────────────────────────
//   Future<void> _pickDate() async {
//     final now = DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: now.add(const Duration(days: 7)),
//       firstDate: now,
//       lastDate: DateTime(now.year + 2),
//       builder: (ctx, child) => Theme(
//         data: Theme.of(ctx).copyWith(
//           colorScheme: const ColorScheme.light(primary: primary),
//         ),
//         child: child!,
//       ),
//     );
//     if (picked != null) setState(() => _selectedDate = picked);
//   }

//   // ── Submit form ────────────────────────────────────────────────────────────
//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_selectedDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select a preferred event date'),
//           backgroundColor: Colors.orange,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }

//     setState(() => _isSubmitting = true);
//     await Future.delayed(const Duration(seconds: 1)); // simulate network call
//     await _showNotification();
//     setState(() {
//       _isSubmitting = false;
//       _isSubmitted = true;
//     });
//   }

//   String _formatDate(DateTime d) =>
//       '${d.day} ${_monthName(d.month)} ${d.year}';

//   String _monthName(int m) => const [
//         '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//         'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//       ][m];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const CommonDrawer(),
//       appBar: const CommonAppBar(),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             // ── Header ─────────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Row(
//                 children: [
//                   Builder(
//                     builder: (ctx) => IconButton(
//                       icon: const Icon(Icons.menu),
//                       onPressed: () => Scaffold.of(ctx).openDrawer(),
//                     ),
//                   ),
//                   Image.asset('assets/images/logo.png', width: 80, height: 80),
//                 ],
//               ),
//             ),

//             // ── Hero image ──────────────────────────────────────────
//             Stack(
//               children: [
//                 Image.asset(
//                   widget.image,
//                   height: 220,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => Container(
//                     height: 220,
//                     color: primary.withOpacity(0.1),
//                     child: const Icon(Icons.image, size: 60, color: Colors.grey),
//                   ),
//                 ),
//                 Container(
//                   height: 220,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withOpacity(0.65),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Back button
//                 Positioned(
//                   top: 12,
//                   left: 12,
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.4),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(Icons.arrow_back,
//                           color: Colors.white, size: 20),
//                     ),
//                   ),
//                 ),
//                 // Bookmark button
//                 Positioned(
//                   top: 12,
//                   right: 12,
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() => _isBookmarked = !_isBookmarked);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(_isBookmarked
//                               ? '${widget.name} saved to favourites!'
//                               : 'Removed from favourites'),
//                           backgroundColor: primary,
//                           behavior: SnackBarBehavior.floating,
//                           duration: const Duration(seconds: 2),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.4),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Venue name overlay
//                 Positioned(
//                   bottom: 14,
//                   left: 16,
//                   right: 16,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: primary,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           widget.category,
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 11,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         widget.name,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           const Icon(Icons.location_on,
//                               color: Colors.white70, size: 14),
//                           const SizedBox(width: 3),
//                           Text(widget.location,
//                               style: const TextStyle(
//                                   color: Colors.white70, fontSize: 13)),
//                           const SizedBox(width: 12),
//                           const Icon(Icons.star,
//                               color: Colors.amber, size: 14),
//                           const SizedBox(width: 3),
//                           Text(
//                             '${widget.rating} (${widget.reviews} reviews)',
//                             style: const TextStyle(
//                                 color: Colors.white70, fontSize: 13),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             // ── Quick info cards ────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 children: [
//                   _infoChip(Icons.attach_money, widget.price, primary),
//                   const SizedBox(width: 10),
//                   _infoChip(Icons.people_outline, widget.capacity, Colors.indigo),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             // ── Description ─────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('About this Venue',
//                       style: TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Text(
//                     widget.description,
//                     style: const TextStyle(fontSize: 14, height: 1.6),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             // ── Amenities ───────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Amenities',
//                       style: TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 8,
//                     children: widget.amenities.map((a) {
//                       return Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 14, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: primary.withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(color: primary.withOpacity(0.25)),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Icon(Icons.check_circle_outline,
//                                 size: 14, color: primary),
//                             const SizedBox(width: 5),
//                             Text(a,
//                                 style: const TextStyle(
//                                     color: primary,
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w500)),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 24),

//             // ── Contact form ────────────────────────────────────────
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: primary.withOpacity(0.04),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: primary.withOpacity(0.2)),
//               ),
//               child: _isSubmitted
//                   ? _SuccessView(venueName: widget.name)
//                   : Form(
//                       key: _formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [

//                           const Text(
//                             'Send Enquiry',
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'Fill in your details and the venue will contact you shortly.',
//                             style: TextStyle(
//                                 fontSize: 13, color: Colors.grey.shade600),
//                           ),

//                           const SizedBox(height: 18),

//                           // Name
//                           _formField(
//                             controller: _nameCtrl,
//                             label: 'Full Name',
//                             icon: Icons.person_outline,
//                             validator: (v) =>
//                                 v == null || v.trim().isEmpty
//                                     ? 'Please enter your name'
//                                     : null,
//                           ),

//                           const SizedBox(height: 12),

//                           // Phone
//                           _formField(
//                             controller: _phoneCtrl,
//                             label: 'Phone Number',
//                             icon: Icons.phone_outlined,
//                             keyboardType: TextInputType.phone,
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly,
//                               LengthLimitingTextInputFormatter(11),
//                             ],
//                             validator: (v) {
//                               if (v == null || v.trim().isEmpty) {
//                                 return 'Please enter your phone number';
//                               }
//                               if (v.length < 10) {
//                                 return 'Enter a valid phone number';
//                               }
//                               return null;
//                             },
//                           ),

//                           const SizedBox(height: 12),

//                           // Email
//                           _formField(
//                             controller: _emailCtrl,
//                             label: 'Email Address',
//                             icon: Icons.email_outlined,
//                             keyboardType: TextInputType.emailAddress,
//                             validator: (v) {
//                               if (v == null || v.trim().isEmpty) {
//                                 return 'Please enter your email';
//                               }
//                               if (!v.contains('@') || !v.contains('.')) {
//                                 return 'Enter a valid email address';
//                               }
//                               return null;
//                             },
//                           ),

//                           const SizedBox(height: 12),

//                           // Event Date picker
//                           GestureDetector(
//                             onTap: _pickDate,
//                             child: Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 14, vertical: 14),
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: primary.withOpacity(0.4)),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Icon(Icons.calendar_today_outlined,
//                                       color: primary, size: 20),
//                                   const SizedBox(width: 10),
//                                   Text(
//                                     _selectedDate == null
//                                         ? 'Select Event Date'
//                                         : 'Event Date: ${_formatDate(_selectedDate!)}',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: _selectedDate == null
//                                           ? Colors.grey.shade500
//                                           : Colors.black87,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 12),

//                           // Message
//                           TextFormField(
//                             controller: _messageCtrl,
//                             maxLines: 3,
//                             decoration: InputDecoration(
//                               labelText: 'Additional Message (optional)',
//                               alignLabelWithHint: true,
//                               prefixIcon: const Padding(
//                                 padding: EdgeInsets.only(bottom: 40),
//                                 child: Icon(Icons.message_outlined,
//                                     color: primary, size: 20),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: BorderSide(
//                                     color: primary.withOpacity(0.4)),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                     color: primary, width: 1.5),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: BorderSide(
//                                     color: primary.withOpacity(0.3)),
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 20),

//                           // Submit button
//                           SizedBox(
//                             width: double.infinity,
//                             height: 50,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: primary,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12)),
//                               ),
//                               onPressed: _isSubmitting ? null : _submit,
//                               child: _isSubmitting
//                                   ? const SizedBox(
//                                       height: 22,
//                                       width: 22,
//                                       child: CircularProgressIndicator(
//                                         color: Colors.white,
//                                         strokeWidth: 2,
//                                       ),
//                                     )
//                                   : const Text(
//                                       'Send Enquiry to Venue',
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//             ),

//             const SizedBox(height: 24),
//             const AppFooter(),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Helpers ────────────────────────────────────────────────────────────────

//   Widget _infoChip(IconData icon, String label, Color color) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: color.withOpacity(0.2)),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: color, size: 18),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 label,
//                 style: TextStyle(
//                     fontSize: 13,
//                     color: color,
//                     fontWeight: FontWeight.w600),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _formField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType? keyboardType,
//     List<TextInputFormatter>? inputFormatters,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       inputFormatters: inputFormatters,
//       validator: validator,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: primary, size: 20),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: primary.withOpacity(0.4)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: primary, width: 1.5),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: primary.withOpacity(0.3)),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.red),
//         ),
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════
// //  SUCCESS VIEW
// // ═══════════════════════════════════════════════════════════════

// class _SuccessView extends StatelessWidget {
//   final String venueName;
//   const _SuccessView({required this.venueName});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 10),
//         Container(
//           width: 70,
//           height: 70,
//           decoration: BoxDecoration(
//             color: Colors.green.withOpacity(0.12),
//             shape: BoxShape.circle,
//           ),
//           child: const Icon(Icons.check_circle_outline,
//               color: Colors.green, size: 42),
//         ),
//         const SizedBox(height: 16),
//         const Text(
//           'Enquiry Sent!',
//           style: TextStyle(
//               fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Your request has been sent to $venueName.\nThey will contact you shortly.',
//           textAlign: TextAlign.center,
//           style: const TextStyle(fontSize: 14, height: 1.6),
//         ),
//         const SizedBox(height: 20),
//         OutlinedButton.icon(
//           style: OutlinedButton.styleFrom(
//             side: const BorderSide(color: Color(0xffB4245D)),
//             foregroundColor: const Color(0xffB4245D),
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10)),
//           ),
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back, size: 16),
//           label: const Text('Back to Venues'),
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_localizations.dart';
import 'footer.dart';
import 'drawer.dart';
import 'saved_vendors_repository.dart';

// ── Global notification plugin ──────────────────────────────────────────────
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// ═══════════════════════════════════════════════════════════════
//  VENUE CONTACT PAGE
// ═══════════════════════════════════════════════════════════════

class VenueContactPage extends StatefulWidget {
  final String name;
  final String location;
  final String price;
  final String image;
  final String category;
  final double rating;
  final int reviews;
  final String capacity;
  final List<String> amenities;
  final String description;

  const VenueContactPage({
    super.key,
    required this.name,
    required this.location,
    required this.price,
    required this.image,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.capacity,
    required this.amenities,
    required this.description,
  });

  @override
  State<VenueContactPage> createState() => _VenueContactPageState();
}

class _VenueContactPageState extends State<VenueContactPage> {
  static const Color primary = Color(0xffB4245D);

  // Form
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  DateTime? _selectedDate;
  bool _vendorUidLoaded = false;

  // State
  // State
  bool _isSubmitting = false;
  bool _isSubmitted = false;
  bool _isBookmarked = false;

  // Review state
  bool _showReviewForm = false;
  int _reviewRating = 5;
  final _reviewCtrl = TextEditingController();
  bool _reviewSubmitted = false;
  bool _reviewSubmitting = false;
  String? _vendorUid; // users/{vendorUid}
  /// Trimmed `startingPrice` from `users/{vendorUid}` when set in vendor profile edit.
  String? _profileStartingPriceRaw;

  @override
  void initState() {
    super.initState();
    _initNotifications();
    _loadVendorUid();
  }

  Future<String?> _fetchVendorUid() async {
    // widget.name is passed as the vendor business name from the listing page.
    final vendorSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('businessName', isEqualTo: widget.name)
        .where('role', isEqualTo: 'vendor')
        .limit(1)
        .get();

    if (vendorSnap.docs.isEmpty) return null;
    return vendorSnap.docs.first.id;
  }

  static String _startingPriceFromUserData(Map<String, dynamic> data) {
    final sp = data['startingPrice'];
    if (sp == null) return '';
    if (sp is num) {
      final n = sp.toDouble();
      if (n == n.roundToDouble()) return n.round().toString();
      return n.toString();
    }
    return sp.toString().trim();
  }

  /// Display label: profile starting price when present, else listing fallback (`widget.price`).
  String _priceDisplayLabel() {
    final raw = _profileStartingPriceRaw;
    if (raw != null && raw.isNotEmpty) {
      final lower = raw.toLowerCase();
      if (lower.contains('pkr') ||
          lower.startsWith('rs') ||
          lower.contains('rs ') ||
          lower.contains('rs.')) {
        return raw;
      }
      return 'PKR $raw';
    }
    return widget.price;
  }

  Future<void> _loadVendorUid() async {
    final vendorSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('businessName', isEqualTo: widget.name)
        .where('role', isEqualTo: 'vendor')
        .limit(1)
        .get();

    String? id;
    String? startingRaw;
    if (vendorSnap.docs.isNotEmpty) {
      final data = vendorSnap.docs.first.data();
      id = vendorSnap.docs.first.id;
      final s = _startingPriceFromUserData(data);
      if (s.isNotEmpty) startingRaw = s;
    }

    if (!mounted) return;
    setState(() {
      _vendorUid = id;
      _profileStartingPriceRaw = startingRaw;
      _vendorUidLoaded = true;
    });
    await _syncBookmarkFromSaved();
  }

  Future<void> _syncBookmarkFromSaved() async {
    final customerUid = FirebaseAuth.instance.currentUser?.uid;
    final vid = _vendorUid;
    if (customerUid == null || vid == null) return;
    try {
      final saved = await SavedVendorsRepository.loadIdSet();
      if (!mounted) return;
      setState(() => _isBookmarked = saved.contains(vid));
    } catch (_) {}
  }

  Future<void> _onBookmarkTap() async {
    final t = AppLocalizations.of(context);
    final customerUid = FirebaseAuth.instance.currentUser?.uid;
    if (customerUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.translate('signInToSaveVendors')),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final vid = _vendorUid;
    if (vid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.translate('vendorProfileLoadingTryAgain')),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final next = !_isBookmarked;
    try {
      if (next) {
        await SavedVendorsRepository.addVendor(vid);
      } else {
        await SavedVendorsRepository.removeVendor(vid);
      }
      if (!mounted) return;
      setState(() => _isBookmarked = next);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            next
                ? '${widget.name} ${t.translate('savedToFavourites')}'
                : t.translate('removedFromFavourites'),
          ),
          backgroundColor: primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.translate('couldNotUpdateSavedVendors')),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _budgetCtrl.dispose();
    _messageCtrl.dispose();
    _reviewCtrl.dispose();
    super.dispose();
  }

  // ── Notifications ──────────────────────────────────────────────────────────
  Future<void> _initNotifications() async {
    const AndroidInitializationSettings android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    await flutterLocalNotificationsPlugin.initialize(
      settings: InitializationSettings(android: android),
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'venue_channel',
      'Venue Requests',
      channelDescription: 'Notifications for venue contact requests',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: '✅ Request Sent to ${widget.name}',
      body: 'The vendor will contact you shortly on ${_phoneCtrl.text}.',
      notificationDetails: NotificationDetails(android: android),
    );
  }

  // ── Date picker ────────────────────────────────────────────────────────────
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (ctx, child) => Theme(
        data: Theme.of(
          ctx,
        ).copyWith(colorScheme: const ColorScheme.light(primary: primary)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // ── Submit form ────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    final t = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.translate('pleaseSelectPreferredDate')),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.translate('pleaseLoginToSendEnquiry')),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final vendorUid = _vendorUid ?? await _fetchVendorUid();
    if (vendorUid == null) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.translate('vendorNotFoundPleaseTryAgainLater')),
      )
    );}

    try {
      final budgetPkr = _parseBudgetPkr(_budgetCtrl.text) ?? 0;

      await FirebaseFirestore.instance.collection('quotes').add({
        'vendorId': vendorUid,
        'customerId': user.uid,
        'customerEmail': _emailCtrl.text.trim(),
        'name': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'category': widget.category,
        'city': widget.location,
        'eventDate': _formatDate(_selectedDate!),
        'message': _messageCtrl.text.trim(),
        'budget': budgetPkr,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      // Write notification to vendor
      await FirebaseFirestore.instance
          .collection('users')
          .doc(vendorUid)
          .collection('notifications')
          .add({
            'title': 'New inquiry from ${_nameCtrl.text.trim()}',
            'sub': '${widget.category} · ${widget.location}',
            'icon': '📩',
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (_) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.translate('failedToSendEnquiry')),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await _showNotification();
    setState(() {
      _isSubmitting = false;
      _isSubmitted = true;
    });
  }

  Future<void> _submitReview() async {
    final t = AppLocalizations.of(context);
    if (_reviewCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.translate('pleaseWriteYourReview')),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _reviewSubmitting = true);
    try {
      // Find vendor's uid by businessName
      final vendorSnap = await FirebaseFirestore.instance
          .collection('users')
          .where('businessName', isEqualTo: widget.name)
          .where('role', isEqualTo: 'vendor')
          .get();

      if (vendorSnap.docs.isEmpty) {
        setState(() => _reviewSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.translate('vendorNotFoundPleaseTryAgainLater')),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final vendorId = vendorSnap.docs.first.id;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _reviewSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.translate('pleaseLoginToLeaveAReview')),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final customerName =
          user.displayName ?? user.email?.split('@').first ?? 'Anonymous';

      await FirebaseFirestore.instance.collection('reviews').add({
        'vendorId': vendorId,
        'customerName': customerName,
        'customerId': user.uid,
        'rating': _reviewRating,
        'service': widget.category,
        'text': _reviewCtrl.text.trim(),
        'reply': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        _reviewSubmitting = false;
        _reviewSubmitted = true;
      });
    } catch (e) {
      setState(() => _reviewSubmitting = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.translate('failedToSubmitReview')),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Parses "50000" or "50,000" → PKR integer.
  int? _parseBudgetPkr(String raw) {
    final s = raw.replaceAll(',', '').replaceAll(' ', '').trim();
    if (s.isEmpty) return null;
    return int.tryParse(s);
  }

  String _formatDate(DateTime d) => '${d.day} ${_monthName(d.month)} ${d.year}';

  String _monthName(int m) => const [
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
  ][m];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      drawer: const CommonDrawer(),
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    ),
                  ),
                  Image.asset('assets/images/logo.png', width: 80, height: 80),
                ],
              ),
            ),

            // ── Hero image ──────────────────────────────────────────
            Stack(
              children: [
                Image.asset(
                  widget.image,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 220,
                    color: primary.withOpacity(0.1),
                    child: const Icon(
                      Icons.image,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.65),
                      ],
                    ),
                  ),
                ),
                // Back button
                Positioned(
                  top: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                // Bookmark button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: _onBookmarkTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                // Venue name overlay
                Positioned(
                  bottom: 14,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white70,
                            size: 14,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            widget.location,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            '${widget.rating} (${widget.reviews} reviews)',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Quick info cards ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _infoChip(Icons.attach_money, _priceDisplayLabel(), primary),
                  const SizedBox(width: 10),
                  _infoChip(
                    Icons.people_outline,
                    widget.capacity,
                    Colors.indigo,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Description ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.translate('aboutThisVenue'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 14, height: 1.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Amenities ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.translate('amenities'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.amenities.map((a) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: primary.withOpacity(0.25)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: 14,
                              color: primary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              a,
                              style: const TextStyle(
                                color: primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Contact form ────────────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primary.withOpacity(0.2)),
              ),
              child: _isSubmitted
                  ? _SuccessView(venueName: widget.name)
                  : Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
Text(
                            t.translate('sendEnquiry'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            t.translate('fillDetailsVenueContact'),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Name
                          _formField(
                            controller: _nameCtrl,
                            label: t.translate('fullName'),
                            icon: Icons.person_outline,
                            validator: (v) => v == null || v.trim().isEmpty
                                ? t.translate('pleaseEnterYourName')
                                : null,
                          ),

                          const SizedBox(height: 12),

                          // Phone
                          _formField(
                            controller: _phoneCtrl,
                            label: t.translate('contactNumber'),
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return t.translate('pleaseEnterYourPhoneNumber');
                              }
                              if (v.length < 10) {
                                return t.translate('enterValidPhoneNumber');
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),

                          // Email
                          _formField(
                            controller: _emailCtrl,
                            label: t.translate('emailAddress'),
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return t.translate('pleaseEnterYourEmail');
                              }
                              if (!v.contains('@') || !v.contains('.')) {
                                return t.translate('enterValidEmail');
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),

                          // Estimated budget (PKR)
                          _formField(
                            controller: _budgetCtrl,
                            label: t.translate('estimatedBudgetPkr'),
                            icon: Icons.account_balance_wallet_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9,]'),
                              ),
                            ],
                            validator: (v) {
                              final n = _parseBudgetPkr(v ?? '');
                              if (n == null || n <= 0) {
                                return t.translate('enterValidBudgetAmount');
                              }
                              if (n > 100000000) {
                                return t.translate('amountTooLarge');
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),

                          // Event Date picker
                          GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: primary.withOpacity(0.4),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    color: primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _selectedDate == null
                                        ? t.translate('selectEventDate')
                                        : '${t.translate('eventDateLabel')} ${_formatDate(_selectedDate!)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _selectedDate == null
                                          ? Colors.grey.shade500
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Message
                          TextFormField(
                            controller: _messageCtrl,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: t.translate('additionalMessageOptional'),
                              alignLabelWithHint: true,
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(bottom: 40),
                                child: Icon(
                                  Icons.message_outlined,
                                  color: primary,
                                  size: 20,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: primary.withOpacity(0.4),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: primary,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: primary.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _isSubmitting ? null : _submit,
                              child: _isSubmitting
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      t.translate('sendEnquiryToVenue'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 24),

            // ── Leave a Review ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.translate('reviews'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  //                 // Show reviews from Firestore
                  //                 StreamBuilder<QuerySnapshot>(

                  //                   key: ValueKey(_vendorUidLoaded ? (_vendorUid ?? 'none') : 'loading'), // 👈
                  // stream: !_vendorUidLoaded || _vendorUid == null
                  //     ? const Stream.empty(): FirebaseFirestore.instance
                  //                       .collection('reviews')
                  //                       .where('vendorId', isEqualTo: _vendorUid ?? '')
                  //                       .orderBy('createdAt', descending: true)
                  //                       .limit(5)
                  //                       .snapshots(),
                  //                   builder: (ctx, snap) {
                  //                     if (!snap.hasData || snap.data!.docs.isEmpty) {
                  //                       return Container(
                  //                         padding: const EdgeInsets.all(16),
                  //                         decoration: BoxDecoration(
                  //                           color: primary.withOpacity(0.04),
                  //                           borderRadius: BorderRadius.circular(12),
                  //                           border: Border.all(
                  //                             color: primary.withOpacity(0.15),
                  //                           ),
                  //                         ),
                  //                         // child: const Text(
                  //                         //   'No reviews yet. Be the first to review!',
                  //                         //   style: TextStyle(color: Colors.grey),
                  //                         // ),
                  //                       );
                  //                     }
                  //                     return ListView.builder(
                  //                       shrinkWrap: true,
                  //                       physics: const NeverScrollableScrollPhysics(),
                  //                       itemCount: snap.data!.docs.length,
                  //                       itemBuilder: (ctx, i) {
                  //                         final d =
                  //                             snap.data!.docs[i].data() as Map<String, dynamic>;
                  //                         return Container(
                  //                           margin: const EdgeInsets.only(bottom: 10),
                  //                           padding: const EdgeInsets.all(14),
                  //                           decoration: BoxDecoration(
                  //                             color: primary.withOpacity(0.04),
                  //                             borderRadius: BorderRadius.circular(12),
                  //                             border: Border.all(
                  //                               color: primary.withOpacity(0.12),
                  //                             ),
                  //                           ),
                  //                           child: Column(
                  //                             crossAxisAlignment: CrossAxisAlignment.start,
                  //                             children: [
                  //                               Row(
                  //                                 children: [
                  //                                   CircleAvatar(
                  //                                     radius: 16,
                  //                                     backgroundColor: primary.withOpacity(
                  //                                       0.15,
                  //                                     ),
                  //                                     child: Text(
                  //                                       (d['customerName'] ?? 'A')[0]
                  //                                           .toUpperCase(),
                  //                                       style: const TextStyle(
                  //                                         color: primary,
                  //                                         fontWeight: FontWeight.bold,
                  //                                         fontSize: 12,
                  //                                       ),
                  //                                     ),
                  //                                   ),
                  //                                   const SizedBox(width: 10),
                  //                                   Expanded(
                  //                                     child: Text(
                  //                                       d['customerName'] ?? 'Anonymous',
                  //                                       style: const TextStyle(
                  //                                         fontWeight: FontWeight.bold,
                  //                                         fontSize: 13,
                  //                                       ),
                  //                                     ),
                  //                                   ),
                  //                                   Row(
                  //                                     children: List.generate(
                  //                                       5,
                  //                                       (j) => Icon(
                  //                                         Icons.star,
                  //                                         size: 13,
                  //                                         color: j < (d['rating'] ?? 5)
                  //                                             ? Colors.amber
                  //                                             : Colors.grey.shade300,
                  //                                       ),
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                               const SizedBox(height: 8),
                  //                               Text(
                  //                                 d['text'] ?? '',
                  //                                 style: const TextStyle(
                  //                                   fontSize: 13,
                  //                                   height: 1.5,
                  //                                 ),
                  //                               ),
                  //                               if ((d['reply'] ?? '').isNotEmpty) ...[
                  //                                 const SizedBox(height: 8),
                  //                                 Container(
                  //                                   padding: const EdgeInsets.all(10),
                  //                                   decoration: BoxDecoration(
                  //                                     color: primary.withOpacity(0.06),
                  //                                     borderRadius: BorderRadius.circular(8),
                  //                                     border: const Border(
                  //                                       left: BorderSide(
                  //                                         color: primary,
                  //                                         width: 3,
                  //                                       ),
                  //                                     ),
                  //                                   ),
                  //                                   child: Text(
                  //                                     'Vendor: ${d['reply']}',
                  //                                     style: const TextStyle(
                  //                                       fontSize: 12,
                  //                                       color: Colors.black87,
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ],
                  //                           ),
                  //                         );
                  //                       },
                  //                     );
                  //                   },
                  //                 ),

                  // Replace the StreamBuilder(...) widget with:
                  _ReviewsList(
                    vendorUid: _vendorUid,
                    vendorUidLoaded: _vendorUidLoaded,
                  ),
                  const SizedBox(height: 16),

                  // Leave a review button / form
                  if (!_reviewSubmitted) ...[
                    if (!_showReviewForm)
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: primary),
                            foregroundColor: primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () =>
                              setState(() => _showReviewForm = true),
                          icon: const Icon(
                            Icons.rate_review_outlined,
                            size: 18,
                          ),
                          label: Text(t.translate('leaveAReview')),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: primary.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.translate('yourRating'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: List.generate(
                                5,
                                (i) => GestureDetector(
                                  onTap: () =>
                                      setState(() => _reviewRating = i + 1),
                                  child: Icon(
                                    Icons.star,
                                    size: 32,
                                    color: i < _reviewRating
                                        ? Colors.amber
                                        : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _reviewCtrl,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: t.translate('shareYourExperience'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: primary,
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: primary.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        setState(() => _showReviewForm = false),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                      foregroundColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(t.translate('cancel')),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: _reviewSubmitting
                                        ? null
                                        : _submitReview,
                                    child: _reviewSubmitting
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            t.translate('submit'),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ] else
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            t.translate('reviewSubmittedThankYou'),
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _infoChip(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primary, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primary.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primary.withOpacity(0.3)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SUCCESS VIEW
// ═══════════════════════════════════════════════════════════════

class _SuccessView extends StatelessWidget {
  final String venueName;
  const _SuccessView({required this.venueName});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 42,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          t.translate('enquirySent'),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          t.translate('requestSentToVenue', {'venueName': venueName}),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, height: 1.6),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xffB4245D)),
            foregroundColor: const Color(0xffB4245D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 16),
          label: Text(t.translate('backToVenues')),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

// Add this class at the bottom of the file, outside VenueContactPage

class _ReviewsList extends StatelessWidget {
  final String? vendorUid;
  final bool vendorUidLoaded;
  static const Color primary = Color(0xffB4245D);

  const _ReviewsList({required this.vendorUid, required this.vendorUidLoaded});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    if (!vendorUidLoaded) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (vendorUid == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: primary.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primary.withOpacity(0.15)),
        ),
        child: Text(
          t.translate('noReviewsYet'),
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .where('vendorId', isEqualTo: vendorUid)
          .orderBy('createdAt', descending: true)
          .limit(5)
          .snapshots(),
      builder: (ctx, snap) {
        if (snap.hasError) {
          debugPrint('Reviews stream error: ${snap.error}');
          return Text(
            'Error: ${snap.error}',
            style: const TextStyle(color: Colors.red),
          );
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primary.withOpacity(0.15)),
            ),
            child: Text(
              t.translate('noReviewsYetBeFirstToReview'),
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snap.data!.docs.length,
          itemBuilder: (ctx, i) {
            final d = snap.data!.docs[i].data() as Map<String, dynamic>;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primary.withOpacity(0.12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: primary.withOpacity(0.15),
                        child: Text(
                          (d['customerName'] ?? 'A')[0].toUpperCase(),
                          style: const TextStyle(
                            color: primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          d['customerName'] ?? 'Anonymous',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (j) => Icon(
                            Icons.star,
                            size: 13,
                            color: j < (d['rating'] ?? 5)
                                ? Colors.amber
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    d['text'] ?? '',
                    style: const TextStyle(fontSize: 13, height: 1.5),
                  ),
                  if ((d['reply'] ?? '').isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: const Border(
                          left: BorderSide(color: primary, width: 3),
                        ),
                      ),
                      child: Text(
                        '${t.translate('vendorReplyPrefix')}${d['reply']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}
