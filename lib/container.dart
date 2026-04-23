import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mc_project/login.dart';
import 'package:mc_project/tracker.dart';
import 'package:mc_project/youtube.dart';
import 'chat.dart';
import 'diary_entry.dart';
import 'home.dart';
import 'helpline.dart';
import 'profile.dart';

class ContainerScreen extends StatefulWidget {
  const ContainerScreen({super.key});

  @override
  State<ContainerScreen> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  final user = FirebaseAuth.instance.currentUser;

  signOutUser() async {
    await FirebaseAuth.instance.signOut().then((value) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEC),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. TOP NAV BAR
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Loud Minds ",
                        style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                            fontSize: 14)),
                    _buildLogoutButton(),
                  ],
                ),
              ),
            ),

            // 2. HERO SECTION
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Your Safe Space\nfor a Loud Mind",
                            style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                                letterSpacing: -2,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Dawn understands that minds can be busy places. We provide a private environment to explore, manage stress, and find peace.",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                height: 1.5),
                          ),
                          const SizedBox(height: 25),
                          _buildTalkToDawnButton(context),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Image.asset(
                        'assets/home.jpg', // Ensure this exists in your assets
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. INTERACTIVE CONTAINER SECTION
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildListDelegate([
                  _buildNavCard(context, 'DIARY', const DiaryEntryScreen(), Icons.book_rounded, Colors.orange),
                  _buildNavCard(context, 'TESTS', HomeScreen(), Icons.psychology_alt_rounded, Colors.teal),
                  _buildNavCard(context, 'TRACKER', TrackerPage(), Icons.query_stats_rounded, Colors.blueAccent),
                  _buildNavCard(context, 'EXERCISES', YouTubeScreen(), Icons.spa_rounded, Colors.redAccent),
                  _buildNavCard(context, 'HELP', const Helpline(), Icons.emergency_share_rounded, Colors.pinkAccent),
                  _buildNavCard(context, 'PROFILE', ProfilePage(testName: 'General'), Icons.account_circle_rounded, Colors.blueGrey),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTalkToDawnButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage())),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5D6D4E),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Talk to Dawn", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(width: 10),
          Icon(Icons.arrow_forward_rounded, size: 18),
        ],
      ),
    );
  }

  // RE-INTRODUCED HOVER LOGIC
  Widget _buildNavCard(BuildContext context, String title, Widget destination, IconData icon, Color accentColor) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destination)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                // Swaps color based on hover state
                color: isHovered ? accentColor : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    color: isHovered ? accentColor : accentColor.withOpacity(0.1),
                    width: 2
                ),
                boxShadow: [
                  BoxShadow(
                      color: isHovered ? accentColor.withOpacity(0.3) : Colors.black.withOpacity(0.03),
                      blurRadius: isHovered ? 20 : 10,
                      offset: const Offset(0, 8)
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      icon,
                      color: isHovered ? Colors.white : accentColor,
                      size: 32
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        fontSize: 13,
                        color: isHovered ? Colors.white : Colors.black87
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return IconButton(
      onPressed: signOutUser,
      icon: const Icon(Icons.logout_rounded, color: Colors.black45, size: 22),
    );
  }
}