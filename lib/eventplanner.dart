import 'package:flutter/material.dart';

import 'drawer.dart';

class Eventplanner extends StatefulWidget {
  const Eventplanner({super.key});

  @override
  State<Eventplanner> createState() => _Eventplanner();
}

class _Eventplanner extends State<Eventplanner> {
  bool rememberMe = false;
  double priceValue = 20000;
  bool isRegisterMode=false;
  

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