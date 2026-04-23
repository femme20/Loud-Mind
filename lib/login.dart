import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mc_project/reg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mc_project/container.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    }
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _obscureText = true;
  bool rememberMe = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController resetEmailController = TextEditingController();
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter your email address to reset your password.'),
              TextField(
                controller: resetEmailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final email = resetEmailController.text.trim();
                if (email.isNotEmpty) {
                  try {
                    await authService.sendPasswordResetEmail(email);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password reset email sent!')),
                    );
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.message}')),
                    );
                  }
                }
                Navigator.pop(context);
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  loginUser({required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Fluttertoast.showToast(msg: "Login Successful");

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("userID", credential.user?.uid ?? " ");

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ContainerScreen()), // Replace with your home page class
        );
      }

      // StreamBuilder
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: Text(e.message ?? 'Unknown error occurred.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // LEFT SIDE: IMAGE
          Expanded(
            flex: 1, // Takes up 50% of the screen
            child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Login.jpg'), // Ensure this exists in pubspec
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // RIGHT SIDE: FORM
          Expanded(
            flex: 1,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Please login to your account",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      const SizedBox(height: 40),

                      // Email Field
                      TextField(
                        controller: emailController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      TextField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setState(() => _obscureText = !_obscureText),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),

                      ),

                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                activeColor: Colors.purple,
                                onChanged: (value) => setState(() => rememberMe = value!),
                              ),
                              const Text("Remember Me"),
                            ],
                          ),
                          GestureDetector(
                            onTap: _forgotPassword,
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade700,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            loginUser(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegistrationScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
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
}