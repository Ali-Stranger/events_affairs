import 'package:flutter/material.dart';

import 'vendorregister.dart';
import 'drawer.dart';
class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  bool rememberMe = false;
  bool isRegisterMode = false;
  bool _obscurePassword = true; // Add this line
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ SIDEBAR MENU
     
      appBar: const CommonAppBar(),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // ================= HEADER =================
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  
              
              
                  Image.asset(
                    'assets/images/logo.png',
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

         

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
                'Create Account',
                style: TextStyle(
                  color: Color(0xffB4245D),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
Container(
  margin: const EdgeInsets.symmetric(horizontal: 12), // 👈 ADD THIS
  decoration: BoxDecoration(
    border: Border.all(color: const Color(0xffB4245D), width: 2),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Row(
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffB4245D),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
          ),
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "👫 As a Couple",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      Expanded(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateAccountPageVendor(),
                ),
              );
            },
            child: const Text(
              "🏢 As a Vendor",
              style: TextStyle(
                color: Color(0xffB4245D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ],
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

                  TextField(
  
  obscureText: _obscurePassword, // Use the variable here
  decoration: InputDecoration(
    labelText: 'Password',
    border: const OutlineInputBorder(),
    // ADD THIS: The Eye Icon Button
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePassword ? Icons.visibility_off : Icons.visibility,
        color: const Color(0xffB4245D),
      ),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword; // Toggle the state
        });
      },
    ),
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