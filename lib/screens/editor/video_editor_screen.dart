import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart'; // Naya import
import '../../models/project.dart';
import 'preview_player.dart';

class VideoEditorScreen extends StatefulWidget {
  final Project project;
  final File videoFile;

  const VideoEditorScreen({super.key, required this.project, required this.videoFile});

  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  bool isLoading = false;
  double _totalDuration = 1.0;
  RangeValues _currentRange = const RangeValues(0.0, 1.0);
  late VideoPlayerController _tempController;

  // Naya Variable: Edited video ko track karne ke liye
  File? _displayFile;

  @override
  void initState() {
    super.initState();
    _displayFile = widget.videoFile;
    _loadVideoMetadata();
  }

  Future<void> _loadVideoMetadata() async {
    _tempController = VideoPlayerController.file(widget.videoFile);
    await _tempController.initialize();
    setState(() {
      _totalDuration = _tempController.value.duration.inSeconds.toDouble();
      _currentRange = RangeValues(0.0, _totalDuration);
    });
    await _tempController.dispose();
  }

  // --- 1. MUSIC OVERLAY FUNCTION (NAYA) ---
  Future<void> _pickAndAddMusic() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      File audioFile = File(result.files.single.path!);
      setState(() => isLoading = true);

      final Directory dir = await getTemporaryDirectory();
      final String outputPath = "${dir.path}/mixed_${DateTime.now().millisecondsSinceEpoch}.mp4";

      // FFmpeg Command: Video ki awaaz 20% kardo, Music full 100% kardo
      String command = "-i ${_displayFile!.path} -i ${audioFile.path} "
          "-filter_complex \"[0:a]volume=0.2[a1];[1:a]volume=1.0[a2];[a1][a2]amix=inputs=2:duration=first\" "
          "-c:v copy -shortest $outputPath";

      await FFmpegKit.execute(command).then((session) async {
        final returnCode = await session.getReturnCode();
        if (ReturnCode.isSuccess(returnCode)) {
          setState(() {
            _displayFile = File(outputPath);
          });
          _showSnackBar("Music added successfully!", Colors.green);
        } else {
          _showSnackBar("Failed to add music", Colors.red);
        }
        setState(() => isLoading = false);
      });
    }
  }

  // --- 2. VIDEO TRIMMING FUNCTION ---
  Future<void> _processVideo() async {
    setState(() => isLoading = true);
    final Directory dir = await getTemporaryDirectory();
    final String outputPath = "${dir.path}/trimmed_${DateTime.now().millisecondsSinceEpoch}.mp4";

    final double start = _currentRange.start;
    final double end = _currentRange.end;

    String command = "-i ${widget.videoFile.path} -ss $start -to $end -c:v libx264 -c:a copy $outputPath";

    await FFmpegKit.execute(command).then((session) async {
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        setState(() {
          _displayFile = File(outputPath);
        });
        _showSnackBar("Video Trimmed Successfully!", Colors.green);
      } else {
        _showSnackBar("Cutting failed", Colors.red);
      }
      setState(() => isLoading = false);
    });
  }

  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: Text(widget.project.projectName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.check, color: Colors.greenAccent),
            onPressed: isLoading ? null : _processVideo,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Center(
              // Key use kiya taake video update hone par player refresh ho jaye
              child: PreviewPlayer(key: ValueKey(_displayFile!.path), videoFile: _displayFile!),
            ),
          ),

          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${_currentRange.start.toStringAsFixed(1)}s", style: const TextStyle(color: Colors.blue)),
                      const Text("Editor Tools", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text("${_currentRange.end.toStringAsFixed(1)}s", style: const TextStyle(color: Colors.blue)),
                    ],
                  ),

                  RangeSlider(
                    values: _currentRange,
                    min: 0.0,
                    max: _totalDuration,
                    divisions: _totalDuration.toInt() > 0 ? _totalDuration.toInt() : 1,
                    activeColor: Colors.blueAccent,
                    onChanged: (values) => setState(() => _currentRange = values),
                  ),

                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.cut, "Trim", _processVideo),
                      _buildActionButton(Icons.music_note, "Music", _pickAndAddMusic),
                      _buildActionButton(Icons.text_fields, "Text", () {
                        _showSnackBar("Text Feature Coming Soon!", Colors.orange);
                      }),
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

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(backgroundColor: Colors.white10, child: Icon(icon, color: Colors.white)),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}