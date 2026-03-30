import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:events_affairs/homePage.dart';
import 'contactus.dart';
import 'footer.dart';
import 'blogs.dart';
import 'login.dart';
import 'venues.dart';

// 🔔 Notification Plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class VenueContactPage extends StatefulWidget {
  final String name;
  final String location;
  final String price;
  final String image;

  const VenueContactPage({
    super.key,
    required this.name,
    required this.location,
    required this.price,
    required this.image,
  });

  @override
  State<VenueContactPage> createState() => _VenueContactPageState();
}

class _VenueContactPageState extends State<VenueContactPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  static const TextStyle headingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xffB4245D),
  );

  bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
    initNotifications();
  }

  // ✅ Initialize Notifications
  Future<void> initNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(settings:settings);

    // ✅ Request permission (Android 13+)
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // ✅ Show Notification
  Future<void> showNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title:  'Request Sent',
      body:  'The vendor will contact you shortly.',
      notificationDetails:  details,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CreateHomePage()));
              },
            ),
            ListTile(
              title: const Text("Venues", style: headingStyle),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const VenuesPage()));
              },
            ),
            ListTile(
              title: const Text("Blogs", style: headingStyle),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const BlogsPage()));
              },
            ),
            ListTile(
              title: const Text("Register Now", style: headingStyle),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Login", style: headingStyle),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
            ListTile(
              title: const Text("Contact Us", style: headingStyle),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ContactUs()));
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(top: 26),
          child: Text(
            'Pakistan #1 Event Planning Market Place',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        backgroundColor: const Color(0xffB4245D),
        actions: const [
          Padding(
            padding: EdgeInsets.only(top: 23),
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // HEADER
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

            // TITLE
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xffB4245D).withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffB4245D),
                  ),
                ),
              ),
            ),

            // IMAGE
            Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(widget.image, height: 180),
            ),

            // DETAILS
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📍 Location: ${widget.location}"),
                  const SizedBox(height: 5),
                  Text("💰 Package: ${widget.price}"),
                ],
              ),
            ),

            // FORM
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Your Name",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: contactController,
                    decoration: const InputDecoration(
                      labelText: "Contact No",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffB4245D),
                    ),
                    onPressed: () async {
                      setState(() {
                        isSubmitted = true;
                      });

                      await showNotification(); // 🔔 FIXED
                    },
                    child: const Text(
                      "Send Details to Vendor",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (isSubmitted)
                    const Text(
                      "The vendor will contact you shortly.",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const AppFooter(),
          ],
        ),
      ),
    );
  }
}