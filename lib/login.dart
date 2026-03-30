import 'package:flutter/material.dart';
import 'homePage.dart';
import 'signup.dart';
import 'blogs.dart';
import 'contactus.dart';
import 'venues.dart';
import 'vendorregister.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  bool isRegisterMode = false;
static const TextStyle headingStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Color(0xffB4245D),
);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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


      appBar: AppBar(
        centerTitle: true,
         automaticallyImplyLeading: false, // removes default hamburger icon
        title: const Padding(
          padding: EdgeInsets.only(top: 24),
          child: Text(
            'Pakistan #1 Event Planning Market Place',
            style: TextStyle(fontSize: 16,color: Colors.white),
          ),
        ),
        backgroundColor:Color(0xffB4245D),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 23),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search,color: Colors.white,),
            ),
          ),
        ],
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // ================= HEADER =================
            Row(
              children: [
                // ✅ MENU BUTTON OPENS DRAWER
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
                  fit: BoxFit.contain,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ================= MY ACCOUNT BOX =================
            Container(
              width: 400,
              height: 69,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xffB4245D).withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'My Account',
                style: TextStyle(
                  color: Color(0xffB4245D),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Color(0xffB4245D),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffB4245D).withOpacity(0.1),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [

                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Username or Email',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        activeColor: const Color(0xffB4245D),
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value!;
                          });
                        },
                      ),
                      const Text("Remember me"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffB4245D),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAccountPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Don’t have an account? Create one",
                      style: TextStyle(
                        color: Color(0xffB4245D),
                        fontWeight: FontWeight.bold,
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