import 'package:flutter/material.dart';
import 'package:mind_mate/screens/mood_tracker_screen.dart';
import 'package:mind_mate/screens/meditation_screen.dart';
import 'package:mind_mate/screens/journal_screen.dart';
import 'package:mind_mate/screens/chat_support_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _userName = "Demo User";
  
  // Updated color palette based on the warm palette image
  static const Color warmBeige = Color(0xFFF8D070);
  static const Color warmOrange = Color(0xFFFF9666);
  static const Color warmCoral = Color(0xFFEE6D57);
  static const Color warmRed = Color(0xFFDE3C50);
  static const Color warmTeal = Color(0xFF3A877A);
  
  // Background color for the app
  static const Color bgColor = Color(0xFFFFF9F0);
  
  // Original pastel palette (keeping for reference)
  static const Color lavender = Color(0xFFE0B7F4);
  static const Color softPink = Color(0xFFF2B5E1);
  static const Color lightBlue = Color(0xFFBFDFF3);
  static const Color mint = Color(0xFFB9E9E9);
  static const Color peach = Color(0xFFFFC9B4);
  
  // Mock mood data for the chart
  final List<Map<String, dynamic>> _moodData = [
    {'day': 'Mon', 'mood': 3}, // 1-5 scale, 5 being happiest
    {'day': 'Tue', 'mood': 4},
    {'day': 'Wed', 'mood': 2},
    {'day': 'Thu', 'mood': 5},
    {'day': 'Fri', 'mood': 4},
    {'day': 'Sat', 'mood': 3},
    {'day': 'Sun', 'mood': 4},
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Serenify', 
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: warmCoral,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              _showSnackBar(context, 'No new notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              _showProfileDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome banner with gradient
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [warmOrange, warmCoral],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $_userName!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'How are you feeling today?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Mood selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMoodButton('😔', 'Sad'),
                      _buildMoodButton('😐', 'Okay'),
                      _buildMoodButton('😊', 'Good'),
                      _buildMoodButton('😃', 'Great'),
                      _buildMoodButton('🤩', 'Amazing'),
                    ],
                  ),
                ],
              ),
            ),
            
            // Quick access cards
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Access',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeatureCard(
                          'Mood Tracker',
                          Icons.mood,
                          warmBeige,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MoodTrackerScreen()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFeatureCard(
                          'Meditation',
                          Icons.spa,
                          warmTeal,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MeditationScreen()),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeatureCard(
                          'Journal',
                          Icons.book,
                          warmOrange,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const JournalScreen()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFeatureCard(
                          'Chat Support',
                          Icons.chat_bubble_outline,
                          warmRed,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ChatSupportScreen()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Weekly mood summary
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Week',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mood Tracker',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: _moodData.map((data) {
                              return _buildMoodBar(data['day'], data['mood']);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Daily challenge
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [warmBeige, warmOrange],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Daily Challenge',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Practice mindful breathing for 5 minutes today',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MeditationScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: warmOrange,
                      ),
                      child: const Text('Start Now', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            
            // Space at the bottom
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          
          // Navigate based on the tab selected
          switch (index) {
            case 0: // Home - already on home screen
              break;
            case 1: // Meditate
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MeditationScreen()),
              );
              break;
            case 2: // Mood
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MoodTrackerScreen()),
              );
              break;
            case 3: // Chat
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatSupportScreen()),
              );
              break;
            case 4: // More - show options
              _showMoreOptions(context);
              break;
          }
        },
        backgroundColor: bgColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: warmCoral,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa),
            label: 'Meditate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
  
  // Helper to build mood buttons
  Widget _buildMoodButton(String emoji, String label) {
    return InkWell(
      onTap: () {
        _showSnackBar(context, 'You selected: $label mood');
        
        // Navigate to mood tracker to record today's mood
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MoodTrackerScreen()),
        );
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(8),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper to build feature cards
  Widget _buildFeatureCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper to build mood bars for the chart
  Widget _buildMoodBar(String day, int mood) {
    // Calculate the height of the bar based on mood (1-5)
    final height = 20.0 * mood;
    Color barColor;
    
    // Choose color based on mood
    if (mood <= 2) {
      barColor = warmRed;
    } else if (mood == 3) {
      barColor = warmOrange;
    } else {
      barColor = warmTeal;
    }
    
    return GestureDetector(
      onTap: () {
        // Navigate to mood tracker when clicking on a mood bar
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MoodTrackerScreen()),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 20,
            height: height,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            day,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper to show more options menu
  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'More Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4A4A),
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionTile(
              icon: Icons.book,
              title: 'Journal',
              subtitle: 'Record your thoughts and feelings',
              color: warmOrange,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JournalScreen()),
                );
              },
            ),
            _buildOptionTile(
              icon: Icons.lightbulb_outline,
              title: 'Daily Tips',
              subtitle: 'Wellness advice for everyday life',
              color: warmBeige,
              onTap: () {
                Navigator.pop(context);
                _showSnackBar(context, 'Daily Tips will be available soon!');
              },
            ),
            _buildOptionTile(
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'Customize your app experience',
              color: Colors.grey,
              onTap: () {
                Navigator.pop(context);
                _showSnackBar(context, 'Settings will be available soon!');
              },
            ),
            _buildOptionTile(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'Learn more about Serenify',
              color: warmTeal,
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper to build option tiles for more menu
  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF4A4A4A),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
      onTap: onTap,
    );
  }
  
  // Helper to show about dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bgColor,
          title: const Text(
            'About Serenify',
            style: TextStyle(
              color: Color(0xFF3A3A3A),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Serenify is your companion for mental well-being. Our mission is to help you find calm, clarity, and balance in your daily life.',
                style: TextStyle(color: Color(0xFF4A4A4A)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Features:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 8),
              _buildFeatureItem('Mood tracking to monitor your emotional health'),
              _buildFeatureItem('Guided meditations for stress relief'),
              _buildFeatureItem('Journaling for self-reflection'),
              _buildFeatureItem('Chat support when you need someone to talk to'),
              const SizedBox(height: 16),
              const Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: warmTeal, width: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: warmTeal,
                backgroundColor: warmTeal.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Close',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        );
      },
    );
  }
  
  // Helper to build feature items in about dialog
  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: warmTeal, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF4A4A4A)),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper to show a dialog for features
  void _showFeatureDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bgColor,
          title: Text(
            feature,
            style: const TextStyle(
              color: Color(0xFF3A3A3A),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'The $feature feature is now available! Click below to try it.',
            style: const TextStyle(color: Color(0xFF4A4A4A)),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: warmOrange, width: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: warmCoral,
                backgroundColor: warmCoral.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Maybe Later',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to the appropriate screen based on feature
                if (feature == 'Mood Tracker') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MoodTrackerScreen()),
                  );
                } else if (feature == 'Meditation') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MeditationScreen()),
                  );
                } else if (feature == 'Journal') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JournalScreen()),
                  );
                } else if (feature == 'Chat Support') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatSupportScreen()),
                  );
                } else if (feature == 'Mindful Breathing') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MeditationScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: warmCoral,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Try Now',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        );
      },
    );
  }
  
  // Helper to show a profile dialog
  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bgColor,
          title: const Text(
            'Profile',
            style: TextStyle(
              color: Color(0xFF3A3A3A),
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: warmOrange, width: 1.5),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: warmCoral,
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _userName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3A3A3A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'demo@serenify.com',
                style: TextStyle(color: Color(0xFF4A4A4A)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: warmRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Helper to get the tab name based on index
  String _getTabName(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Meditation';
      case 2:
        return 'Mood';
      case 3:
        return 'Chat';
      case 4:
        return 'More';
      default:
        return '';
    }
  }
  
  // Helper to show a custom snackbar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF774936),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}