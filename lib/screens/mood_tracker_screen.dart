import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_mate/constants/app_constants.dart';
import 'package:mind_mate/models/mood_entry_model.dart';
import 'package:mind_mate/services/storage_service.dart';
import 'package:mind_mate/widgets/custom_button.dart';
import 'package:table_calendar/table_calendar.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({Key? key}) : super(key: key);

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<MoodEntry> _moodEntries = [];
  bool _isLoading = true;

  // Color palette
  static const Color warmBeige = Color(0xFFF8D070);
  static const Color warmOrange = Color(0xFFFF9666);
  static const Color warmCoral = Color(0xFFEE6D57);
  static const Color warmRed = Color(0xFFDE3C50);
  static const Color warmTeal = Color(0xFF3A877A);
  static const Color bgColor = Color(0xFFFFF9F0);

  // Sample mood data
  final List<Map<String, dynamic>> _weekMoodData = [
    {'day': 'Mon', 'mood': 3, 'note': 'Had a normal day'}, // 1-5 scale
    {'day': 'Tue', 'mood': 4, 'note': 'Completed my project!'},
    {'day': 'Wed', 'mood': 2, 'note': 'Feeling tired and stressed'},
    {'day': 'Thu', 'mood': 5, 'note': 'Great day with friends'},
    {'day': 'Fri', 'mood': 4, 'note': 'Weekend is coming!'},
    {'day': 'Sat', 'mood': 3, 'note': 'Relaxing weekend'},
    {'day': 'Sun', 'mood': 4, 'note': 'Ready for next week'},
  ];

  // Today's mood state
  int _todayMood = 3;
  final TextEditingController _noteController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMoodEntries();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Load mood entries from local storage
  Future<void> _loadMoodEntries() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final entriesData = await StorageService.getMoodEntries();
      
      setState(() {
        _moodEntries = entriesData.map((data) => MoodEntry.fromMap(data)).toList();
        _moodEntries.sort((a, b) => b.date.compareTo(a.date)); // Sort by date, newest first
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading mood entries: $e');
      
      // Use demo data if loading fails
      setState(() {
        _moodEntries = _getDemoMoodEntries();
        _isLoading = false;
      });
    }
  }

  // Save a new mood entry
  Future<void> _saveMoodEntry(MoodEntry entry) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Add to local list
      setState(() {
        _moodEntries.insert(0, entry); // Add to beginning of list
      });
      
      // Save to storage
      await StorageService.addMoodEntry(entry.toMap());
      
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mood entry saved')),
        );
      }
    } catch (e) {
      print('Error saving mood entry: $e');
      
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving mood entry: $e')),
        );
      }
    }
  }

  // Get mood entries for a specific day
  List<MoodEntry> _getMoodEntriesForDay(DateTime day) {
    return _moodEntries.where((entry) {
      return isSameDay(entry.date, day);
    }).toList();
  }

  // Generate sample mood entries for demo purposes
  List<MoodEntry> _getDemoMoodEntries() {
    final now = DateTime.now();
    return [
      MoodEntry(
        id: '1',
        mood: Mood.happy,
        date: now,
        note: 'Feeling good today!',
        factors: [MoodFactor.exercise, MoodFactor.socializing],
      ),
      MoodEntry(
        id: '2',
        mood: Mood.sad,
        date: now.subtract(const Duration(days: 2)),
        note: 'Rough day at work',
        factors: [MoodFactor.work, MoodFactor.stress],
      ),
      MoodEntry(
        id: '3',
        mood: Mood.neutral,
        date: now.subtract(const Duration(days: 4)),
        note: 'Nothing special today',
        factors: [],
      ),
      MoodEntry(
        id: '4',
        mood: Mood.excited,
        date: now.subtract(const Duration(days: 7)),
        note: 'Got a promotion!',
        factors: [MoodFactor.work, MoodFactor.achievement],
      ),
      MoodEntry(
        id: '5',
        mood: Mood.anxious,
        date: now.subtract(const Duration(days: 9)),
        note: 'Big presentation tomorrow',
        factors: [MoodFactor.work, MoodFactor.stress],
      ),
    ];
  }

  // Show dialog to add a new mood entry
  void _showAddMoodDialog() {
    Mood selectedMood = Mood.neutral;
    final noteController = TextEditingController();
    final selectedFactors = <MoodFactor>{};

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('How are you feeling?'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mood selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: Mood.values.map((mood) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedMood = mood;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedMood == mood
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          mood.emoji,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  selectedMood.name.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                // Factors that may have contributed
                const Text(
                  'Factors that may have contributed:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: MoodFactor.values.map((factor) {
                    return FilterChip(
                      label: Text(factor.name),
                      selected: selectedFactors.contains(factor),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedFactors.add(factor);
                          } else {
                            selectedFactors.remove(factor);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                
                // Note field
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    hintText: 'Add any notes about how you\'re feeling',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                // Create a new mood entry
                final newEntry = MoodEntry(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  mood: selectedMood,
                  date: _selectedDay,
                  note: noteController.text.trim(),
                  factors: selectedFactors.toList(),
                );
                
                // Save the entry
                _saveMoodEntry(newEntry);
                
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'View Statistics',
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.moodStatsRoute);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Calendar'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCalendarTab(theme),
                _buildHistoryTab(theme),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMoodDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalendarTab(ThemeData theme) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: _calendarFormat,
          eventLoader: _getMoodEntriesForDay,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          calendarStyle: CalendarStyle(
            markerDecoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isEmpty) return null;
              
              return Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary,
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(),
        Expanded(
          child: _buildMoodEntriesForSelectedDay(theme),
        ),
      ],
    );
  }

  Widget _buildMoodEntriesForSelectedDay(ThemeData theme) {
    final entries = _getMoodEntriesForDay(_selectedDay);
    
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No mood entries for ${DateFormat.yMMMd().format(_selectedDay)}',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Add Mood Entry',
              onPressed: _showAddMoodDialog,
              type: ButtonType.outline,
            ),
          ],
        ),
      );
    }
    
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _buildMoodEntryCard(entry, theme);
      },
    );
  }

  Widget _buildHistoryTab(ThemeData theme) {
    if (_moodEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No mood entries yet',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Add Mood Entry',
              onPressed: _showAddMoodDialog,
              type: ButtonType.outline,
            ),
          ],
        ),
      );
    }
    
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _moodEntries.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final entry = _moodEntries[index];
        return _buildMoodEntryCard(entry, theme);
      },
    );
  }

  Widget _buildMoodEntryCard(MoodEntry entry, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  entry.mood.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.mood.name.toUpperCase(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  DateFormat.yMMMd().add_jm().format(entry.date),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            if (entry.note.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(entry.note),
            ],
            if (entry.factors.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: entry.factors.map((factor) {
                  return Chip(
                    label: Text(factor.name),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper to build a mood entry card
  Widget _buildMoodEntry(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getMoodColor(data['mood']),
          child: Text(
            _getMoodEmoji(data['mood']),
            style: const TextStyle(fontSize: 18),
          ),
        ),
        title: Text(
          '${data['day']}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A4A4A),
          ),
        ),
        subtitle: Text(
          data['note'] ?? 'No note',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: warmCoral,
        ),
        onTap: () => _showMoodDetails(data),
      ),
    );
  }
  
  // Helper to build mood bars for the chart
  Widget _buildMoodBar(String day, int mood) {
    // Calculate the height of the bar based on mood (1-5)
    final height = 20.0 * mood;
    Color barColor = _getMoodColor(mood);
    
    return Column(
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
    );
  }
  
  // Get color based on mood value
  Color _getMoodColor(int mood) {
    if (mood <= 2) {
      return warmRed;
    } else if (mood == 3) {
      return warmOrange;
    } else {
      return warmTeal;
    }
  }
  
  // Get emoji based on mood value
  String _getMoodEmoji(int mood) {
    switch (mood) {
      case 1:
        return '😔';
      case 2:
        return '😐';
      case 3:
        return '😊';
      case 4:
        return '😃';
      case 5:
        return '🤩';
      default:
        return '😊';
    }
  }
  
  // Save mood to the list (in a real app this would save to a database)
  void _saveMood() {
    String note = _noteController.text.trim();
    
    // Show a confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Mood saved: ${_getMoodEmoji(_todayMood)} ${note.isNotEmpty ? "with note" : "without note"}',
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
    
    // Clear the note
    _noteController.clear();
  }
  
  // Show mood details
  void _showMoodDetails(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bgColor,
          title: Text(
            data['day'],
            style: const TextStyle(
              color: Color(0xFF3A3A3A),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: _getMoodColor(data['mood']),
                child: Text(
                  _getMoodEmoji(data['mood']),
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Note:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data['note'] ?? 'No note added for this day.',
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
} 