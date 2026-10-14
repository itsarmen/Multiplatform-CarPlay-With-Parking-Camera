import 'package:flutter/material.dart';

import '../../yaru_gallery/tokens.dart';
import '../dashboard/dashboard_card.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: YaruGallery.pageBackground,
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: dashboardCardDecoration(),
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: const _MapPainter()),
              ),
              const Positioned(top: 14, left: 14, child: _SearchBar()),
              const Positioned(top: 66, left: 14, child: _RouteCard()),
              const Positioned(bottom: 14, right: 14, child: _ZoomControls()),
              const Positioned(bottom: 14, left: 14, child: _ScaleChip()),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: SizedBox(
        width: 240,
        height: 38,
        child: Row(
          children: const [
            Icon(Icons.search, size: 18, color: YaruGallery.textSecondary),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search destination',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: YaruGallery.fontFamily,
                  fontSize: 13,
                  color: YaruGallery.textDisabled,
                ),
              ),
            ),
            Icon(Icons.mic_none_outlined, size: 18, color: YaruGallery.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard();

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              Text(
                '12 min',
                style: TextStyle(
                  fontFamily: YaruGallery.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: YaruGallery.accent,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '4.2 km',
                style: TextStyle(
                  fontFamily: YaruGallery.fontFamily,
                  fontSize: 13,
                  color: YaruGallery.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const SizedBox(
            width: 168,
            child: Text(
              'Fastest route via Market St',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: YaruGallery.fontFamily,
                fontSize: 12,
                color: YaruGallery.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoomControls extends StatelessWidget {
  const _ZoomControls();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _SquareButton(icon: Icons.add),
        SizedBox(height: 8),
        _SquareButton(icon: Icons.remove),
        SizedBox(height: 8),
        _SquareButton(icon: Icons.my_location, accent: true),
      ],
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({required this.icon, this.accent = false});

  final IconData icon;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: YaruGallery.canvas,
      borderRadius: BorderRadius.circular(10),
      elevation: 1,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            icon,
            size: 19,
            color: accent ? YaruGallery.accent : YaruGallery.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _ScaleChip extends StatelessWidget {
  const _ScaleChip();

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.navigation_outlined, size: 14, color: YaruGallery.textSecondary),
          SizedBox(width: 6),
          Text(
            '2D · 500 m',
            style: TextStyle(
              fontFamily: YaruGallery.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: YaruGallery.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Surface extends StatelessWidget {
  const _Surface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: YaruGallery.canvas,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFE9EDE6),
    );

    final water = Path()
      ..moveTo(w * 0.72, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.46)
      ..lineTo(w * 0.86, h * 0.3)
      ..close();
    canvas.drawPath(water, Paint()..color = const Color(0xFFCFE3F0));

    final park = Paint()..color = const Color(0xFFD6E8CE);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.07, h * 0.64, w * 0.16, h * 0.2),
        const Radius.circular(6),
      ),
      park,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.4, h * 0.08, w * 0.12, h * 0.16),
        const Radius.circular(6),
      ),
      park,
    );

    final casing = Paint()
      ..color = const Color(0xFFD8DBD4)
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final roads = <List<Offset>>[
      [Offset(0, h * 0.3), Offset(w, h * 0.22)],
      [Offset(0, h * 0.72), Offset(w, h * 0.8)],
      [Offset(w * 0.26, 0), Offset(w * 0.18, h)],
      [Offset(w * 0.62, 0), Offset(w * 0.7, h)],
      [Offset(0, h), Offset(w * 0.55, 0)],
    ];
    for (final r in roads) {
      final path = Path()
        ..moveTo(r[0].dx, r[0].dy)
        ..lineTo(r[1].dx, r[1].dy);
      canvas.drawPath(path, casing);
      canvas.drawPath(path, road);
    }

    final route = Path()
      ..moveTo(w * 0.18, h * 0.82)
      ..lineTo(w * 0.3, h * 0.6)
      ..lineTo(w * 0.5, h * 0.55)
      ..lineTo(w * 0.68, h * 0.3)
      ..lineTo(w * 0.82, h * 0.2);
    canvas.drawPath(
      route,
      Paint()
        ..color = YaruGallery.accent
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );

    final start = Offset(w * 0.18, h * 0.82);
    canvas.drawCircle(start, 9, Paint()..color = Colors.white);
    canvas.drawCircle(start, 6, Paint()..color = YaruGallery.successExample);

    final dest = Offset(w * 0.82, h * 0.2);
    canvas.drawCircle(dest, 12, Paint()..color = Colors.white);
    canvas.drawCircle(dest, 8, Paint()..color = YaruGallery.accent);
  }

  @override
  bool shouldRepaint(_MapPainter oldDelegate) => false;
}
