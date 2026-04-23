import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpline extends StatefulWidget {
  const Helpline({super.key});

  @override
  State<Helpline> createState() => _HelplineState();
}

class _HelplineState extends State<Helpline> {
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
          'Helpline',
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
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Emergency Mental Health Support',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3A0000),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Available 24/7 • Confidential • Professional',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Header row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Organization',
                            style: TextStyle(fontWeight: FontWeight.bold,
                                color: Color(0xFF3A0000))),
                      ),
                      Expanded(
                        child: Text('Contact',
                            style: TextStyle(fontWeight: FontWeight.bold,
                                color: Color(0xFF3A0000))),
                      ),
                      SizedBox(width: 50),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                Expanded(
                  child: ListView(
                    children: [
                      HelplineTile('021-111-111-943', 'Zindagi Trust Helpline',
                          'https://zindagitrust.org/'),
                      HelplineTile('0311-7786264', 'Taskeen Mental Health',
                          'https://taskeen.org/'),
                      HelplineTile('115', 'Edhi Helpline', 'https://edhi.org/'),
                      HelplineTile('021-111-345-822', 'Sehat Kahani Mental Health',
                          'https://sehatkahani.com/'),
                      HelplineTile('0300-8562301', 'Willing Ways', 'https://willingways.com.pk/'),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.red.shade100),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                color: Colors.red, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'In case of immediate danger or emergency, please call your local emergency number or go to the nearest hospital.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HelplineTile extends StatelessWidget {
  const HelplineTile(this.contact, this.foundation, this.websiteUrl,
      {super.key});
  final String contact;
  final String foundation;
  final String websiteUrl;

  _callNumber(String phoneNumber) async {
    String number = phoneNumber;
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.85),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.phone, color: Colors.green, size: 22),
            onPressed: () => _callNumber(contact),
          ),
        ),
        title: Text(
          foundation,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF3A0000),
          ),
        ),
        subtitle: Text(
          contact,
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.open_in_new_rounded, color: Colors.blue),
          onPressed: () => launchUrl(Uri.parse(websiteUrl)),
        ),
      ),
    );
  }
}