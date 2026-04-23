import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mc_project/login.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  bool _obscureText = true;

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.forward();
  }

  // CORE LOGIC: Register and Create Firestore Document
  Future<void> registerUser() async {
    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    // 1. Validation
    if (firstName.isEmpty || email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all required fields");
      return;
    }
    if (password != confirmPassword) {
      Fluttertoast.showToast(msg: "Passwords do not match");
      return;
    }
    if (password.length < 6) {
      Fluttertoast.showToast(msg: "Password must be at least 6 characters");
      return;
    }

    try {
      // 2. Create Auth User
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 3. Create User Document in Firestore
      // This matches your Profile Page logic to prevent "No data found" errors
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'username': email.split('@')[0], // Default username
        'AnxietyTestScore': 0,
        'ADHDTestScore': 0,
        'DepressionTestScore': 0,
        'StressTestScore': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(msg: "Account Created Successfully!");

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? "Registration Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // LEFT SIDE: DESIGN (Matches Login)
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/chatbg7.jpg"), // Use same branding image
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.1), // Subtle overlay
              ),
            ),
          ),

          // RIGHT SIDE: REGISTRATION FORM
          Expanded(
            flex: 1,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Join Dawn",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.5,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Start your journey to mental wellness.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      const SizedBox(height: 40),

                      // Name Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(firstNameController, "First Name", Icons.person_outline),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildTextField(lastNameController, "Last Name", Icons.person_outline),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Email
                      _buildTextField(emailController, "Email Address", Icons.email_outlined),
                      const SizedBox(height: 20),

                      // Password
                      _buildTextField(
                          passwordController,
                          "Password",
                          Icons.lock_outline,
                          isPassword: true
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password
                      _buildTextField(
                          confirmPasswordController,
                          "Confirm Password",
                          Icons.lock_reset_outlined,
                          isPassword: true
                      ),

                      const SizedBox(height: 40),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade700,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          onPressed: registerUser,
                          child: const Text(
                            "Create Account",
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build consistent fields
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscureText : false,
      style: const TextStyle(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
        prefixIcon: Icon(icon, color: Colors.purple.shade300),
        suffixIcon: isPassword ? IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ) : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.purple, width: 2),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}