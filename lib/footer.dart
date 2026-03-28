import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xffB4245D),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Events Affairs",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Pakistan's #1 Event Planning Marketplace",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Quick Links",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text("• Venues", style: TextStyle(color: Colors.white70)),
          const Text("• Vendors", style: TextStyle(color: Colors.white70)),
          const Text("• Blogs", style: TextStyle(color: Colors.white70)),
          const Text("• Contact Us", style: TextStyle(color: Colors.white70)),

          const SizedBox(height: 20),

          const Text(
            "Contact",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text("📞 +92 300 1234567", style: TextStyle(color: Colors.white70)),
          const Text("📧 info@eventsaffairs.com", style: TextStyle(color: Colors.white70)),

          const SizedBox(height: 20),

          const Divider(color: Colors.white38),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              "© 2026 Events Affairs. All rights reserved.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}