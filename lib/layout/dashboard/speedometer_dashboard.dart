import 'package:flutter/material.dart';

import '../../yaru_gallery/tokens.dart';
import 'dashboard_card.dart';
import 'speed_limits_card.dart';
import 'speedometer_gauge.dart';

class SpeedometerDashboard extends StatefulWidget {
  const SpeedometerDashboard({super.key});

  @override
  State<SpeedometerDashboard> createState() => _SpeedometerDashboardState();
}

class _SpeedometerDashboardState extends State<SpeedometerDashboard> {
  static const double _maxSpeed = 160;

  final double _speed = 0;
  int _activeLimit = 50;
  final bool _gpsConnected = true;

  final List<SpeedPreset> _presets = <SpeedPreset>[
    const SpeedPreset(30, 'Residential'),
    const SpeedPreset(50, 'Urban'),
    const SpeedPreset(60, 'Main road'),
    const SpeedPreset(80, 'Highway'),
    const SpeedPreset(100, 'Expressway'),
    const SpeedPreset(120, 'Motorway'),
  ];

  void _addPreset(int value) {
    setState(() {
      if (!_presets.any((p) => p.value == value)) {
        _presets
          ..add(SpeedPreset(value, 'Custom'))
          ..sort((a, b) => a.value.compareTo(b.value));
      }
      _activeLimit = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final warning = _speed > _activeLimit;
    return Container(
      color: YaruGallery.pageBackground,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 66,
            child: _SpeedometerCard(
              speed: _speed,
              limit: _activeLimit,
              maxSpeed: _maxSpeed,
              gpsConnected: _gpsConnected,
              warning: warning,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 34,
            child: SpeedLimitsCard(
              presets: _presets,
              activeValue: _activeLimit,
              onSelect: (value) => setState(() => _activeLimit = value),
              onAdd: _addPreset,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeedometerCard extends StatelessWidget {
  const _SpeedometerCard({
    required this.speed,
    required this.limit,
    required this.maxSpeed,
    required this.gpsConnected,
    required this.warning,
  });

  final double speed;
  final int limit;
  final double maxSpeed;
  final bool gpsConnected;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: dashboardCardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  'CURRENT SPEED',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: YaruGallery.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: YaruGallery.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (warning) const _WarningChip() else _LimitChip(limit: limit),
              const SizedBox(width: 8),
              _GpsChip(connected: gpsConnected),
            ],
          ),
          const SizedBox(height: 2),
          Expanded(
            child: SpeedometerGauge(
              speed: speed,
              maxSpeed: maxSpeed,
              warning: warning,
            ),
          ),
          const SizedBox(height: 6),
          const Divider(height: 1, color: YaruGallery.borderSubtle),
          const SizedBox(height: 12),
          const Row(
            children: [
              _Stat(value: '0.0 km', label: 'Trip distance'),
              _Stat(value: '0 km/h', label: 'Average speed'),
              _Stat(value: '00:00', label: 'Elapsed time'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: YaruGallery.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: YaruGallery.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: YaruGallery.fontFamily,
              fontSize: 11,
              color: YaruGallery.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GpsChip extends StatelessWidget {
  const _GpsChip({required this.connected});
  final bool connected;

  @override
  Widget build(BuildContext context) {
    final color =
        connected ? YaruGallery.successExample : YaruGallery.textDisabled;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            connected ? 'GPS connected' : 'No GPS signal',
            style: TextStyle(
              fontFamily: YaruGallery.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _LimitChip extends StatelessWidget {
  const _LimitChip({required this.limit});
  final int limit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: YaruGallery.surfaceSubtle,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.speed_outlined,
            size: 13,
            color: YaruGallery.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            'Limit $limit',
            style: const TextStyle(
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

class _WarningChip extends StatelessWidget {
  const _WarningChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: YaruGallery.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.warning_amber_rounded, size: 13, color: YaruGallery.warning),
          SizedBox(width: 6),
          Text(
            'Over limit',
            style: TextStyle(
              fontFamily: YaruGallery.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: YaruGallery.warning,
            ),
          ),
        ],
      ),
    );
  }
}
