import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final String testName;
  const ProfilePage({super.key, required this.testName});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  // Add logout logic
  void _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    // Clears the navigation stack so user can't go back into the app
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("PROFILE",
            style: TextStyle(letterSpacing: 1.2, fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black38)),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Users').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          String displayName = data['firstName'] ?? 'Dawn Traveler';

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildWellnessAura(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildIdentityCard(displayName),
                      const SizedBox(height: 35),
                      _buildSectionHeader("Mental Landscape", Icons.auto_awesome),
                      const SizedBox(height: 15),
                      _buildMetricPills(data),
                      const SizedBox(height: 60),
                      _buildLogoutButton(),
                      const SizedBox(height: 40),
                      _buildPrivacyWhisper(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWellnessAura() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, 1.5),
          radius: 1.5,
          colors: [
            Colors.purple.withOpacity(0.15),
            const Color(0xFFF8F9FE),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.wb_twilight_rounded, size: 40, color: Colors.purple),
      ),
    );
  }

  Widget _buildIdentityCard(String name) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Text(name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF2D3142))),
          const SizedBox(height: 5),
          Text(user?.email ?? "", style: const TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.purple.shade300),
        const SizedBox(width: 8),
        Text(title.toUpperCase(),
            style: const TextStyle(letterSpacing: 1.2, fontSize: 11, fontWeight: FontWeight.w900, color: Colors.black38)),
      ],
    );
  }

// UPDATED: Corrected the Eating Disorder key and added robustness
  Widget _buildMetricPills(Map<String, dynamic> data) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _pill(data, 'AnxietyTestScore', 'Anxiety', Colors.indigo),
        _pill(data, 'StressTestScore', 'Stress', Colors.orange.shade800),
        _pill(data, 'DepressionTestScore', 'Depression', Colors.pink.shade700),
        _pillEatingScore(data, 'EatingTestScore', 'Eating Disorder', Colors.purple.shade700),
      ],
    );
  }

// New helper for Eating Disorder to handle string/int safely
  Widget _pillEatingScore(Map<String, dynamic> data, String key, String label, Color color) {
    int score = 0;

    if (data.containsKey(key)) {
      var val = data[key];
      if (val is int) {
        score = val;
      } else if (val is String) {
        score = int.tryParse(val) ?? 0;
      }
    }

    if (score == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: color.withOpacity(0.9), fontWeight: FontWeight.w900, fontSize: 14)),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "$score",
              style: TextStyle(
                color: color.withOpacity(0.9),
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _pill(Map<String, dynamic> data, String key, String label, Color color) {
    int score = data[key] ?? 0;
    if (score == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: color.withOpacity(0.9), fontWeight: FontWeight.w900, fontSize: 14)),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Text(
                "$score",
                style: TextStyle(
                    color: color.withOpacity(0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w900
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: _handleLogout,
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text("LOGOUT FROM LOUD MINDS ", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.1)),
        style: TextButton.styleFrom(
          foregroundColor: Colors.redAccent,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.redAccent.withOpacity(0.05),
        ),
      ),
    );
  }

  Widget _buildPrivacyWhisper() {
    return const Opacity(
      opacity: 0.6,
      child: Column(
        children: [
          Text("SECURED BY LOUD MINDS ARCHITECTURE",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.black)),
          SizedBox(height: 8),
          Text("End-to-End Encryption • Local AI Processing • Zero Logs",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500, height: 1.5)),
        ],
      ),
    );
  }
}