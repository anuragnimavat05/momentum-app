import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/data_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        final user = dataProvider.currentUser;
        final level = user?.level ?? 1;
        final xp = user?.xp ?? 0;
        final xpForNextLevel = (level * AppConstants.xpPerLevel);
        final xpProgress = (xp % AppConstants.xpPerLevel) / AppConstants.xpPerLevel;

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Profile Header
                  _ProfileHeader(
                    name: user?.displayName ?? 'Champion',
                    level: level,
                    xp: xp,
                  ),
                  const SizedBox(height: 32),

                  // Level Progress
                  _LevelProgress(
                    currentLevel: level,
                    progress: xpProgress,
                    xpToNext: AppConstants.xpPerLevel - (xp % AppConstants.xpPerLevel),
                  ),
                  const SizedBox(height: 24),

                  // Stats Grid
                  _StatsGrid(dataProvider: dataProvider),
                  const SizedBox(height: 24),

                  // Achievements
                  _buildAchievements(),
                  const SizedBox(height: 24),

                  // Settings
                  _buildSettings(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAchievements() {
    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Achievements',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _AchievementBadge(
                  icon: Icons.local_fire_department,
                  title: '5 Day Streak',
                  isUnlocked: true,
                ),
                _AchievementBadge(
                  icon: Icons.check_circle,
                  title: 'First Task',
                  isUnlocked: true,
                ),
                _AchievementBadge(
                  icon: Icons.star,
                  title: 'Level 10',
                  isUnlocked: true,
                ),
                _AchievementBadge(
                  icon: Icons.timer,
                  title: '10 Hours Focus',
                  isUnlocked: false,
                ),
                _AchievementBadge(
                  icon: Icons.flag,
                  title: 'First Goal',
                  isUnlocked: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings(BuildContext context) {
    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _SettingsItem(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {},
          ),
          _SettingsItem(
            icon: Icons.palette,
            title: 'Theme',
            onTap: () {},
          ),
          _SettingsItem(
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {},
          ),
          _SettingsItem(
            icon: Icons.info,
            title: 'About',
            onTap: () {},
          ),
          const Divider(color: AppTheme.surfaceLight),
          _SettingsItem(
            icon: Icons.logout,
            title: 'Sign Out',
            color: AppTheme.error,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final int level;
  final int xp;

  const _ProfileHeader({
    required this.name,
    required this.level,
    required this.xp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: AppTheme.glowShadow(AppTheme.primary),
          ),
          child: Center(
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'C',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ).animate().scale(curve: Curves.easeOutBack),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.warning.withAlpha(25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Level $level',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _LevelProgress extends StatelessWidget {
  final int currentLevel;
  final double progress;
  final int xpToNext;

  const _LevelProgress({
    required this.currentLevel,
    required this.progress,
    required this.xpToNext,
  });

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level $currentLevel',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
              Text(
                '$xpToNext XP to Level ${currentLevel + 1}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedProgressBar(
            progress: progress,
            height: 8,
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final DataProvider dataProvider;

  const _StatsGrid({required this.dataProvider});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _StatTile(
          icon: Icons.local_fire_department,
          label: 'Current Streak',
          value: '${dataProvider.currentStreak}',
          color: AppTheme.warning,
        ),
        _StatTile(
          icon: Icons.emoji_events,
          label: 'Longest Streak',
          value: '${dataProvider.currentUser?.longestStreak ?? 0}',
          color: AppTheme.success,
        ),
        _StatTile(
          icon: Icons.timer,
          label: 'Total Focus',
          value: '${dataProvider.totalFocusMinutes ~/ 60}h',
          color: AppTheme.primary,
        ),
        _StatTile(
          icon: Icons.check_circle,
          label: 'Tasks Done',
          value: '${dataProvider.currentUser?.completedTasks ?? 0}',
          color: AppTheme.accent,
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isUnlocked;

  const _AchievementBadge({
    required this.icon,
    required this.title,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppTheme.warning.withAlpha(25)
            : AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: isUnlocked
            ? Border.all(color: AppTheme.warning)
            : null,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isUnlocked ? AppTheme.warning : AppTheme.textTertiary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: isUnlocked
                  ? AppTheme.warning
                  : AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.color = AppTheme.textPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppTheme.textTertiary,
      ),
      onTap: onTap,
    );
  }
}
