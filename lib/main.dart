import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/supabase/supabase_client.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ==================== Supabase Initialize ====================
  await Supabase.initialize(
    url: 'https://tmndrtbedsfwminigyoj.supabase.co',           // ← Yahan apna URL daalo
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRtbmRydGJlZHNmd21pbmlneW9qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ0OTc3NjksImV4cCI6MjA5MDA3Mzc2OX0.YYUb3MUHXmA_An4X83fX_NpWO1JK9pW81cE6qzhB7HQ',                        // ← Yahan apna Anon Key daalo
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Video Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const LoginScreen(),           // Pehle Login screen se start hoga
    );
  }
}