import 'package:flutter/material.dart';
import '../../models/project.dart';

class TimelineWidget extends StatefulWidget {
  final Project project;

  const TimelineWidget({super.key, required this.project});

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  double zoomLevel = 1.0;
  double currentPlayheadPosition = 0.0; // seconds

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A),
      child: Column(
        children: [
          // Timeline Header (Zoom + Time)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.zoom_out),
                      onPressed: () {
                        setState(() => zoomLevel = (zoomLevel - 0.2).clamp(0.5, 3.0));
                      },
                    ),
                    Text("${zoomLevel.toStringAsFixed(1)}x"),
                    IconButton(
                      icon: const Icon(Icons.zoom_in),
                      onPressed: () {
                        setState(() => zoomLevel = (zoomLevel + 0.2).clamp(0.5, 3.0));
                      },
                    ),
                  ],
                ),
                Text(
                  "${currentPlayheadPosition.toStringAsFixed(1)}s / ${widget.project.totalDuration?.toStringAsFixed(1) ?? '0.0'}s",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          // Tracks Area
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    // Video Track 1
                    _buildTrack("V1", Colors.blue, true),
                    const SizedBox(height: 8),

                    // Video Track 2
                    _buildTrack("V2", Colors.green, false),
                    const SizedBox(height: 8),

                    // Audio Track
                    _buildTrack("A1", Colors.orange, false),
                  ],
                ),
              ),
            ),
          ),

          // Playhead Controls
          Container(
            height: 60,
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 32,
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () {},
                ),
                IconButton(
                  iconSize: 48,
                  icon: const Icon(Icons.play_arrow, color: Colors.blue),
                  onPressed: () {},
                ),
                IconButton(
                  iconSize: 32,
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrack(String trackName, Color color, bool hasClip) {
    return Container(
      width: 1200, // Scrollable timeline width
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Stack(
        children: [
          // Track Label
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                trackName,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Sample Clip
          if (hasClip)
            Positioned(
              left: 100,
              top: 25,
              child: Container(
                width: 220,
                height: 35,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: color, width: 2),
                ),
                child: const Center(
                  child: Text(
                    "Imported Video Clip",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
