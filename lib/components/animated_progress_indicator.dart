import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedCircularProgressIndicator extends StatefulWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final double value, strokeWidth;

  const AnimatedCircularProgressIndicator({
    Key? key,
    this.backgroundColor = Colors.transparent,
    required this.foregroundColor,
    required this.value,
    this.strokeWidth = 2,
  }) : super(key: key);

  @override
  State<AnimatedCircularProgressIndicator> createState() => _AnimatedCircularProgressIndicatorState();
}

class _AnimatedCircularProgressIndicatorState extends State<AnimatedCircularProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Tween<double> valueTween;
  late Animation<double> curve;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _animationController.forward();
    valueTween = Tween<double>(begin: 0, end: widget.value);
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedCircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) {
      double beginValue = valueTween.evaluate(_animationController);

      valueTween = Tween<double>(
        begin: beginValue,
        end: widget.value,
      );

      _animationController
        ..value = 0
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: _animationController,
        child: Container(),
        builder: (context, child) {
          return CustomPaint(
            foregroundPainter: CircleProgressBarPainter(
              backgroundColor: widget.backgroundColor,
              foregroundColor: widget.foregroundColor,
              strokeWidth: widget.strokeWidth,
              percentage: valueTween.evaluate(curve),
            ),
          );
        },
      ),
    );
  }
}

class CircleProgressBarPainter extends CustomPainter {
  final double percentage, strokeWidth;
  final Color backgroundColor, foregroundColor;

  CircleProgressBarPainter({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.percentage,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final constrainedSize = size - Offset(strokeWidth, strokeWidth) as Size;
    final shortestSide = math.min(constrainedSize.width, constrainedSize.height);
    final foregroundPaint = Paint()
      ..color = foregroundColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final radius = (shortestSide / 2);

    const double startAngle = -(2 * math.pi * 0.25);
    final double sweepAngle = (2 * math.pi * (percentage));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final oldPainter = (oldDelegate as CircleProgressBarPainter);
    return oldPainter.percentage != percentage || oldPainter.backgroundColor != backgroundColor || oldPainter.foregroundColor != foregroundColor || oldPainter.strokeWidth != strokeWidth;
  }
}
