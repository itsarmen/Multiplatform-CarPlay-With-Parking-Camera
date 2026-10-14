import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../yaru_gallery/tokens.dart';

/// A large semicircular GPS speedometer gauge.
class SpeedometerGauge extends StatelessWidget {
  const SpeedometerGauge({
    super.key,
    required this.speed,
    required this.maxSpeed,
    required this.warning,
  });

  final double speed;
  final double maxSpeed;
  final bool warning;

  static const double _centerFactor = 0.86;
  static const double _radiusMargin = 22;

  @override
  Widget build(BuildContext context) {
    final activeColor =
        warning ? YaruGallery.warning : YaruGallery.accent;
    final rounded = speed.round();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double w = constraints.maxWidth;
        final double h =
            constraints.maxHeight.isFinite ? constraints.maxHeight : w * 0.6;
        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _GaugePainter(
                  speed: speed,
                  maxSpeed: maxSpeed,
                  activeColor: activeColor,
                  warning: warning,
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.58),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$rounded',
                    style: TextStyle(
                      fontFamily: YaruGallery.fontFamily,
                      fontSize: math.min(56, h * 0.32),
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      color: warning
                          ? YaruGallery.warning
                          : YaruGallery.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'km/h',
                    style: TextStyle(
                      fontFamily: YaruGallery.fontFamily,
                      fontSize: 14,
                      color: YaruGallery.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.speed,
    required this.maxSpeed,
    required this.activeColor,
    required this.warning,
  });

  final double speed;
  final double maxSpeed;
  final Color activeColor;
  final bool warning;

  static const double _startAngle = math.pi;
  static const double _sweepAngle = math.pi;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height * SpeedometerGauge._centerFactor,
    );
    final radius = math.min(
          size.width / 2,
          size.height * SpeedometerGauge._centerFactor,
        ) -
        SpeedometerGauge._radiusMargin;

    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..color = YaruGallery.surfaceMuted;
    canvas.drawArc(rect, _startAngle, _sweepAngle, false, track);

    final fraction = (speed / maxSpeed).clamp(0.0, 1.0);
    if (fraction > 0) {
      final active = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round
        ..color = activeColor;
      canvas.drawArc(rect, _startAngle, _sweepAngle * fraction, false, active);
    }

    for (int value = 0; value <= maxSpeed; value += 10) {
      final angle = _startAngle + _sweepAngle * (value / maxSpeed);
      final major = value % 20 == 0;
      final direction = Offset(math.cos(angle), math.sin(angle));
      final inner = center + direction * (radius - (major ? 18 : 10));
      final outer = center + direction * (radius - 4);

      canvas.drawLine(
        inner,
        outer,
        Paint()
          ..color = major ? YaruGallery.textSecondary : YaruGallery.textDisabled
          ..strokeWidth = major ? 2 : 1,
      );

      if (major) {
        final label = TextPainter(
          text: TextSpan(
            text: '$value',
            style: const TextStyle(
              fontFamily: YaruGallery.fontFamily,
              fontSize: 11,
              color: YaruGallery.textSecondary,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        final position = center + direction * (radius - 40);
        label.paint(
          canvas,
          position - Offset(label.width / 2, label.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) {
    return oldDelegate.speed != speed ||
        oldDelegate.maxSpeed != maxSpeed ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.warning != warning;
  }
}
