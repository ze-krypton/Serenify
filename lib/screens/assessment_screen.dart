import 'package:flutter/material.dart';
import 'package:mind_mate/widgets/content_card.dart';

class AssessmentScreen extends StatelessWidget {
  const AssessmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self-Assessments'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Introduction text
            Text(
              'Take an assessment to understand your mental health better',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Your responses are confidential and used to provide personalized recommendations.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            
            // Depression assessment
            ContentCard(
              title: 'Depression Assessment',
              subtitle: 'PHQ-9 questionnaire to evaluate depression symptoms',
              icon: Icons.psychology,
              style: CardStyle.elevated,
              onTap: () => _showAssessmentDialog(context, 'Depression Assessment'),
              child: const SizedBox.shrink(),
            ),
            
            const SizedBox(height: 16),
            
            // Anxiety assessment
            ContentCard(
              title: 'Anxiety Assessment',
              subtitle: 'GAD-7 questionnaire to evaluate anxiety symptoms',
              icon: Icons.sentiment_dissatisfied,
              style: CardStyle.elevated,
              onTap: () => _showAssessmentDialog(context, 'Anxiety Assessment'),
              child: const SizedBox.shrink(),
            ),
            
            const SizedBox(height: 16),
            
            // Stress assessment
            ContentCard(
              title: 'Stress Assessment',
              subtitle: 'PSS-10 questionnaire to evaluate stress levels',
              icon: Icons.shield_moon,
              style: CardStyle.elevated,
              onTap: () => _showAssessmentDialog(context, 'Stress Assessment'),
              child: const SizedBox.shrink(),
            ),
            
            const SizedBox(height: 16),
            
            // Sleep assessment
            ContentCard(
              title: 'Sleep Quality Assessment',
              subtitle: 'Evaluate your sleep patterns and quality',
              icon: Icons.nights_stay,
              style: CardStyle.elevated,
              onTap: () => _showAssessmentDialog(context, 'Sleep Quality Assessment'),
              child: const SizedBox.shrink(),
            ),
            
            const SizedBox(height: 16),
            
            // Well-being assessment
            ContentCard(
              title: 'Well-being Assessment',
              subtitle: 'Evaluate your overall mental well-being',
              icon: Icons.self_improvement,
              style: CardStyle.elevated,
              onTap: () => _showAssessmentDialog(context, 'Well-being Assessment'),
              child: const SizedBox.shrink(),
            ),
            
            const SizedBox(height: 32),
            
            // Past assessments
            Text(
              'Past Assessments',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Empty state for past assessments
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.assessment_outlined,
                    size: 48,
                    color: theme.colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No past assessments',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Take an assessment to see your results here',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAssessmentDialog(BuildContext context, String assessmentTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(assessmentTitle),
        content: const Text(
          'This is a demo version. In the full app, you would be able to take the assessment and receive personalized feedback.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Assessment demo not available in this version')),
              );
            },
            child: const Text('Start Demo'),
          ),
        ],
      ),
    );
  }
} 