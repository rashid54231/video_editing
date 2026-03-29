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

      final response = await SupabaseService.supabase
          .from('projects')
          .insert({
        'user_id': userId,
        'project_name': projectNameController.text.trim(),
        'description': descriptionController.text.trim(),
        'aspect_ratio': selectedAspectRatio,
        'frame_rate': selectedFrameRate,
        'resolution': selectedResolution,
      })
          .select()
          .single();

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
        title: const Text("New Project"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: projectNameController,
              decoration: const InputDecoration(
                labelText: "Project Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description (Optional)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            const Text("Aspect Ratio", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: selectedAspectRatio,
              items: aspectRatios.map((ratio) {
                return DropdownMenuItem(value: ratio, child: Text(ratio));
              }).toList(),
              onChanged: (value) {
                setState(() => selectedAspectRatio = value!);
              },
            ),
            const SizedBox(height: 20),

            const Text("Frame Rate", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<int>(
              value: selectedFrameRate,
              items: frameRates.map((rate) {
                return DropdownMenuItem(value: rate, child: Text("$rate fps"));
              }).toList(),
              onChanged: (value) {
                setState(() => selectedFrameRate = value!);
              },
            ),
            const SizedBox(height: 20),

            const Text("Resolution", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: selectedResolution,
              items: resolutions.map((res) {
                return DropdownMenuItem(value: res, child: Text(res));
              }).toList(),
              onChanged: (value) {
                setState(() => selectedResolution = value!);
              },
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : _createProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Create Project", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
