import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';

class DepressionTestScreen extends StatefulWidget {
  const DepressionTestScreen({super.key});

  @override
  _DepressionTestScreenState createState() => _DepressionTestScreenState();
}

class _DepressionTestScreenState extends State<DepressionTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question':
      'Over the past 2 weeks, have you felt persistently sad, hopeless, or irritable for most of the day?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Did you experience a significant loss of interest or pleasure in most activities you used to enjoy?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Have you had significant changes in appetite or weight (either weight loss or gain) without trying?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Have you experienced trouble sleeping (insomnia) or sleeping too much (hypersomnia) nearly every day?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Do you feel restless or fidgety, or are you slowed down and have difficulty moving or speaking?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you feel constantly tired or lacking in energy?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'During this period, have you experienced feelings of worthlessness or excessive guilt, even over trivial matters?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Do you have difficulty concentrating on tasks or making decisions nearly every day?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Over the past 2 weeks, have you felt a general sense of hopelessness or helplessness about the future, even for small things?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
      'Have you felt that your depression has significantly interfered with your work, social life, or other important areas of functioning?',
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

      if (doc.exists && doc.data()!['DepressionTestType'] != null) {
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
          'Depression Test',
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
              'You have already taken the depression test.',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
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
                            style: const TextStyle(color: Colors.black),
                          ),
                          value: questions[index]['options'][i]
                          ['points'],
                          groupValue: selectedOptions[index],
                          onChanged: (val) {
                            setState(() => selectedOptions[index] = val!);
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
          double averageScore = totalScore / questions.length;

          String diagnosis;
          if (totalScore == 0) {
            diagnosis = 'No depression';
          } else if (totalScore <= 4) {
            diagnosis = 'Minimal depression';
          } else if (totalScore <= 8) {
            diagnosis = 'Mild depression';
          } else if (totalScore <= 14) {
            diagnosis = 'Moderate depression';
          } else if (totalScore <= 20) {
            diagnosis = 'Moderately severe depression';
          } else {
            diagnosis = 'Severe depression';
          }

          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .update({
              'DepressionTestType': 'Depression Test',
              'DepressionTestScore': totalScore,
              'DepressionTestAverage': averageScore,
              'depressionDiagnosis': diagnosis,
              'timestamp': Timestamp.now(),
            });

            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Test Result'),
                content: Text(
                    'Total Score: $totalScore\nAverage Score: ${averageScore.toStringAsFixed(2)}\nDiagnosis: $diagnosis'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfilePage(
                              testName: 'Depression Test'),
                        ),
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('User not logged in.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}