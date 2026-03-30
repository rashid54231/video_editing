import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase/supabase_client.dart';
import '../../models/project.dart';
import 'project_list_screen.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final projectNameController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedAspectRatio = '16:9';
  int selectedFrameRate = 30;
  String selectedResolution = '1920x1080';

  bool isLoading = false;

  final List<String> aspectRatios = ['16:9', '9:16', '1:1', '4:5', '21:9'];
  final List<int> frameRates = [24, 30, 60];
  final List<String> resolutions = ['1920x1080', '1080x1920', '1280x720', '3840x2160'];

  // Common Input Style for consistent look
  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white24),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
    );
  }

  Future<void> _createProject() async {
    if (projectNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Project ka naam daalo")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final userId = SupabaseService.supabase.auth.currentUser!.id;

      await SupabaseService.supabase.from('projects').insert({
        'user_id': userId,
        'project_name': projectNameController.text.trim(),
        'description': descriptionController.text.trim(),
        'aspect_ratio': selectedAspectRatio,
        'frame_rate': selectedFrameRate,
        'resolution': selectedResolution,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Project successfully bana diya!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProjectListScreen()),
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
            // Project Name Field
            TextField(
              controller: projectNameController,
              style: const TextStyle(color: Colors.white), // Typing text white
              cursorColor: Colors.blueAccent,
              decoration: _inputStyle("Project Name"),
            ),
            const SizedBox(height: 20),

            // Description Field
            TextField(
              controller: descriptionController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white), // Typing text white
              cursorColor: Colors.blueAccent,
              decoration: _inputStyle("Description (Optional)"),
            ),
            const SizedBox(height: 30),

            const Text("Aspect Ratio", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFF1A1A1A), // Dropdown menu background
              value: selectedAspectRatio,
              style: const TextStyle(color: Colors.white, fontSize: 16), // Selected text color
              decoration: _inputStyle(""),
              items: aspectRatios.map((ratio) {
                return DropdownMenuItem(value: ratio, child: Text(ratio));
              }).toList(),
              onChanged: (value) => setState(() => selectedAspectRatio = value!),
            ),
            const SizedBox(height: 20),

            const Text("Frame Rate", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              dropdownColor: const Color(0xFF1A1A1A),
              value: selectedFrameRate,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: _inputStyle(""),
              items: frameRates.map((rate) {
                return DropdownMenuItem(value: rate, child: Text("$rate fps"));
              }).toList(),
              onChanged: (value) => setState(() => selectedFrameRate = value!),
            ),
            const SizedBox(height: 20),

            const Text("Resolution", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFF1A1A1A),
              value: selectedResolution,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: _inputStyle(""),
              items: resolutions.map((res) {
                return DropdownMenuItem(value: res, child: Text(res));
              }).toList(),
              onChanged: (value) => setState(() => selectedResolution = value!),
            ),
            const SizedBox(height: 40),

            // Create Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : _createProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Create Project", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}