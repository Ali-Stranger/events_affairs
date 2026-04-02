import 'package:flutter/material.dart';
import 'homePage.dart';
import 'login.dart';
import 'blogs.dart';
import 'contactus.dart';
import 'venues.dart';
import 'signup.dart';
import 'vendorregister.dart';
import 'data.dart'; // ✅ IMPORTANT

class Eventplanner extends StatefulWidget {
  const Eventplanner({super.key});

  @override
  State<Eventplanner> createState() => _EventplannerState();
}

class _EventplannerState extends State<Eventplanner> {
  bool isRegisterMode = false;
  double priceValue = 200000;

  TextEditingController venueController = TextEditingController();
  String? selectedLocation;

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
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Color(0xffB4245D)),
                    child: Text(
                      "Events Affairs Menu",
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
                ],
        ),
      ),

      // ================= APP BAR =================
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Event Planner",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xffB4245D),
      ),

      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // NAME
            TextField(
              controller: venueController,
              decoration: const InputDecoration(
                labelText: "Venue Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // LOCATION
            DropdownButtonFormField<String>(
              value: selectedLocation,
              hint: const Text("Select Location"),
              items: const [
                DropdownMenuItem(value: "Lahore", child: Text("Lahore")),
                DropdownMenuItem(value: "Karachi", child: Text("Karachi")),
                DropdownMenuItem(value: "Islamabad", child: Text("Islamabad")),
                DropdownMenuItem(value: "Multan", child: Text("Multan")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedLocation = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // PRICE
            Text("Max Price: PKR ${priceValue.round()}"),

            Slider(
              value: priceValue,
              min: 10000,
              max: 300000,
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffB4245D),
                ),
                onPressed: () {
                  String name = venueController.text.toLowerCase();

                  List results = venueList.where((venue) {
                    final matchName = venue["name"].toLowerCase().contains(
                      name,
                    );

                    final matchLocation =
                        selectedLocation == null ||
                        venue["location"] == selectedLocation;

                    final matchPrice = venue["price"] <= priceValue;

                    return matchName && matchLocation && matchPrice;
                  }).toList();

                  // RESULT SCREEN
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(
                          title: const Text("Search Results"),
                          backgroundColor: const Color(0xffB4245D),
                        ),
                        body: results.isEmpty
                            ? const Center(child: Text("No results found"))
                            : ListView.builder(
                                itemCount: results.length,
                                itemBuilder: (context, index) {
                                  final item = results[index];

                                  return ListTile(
                                    title: Text(item["name"]),
                                    subtitle: Text(
                                      "${item["location"]} - PKR ${item["price"]}",
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Search",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
