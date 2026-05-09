import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/data_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        if (dataProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(dataProvider),
                const SizedBox(height: 24),

                // Momentum Card
                _buildMomentumCard(dataProvider),
                const SizedBox(height: 24),

                // Stats Row
                _buildStatsRow(dataProvider),
                const SizedBox(height: 24),

                // AI Suggestion Card
                _buildAISuggestionCard(dataProvider),
                const SizedBox(height: 24),

                // Today's Tasks
                _buildTodaysTasks(context, dataProvider),
                const SizedBox(height: 24),

                // Quick Actions
                _buildQuickActions(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(DataProvider dataProvider) {
    final greeting = dataProvider.getTimeGreeting();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn(),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dataProvider.currentUser?.displayName ?? 'Champion',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ).animate().fadeIn(delay: 100.ms),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: dataProvider.currentStreak > 0 
                        ? AppTheme.warning 
                        : AppTheme.textTertiary,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${dataProvider.currentStreak} day streak',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),
          ],
        ),
      ],
    );
  }

  Widget _buildMomentumCard(DataProvider dataProvider) {
    final momentum = dataProvider.momentumScore;
    return GradientCard(
      useGradient: false,
      child: Column(
        children: [
          Row(
            children: [
              // Momentum Ring
              _MomentumRing(score: momentum),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MOMENTUM',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getMomentumLabel(momentum),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedProgressBar(
                      progress: momentum / 100,
                      height: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _MomentumRing({required int score}) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.primaryGradient,
        boxShadow: AppTheme.glowShadow(AppTheme.primary, intensity: 0.6),
      ),
      child: Center(
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.surface,
          ),
          child: Center(
            child: Text(
              '$score',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getMomentumLabel(int score) {
    if (score >= 80) return 'On Fire! 🔥';
    if (score >= 60) return 'Strong 💪';
    if (score >= 40) return 'Building';
    if (score >= 20) return 'Starting';
    return 'Restart';
  }

  Widget _buildStatsRow(DataProvider dataProvider) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'Focus Time',
            value: '${dataProvider.todayFocusMinutes}m',
            icon: Icons.timer,
            iconColor: AppTheme.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            label: 'Tasks Done',
            value: '${dataProvider.currentUser?.completedTasks ?? 0}',
            icon: Icons.check_circle,
            iconColor: AppTheme.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            label: 'Level',
            value: '${dataProvider.currentUser?.level ?? 1}',
            icon: Icons.star,
            iconColor: AppTheme.warning,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildAISuggestionCard(DataProvider dataProvider) {
    final suggestion = dataProvider.getAiSuggestion();
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.secondary.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.psychology,
              color: AppTheme.secondary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Coach',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  suggestion,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildTodaysTasks(BuildContext context, DataProvider dataProvider) {
    final tasks = dataProvider.todayTasks.take(3).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Tasks",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (tasks.isEmpty)
          GlassCard(
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.celebration,
                    color: AppTheme.accent,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'All done for today!',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...tasks.asMap().entries.map((entry) {
            final task = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _TaskTile(
                title: task.title,
                suggestedAction: task.suggestedAction,
                priority: task.priority,
                onComplete: () => dataProvider.completeTask(task),
              ).animate().fadeIn(delay: (600 + entry.key * 100).ms),
            );
          }),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.lightbulb,
                label: 'What now?',
                color: AppTheme.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.play_arrow,
                label: 'Quick Focus',
                color: AppTheme.accent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.add_circle,
                label: 'Add Task',
                color: AppTheme.secondary,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 800.ms),
      ],
    );
  }
}

class _TaskTile extends StatelessWidget {
  final String title;
  final String? suggestedAction;
  final String priority;
  final VoidCallback onComplete;

  const _TaskTile({
    required this.title,
    this.suggestedAction,
    required this.priority,
    required this.onComplete,
  });

  Color get _priorityColor {
    switch (priority) {
      case 'High':
        return AppTheme.error;
      case 'Medium':
        return AppTheme.warning;
      default:
        return AppTheme.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onComplete,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              border: Border.all(color: _priorityColor, width: 2),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (suggestedAction != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    suggestedAction!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.accent,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppTheme.textTertiary,
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: () {},
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
