import 'package:flutter/material.dart';

void main() {
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  const apiKey = String.fromEnvironment('API_KEY', defaultValue: 'no-key');

  runApp(MyApp(flavor: flavor, apiKey: apiKey));
}

class MyApp extends StatelessWidget {
  final String flavor;
  final String apiKey;

  const MyApp({super.key, required this.flavor, required this.apiKey});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("FLAVOR: $flavor\nAPI: $apiKey"),
        ),
      ),
    );
  }
}