import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_mate/models/mood_entry_model.dart';
import 'package:mind_mate/services/storage_service.dart';
import 'package:mind_mate/widgets/custom_button.dart';
import 'package:mind_mate/constants/app_constants.dart';

class MoodStatsScreen extends StatefulWidget {
  const MoodStatsScreen({Key? key}) : super(key: key);

  @override
  State<MoodStatsScreen> createState() => _MoodStatsScreenState();
}

class _MoodStatsScreenState extends State<MoodStatsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<MoodEntry> _moodEntries = [];
  bool _isLoading = true;
  String _selectedTimeRange = 'Weekly'; // Weekly, Monthly, Yearly
  
  final List<String> _timeRanges = ['Weekly', 'Monthly', 'Yearly'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMoodEntries();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMoodEntries() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final entriesData = await StorageService.getMoodEntries();
      setState(() {
        _moodEntries = entriesData.map((data) => MoodEntry.fromMap(data)).toList();
        _moodEntries.sort((a, b) => a.date.compareTo(b.date)); // Sort by date, oldest first
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

  // Get filtered entries based on selected time range
  List<MoodEntry> _getFilteredEntries() {
    final now = DateTime.now();
    final filteredEntries = <MoodEntry>[];
    
    switch (_selectedTimeRange) {
      case 'Weekly':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final startDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        filteredEntries.addAll(
          _moodEntries.where((entry) => entry.date.isAfter(startDate) || entry.date.isAtSameMomentAs(startDate))
        );
        break;
      case 'Monthly':
        final startDate = DateTime(now.year, now.month, 1);
        filteredEntries.addAll(
          _moodEntries.where((entry) => entry.date.isAfter(startDate) || entry.date.isAtSameMomentAs(startDate))
        );
        break;
      case 'Yearly':
        final startDate = DateTime(now.year, 1, 1);
        filteredEntries.addAll(
          _moodEntries.where((entry) => entry.date.isAfter(startDate) || entry.date.isAtSameMomentAs(startDate))
        );
        break;
    }
    
    return filteredEntries;
  }

  // Demo data for testing
  List<MoodEntry> _getDemoMoodEntries() {
    final now = DateTime.now();
    final entries = <MoodEntry>[];
    
    // Generate entries for the past 30 days
    for (int i = 30; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final random = i % Mood.values.length;
      entries.add(
        MoodEntry(
          id: 'demo_$i',
          mood: Mood.values[random],
          date: date,
          note: 'Demo entry for ${DateFormat.yMMMd().format(date)}',
          factors: [MoodFactor.values[i % MoodFactor.values.length]],
        ),
      );
    }
    
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Analytics'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Trends'),
            Tab(text: 'Factors'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Time range selector
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SegmentedButton<String>(
                    segments: _timeRanges.map((range) => 
                      ButtonSegment<String>(
                        value: range,
                        label: Text(range),
                      ),
                    ).toList(),
                    selected: {_selectedTimeRange},
                    onSelectionChanged: (Set<String> selection) {
                      setState(() {
                        _selectedTimeRange = selection.first;
                      });
                    },
                  ),
                ),
                
                // Charts
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(theme),
                      _buildTrendsTab(theme),
                      _buildFactorsTab(theme),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildOverviewTab(ThemeData theme) {
    final filteredEntries = _getFilteredEntries();
    
    if (filteredEntries.isEmpty) {
      return _buildEmptyState(theme);
    }
    
    // Count occurrences of each mood
    final moodCounts = <Mood, int>{};
    for (final entry in filteredEntries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
    }
    
    // Prepare data for pie chart
    final pieData = moodCounts.entries.map((entry) {
      final mood = entry.key;
      final count = entry.value;
      
      return PieChartSectionData(
        value: count.toDouble(),
        title: '${(count / filteredEntries.length * 100).toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: _getMoodColor(mood),
      );
    }).toList();
    
    // Most common mood
    Mood? mostCommonMood;
    if (moodCounts.isNotEmpty) {
      mostCommonMood = moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Distribution',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.3,
            child: PieChart(
              PieChartData(
                sections: pieData,
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                startDegreeOffset: 180,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Legend
          Text(
            'Legend',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: moodCounts.keys.map((mood) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _getMoodColor(mood),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text('${mood.emoji} ${mood.name}'),
                ],
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Summary
          Text(
            'Summary',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Based on $_selectedTimeRange data from ${filteredEntries.length} entries:',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          // Most common mood
          if (mostCommonMood != null) 
            Text(
              '• Most common mood: ${mostCommonMood.emoji} ${mostCommonMood.name}',
              style: theme.textTheme.bodyLarge,
            ),
          // Date range
          if (filteredEntries.isNotEmpty) 
            Text(
              '• Date range: ${DateFormat.yMMMd().format(filteredEntries.first.date)} - ${DateFormat.yMMMd().format(filteredEntries.last.date)}',
              style: theme.textTheme.bodyLarge,
            ),
        ],
      ),
    );
  }

  Widget _buildTrendsTab(ThemeData theme) {
    final filteredEntries = _getFilteredEntries();
    
    if (filteredEntries.isEmpty) {
      return _buildEmptyState(theme);
    }
    
    // Group entries by day for line chart
    final dataByDay = <DateTime, List<MoodEntry>>{};
    
    for (final entry in filteredEntries) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      dataByDay[date] = [...(dataByDay[date] ?? []), entry];
    }
    
    // Calculate average mood score for each day
    final List<FlSpot> spots = [];
    final xLabels = <String>[];
    
    // Sort dates
    final sortedDates = dataByDay.keys.toList()..sort();
    
    for (int i = 0; i < sortedDates.length; i++) {
      final date = sortedDates[i];
      final entries = dataByDay[date]!;
      
      // Calculate average mood value (using the value getter from our Mood enum)
      final avgValue = entries.map((e) => e.mood.value).reduce((a, b) => a + b) / entries.length;
      
      spots.add(FlSpot(i.toDouble(), avgValue));
      
      // Format date for x-axis label
      if (_selectedTimeRange == 'Weekly') {
        xLabels.add(DateFormat('E').format(date)); // Day of week
      } else if (_selectedTimeRange == 'Monthly') {
        xLabels.add(DateFormat('d').format(date)); // Day of month
      } else {
        xLabels.add(DateFormat('MMM').format(date)); // Month
      }
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Trends Over Time',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value % 1 != 0) return const SizedBox.shrink();
                        final moodIndex = value.toInt() - 1;
                        if (moodIndex < 0 || moodIndex >= Mood.values.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            Mood.values[moodIndex].emoji,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= xLabels.length) {
                          return const SizedBox.shrink();
                        }
                        // Only show some labels to avoid overcrowding
                        if (_selectedTimeRange == 'Monthly' && xLabels.length > 10) {
                          if (value % 5 != 0 && value != xLabels.length - 1) {
                            return const SizedBox.shrink();
                          }
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            xLabels[value.toInt()],
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: spots.isEmpty ? 1 : (spots.length - 1).toDouble(),
                minY: 0,
                maxY: (Mood.values.length + 1).toDouble(),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: theme.colorScheme.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: spots.length < 15),
                    belowBarData: BarAreaData(
                      show: true,
                      color: theme.colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _selectedTimeRange == 'Weekly' 
                ? 'Your mood trends over the week' 
                : _selectedTimeRange == 'Monthly'
                    ? 'Your mood trends over the month'
                    : 'Your mood trends over the year',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildFactorsTab(ThemeData theme) {
    final filteredEntries = _getFilteredEntries();
    
    if (filteredEntries.isEmpty) {
      return _buildEmptyState(theme);
    }
    
    // Count occurrences of each factor
    final factorCounts = <MoodFactor, int>{};
    for (final entry in filteredEntries) {
      for (final factor in entry.factors) {
        factorCounts[factor] = (factorCounts[factor] ?? 0) + 1;
      }
    }
    
    // Sort factors by count (descending)
    final sortedFactors = factorCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Prepare data for bar chart
    final barGroups = <BarChartGroupData>[];
    final xLabels = <String>[];
    
    for (int i = 0; i < sortedFactors.length; i++) {
      final factor = sortedFactors[i].key;
      final count = sortedFactors[i].value;
      
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: theme.colorScheme.primary,
              width: 20,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
          ],
        ),
      );
      
      xLabels.add(factor.name);
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contributing Factors',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: barGroups.isEmpty
                ? Center(child: Text('No factor data available', style: theme.textTheme.bodyLarge))
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.center,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${xLabels[group.x.toInt()]}: ${rod.toY.toInt()}',
                              TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value < 0 || value >= xLabels.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  xLabels[value.toInt()],
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                            reservedSize: 30,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              if (value == 0) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        drawHorizontalLine: true,
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: theme.dividerColor),
                          bottom: BorderSide(color: theme.dividerColor),
                        ),
                      ),
                      barGroups: barGroups,
                      maxY: sortedFactors.isEmpty ? 10 : (sortedFactors.first.value * 1.2),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            _selectedTimeRange == 'Weekly' 
                ? 'Factors that influenced your mood this week' 
                : _selectedTimeRange == 'Monthly'
                    ? 'Factors that influenced your mood this month'
                    : 'Factors that influenced your mood this year',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No mood data available',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your mood to see statistics',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Add Mood Entry',
            onPressed: () {
              // Navigate to mood tracker screen
              Navigator.pushReplacementNamed(context, AppConstants.moodTrackerRoute);
            },
            type: ButtonType.outline,
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getMoodColor(Mood mood) {
    switch (mood) {
      case Mood.happy:
        return Colors.green;
      case Mood.excited:
        return Colors.amber;
      case Mood.calm:
        return Colors.lightBlue;
      case Mood.neutral:
        return Colors.grey;
      case Mood.sad:
        return Colors.indigo;
      case Mood.anxious:
        return Colors.orange;
      case Mood.angry:
        return Colors.red;
      case Mood.stressed:
        return Colors.deepPurple;
    }
  }
} 