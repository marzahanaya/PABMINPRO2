import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static Future init() async {
    await Supabase.initialize(
      url: dotenv.env['https://yxhwqhrvvkcmqaailalt.supabase.co']!,
      anonKey: dotenv.env['https://yxhwqhrvvkcmqaailalt.supabase.co']!,
    );
  }
}