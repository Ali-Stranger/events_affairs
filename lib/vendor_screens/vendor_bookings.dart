
// import 'package:flutter/material.dart';
// // Optional: for calling/WhatsApp

// const Color kPrimary = Color(0xffB4245D);

// class _InquiryModel {
//   final String name, event, date, city;
//   final double budget;
//   final String phone;

//   const _InquiryModel({
//     required this.name,
//     required this.event,
//     required this.date,
//     required this.city,
//     required this.budget,
//     required this.phone,
//   });
// }

// // Sample Data
// const _allInquiries = [
//   _InquiryModel(name: 'Ali Khan', event: 'Wedding Décor', date: 'May 15, 2026', city: 'Lahore', budget: 60000, phone: "03001234567"),
//   _InquiryModel(name: 'Sara Raza', event: 'Stage Setup', date: 'Jun 2, 2026', city: 'Karachi', budget: 45000, phone: "03217654321"),
//   _InquiryModel(name: 'M. Bilal', event: 'Floral Arrangement', date: 'May 28, 2026', city: 'Karachi', budget: 25000, phone: "03119876543"),
//   _InquiryModel(name: 'Amna Javed', event: 'Mehndi Décor', date: 'Jun 10, 2026', city: 'Islamabad', budget: 35000, phone: "03334445556"),
// ];

// class VendorBookingsPage extends StatelessWidget {
//   const VendorBookingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         backgroundColor: kPrimary,
//         elevation: 0,
//         title: const Text('New Inquiries', 
//           style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: _allInquiries.isEmpty
//           ? const Center(child: Text('No inquiries received yet.', style: TextStyle(color: Colors.grey)))
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: _allInquiries.length,
//               itemBuilder: (ctx, i) => _InquiryCard(inquiry: _allInquiries[i]),
//             ),
//     );
//   }
// }

// class _InquiryCard extends StatelessWidget {
//   final _InquiryModel inquiry;
//   const _InquiryCard({required this.inquiry});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade100),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 22,
//                 backgroundColor: kPrimary.withOpacity(0.1),
//                 child: Text(inquiry.name[0], style: const TextStyle(color: kPrimary, fontWeight: FontWeight.bold)),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(inquiry.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
//                     Text('${inquiry.event} · ${inquiry.city}',
//                         style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
//             ],
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 12),
//             child: Divider(height: 1),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _InfoRow(icon: Icons.calendar_today, text: inquiry.date),
//               Text(
//                 'PKR ${inquiry.budget.toStringAsFixed(0)}',
//                 style: const TextStyle(fontWeight: FontWeight.bold, color: kPrimary),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _ContactBtn(
//                   label: 'WhatsApp',
//                   icon: Icons.chat_bubble_outline,
//                   color: Colors.green,
//                   onTap: () {}, // Logic to launch WhatsApp
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: _ContactBtn(
//                   label: 'Call User',
//                   icon: Icons.call_outlined,
//                   color: Colors.blue,
//                   onTap: () {}, // Logic to launch Dialer
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _InfoRow extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   const _InfoRow({required this.icon, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, size: 14, color: Colors.grey),
//         const SizedBox(width: 6),
//         Text(text, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
//       ],
//     );
//   }
// }

// class _ContactBtn extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;
//   const _ContactBtn({required this.label, required this.icon, required this.color, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: color.withOpacity(0.2)),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 16, color: color),
//             const SizedBox(width: 6),
//             Text(label, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

// Your Brand Primary Color
const Color kPrimary = Color(0xffB4245D);

class InquiryModel {
  final String name, date, city, phone;
  final double budget;

  const InquiryModel({
    required this.name,
    required this.date,
    required this.city,
    required this.budget,
    required this.phone,
  });
}

class VendorBookingsPage extends StatelessWidget {
  const VendorBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Sample list for demonstration
    final List<InquiryModel> inquiries = [
      const InquiryModel(name: 'Ali Khan', date: 'May 15, 2026', city: 'Lahore', budget: 60000, phone: "03001234567"),
      const InquiryModel(name: 'Sara Raza', date: 'Jun 2, 2026', city: 'Karachi', budget: 45000, phone: "03217654321"),
      const InquiryModel(name: 'M. Bilal', date: 'May 28, 2026', city: 'Karachi', budget: 25000, phone: "03119876543"),
      const InquiryModel(name: 'Amna Javed', date: 'Jun 10, 2026', city: 'Islamabad', budget: 35000, phone: "03334445556"),
    ];

    return Scaffold(
      // Background: Soft grey in light mode, deep charcoal in dark mode
      backgroundColor: isDark ? const Color(0xff0F0F12) : const Color(0xffF5F7FA),
      
      appBar: AppBar(
        backgroundColor: kPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'New Requests',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      body: inquiries.isEmpty
          ? const Center(child: Text("No new inquiries", style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              itemCount: inquiries.length,
              itemBuilder: (ctx, i) => _InquiryCard(
                inquiry: inquiries[i],
                isDark: isDark,
              ),
            ),
    );
  }
}

class _InquiryCard extends StatelessWidget {
  final InquiryModel inquiry;
  final bool isDark;
  
  const _InquiryCard({required this.inquiry, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1C1C26) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        // Subtle border for light mode to prevent "washed out" look
        border: isDark ? null : Border.all(color: kPrimary.withOpacity(0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : kPrimary.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          // Top Row: User Info
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: kPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.person_rounded, color: kPrimary, size: 26),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inquiry.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xff2D3436),
                      ),
                    ),
                    Text(
                      inquiry.city,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white38 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
            ],
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Divider(height: 1, thickness: 0.5),
          ),

          // Middle Row: Metrics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric(Icons.calendar_today_rounded, "DATE", inquiry.date),
              _buildMetric(Icons.account_balance_wallet_rounded, "BUDGET", "PKR ${inquiry.budget.toInt()}"),
            ],
          ),

          const SizedBox(height: 22),

          // Bottom Row: Action Buttons
          Row(
            children: [
              Expanded(
                child: _ActionBtn(
                  label: 'WhatsApp',
                  icon: Icons.message_rounded,
                  color: const Color(0xff25D366), // WhatsApp Green
                  isDark: isDark,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionBtn(
                  label: 'Call',
                  icon: Icons.phone_rounded,
                  color: const Color(0xff0984E3), // Classic Blue
                  isDark: isDark,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(IconData icon, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: kPrimary.withOpacity(0.6)),
            const SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: isDark ? Colors.white30 : Colors.black38,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white70 : const Color(0xff2D3436),
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}