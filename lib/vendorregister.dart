import 'package:flutter/material.dart';
import 'login.dart';
import 'blogs.dart';
import 'homePage.dart';
import 'contactus.dart';
import 'venues.dart';
import 'signup.dart';
class CreateAccountPageVendor extends StatefulWidget {
  const CreateAccountPageVendor({super.key});

  @override
  State<CreateAccountPageVendor> createState() => _CreateAccountPageVendorState();
}

class _CreateAccountPageVendorState extends State<CreateAccountPageVendor> {
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
      // ✅ SIDEBAR MENU
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

      body: SingleChildScrollView(
        child: Column(
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
                  fit: BoxFit.contain,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ================= SIGNUP BOX =================
            Container(
              width: 400,
              height: 69,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xffB4245D).withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Create Account as Vendor',
                style: TextStyle(
                  color: Color(0xffB4245D),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ================= FORM =================
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
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Bussiness Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Bussiness Address',
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
                        "Create Account",
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
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Already have an account? Login",
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