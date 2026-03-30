import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/supabase/supabase_client.dart';
import '../editor/video_editor_screen.dart'; // Iska path check kar lena sahi hai ya nahi
import '../../models/project.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final projectNameController = TextEditingController();
  final descriptionController = TextEditingController();

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
    }
  }

  // --- ASLI KAAM YAHAN HO RAHA HAI: DATA SAVE KARNA ---
  Future<void> _createProject() async {
    if (projectNameController.text.trim().isEmpty || _selectedVideoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Naam aur Video dono zaroori hain!")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // 1. Current User ki ID lena
      final userId = SupabaseService.supabase.auth.currentUser!.id;

      // 2. Supabase mein data insert karna
      final response = await SupabaseService.supabase
          .from('projects')
          .insert({
        'user_id': userId,
        'project_name': projectNameController.text.trim(),
        'description': descriptionController.text.trim(),
        'aspect_ratio': '16:9', // Default values
        'frame_rate': 30,
        'resolution': '1920x1080',
      })
          .select()
          .single();

      if (mounted) {
        // 3. Project model banana taake Editor ko bhej saken
        final newProject = Project.fromJson(response);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Project Created Successfully!"), backgroundColor: Colors.green),
        );

        // 4. Seedha Editor Screen par jana Video ke saath
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VideoEditorScreen(
              project: newProject,
              videoFile: _selectedVideoFile!,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text("New Project", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: projectNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Project Name",
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
              ),
            ),
            const SizedBox(height: 30),

            const Text("Step 1: Select Video",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            GestureDetector(
              onTap: _pickVideoFromGallery,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: _selectedVideoFile == null ? Colors.blueAccent : Colors.green,
                      width: 2
                  ),
                ),
                child: _selectedVideoFile == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.video_library, color: Colors.blueAccent, size: 50),
                    SizedBox(height: 10),
                    Text("Tap to select video from Gallery", style: TextStyle(color: Colors.white54)),
                  ],
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 60),
                    const SizedBox(height: 10),
                    const Text("Video Selected!", style: TextStyle(color: Colors.white)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(_selectedVideoFile!.path.split('/').last,
                        style: const TextStyle(color: Colors.white38, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : _createProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Create Project", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}