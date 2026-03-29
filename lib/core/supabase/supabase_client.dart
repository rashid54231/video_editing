import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  // Easy access ke liye functions
  static SupabaseClient get supabase => client;
}
