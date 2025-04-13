import 'dart:async';
import 'package:flutter/material.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> with SingleTickerProviderStateMixin {
  // Color palette
  static const Color warmBeige = Color(0xFFF8D070);
  static const Color warmOrange = Color(0xFFFF9666);
  static const Color warmCoral = Color(0xFFEE6D57);
  static const Color warmRed = Color(0xFFDE3C50);
  static const Color warmTeal = Color(0xFF3A877A);
  static const Color bgColor = Color(0xFFFFF9F0);
  
  // Sample meditation sessions
  final List<Map<String, dynamic>> _meditationSessions = [
    {
      'title': 'Morning Calm',
      'duration': 5,
      'description': 'Start your day with a peaceful 5-minute meditation.',
      'color': warmTeal,
      'icon': Icons.brightness_5,
    },
    {
      'title': 'Stress Relief',
      'duration': 10,
      'description': 'Release tension and find your center with guided breathing.',
      'color': warmCoral,
      'icon': Icons.self_improvement,
    },
    {
      'title': 'Deep Focus',
      'duration': 15,
      'description': 'Enhance concentration for work or study sessions.',
      'color': warmBeige,
      'icon': Icons.psychology,
    },
    {
      'title': 'Sleep Well',
      'duration': 20,
      'description': 'Gentle meditation to prepare for restful sleep.',
      'color': warmRed,
      'icon': Icons.nightlight_round,
    },
    {
      'title': 'Mindful Awareness',
      'duration': 10,
      'description': 'Practice being present and aware of your surroundings.',
      'color': warmOrange,
      'icon': Icons.spa,
    },
  ];
  
  // Active meditation session variables
  bool _isMeditating = false;
  int _selectedDuration = 5; // in minutes
  int _remainingSeconds = 0;
  Timer? _timer;
  String _selectedTitle = '';
  
  // Animation for breathing
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Setup breathing animation
    _breathingController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    
    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Add status listener for repeating
    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _breathingController.forward();
      }
    });
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _breathingController.dispose();
    super.dispose();
  }
  
  void _startMeditation(String title, int duration) {
    setState(() {
      _isMeditating = true;
      _selectedDuration = duration;
      _remainingSeconds = duration * 60;
      _selectedTitle = title;
    });
    
    // Start breathing animation
    _breathingController.forward();
    
    // Start timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _endMeditation();
        }
      });
    });
  }
  
  void _endMeditation() {
    _timer?.cancel();
    _breathingController.stop();
    
    setState(() {
      _isMeditating = false;
    });
    
    // Show completion dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        title: const Text(
          'Meditation Complete',
          style: TextStyle(
            color: Color(0xFF3A3A3A),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: warmTeal,
              size: 70,
            ),
            const SizedBox(height: 16),
            Text(
              'You completed $_selectedDuration minutes of meditation.',
              style: const TextStyle(
                color: Color(0xFF4A4A4A),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'How do you feel now?',
              style: TextStyle(
                color: Color(0xFF4A4A4A),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeelingButton('😌 Calm'),
                _buildFeelingButton('😊 Happy'),
                _buildFeelingButton('😐 Neutral'),
              ],
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
              'Done',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
  
  Widget _buildFeelingButton(String text) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You felt $text after meditation',
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
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: warmTeal.withOpacity(0.2),
        foregroundColor: warmTeal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(text),
    );
  }
  
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _isMeditating 
        ? null  // No app bar during meditation
        : AppBar(
            title: const Text('Meditation', 
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: warmTeal,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
      body: _isMeditating 
        ? _buildMeditationTimer()
        : _buildMeditationList(),
    );
  }
  
  Widget _buildMeditationList() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: warmTeal,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Take a moment to pause',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Select a meditation session to begin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Meditation sessions
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose a Session',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                const SizedBox(height: 16),
                ..._meditationSessions.map((session) => _buildSessionCard(session)).toList(),
              ],
            ),
          ),
          
          // Quick start
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Timer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [warmBeige, warmOrange],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Custom Session Duration',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Duration selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTimeButton(5),
                          _buildTimeButton(10),
                          _buildTimeButton(15),
                          _buildTimeButton(20),
                          _buildTimeButton(30),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _startMeditation('Custom Session', _selectedDuration),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: warmOrange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Begin Session',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  
  Widget _buildSessionCard(Map<String, dynamic> session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: session['color'],
          radius: 25,
          child: Icon(
            session['icon'],
            color: Colors.white,
          ),
        ),
        title: Text(
          session['title'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A4A4A),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${session['duration']} minutes',
              style: TextStyle(
                color: session['color'],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              session['description'],
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.play_circle_fill_rounded, size: 40),
          color: session['color'],
          onPressed: () => _startMeditation(session['title'], session['duration']),
        ),
      ),
    );
  }
  
  Widget _buildTimeButton(int minutes) {
    bool isSelected = _selectedDuration == minutes;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDuration = minutes;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            '$minutes',
            style: TextStyle(
              color: isSelected ? warmOrange : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMeditationTimer() {
    return Stack(
      children: [
        // Background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF3A877A),
                Color(0xFF2C5D52),
              ],
            ),
          ),
        ),
        
        // Content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Session title
              Text(
                _selectedTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 60),
              
              // Breathing animation circle
              AnimatedBuilder(
                animation: _breathingAnimation,
                builder: (context, child) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.6 * _breathingAnimation.value,
                    height: MediaQuery.of(context).size.width * 0.6 * _breathingAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        _breathingController.status == AnimationStatus.forward
                            ? 'Breathe In'
                            : 'Breathe Out',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 60),
              
              // Timer
              Text(
                _formatTime(_remainingSeconds),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // End session button
              ElevatedButton.icon(
                onPressed: _endMeditation,
                icon: const Icon(Icons.stop_circle_outlined),
                label: const Text('End Session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: warmTeal,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 