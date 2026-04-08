
import 'package:flutter/material.dart';

import 'footer.dart';

import 'eventplanner.dart';
import 'venuecontact.dart';

import 'drawer.dart';

class VenuesPage extends StatefulWidget {
  const VenuesPage({super.key});

  @override
  State<VenuesPage> createState() => _VenuesPageState();
}

class _VenuesPageState extends State<VenuesPage> {
bool isRegisterMode = false;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ================= DRAWER =================
      drawer: const CommonDrawer(),
      appBar: const CommonAppBar(),

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Column(
          children: [

            // ================= HEADER ROW =================
            Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),

                Image.asset(
                  "assets/images/logo.png",
                  width: 90,
                  height: 90,
                ),
              ],
            ),

            const SizedBox(height: 10),

            Container(
  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  decoration: BoxDecoration(
    color: const Color(0xffB4245D).withOpacity(0.3), // 🔴 background color
    borderRadius: BorderRadius.circular(10),
  ),
  child: const Center(
    child: Text(
      "Top Trending Venues",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xffB4245D), // ⚪ text color
      ),
    ),
  ),
),

            const SizedBox(height: 10),

            // ================= VENUE CARDS =================
            venueCard(
              context,
              image: "assets/images/download.jpg",
              name: "Royal Palm Banquet",
              location: "Lahore",
              price: "PKR 150,000",
            ),

            venueCard(
              context,
              image: "assets/images/download.jpg",
              name: "Pearl Continental Hall",
              location: "Karachi",
              price: "PKR 200,000",
            ),

            venueCard(
              context,
              image: "assets/images/download.jpg",
              name: "Serena Event Lawn",
              location: "Islamabad",
              price: "PKR 180,000",
            ),

            venueCard(
              context,
              image: "assets/images/download.jpg",
              name: "Grand Marquee",
              location: "Multan",
              price: "PKR 120,000",
            ),

            const SizedBox(height: 10),

            SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffB4245D),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Eventplanner(),
                        ),
                      );
                    },
                    child: const Text(
                      "See more",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

            const AppFooter(),
          ],
        ),
      ),
    );
  }

  // ================= VENUE CARD WIDGET =================
  Widget venueCard(
    BuildContext context, {
    required String image,
    required String name,
    required String location,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        children: [

          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported),
            ),
          ),

          const SizedBox(width: 12),

          // DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text("📍 $location"),

                const SizedBox(height: 4),

                Text(
                  "💰 $price",
                  style: const TextStyle(
                    color: Color(0xffB4245D),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                // CONTACT BUTTON
                SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffB4245D),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>  VenueContactPage(name: name, location: location, price: price, image: image),
                        ),
                      );
                    },
                    child: const Text(
                      "Contact Us",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}