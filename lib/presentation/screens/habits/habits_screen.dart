import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../data/models/habit_model.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  // Demo habits
  final List<HabitModel> _habits = [
    HabitModel(
      id: '1',
      userId: 'demo',
      title: 'Morning meditation',
      why: 'Start the day with clarity',
      category: 'Health',
      frequency: 'daily',
      currentStreak: 12,
      longestStreak: 21,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      completionHistory: List.generate(
        12,
        (i) => DateTime.now().subtract(Duration(days: i)),
      ),
    ),
    HabitModel(
      id: '2',
      userId: 'demo',
      title: 'Read 10 pages',
      why: 'Expand my knowledge',
      category: 'Learning',
      frequency: 'daily',
      currentStreak: 5,
      longestStreak: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      completionHistory: List.generate(
        5,
        (i) => DateTime.now().subtract(Duration(days: i)),
      ),
    ),
    HabitModel(
      id: '3',
      userId: 'demo',
      title: 'Workout',
      why: 'Stay strong and healthy',
      category: 'Fitness',
      frequency: 'weekdays',
      currentStreak: 3,
      longestStreak: 30,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      completionHistory: List.generate(
        3,
        (i) => DateTime.now().subtract(Duration(days: i)),
      ),
    ),
  ];

  void _toggleHabit(HabitModel habit) {
    // In real app, this would update Firestore
    setState(() {
      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        final newHistory = List<DateTime>.from(habit.completionHistory);
        if (habit.completedToday) {
          newHistory.removeWhere((d) =>
              d.year == DateTime.now().year &&
              d.month == DateTime.now().month &&
              d.day == DateTime.now().day);
        } else {
          newHistory.add(DateTime.now());
        }
        _habits[index] = habit.copyWith(
          completionHistory: newHistory,
          currentStreak: newHistory.length,
          longestStreak: newHistory.length > habit.longestStreak
              ? newHistory.length
              : habit.longestStreak,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedToday = _habits.where((h) => h.completedToday).length;
    final totalHabits = _habits.length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(completedToday, totalHabits),
              const SizedBox(height: 24),
              _buildProgressCard(completedToday, totalHabits),
              const SizedBox(height: 24),
              _buildHabitList(),
              const SizedBox(height: 24),
              _buildAddHabitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int completed, int total) {
    return Row(
      children: [
        const Text(
          'Habits',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const Spacer(),
        PremiumGlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            '$completed/$total today',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(int completed, int total) {
    final progress = total > 0 ? completed / total : 0.0;
    
    return PremiumGlassCard(
      enableGlow: true,
      glowColor: completed == total ? AppTheme.success : AppTheme.primary,
      child: Column(
        children: [
          Row(
            children: [
              GlowingProgressRing(
                progress: progress,
                size: 80,
                strokeWidth: 6,
                progressColor: completed == total ? AppTheme.success : AppTheme.primary,
                center: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: completed == total ? AppTheme.success : AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      completed == total ? 'All habits done! 🎉' : 'Keep going!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      completed == total
                          ? 'Amazing consistency!'
                          : '${total - completed} habits remaining',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildHabitList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Habits',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ..._habits.asMap().entries.map((entry) {
          final habit = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _HabitCard(
              habit: habit,
              onToggle: () => _toggleHabit(habit),
            ).animate().fadeIn(delay: (100 * entry.key).ms).slideX(begin: 0.1),
          );
        }),
      ],
    );
  }

  Widget _buildAddHabitButton() {
    return SizedBox(
      width: double.infinity,
      child: PremiumGlassCard(
        onTap: () {
          // Open add habit dialog
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: AppTheme.primary),
            SizedBox(width: 8),
            Text(
              'Add New Habit',
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  final HabitModel habit;
  final VoidCallback onToggle;

  const _HabitCard({
    required this.habit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.horizontal,
      onDismissed: (_) => onToggle(),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: AppTheme.success.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.check, color: AppTheme.success),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.error.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.close, color: AppTheme.error),
      ),
      child: PremiumGlassCard(
        onTap: onToggle,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: habit.completedToday
                    ? AppTheme.success
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: habit.completedToday
                      ? AppTheme.success
                      : AppTheme.textTertiary,
                  width: 2,
                ),
              ),
              child: habit.completedToday
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: habit.completedToday
                          ? AppTheme.textSecondary
                          : AppTheme.textPrimary,
                      decoration: habit.completedToday
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (habit.why != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      habit.why!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: habit.currentStreak > 0
                          ? AppTheme.warning
                          : AppTheme.textTertiary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${habit.currentStreak}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: habit.currentStreak > 0
                            ? AppTheme.warning
                            : AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    habit.category,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
