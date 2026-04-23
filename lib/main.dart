import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mc_project/container.dart';
import 'package:mc_project/deptest.dart';
import 'package:mc_project/home.dart';
import 'package:mc_project/login.dart';
import 'package:mc_project/profile.dart';
import 'package:mc_project/reg.dart';
import 'anxiety_test.dart';
import 'stress_test.dart';
import 'eating_disorder_test.dart';
import 'splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loud Minds',
      theme: ThemeData(
        primaryColor: Colors.purple.shade100,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple.shade100,
          titleTextStyle: const TextStyle(
            color: Color(0xFF3A0000),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          iconTheme: const IconThemeData(color: Color(0xFF3A0000)),
        ),
        fontFamily: 'Segoe UI',
      ),

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final Widget destination = (authSnapshot.hasData && authSnapshot.data != null)
              ? const ContainerScreen()
              : const LoginScreen();

          return SplashScreen(nextScreen: destination);
        },
      ),

      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/test/depression': (context) => const DepressionTestScreen(),
        '/test/anxiety': (context) => const AnxietyTestScreen(),
        '/test/stress': (context) => const StressTestScreen(),
        '/test/eating': (context) => const EatingDisorderTestScreen(),
        '/profile': (context) => ProfilePage(testName: ''),
      },
    );
  }
}