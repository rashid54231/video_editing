import 'dart:io'; // File handle karne ke liye
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Naya tool
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase/supabase_client.dart';
import 'project_list_screen.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final projectNameController = TextEditingController();
  final descriptionController = TextEditingController();

  // --- VIDEO SELECTION VARIABLES ---
  File? _selectedVideoFile;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  // Gallery se video uthane wala function
  Future<void> _pickVideoFromGallery() async {
    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedVideoFile = File(pickedFile.path);
      });
      print("Video Path: ${_selectedVideoFile!.path}");
    }
  }

  Future<void> _createProject() async {
    if (projectNameController.text.trim().isEmpty || _selectedVideoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Naam aur Video dono zaroori hain!")),
      );
      return;
    }

    setState(() => isLoading = true);
    // Baaki Supabase wala logic wahi rahega...
    // Abhi hum sirf UI aur selection check kar rahe hain.
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(title: const Text("New Project"), backgroundColor: Colors.black),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Name
            TextField(
              controller: projectNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Project Name",
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
            const SizedBox(height: 30),

            // --- VIDEO PICKER UI ---
            const Text("Step 1: Select Video", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            GestureDetector(
              onTap: _pickVideoFromGallery,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: _selectedVideoFile == null ? Colors.blueAccent : Colors.green, width: 2),
                ),
                child: _selectedVideoFile == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, color: Colors.blueAccent, size: 50),
                    SizedBox(height: 10),
                    Text("Tap to select video from Gallery", style: TextStyle(color: Colors.white54)),
                  ],
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 60),
                    const SizedBox(height: 10),
                    Text("Video Selected!", style: const TextStyle(color: Colors.white)),
                    Text(_selectedVideoFile!.path.split('/').last, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Create Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _createProject,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                child: const Text("Create Project"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}