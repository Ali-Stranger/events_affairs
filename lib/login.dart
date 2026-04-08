import 'package:flutter/material.dart';
import 'homePage.dart'; // Ensure this matches your filename
import 'signup.dart';
import 'drawer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  bool _obscurePassword = true; // Add this line
  // Controllers to capture text input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up controllers when the widget is removed
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= HEADER =================
            Padding(
              padding: const EdgeInsets.only(
              left: 8),
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

            // ================= LOGIN FORM =================
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
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username or Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
  controller: _passwordController,
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
  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distributes them to opposite sides
  children: [
    Row(
      children: [
        Checkbox(
          value: rememberMe,
          activeColor: const Color(0xffB4245D),
          onChanged: (value) => setState(() => rememberMe = value!),
        ),
        const Text("Remember me"),
      ],
    ),
    TextButton(
      onPressed: () {
        /* Navigate to ForgotPasswordPage() */
      },
      child: const Text(
        "Forgot Password?",
        style: TextStyle(color: Color(0xffB4245D)),
      ),
    ),
  ],
),
                  const SizedBox(height: 10),
                  
                  // Login Button Logic
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffB4245D),
                      ),
                      onPressed: () {
                        // Check if credentials are 'user' and 'user'
                        if (_usernameController.text == 'user' && 
                            _passwordController.text == 'user') {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const CreateHomePage()),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Invalid Username or Password. Try 'user'"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateAccountPage()),
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