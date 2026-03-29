import 'package:flutter/material.dart';
import '../../models/project.dart';

// Dummy widgets agar aapki files abhi ready nahi hain
class EffectsPanel extends StatelessWidget {
  const EffectsPanel({super.key});
  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: 10,
    itemBuilder: (context, index) => Card(
      color: Colors.white.withOpacity(0.05),
      child: ListTile(
        leading: const Icon(Icons.auto_awesome, color: Colors.blueAccent),
        title: Text("Filter Effect ${index + 1}", style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.add, color: Colors.grey),
      ),
    ),
  );
}

class VideoEditorScreen extends StatefulWidget {
  final Project project;
  const VideoEditorScreen({super.key, required this.project});

  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  int currentTab = 0;
  double videoProgress = 0.3; // Dummy progress

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: Text(widget.project.projectName, style: const TextStyle(fontSize: 18)),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.file_upload_outlined, size: 20, color: Colors.blueAccent),
            label: const Text("Export", style: TextStyle(color: Colors.blueAccent)),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // 1. Preview Area with Controls
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.black,
                  child: const Center(
                    child: Icon(Icons.movie_creation_outlined, color: Colors.white24, size: 80),
                  ),
                ),
                // Play Button
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blueAccent.withOpacity(0.8),
                  child: const Icon(Icons.play_arrow_rounded, size: 40, color: Colors.white),
                ),
                // Time Indicator (Bottom of Preview)
                Positioned(
                  bottom: 10,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text("00:45 / 02:30", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),

          // 2. Seek Bar (Timeline Progress)
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              trackHeight: 2,
            ),
            child: Slider(
              value: videoProgress,
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.white12,
              onChanged: (val) => setState(() => videoProgress = val),
            ),
          ),

          // 3. Middle Tabs
          Container(
            color: Colors.black,
            child: Row(
              children: [
                _buildTab("Controls", 0),
                _buildTab("Timeline", 1),
                _buildTab("Layers", 2),
              ],
            ),
          ),

          // 4. Content Area
          Expanded(
            flex: 6,
            child: IndexedStack(
              index: currentTab,
              children: [
                _buildControlPanel(),
                const Center(child: Text("Timeline View (Drag to Scroll)", style: TextStyle(color: Colors.grey))),
                const EffectsPanel(),
              ],
            ),
          ),
        ],
      ),

      // 5. Bottom Quick Tools
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildToolIcon(Icons.add_photo_alternate_outlined, "Media"),
            _buildToolIcon(Icons.music_note_outlined, "Audio"),
            _buildToolIcon(Icons.title_rounded, "Text"),
            _buildToolIcon(Icons.content_cut_rounded, "Trim"),
            _buildToolIcon(Icons.auto_awesome_outlined, "Effects", isSpecial: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    bool isSelected = currentTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => currentTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.blueAccent : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white38,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolIcon(IconData icon, String label, {bool isSpecial = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isSpecial ? Colors.blueAccent : Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isSpecial ? Colors.blueAccent : Colors.white38, fontSize: 10)),
      ],
    );
  }

  Widget _buildControlPanel() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildControlRow("Volume", Icons.volume_up, 0.8),
        _buildControlRow("Speed", Icons.speed, 0.5),
        _buildControlRow("Opacity", Icons.opacity, 1.0),
      ],
    );
  }

  Widget _buildControlRow(String title, IconData icon, double val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 20),
          const SizedBox(width: 15),
          Expanded(child: Text(title, style: const TextStyle(color: Colors.white))),
          Slider(value: val, onChanged: (v) {}, activeColor: Colors.white24),
        ],
      ),
    );
  }
}