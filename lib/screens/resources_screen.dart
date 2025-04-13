import 'package:flutter/material.dart';
import 'package:mind_mate/constants/app_constants.dart';
import 'package:mind_mate/widgets/content_card.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction text
            Text(
              'Educational resources to help you understand and improve your mental health',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            
            // Categories
            Text(
              'Categories',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Category grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: AppConstants.resourceCategories.length,
              itemBuilder: (context, index) {
                final category = AppConstants.resourceCategories[index];
                return _buildCategoryCard(context, category);
              },
            ),
            
            const SizedBox(height: 32),
            
            // Featured resources
            Text(
              'Featured Resources',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Featured resource cards
            _buildResourceCard(
              context,
              'Understanding Anxiety',
              'Learn about the different types of anxiety disorders and how they affect daily life.',
              Icons.psychology,
            ),
            
            const SizedBox(height: 16),
            
            _buildResourceCard(
              context,
              'Mindfulness Techniques',
              'Practical mindfulness exercises to help you stay present and reduce stress.',
              Icons.spa,
            ),
            
            const SizedBox(height: 16),
            
            _buildResourceCard(
              context,
              'Sleep Hygiene Guide',
              'Tips for improving your sleep quality and establishing a healthy sleep routine.',
              Icons.bedtime,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryCard(BuildContext context, String category) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // In a full app, this would navigate to a category-specific page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$category resources not available in demo')),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.7),
                theme.colorScheme.primary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Text(
            category,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
  
  Widget _buildResourceCard(BuildContext context, String title, String description, IconData icon) {
    return ContentCard(
      title: title,
      subtitle: description,
      icon: icon,
      style: CardStyle.elevated,
      onTap: () {
        // In a full app, this would open the resource
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resource not available in demo')),
        );
      },
      child: const SizedBox.shrink(),
    );
  }
} 