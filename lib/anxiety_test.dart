import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';

class AnxietyTestScreen extends StatefulWidget {
  const AnxietyTestScreen({super.key});

  @override
  _AnxietyTestScreenState createState() => _AnxietyTestScreenState();
}

class _AnxietyTestScreenState extends State<AnxietyTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Over the last 2 weeks, how often have you felt nervous, anxious, or on edge?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, how often have you been unable to stop or control worrying?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you felt restless or unable to relax?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'A little', 'points': 1},
        {'option': 'Quite a bit', 'points': 2},
        {'option': 'Very much', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you been easily tired?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'Occasionally', 'points': 1},
        {'option': 'Frequently', 'points': 2},
        {'option': 'Very much', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you had difficulty concentrating?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'Occasionally', 'points': 1},
        {'option': 'Frequently', 'points': 2},
        {'option': 'Very much', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you had trouble sleeping due to worry?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you been irritable?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'Occasionally', 'points': 1},
        {'option': 'Frequently', 'points': 2},
        {'option': 'Very much', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you felt afraid something awful might happen?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Occasionally', 'points': 1},
        {'option': 'Frequently', 'points': 2},
        {'option': 'All the time', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you avoided situations due to anxiety?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'Occasionally', 'points': 1},
        {'option': 'Frequently', 'points': 2},
        {'option': 'All the time', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you struggled to control your worries?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'To some degree', 'points': 1},
        {'option': 'To a considerable degree', 'points': 2},
        {'option': 'Very much', 'points': 3},
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

      if (doc.exists && doc.data()!['AnxietyTestType'] != null) {
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
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 58, 0, 0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Anxiety Test',
          style: TextStyle(color: Color.fromARGB(255, 58, 0, 0), fontWeight: FontWeight.bold),
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
              'You have already taken the anxiety test.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          )
              : ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white.withOpacity(0.85),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                          activeColor: const Color.fromARGB(255, 58, 0, 0),
                          title: Text(questions[index]['options'][i]['option'],style: const TextStyle(color: Colors.black),),
                          value: questions[index]['options'][i]['points'],
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
              const SnackBar(content: Text('Please answer all questions')),
            );
            return;
          }

          int totalScore = selectedOptions.values.fold(0, (a, b) => a + b);

          String diagnosis;
          if (totalScore <= 4) diagnosis = 'Minimal anxiety';
          else if (totalScore <= 9) diagnosis = 'Mild anxiety';
          else if (totalScore <= 14) diagnosis = 'Moderate anxiety';
          else diagnosis = 'Severe anxiety';

          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
              'AnxietyTestType': 'Anxiety Test',
              'AnxietyTestScore': totalScore,
              'AnxietyDiagnosis': diagnosis,
              'timestamp': Timestamp.now(),
            });

            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Test Result'),
                content: Text('Score: $totalScore\nDiagnosis: $diagnosis'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfilePage(testName: 'Anxiety Test'),
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