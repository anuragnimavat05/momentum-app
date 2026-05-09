import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/data_provider.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  bool _isRunning = false;
  int _selectedMinutes = 25;
  int _remainingSeconds = 25 * 60;
  Timer? _timer;
  String _selectedSound = 'None';

  final List<int> _sessionDurations = [15, 25, 45, 60];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _remainingSeconds = _selectedMinutes * 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
    
    // Show completion dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Focus Complete! 🎉'),
        content: const Text('Great job staying focused! Take a break.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final quote = AppConstants.motivationalQuotes[
      DateTime.now().minute % AppConstants.motivationalQuotes.length
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Focus Mode',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                quote,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Timer
              _buildTimer(),
              const Spacer(),
              if (!_isRunning) ...[
                _buildDurationSelector(),
                const SizedBox(height: 24),
                _buildSoundSelector(),
                const SizedBox(height: 24),
              ],
              _buildControls(),
              const SizedBox(height: 24),
              _buildStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimer() {
    final progress = 1 - (_remainingSeconds / (_selectedMinutes * 60));
    
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: 280,
            height: 280,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 8,
              color: AppTheme.surfaceLight,
            ),
          ),
          // Progress circle
          SizedBox(
            width: 280,
            height: 280,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              strokeCap: StrokeCap.round,
              color: AppTheme.primary,
            ),
          ).animate().scale(
            duration: 300.ms,
            curve: Curves.easeOut,
          ),
          // Timer text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formattedTime,
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ).animate().fadeIn(),
              const SizedBox(height: 8),
              Text(
                _isRunning ? 'Stay focused!' : 'Ready to focus',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _sessionDurations.map((minutes) {
        final isSelected = _selectedMinutes == minutes;
        return GestureDetector(
          onTap: () => setState(() {
            _selectedMinutes = minutes;
            _remainingSeconds = minutes * 60;
          }),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primary : AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected ? AppTheme.glowShadow(AppTheme.primary) : null,
            ),
            child: Text(
              '$minutes min',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.background : AppTheme.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSoundSelector() {
    final sounds = ['None', 'Rain', 'Forest', 'White Noise'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: sounds.map((sound) {
          final isSelected = _selectedSound == sound;
          return GestureDetector(
            onTap: () => setState(() => _selectedSound = sound),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? Border.all(color: AppTheme.secondary)
                    : null,
              ),
              child: Text(
                sound,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? AppTheme.secondary
                      : AppTheme.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_isRunning)
          GestureDetector(
            onTap: _stopTimer,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.stop,
                color: Colors.white,
                size: 32,
              ),
            ),
          )
        else
          GestureDetector(
            onTap: _startTimer,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: AppTheme.glowShadow(AppTheme.primary),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ).animate().scale(curve: Curves.easeOutBack),
      ],
    );
  }

  Widget _buildStats() {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatItem(
              label: 'Today',
              value: '${dataProvider.todayFocusMinutes}m',
            ),
            _StatItem(
              label: 'Total',
              value: '${dataProvider.totalFocusMinutes ~/ 60}h',
            ),
          ],
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
