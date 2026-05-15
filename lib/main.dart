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

  String _maskApiKey(String key) {
    if (key.length <= 8) return key;
    return '${key.substring(0, 4)}...${key.substring(key.length - 4)}';
  }

  Color _getFlavorColor() {
    return flavor == 'prod' ? Colors.red : Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter CI/CD Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _getFlavorColor(),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter CI/CD Demo'),
          centerTitle: true,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getFlavorColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getFlavorColor()),
                  ),
                  child: Text(
                    flavor.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getFlavorColor(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Flavor Card
                  _buildInfoCard(
                    title: 'Build Flavor',
                    value: flavor.toUpperCase(),
                    icon: Icons.build,
                    color: _getFlavorColor(),
                  ),
                  const SizedBox(height: 16),

                  // API Configuration Card
                  _buildInfoCard(
                    title: 'API Configuration',
                    value: _maskApiKey(apiKey),
                    icon: Icons.vpn_key,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),

                  // Build Info Card
                  _buildInfoCard(
                    title: 'Build Type',
                    value: flavor == 'prod' ? 'Production' : 'Development',
                    icon: Icons.info,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 32),

                  // Build Environment Details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Environment Details',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Flavor: ${flavor.toUpperCase()}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'API Key Configured: ${apiKey != 'no-key' ? '✓' : '✗'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: apiKey != 'no-key' ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
