import 'package:flutter/material.dart';
import 'package:mc_project/notify_service.dart';
import 'package:timezone/data/latest.dart' as tz;

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  // Data variables
  TimeOfDay? medicationTime;
  TimeOfDay? sleepTime;
  TimeOfDay? wakeUpTime;

  bool _isMedicationTaken = false;
  bool _isSlept = false;

  // Helper to format time for display
  String formatTime(TimeOfDay? time) {
    if (time == null) return "--:--";
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:${time.minute.toString().padLeft(2, '0')} $period";
  }

  Future<void> _pickTime(String type) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.purple),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (type == 'med') medicationTime = picked;
        if (type == 'sleep') sleepTime = picked;
        if (type == 'wake') wakeUpTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Daily Tracker",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 24)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text("Set your schedule to receive reminders.",
                style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 30),

            // --- TIME SETTING SECTION ---
            _buildTimeCard("Medication", medicationTime, Icons.medication_rounded, Colors.indigoAccent, () => _pickTime('med')),
            _buildTimeCard("Sleep Time", sleepTime, Icons.bedtime_rounded, Colors.orangeAccent, () => _pickTime('sleep')),
            _buildTimeCard("Wake Up", wakeUpTime, Icons.wb_sunny_rounded, Colors.teal, () => _pickTime('wake')),

            const SizedBox(height: 20),

            // Set Reminders Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  shadowColor: Colors.purple.withOpacity(0.3),
                ),
                onPressed: () {
                  // Notification Logic here (Same as your original)
                },
                child: const Text("Activate All Reminders",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),

            const SizedBox(height: 40),
            const Text("Today's Progress",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),

            // --- CHECK-IN SECTION ---
            _buildCheckInTile(
                "Take Medication",
                _isMedicationTaken,
                Colors.indigoAccent,
                    () => setState(() => _isMedicationTaken = !_isMedicationTaken)
            ),
            _buildCheckInTile(
                "Sleep Check-in",
                _isSlept,
                Colors.orangeAccent,
                    () => setState(() => _isSlept = !_isSlept)
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard(String label, TimeOfDay? time, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14)),
                Text(formatTime(time), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.edit_calendar_rounded, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInTile(String title, bool isDone, Color color, VoidCallback onTap) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: isDone ? color.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDone ? color : Colors.transparent, width: 2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(isDone ? Icons.check_circle_rounded : Icons.circle_outlined, color: isDone ? color : Colors.grey),
        title: Text(title, style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 18,
          decoration: isDone ? TextDecoration.lineThrough : null,
          color: isDone ? color : Colors.black87,
        )),
        trailing: isDone ? null : TextButton(
          onPressed: onTap,
          child: Text("Done", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ),
        onTap: onTap,
      ),
    );
  }
}