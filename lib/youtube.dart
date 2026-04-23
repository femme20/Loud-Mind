import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class YouTubeScreen extends StatelessWidget {
  final Map<String, List<Map<String, String>>> exercises = {
    'Gentle Yoga': [
      {'title': '30 Minute Relaxing Yoga For Mental Health', 'url': 'http://www.youtube.com/watch?v=COp7BR_Dvps', 'time': '30 min'},
      {'title': '10 Minute Yoga Stress and Anxiety', 'url': 'http://www.youtube.com/watch?v=8TuRYV71Rgo', 'time': '10 min'},
      {'title': '45 min Lazy Yin Yoga for Burnout', 'url': 'http://www.youtube.com/watch?v=nwBcidD3xvY', 'time': '45 min'},
    ],
    'Anxiety Relief': [
      {'title': 'Simple Breathing Techniques', 'url': 'http://www.youtube.com/watch?v=odADwWzHR24', 'time': '5 min'},
      {'title': '10 Minute Pilates for Stress', 'url': 'http://www.youtube.com/watch?v=tYddPTEfS_8', 'time': '10 min'},
    ],
    'Meditation': [
      {'title': '10-Minute Meditation For Beginners', 'url': 'http://www.youtube.com/watch?v=U9YKY7fdwyg', 'time': '10 min'},
      {'title': '5 Minute Mindfulness Meditation', 'url': 'http://www.youtube.com/watch?v=ssss7V1_eyA', 'time': '5 min'},
    ],
  };

  YouTubeScreen({super.key});

  Future<void> _launchUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint(e.toString());
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
        title: const Text("Wellness Videos",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 24)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: exercises.keys.length,
        itemBuilder: (context, index) {
          String category = exercises.keys.elementAt(index);
          List<Map<String, String>> videos = exercises[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  category,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.purple),
                ),
              ),
              // Horizontal Scroll for Videos
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: videos.length,
                  itemBuilder: (context, vIndex) {
                    return _buildVideoCard(context, videos[vIndex]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, Map<String, String> video) {
    return GestureDetector(
      onTap: () => _launchUrl(video['url']!),
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Thumbnail" Placeholder with Play Button
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade300, Colors.indigo.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 45),
              ),
            ),
            // Video Title
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video['time'] ?? "Video",
                    style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}