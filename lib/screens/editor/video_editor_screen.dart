import 'package:flutter/material.dart';
import '../../models/project.dart';
// import '../../core/supabase/supabase_client.dart'; // Iski abhi screen mein zaroorat nahi agar use nahi ho raha
// import 'timeline_widget.dart'; // Ensure ye files exist karti hain
// import 'preview_player.dart';

// Agar EffectsPanel class nahi bani to ye niche wala dummy code use karen
// warna apni file mein class ka naam check karen.
class EffectsPanel extends StatelessWidget {
  const EffectsPanel({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Effects List", style: TextStyle(color: Colors.white)));
}

class VideoEditorScreen extends StatefulWidget {
  final Project project;

  // Constructor se 'const' hata diya kyunki Project dynamic hai
  const VideoEditorScreen({super.key, required this.project});

  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: Text(widget.project.projectName),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: () {}),
          // 'export' ko 'ios_share' se badal diya
          IconButton(icon: const Icon(Icons.ios_share), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            // child: PreviewPlayer(project: widget.project), // Ensure PreviewPlayer is ready
            child: Container(color: Colors.grey[900], child: const Center(child: Icon(Icons.play_arrow, size: 50))),
          ),

          Container(
            color: Colors.black,
            child: Row(
              children: [
                _buildTab("Preview", 0),
                _buildTab("Timeline", 1),
                _buildTab("Effects", 2),
              ],
            ),
          ),

          Expanded(
            flex: 6,
            child: IndexedStack(
              index: currentTab,
              children: [
                Container(
                  color: Colors.black87,
                  child: const Center(
                    child: Text(
                      "Preview Controls\n(Speed, Volume, Split etc.)",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // TimelineWidget(project: widget.project), // Ensure TimelineWidget is ready
                Container(color: Colors.black, child: const Center(child: Text("Timeline Area"))),
                const EffectsPanel(),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.add_photo_alternate),
              onPressed: () {},
              color: Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.music_note),
              onPressed: () {},
              color: Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.text_fields),
              onPressed: () {},
              color: Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.auto_awesome), // Filter icon changed for better look
              onPressed: () => setState(() => currentTab = 2),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    bool isSelected = currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => currentTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}