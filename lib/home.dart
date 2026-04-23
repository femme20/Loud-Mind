import 'dart:ui';
import 'package:flutter/material.dart';
import 'deptest.dart';
import 'anxiety_test.dart';
import 'stress_test.dart';
import 'eating_disorder_test.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> tests = [
    {
      'name': 'Depression Test',
      'icon': Icons.wb_twilight_rounded,
      'color': Colors.indigo.shade200,
      'screen': DepressionTestScreen(),
    },
    {
      'name': 'Anxiety Test',
      'icon': Icons.air_rounded,
      'color': Colors.teal.shade200,
      'screen': AnxietyTestScreen(),
    },
    {
      'name': 'Stress Test',
      'icon': Icons.water_drop_rounded,
      'color': Colors.blueGrey.shade200,
      'screen': StressTestScreen(),
    },
    {
      'name': 'Eating Habit Test',
      'icon': Icons.spa_rounded,
      'color': Colors.green.shade200,
      'screen': EatingDisorderTestScreen(),
    },
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE (Blurred for focus)
          Positioned.fill(
            child: Image.asset(
              "assets/chatbg7.jpg",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Color(0xFFF5F0FF));
              },
            ),
          ),
          // Adding a blur layer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.white.withOpacity(0.3)),
            ),
          ),

          // 2. THE CONTENT
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Remove back button or make it functional
                        if (Navigator.canPop(context))
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios_new,
                                color: Color(0xFF3A0000), size: 20),
                          )
                        else
                          const SizedBox(height: 40), // Spacer if no back needed

                        const SizedBox(height: 20),
                        const Text(
                          "Breathe in deeply.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          "Self-Care Checkup",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF3A0000),
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Choose an assessment to begin your wellness journey",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tests List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildPebbleCard(context, tests[index]),
                      childCount: tests.length,
                    ),
                  ),
                ),

                // Bottom spacer
                const SliverToBoxAdapter(
                  child: SizedBox(height: 40),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPebbleCard(BuildContext context, Map<String, dynamic> test) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          // FIXED: Direct navigation instead of using named routes
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => test['screen']),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(40),
            ),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: test['color'].withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(test['icon'], color: Colors.black87, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF3A0000),
                      ),
                    ),
                    const Text(
                      "Takes about 5 minutes",
                      style: TextStyle(color: Colors.black45, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}