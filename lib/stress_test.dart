import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';

class StressTestScreen extends StatefulWidget {
  const StressTestScreen({super.key});

  @override
  _StressTestScreenState createState() => _StressTestScreenState();
}

class _StressTestScreenState extends State<StressTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Do you often feel overwhelmed, anxious, or irritable?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Do you experience frequent feelings of sadness, hopelessness, or low mood?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Do you have difficulty concentrating or making decisions due to feeling stressed?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Do you experience headaches, muscle tension, or stomachaches more frequently when stressed?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Do you have trouble sleeping or staying asleep due to stress?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Do you notice changes in your appetite (increased or decreased) when stressed?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Do you find yourself using unhealthy coping mechanisms like smoking, drinking, or overeating to deal with stress?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Do you isolate yourself from social activities or withdraw from loved ones when stressed?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Do you have difficulty relaxing or taking time for yourself due to feeling constantly on edge?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Do you find yourself procrastinating on tasks or neglecting responsibilities due to feeling overwhelmed?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
  ];

  final Map<int, int> selectedOptions = {};
  bool testTaken = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfTestTaken();
  }

  Future<void> _checkIfTestTaken() async {
    final user = FirebaseAuth.instance.currentUser;
    bool taken = false;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data()!['StressTestType'] != null) {
        taken = true;
      }
    }

    setState(() {
      testTaken = taken;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 58, 0, 0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Stress Test',
          style: TextStyle(
              color: Color.fromARGB(255, 58, 0, 0),
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple.shade100,
      ),
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/diary_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : testTaken
              ? const Center(
            child: Text(
              'You have already taken the stress test.',
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
              textAlign: TextAlign.center,
            ),
          )
              : ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white.withOpacity(0.85),
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${index + 1}: ${questions[index]['question']}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 58, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(
                        questions[index]['options'].length,
                            (i) => RadioListTile<int>(
                          activeColor:
                          const Color.fromARGB(255, 58, 0, 0),
                          title: Text(
                            questions[index]['options'][i]['option'],
                            style:
                            const TextStyle(color: Colors.black),
                          ),
                          value: questions[index]['options'][i]
                          ['points'],
                          groupValue: selectedOptions[index],
                          onChanged: (val) {
                            setState(() =>
                            selectedOptions[index] = val!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: testTaken
          ? null
          : FloatingActionButton(
        backgroundColor: Colors.purple.shade200,
        child: const Icon(Icons.done, color: Colors.white),
        onPressed: () async {
          if (selectedOptions.length < questions.length) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Please answer all questions')),
            );
            return;
          }

          int totalScore =
          selectedOptions.values.fold(0, (a, b) => a + b);

          String diagnosis =
          totalScore <= 4 ? 'Low Stress' : 'High Stress';

          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .update({
              'StressTestType': 'Stress Test',
              'StressTestScore': totalScore,
              'StressDiagnosis': diagnosis,
              'timestamp': Timestamp.now(),
            });

            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Test Result'),
                content:
                Text('Score: $totalScore\nDiagnosis: $diagnosis'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfilePage(
                              testName: 'Stress Test'),
                        ),
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}