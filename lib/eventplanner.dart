import 'package:flutter/material.dart';
import 'homePage.dart';
import 'login.dart';
import 'blogs.dart';
import 'contactus.dart';
import 'venues.dart';
import 'signup.dart';
class Eventplanner extends StatefulWidget {
  const Eventplanner({super.key});

  @override
  State<Eventplanner> createState() => _Eventplanner();
}

class _Eventplanner extends State<Eventplanner> {
  bool rememberMe = false;
  double priceValue = 20000;
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
      drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: isRegisterMode
        ? [

            // ================= REGISTER HEADER =================
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xffB4245D),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                Navigator.pop(context);
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
                decoration: BoxDecoration(
                  color: Color(0xffB4245D),
                ),
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
          padding: const EdgeInsets.only(top:26),
          child: const Text(
            'Pakistan #1 Event Planning Market Place',
            style: TextStyle(fontSize: 16,
            color: Colors.white),
          ),
        ),
        backgroundColor: const Color(0xffB4245D),
         actions: [
          Padding(
            padding: const EdgeInsets.only(top: 23),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search,color: Colors.white,),
            ),
          ),
        ],
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Column(
          children: [
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


            // const SizedBox(height: 5),

            // ================= TITLE BOX =================
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffB4245D).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "Event Planner",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffB4245D),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Refine Your Search",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xffB4245D),
              ),
            ),

            const SizedBox(height: 20),

            // ================= FORM BOX =================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffB4245D).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                children: [

                  // Vendor Name
                  const TextField(
                    decoration: InputDecoration(
                      labelText: "Venue Name",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Location Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Select Location"),
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: "Lahore", child: Text("Lahore")),
                        DropdownMenuItem(value: "Karachi", child: Text("Karachi")),
                        DropdownMenuItem(value: "Islamabad", child: Text("Islamabad")),
                        DropdownMenuItem(value: "Multan", child: Text("Multan")),
                      ],
                      onChanged: (value) {},
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Price Range
                  const Text(
                    "Price Range",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xffB4245D),
                    ),
                  ),

                 Slider(
                  value: priceValue,
                  min: 10000,
                  max: 1000000,
                  divisions: 100,
                  label: "PKR ${priceValue.round()}",
                  activeColor: const Color(0xffB4245D),
                  onChanged: (value) {
                    setState(() {
                      priceValue = value;
                          });
                          },
                        ),
                  const SizedBox(height: 20),

                  // SEARCH BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffB4245D),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Search",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}