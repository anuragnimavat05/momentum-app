import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  const AnimatedGradientBackground({super.key, required this.child});
  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 3), vsync: this)..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.background,
                AppTheme.backgroundSecondary,
                AppTheme.surface.withAlpha(50),
                AppTheme.background,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

class PremiumGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool enableGlow;
  final Color? glowColor;
  const PremiumGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius = 16,
    this.enableGlow = false,
    this.glowColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppTheme.surface.withAlpha(180),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.white.withAlpha(15), width: 1),
        boxShadow: enableGlow ? AppTheme.glowShadow(glowColor ?? AppTheme.primary, intensity: 0.3) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(padding: padding ?? const EdgeInsets.all(16), child: child),
        ),
      ),
    );
  }
}

class GlowingProgressRing extends StatefulWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Widget? center;
  final bool animate;
  const GlowingProgressRing({
    super.key,
    required this.progress,
    this.size = 100,
    this.strokeWidth = 8,
    this.progressColor,
    this.center,
    this.animate = true,
  });
  @override
  State<GlowingProgressRing> createState() => _GlowingProgressRingState();
}

class _GlowingProgressRingState extends State<GlowingProgressRing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentProgress = 0;
  @override
  void initState() {
    super.initState();
    _currentProgress = widget.progress;
    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _animation = Tween<double>(begin: 0, end: widget.progress).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    if (widget.animate) _controller.forward();
  }
  @override
  void didUpdateWidget(GlowingProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(begin: _currentProgress, end: widget.progress).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller.forward(from: 0);
      _currentProgress = widget.progress;
    }
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size, height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(size: Size(widget.size, widget.size), painter: _RingPainter(progress: 1.0, strokeWidth: widget.strokeWidth, color: AppTheme.surfaceLight)),
              CustomPaint(size: Size(widget.size, widget.size), painter: _RingPainter(progress: _animation.value, strokeWidth: widget.strokeWidth, color: widget.progressColor ?? AppTheme.primary, withGlow: true)),
              if (widget.center != null) widget.center!,
            ],
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress; final double strokeWidth; final Color color; final bool withGlow;
  _RingPainter({required this.progress, required this.strokeWidth, required this.color, this.withGlow = false});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = strokeWidth..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    if (withGlow) paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final center = Offset(size.width / 2, size.height / 2), radius = (size.width - strokeWidth) / 2;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, 2 * pi * progress, false, paint);
  }
  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => oldDelegate.progress != progress || oldDelegate.color != color;
}

class FloatingGlowButton extends StatefulWidget {
  final IconData icon; final VoidCallback onPressed; final Color? color; final double size;
  const FloatingGlowButton({super.key, required this.icon, required this.onPressed, this.color, this.size = 56});
  @override
  State<FloatingGlowButton> createState() => _FloatingGlowButtonState();
}

class _FloatingGlowButtonState extends State<FloatingGlowButton> with SingleTickerProviderStateMixin {
  late AnimationController _floatController; late Animation<double> _floatAnimation;
  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: 0, end: 8).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));
  }
  @override
  void dispose() { _floatController.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_floatAnimation.value),
          child: Container(
            width: widget.size, height: widget.size,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: AppTheme.glowShadow(widget.color ?? AppTheme.primary),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(widget.size),
                child: Icon(widget.icon, color: Colors.white, size: widget.size * 0.5),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PulseAchievementBadge extends StatefulWidget {
  final IconData icon; final String title; final bool isUnlocked; final bool isNew;
  const PulseAchievementBadge({super.key, required this.icon, required this.title, required this.isUnlocked, this.isNew = false});
  @override
  State<PulseAchievementBadge> createState() => _PulseAchievementBadgeState();
}

class _PulseAchievementBadgeState extends State<PulseAchievementBadge> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    if (widget.isNew) _pulseController.repeat(reverse: true);
  }
  @override
  void dispose() { _pulseController.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.isUnlocked ? AppTheme.warning.withAlpha(25 + (30 * _pulseController.value).toInt()) : AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.isUnlocked ? AppTheme.warning.withAlpha((150 + 100 * _pulseController.value).toInt()) : Colors.transparent, width: 2),
            boxShadow: widget.isUnlocked && widget.isNew ? AppTheme.glowShadow(AppTheme.warning, intensity: 0.3 + 0.3 * _pulseController.value) : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: widget.isUnlocked ? AppTheme.warning : AppTheme.textTertiary, size: 28),
              const SizedBox(height: 8),
              Text(widget.title, style: TextStyle(fontSize: 10, color: widget.isUnlocked ? AppTheme.warning : AppTheme.textTertiary), textAlign: TextAlign.center),
            ],
          ),
        );
      },
    );
  }
}

class ConfettiOverlay extends StatefulWidget {
  final bool show; final VoidCallback? onComplete;
  const ConfettiOverlay({super.key, required this.show, this.onComplete});
  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller; final List<_ConfettiPiece> _pieces = []; final Random _random = Random();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _controller.addStatusListener((status) { if (status == AnimationStatus.completed) widget.onComplete?.call(); });
  }
  @override
  void didUpdateWidget(ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) { _generatePieces(); _controller.forward(from: 0); }
  }
  void _generatePieces() {
    _pieces.clear();
    for (int i = 0; i < 50; i++) {
      _pieces.add(_ConfettiPiece(x: _random.nextDouble(), y: -_random.nextDouble() * 0.2, velocityX: (_random.nextDouble() - 0.5) * 0.3, velocityY: _random.nextDouble() * 0.5 + 0.3, rotation: _random.nextDouble() * 2 * pi, rotationSpeed: (_random.nextDouble() - 0.5) * 0.2, color: [AppTheme.primary, AppTheme.secondary, AppTheme.accent, AppTheme.warning, AppTheme.success][_random.nextInt(5)], size: _random.nextDouble() * 8 + 4));
    }
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    if (!widget.show && !_controller.isAnimating) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(size: Size.infinite, painter: _ConfettiPainter(pieces: _pieces, progress: _controller.value));
      },
    );
  }
}

class _ConfettiPiece {
  double x, y, velocityX, velocityY, rotation, rotationSpeed; Color color; double size;
  _ConfettiPiece({required this.x, required this.y, required this.velocityX, required this.velocityY, required this.rotation, required this.rotationSpeed, required this.color, required this.size});
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces; final double progress;
  _ConfettiPainter({required this.pieces, required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in pieces) {
      final x = (piece.x + piece.velocityX * progress) * size.width;
      final y = (piece.y + piece.velocityY * progress * progress * 2) * size.height;
      final opacity = (1 - progress).clamp(0.0, 1.0);
      final paint = Paint()..color = piece.color.withAlpha((opacity * 255).toInt())..style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(piece.rotation + piece.rotationSpeed * progress * 10);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: piece.size, height: piece.size * 0.6), paint);
      canvas.restore();
    }
  }
  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}
