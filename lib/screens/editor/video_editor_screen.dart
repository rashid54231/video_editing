import 'dart:io';
import 'package:flutter/foundation.dart'; // kIsWeb ke liye zaroori
import 'package:flutter/material.dart';
import '../../models/project.dart';
import 'preview_player.dart';

class VideoEditorScreen extends StatefulWidget {
  final Project project;
  final File videoFile;

  const VideoEditorScreen({
    super.key,
    required this.project,
    required this.videoFile
  });

  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  // Trimming ke liye variables (Agay kaam ayenge)
  double _startValue = 0.0;
  double _endValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: Text(widget.project.projectName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Save Button (FFmpeg Processing ke liye)
          IconButton(
            icon: const Icon(Icons.check, color: Colors.greenAccent),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Processing Video... (Step 3)")),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.ios_share), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // 1. VIDEO PREVIEW AREA
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Center(
                // Yahan humne PreviewPlayer ko call kiya hai
                child: PreviewPlayer(videoFile: widget.videoFile),
              ),
            ),
          ),

          // 2. EDITING TOOLS & TIMELINE (Step 3 ka hissa)
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Video Timeline (Trimming)",
                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Dummy Timeline Slider (Trimming Control)
                  RangeSlider(
                    values: RangeValues(_startValue, _endValue),
                    activeColor: Colors.blueAccent,
                    inactiveColor: Colors.white24,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _startValue = values.start;
                        _endValue = values.end;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  // Editing Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.cut, "Trim"),
                      _buildActionButton(Icons.music_note, "Music"),
                      _buildActionButton(Icons.text_fields, "Text"),
                      _buildActionButton(Icons.filter_vintage, "Filter"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget buttons banane ke liye
  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white10,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}