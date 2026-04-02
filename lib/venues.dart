import 'package:events_affairs/homePage.dart';
import 'package:flutter/material.dart';
import 'contactus.dart';
import 'footer.dart';
import 'blogs.dart';
import 'login.dart';
import 'eventplanner.dart';
import 'venuecontact.dart';
import 'signup.dart';
import 'vendorregister.dart';

class VenuesPage extends StatefulWidget {
  const VenuesPage({super.key});

  @override
  State<VenuesPage> createState() => _VenuesPageState();
}

class _VenuesPageState extends State<VenuesPage> {
  bool isRegisterMode = false;
  static const TextStyle headingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xffB4245D),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ================= DRAWER =================
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: isRegisterMode
              ? [
                  // ================= REGISTER HEADER =================
                  DrawerHeader(
                    decoration: const BoxDecoration(color: Color(0xffB4245D)),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              isRegisterMode = false;
                            });
                          },
                        ),
                        const Text(
                          "Register As",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ListTile(
                    title: const Text("As a Vendor", style: headingStyle),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAccountPageVendor(),
                        ),
                      );
                      // TODO: Vendor register page
                    },
                  ),

                  ListTile(
                    title: const Text("As a Couple", style: headingStyle),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAccountPage(),
                        ),
                      );
                    },
                  ),
                ]
              : [
                  // ================= NORMAL MENU HEADER =================
                  SizedBox(
                    height: 88,
                    child: const DrawerHeader(
                      decoration: BoxDecoration(color: Color(0xffB4245D)),
                      child: Text(
                        "Events Affairs Menu",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  ListTile(
                    title: const Text("Home", style: headingStyle),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateHomePage(),
                        ),
                      );
                    },
                  ),

                  ListTile(
                    title: const Text("Venues", style: headingStyle),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VenuesPage(),
                        ),
                      );
                    },
                  ),

                  ListTile(
                    title: const Text("Blogs", style: headingStyle),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BlogsPage(),
                        ),
                      );
                    },
                  ),

                  ListTile(
                    title: const Text("Register Now", style: headingStyle),
                    onTap: () {
                      setState(() {
                        isRegisterMode = true; // 🔥 SWITCH MENU
                      });
                    },
                  ),

                  ListTile(
                    title: const Text("Login", style: headingStyle),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  ),

                  ListTile(
                    title: const Text("Contact Us", style: headingStyle),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContactUs(),
                        ),
                      );
                    },
                  ),
                ],
        ),
      ),
      // ================= APP BAR =================
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 26),
          child: const Text(
            'Pakistan #1 Event Planning Market Place',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        backgroundColor: const Color(0xffB4245D),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 23),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.white),
            ),
          ),
        ],
      ),

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

                Image.asset("assets/images/logo.png", width: 90, height: 90),
              ],
            ),

            const SizedBox(height: 10),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(
                  0xffB4245D,
                ).withOpacity(0.3), // 🔴 background color
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
                    MaterialPageRoute(builder: (_) => const Eventplanner()),
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
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
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
                          builder: (_) => VenueContactPage(
                            name: name,
                            location: location,
                            price: price,
                            image: image,
                          ),
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
