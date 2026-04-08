import 'package:flutter/material.dart';

import 'drawer.dart';
class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUs();
}

class _ContactUs extends State<ContactUs> {
  bool isRegisterMode=false;
  static const TextStyle headingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xffB4245D),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ================= DRAWER =================
      drawer: const CommonDrawer(),
      appBar: const CommonAppBar(),

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ================= HEADER =================
              Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 90,
                    height: 90,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ================= CONTACT US BOX =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xffB4245D).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Contact Us',
                  style: TextStyle(
                    color: Color(0xffB4245D),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================= LOCATION =================
              Text("Location", style: headingStyle),
              const SizedBox(height: 10),

              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/download.jpg"), // <-- put map image here
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "FCCU, Lahore",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 25),

              // ================= ABOUT =================
              Text("About", style: headingStyle),
              const SizedBox(height: 10),

              const Text(
                "Eventaffairs.pk is Pakistan #1 Event Planning Portal and Mobile Application "
                "where you can find the Venues of Your Choice, best wedding vendors, and many more "
                "with prices and reviews at the click of a button. Whether you are looking to hire "
                "Event planners in Pakistan, or looking for the top photographers, or just some ideas "
                "and inspiration for your Events.",
                style: TextStyle(fontSize: 14, height: 1.5),
              ),

              const SizedBox(height: 25),

              // ================= OUR PAGES =================
              Text("Our Pages", style: headingStyle),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset("assets/images/logo.png", width: 35),
                  Image.asset("assets/images/logo.png", width: 35),
                  Image.asset("assets/images/logo.png", width: 35),
                  Image.asset("assets/images/logo.png", width: 35),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}