import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get env => dotenv.env['ENV'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
}