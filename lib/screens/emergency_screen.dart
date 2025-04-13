import 'package:flutter/material.dart';
import 'package:mind_mate/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Help'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red, size: 30),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'If you\'re in immediate danger, call your local emergency number.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.call, color: Colors.red),
                    label: const Text('Call 911 (US)'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                    onPressed: () => _callEmergency('911'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Helplines section
            Text(
              'Crisis Helplines',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Helplines list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: AppConstants.emergencyContacts.length,
              itemBuilder: (context, index) {
                final entry = AppConstants.emergencyContacts.entries.elementAt(index);
                return _buildHelplineCard(context, entry.key, entry.value);
              },
            ),
            
            const SizedBox(height: 32),
            
            // Immediate actions section
            Text(
              'Immediate Actions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Action cards
            _buildActionCard(
              context,
              'Deep Breathing',
              'Take slow, deep breaths. Inhale for 4 seconds, hold for 4 seconds, exhale for 4 seconds.',
              Icons.air,
            ),
            
            _buildActionCard(
              context,
              'Grounding Technique',
              'Identify 5 things you can see, 4 things you can touch, 3 things you can hear, 2 things you can smell, and 1 thing you can taste.',
              Icons.spa,
            ),
            
            _buildActionCard(
              context,
              'Reach Out',
              'Contact a trusted friend or family member and talk about how you\'re feeling.',
              Icons.people,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHelplineCard(BuildContext context, String name, String number) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              number,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.call, color: Colors.green),
          onPressed: () => _callEmergency(number.replaceAll(RegExp(r'[^0-9]'), '')),
        ),
      ),
    );
  }
  
  Widget _buildActionCard(BuildContext context, String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 28,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
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
  
  Future<void> _callEmergency(String number) async {
    final Uri telUri = Uri(scheme: 'tel', path: number);
    
    // In a real app, this would actually place the call
    if (await canLaunchUrl(telUri)) {
      // For safety in a demo app, we show a dialog instead of actually calling
      // await launchUrl(telUri);
      
      // Show dialog to confirm call would be placed in the real app
      // ignore: use_build_context_synchronously
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: const Text('Demo Mode'),
          content: Text('In the full app, this would call $number'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  
  // Global navigator key used for showing dialogs
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
} 