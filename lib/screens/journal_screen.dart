import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  // Color palette
  static const Color warmBeige = Color(0xFFF8D070);
  static const Color warmOrange = Color(0xFFFF9666);
  static const Color warmCoral = Color(0xFFEE6D57);
  static const Color warmRed = Color(0xFFDE3C50);
  static const Color warmTeal = Color(0xFF3A877A);
  static const Color bgColor = Color(0xFFFFF9F0);
  
  // Journal entries (in a real app this would be stored in a database)
  final List<Map<String, dynamic>> _journalEntries = [
    {
      'id': '1',
      'title': 'A Productive Day',
      'content': 'Today I completed all my tasks before noon! I felt very productive and accomplished. Later I went for a walk in the park and enjoyed the fresh air.',
      'mood': 'Happy',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'tags': ['productive', 'work', 'exercise'],
    },
    {
      'id': '2',
      'title': 'Feeling Stressed',
      'content': 'Work has been overwhelming lately. I need to find better ways to manage my time and reduce stress. Perhaps I should try meditation.',
      'mood': 'Stressed',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'tags': ['work', 'stress'],
    },
    {
      'id': '3',
      'title': 'Weekend Plans',
      'content': 'I\'m looking forward to the weekend. Planning to meet friends and maybe watch a movie. It\'s been a while since I\'ve had a proper break.',
      'mood': 'Excited',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'tags': ['weekend', 'friends', 'movies'],
    },
  ];
  
  // Controllers for new entry
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedMood = 'Neutral';
  final List<String> _moodOptions = ['Happy', 'Sad', 'Excited', 'Stressed', 'Calm', 'Neutral'];
  
  bool _isEditing = false;
  
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Journal', 
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: warmOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isEditing ? _buildJournalEntryEditor() : _buildJournalList(),
      floatingActionButton: _isEditing 
        ? null
        : FloatingActionButton(
            onPressed: () {
              setState(() {
                _isEditing = true;
                _titleController.clear();
                _contentController.clear();
                _selectedMood = 'Neutral';
              });
            },
            backgroundColor: warmOrange,
            child: const Icon(Icons.add),
          ),
    );
  }
  
  Widget _buildJournalList() {
    return Column(
      children: [
        // Header section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: warmOrange,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Journal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Capture your thoughts and emotions',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  _JournalStat(
                    count: '3',
                    label: 'Entries',
                    icon: Icons.book,
                  ),
                  _JournalStat(
                    count: '5',
                    label: 'Days',
                    icon: Icons.calendar_today,
                  ),
                  _JournalStat(
                    count: '7',
                    label: 'Tags',
                    icon: Icons.label,
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Entries list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _journalEntries.length,
            itemBuilder: (context, index) {
              final entry = _journalEntries[index];
              return _buildJournalCard(entry);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildJournalCard(Map<String, dynamic> entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () => _showJournalDetails(entry),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      entry['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A4A4A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getMoodColor(entry['mood']),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      entry['mood'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('MMMM d, yyyy').format(entry['date']),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                entry['content'],
                style: const TextStyle(
                  color: Color(0xFF4A4A4A),
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: (entry['tags'] as List<String>).map((tag) {
                  return Chip(
                    label: Text(
                      '#$tag',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: warmCoral.withOpacity(0.7),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return warmTeal;
      case 'sad':
        return warmRed;
      case 'excited':
        return warmBeige;
      case 'stressed':
        return warmRed;
      case 'calm':
        return warmTeal;
      default:
        return warmOrange;
    }
  }
  
  void _showJournalDetails(Map<String, dynamic> entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with date and mood
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _getMoodColor(entry['mood']),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMMM d, yyyy').format(entry['date']),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            entry['mood'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      entry['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Entry content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry['content'],
                        style: const TextStyle(
                          color: Color(0xFF4A4A4A),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Tags',
                        style: TextStyle(
                          color: Color(0xFF4A4A4A),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (entry['tags'] as List<String>).map((tag) {
                          return Chip(
                            label: Text(
                              '#$tag',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: warmCoral.withOpacity(0.7),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Bottom actions
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _editEntry(entry);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: warmOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _deleteEntry(entry);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: warmRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _editEntry(Map<String, dynamic> entry) {
    // In a real app, you would implement editing functionality
    // For this demo, we'll just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Edit functionality would be available in the full app',
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
  }
  
  void _deleteEntry(Map<String, dynamic> entry) {
    // In a real app, you would delete from database
    // For this demo, we're just removing from the list
    setState(() {
      _journalEntries.removeWhere((e) => e['id'] == entry['id']);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Journal entry deleted',
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
  }
  
  Widget _buildJournalEntryEditor() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: warmOrange,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Journal Entry',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Write down your thoughts and feelings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Form
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Date display
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: warmOrange),
                      const SizedBox(width: 12),
                      Text(
                        'Today, ${DateFormat('MMMM d, yyyy').format(DateTime.now())}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Title field
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: warmOrange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(16),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: const Icon(Icons.title, color: warmOrange),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Mood selector
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'How are you feeling?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _moodOptions.map((mood) {
                          bool isSelected = _selectedMood == mood;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedMood = mood;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? _getMoodColor(mood) : Colors.grey[200],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                mood,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Content field
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Write your thoughts...',
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4A4A4A),
                    height: 1.5,
                  ),
                  maxLines: 8,
                  textAlignVertical: TextAlignVertical.top,
                ),
                
                const SizedBox(height: 30),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        icon: const Icon(Icons.close),
                        label: const Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.grey[700],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _saveEntry,
                        icon: const Icon(Icons.check),
                        label: const Text('Save'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: warmOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _saveEntry() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write some content'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // In a real app, you would save to a database
    // For this demo, we're just adding to the list
    setState(() {
      _journalEntries.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title,
        'content': content,
        'mood': _selectedMood,
        'date': DateTime.now(),
        'tags': _extractHashtags(content),
      });
      
      _isEditing = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Journal entry saved',
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
  }
  
  List<String> _extractHashtags(String text) {
    // Simple hashtag extraction
    final List<String> tags = [];
    final words = text.split(' ');
    
    for (var word in words) {
      if (word.startsWith('#')) {
        final tag = word.substring(1).toLowerCase();
        if (tag.isNotEmpty && !tags.contains(tag)) {
          tags.add(tag);
        }
      }
    }
    
    // For demo, if no tags found, add some random ones
    if (tags.isEmpty) {
      final List<String> sampleTags = ['journal', 'thoughts', 'reflection'];
      tags.add(sampleTags[DateTime.now().millisecond % sampleTags.length]);
    }
    
    return tags;
  }
}

class _JournalStat extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;
  
  const _JournalStat({
    required this.count,
    required this.label,
    required this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
} 