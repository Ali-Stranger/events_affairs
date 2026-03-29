import 'package:flutter/material.dart';
import 'login.dart';
import 'blogs.dart';
import 'homePage.dart';
import 'venues.dart';
class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUs();
}

class _ContactUs extends State<ContactUs> {
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
              
              title: const Text("Home",style: headingStyle),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>const CreateHomePage() ));
              },
            ),

            ListTile(
              
              title: const Text("Venues",style: headingStyle),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const VenuesPage()));
              },
            ),

            ListTile(
              
              title: const Text("Blogs",style:headingStyle),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const BlogsPage() ));
              },
            ),
            ListTile(
              
              title: const Text("Register Now",style: headingStyle),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              
              title: const Text("Login",style: headingStyle),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
              },
            ),
            ListTile(
              
              title: const Text("Contact Us",style: headingStyle,),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ContactUs() ));
              },
            ),
          ],
        ),
      ),

      // ================= APP BAR =================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color(0xffB4245D),
        title: Padding(
          padding: const EdgeInsets.only(top:26),
          child: const Text(
            'Pakistan #1 Event Planning Market Place',
            style: TextStyle(fontSize: 16,
            color: Colors.white),
          ),
        ),
        
         actions: [
          Padding(
            padding: const EdgeInsets.only(top: 23),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search,color: Colors.white,),
            ),
          ),
]      ),

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