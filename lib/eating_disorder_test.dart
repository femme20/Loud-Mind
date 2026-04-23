import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';

class EatingDisorderTestScreen extends StatefulWidget {
  const EatingDisorderTestScreen({super.key});

  @override
  _EatingDisorderTestScreenState createState() =>
      _EatingDisorderTestScreenState();
}

class _EatingDisorderTestScreenState extends State<EatingDisorderTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question':
      'Do you find yourself preoccupied with food or weight loss most of the time, even when you\'re not eating?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Every day', 'points': 3},
      ],
    },
    {
      'question':
      'Do you often skip meals or restrict your food intake even when you\'re feeling hungry?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Every day', 'points': 3},
      ],
    },
    {
      'question':
      'Do you purge after eating through methods like vomiting, laxatives, or excessive exercise to avoid weight gain?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Every day', 'points': 3},
      ],
    },
    {
      'question':
      'Do you eat large amounts of food in a short period of time (binge eating) even when you\'re not hungry, followed by feelings of guilt or shame?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Every day', 'points': 3},
      ],
    },
    {
      'question':
      'Do you see yourself as overweight or fat even when you\'re objectively underweight?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Every day', 'points': 3},
      ],
    },
    {
      'question':
      'Is your self-worth heavily influenced by your weight or body shape?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Every day', 'points': 3},
      ],
    },
    {
      'question':
      'Do you constantly feel the need to control your weight and food intake?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Every day', 'points': 3},
      ],
    },
    {
      'question':
      'Do you use food or restricting food intake as a way to cope with stress or difficult emotions?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Every day', 'points': 3},
      ],
    },
    {
      'question':
      'Do you isolate yourself from social activities or avoid eating in public due to anxiety about your food choices or body image?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Every day', 'points': 3},
      ],
    },
    {
      'question':
      'Have you noticed changes in your health, such as fatigue, hair loss, or irregular periods, but avoid seeking medical help due to fear of weight gain?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Every day', 'points': 3},
      ],
    },
    // ... other questions ...
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

      if (doc.exists && doc.data()!['EatingTestType'] != null) {
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
          'Eating Disorder Test',
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
              'You have already taken the Eating Disorder test.',
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

          String diagnosis;
          if (totalScore <= 4) {
            diagnosis = 'Minimal concern';
          } else if (totalScore <= 9) {
            diagnosis = 'Mild concern';
          } else if (totalScore <= 14) {
            diagnosis = 'Moderate concern';
          } else {
            diagnosis = 'Severe concern';
          }

          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .update({
              'EatingTestType': 'Eating Disorder Test',
              'EatingTestScore': totalScore,
              'EatingDiagnosis': diagnosis,
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
                              testName: 'Eating Disorder Test'),
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