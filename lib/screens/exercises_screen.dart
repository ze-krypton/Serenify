import 'package:flutter/material.dart';
import 'package:mind_mate/widgets/content_card.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guided Exercises'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction text
            Text(
              'Guided exercises to help you manage stress, anxiety, and improve your mental well-being',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            
            // Featured exercise
            _buildFeatureExerciseCard(context),
            
            const SizedBox(height: 32),
            
            // Exercise categories
            _buildCategoryHeader(context, 'Breathing Exercises'),
            const SizedBox(height: 16),
            
            _buildExerciseCard(
              context, 
              'Box Breathing',
              'A calming breathing technique to reduce stress and improve focus',
              '4 min',
              Icons.air,
            ),
            
            const SizedBox(height: 16),
            
            _buildExerciseCard(
              context, 
              '4-7-8 Breathing',
              'A breathing pattern to help you relax and fall asleep',
              '5 min',
              Icons.nightlight,
            ),
            
            const SizedBox(height: 32),
            
            _buildCategoryHeader(context, 'Meditation'),
            const SizedBox(height: 16),
            
            _buildExerciseCard(
              context, 
              'Body Scan Meditation',
              'Bring awareness to each part of your body to release tension',
              '10 min',
              Icons.self_improvement,
            ),
            
            const SizedBox(height: 16),
            
            _buildExerciseCard(
              context, 
              'Loving-Kindness Meditation',
              'Cultivate feelings of goodwill, kindness, and warmth towards others',
              '15 min',
              Icons.favorite,
            ),
            
            const SizedBox(height: 32),
            
            _buildCategoryHeader(context, 'Progressive Relaxation'),
            const SizedBox(height: 16),
            
            _buildExerciseCard(
              context, 
              'Muscle Relaxation',
              'Systematically tense and relax different muscle groups',
              '12 min',
              Icons.fitness_center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureExerciseCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          // In a full app, this would start the exercise
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Exercise not available in demo')),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              color: theme.colorScheme.primaryContainer,
              child: Center(
                child: Icon(
                  Icons.spa,
                  size: 64,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'FEATURED',
                      style: TextStyle(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Daily Mindfulness Meditation',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start your day with a 10-minute guided meditation to improve focus and reduce stress.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '10 min',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.headphones,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Audio guided',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
  
  Widget _buildExerciseCard(BuildContext context, String title, String description, String duration, IconData icon) {
    return ContentCard(
      title: title,
      subtitle: description,
      icon: icon,
      style: CardStyle.elevated,
      onTap: () {
        // In a full app, this would start the exercise
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercise not available in demo')),
        );
      },
      trailing: Chip(
        label: Text(duration),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: const SizedBox.shrink(),
    );
  }
} 