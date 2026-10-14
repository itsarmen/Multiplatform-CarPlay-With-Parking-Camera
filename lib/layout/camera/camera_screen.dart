import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../yaru_gallery/tokens.dart';
import '../dashboard/dashboard_card.dart';

enum CameraKind { rightMirror, parking }

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
    required this.kind,
    this.deviceId,
    this.deviceName,
    this.zoom = 1.0,
    this.referenceDistance = 0.5,
    this.carWidth = 0.6,
    this.lineAngle = 0.45,
    this.linesVisible = true,
    this.beeperEnabled = true,
    this.onZoomChanged,
    this.onDistanceChanged,
    this.onCarWidthChanged,
    this.onLineAngleChanged,
    this.onLinesChanged,
    this.onBeeperChanged,
    this.onOpenSettings,
  });

  final CameraKind kind;
  final String? deviceId;
  final String? deviceName;
  final double zoom;
  final double referenceDistance;
  final double carWidth;
  final double lineAngle;
  final bool linesVisible;
  final bool beeperEnabled;
  final ValueChanged<double>? onZoomChanged;
  final ValueChanged<double>? onDistanceChanged;
  final ValueChanged<double>? onCarWidthChanged;
  final ValueChanged<double>? onLineAngleChanged;
  final ValueChanged<bool>? onLinesChanged;
  final ValueChanged<bool>? onBeeperChanged;
  final VoidCallback? onOpenSettings;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  static const Color _amber = Color(0xFFF0A500);
  static const Color _stageColor = Color(0xFF1E1E1E);

  CameraController? _controller;
  bool _initializing = false;
  String? _error;
  bool _showSliders = false;
  Size? _resolution;

  bool get _isMirror => widget.kind == CameraKind.rightMirror;

  String get _title => _isMirror ? 'Right mirror camera' : 'Parking camera';

  String? get _resolutionLabel {
    final resolution = _resolution;
    if (resolution == null) return null;
    final width = resolution.width.round();
    final height = resolution.height.round();
    if (width <= 0 || height <= 0) return null;
    return '$width × $height';
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void didUpdateWidget(CameraScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.kind != widget.kind) {
      _showSliders = false;
    }
    if (oldWidget.deviceId != widget.deviceId) {
      _initCamera();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    _controller?.dispose();
    _controller = null;
    _resolution = null;
    final id = widget.deviceId;
    if (id == null || id.isEmpty) {
      setState(() {
        _initializing = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _initializing = true;
      _error = null;
    });

    try {
      final cameras = await availableCameras();
      CameraDescription? description;
      for (final camera in cameras) {
        if (camera.name == id) {
          description = camera;
          break;
        }
      }
      if (description == null) {
        throw StateError('Camera not found');
      }
      final controller = CameraController(
        description,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _resolution = controller.value.previewSize;
        _initializing = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _initializing = false;
        _error = 'Preview unavailable';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: YaruGallery.pageBackground,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 62, child: _stage()),
          const SizedBox(width: 16),
          Expanded(flex: 38, child: _controls()),
        ],
      ),
    );
  }

  Widget _stage() {
    return Container(
      decoration: dashboardCardDecoration(),
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: ColoredBox(
          color: _stageColor,
          child: Stack(
            children: [
              Positioned.fill(child: _feed()),
              Positioned.fill(
                child: CustomPaint(
                  painter: _OverlayPainter(
                    mirror: _isMirror,
                    guidelines: widget.linesVisible,
                    amber: _amber,
                    zoom: widget.zoom,
                    carWidth: widget.carWidth,
                    lineAngle: widget.lineAngle,
                  ),
                ),
              ),
              const Positioned(
                top: 10,
                right: 10,
                child: _LiveChip(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feed() {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      final preview = controller.value.previewSize;
      final width = preview?.width ?? 1280;
      final height = preview?.height ?? 720;
      return ClipRect(
        child: Transform.scale(
          scale: widget.zoom,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: width,
              height: height,
              child: CameraPreview(controller),
            ),
          ),
        ),
      );
    }
    return Center(child: _feedPlaceholder());
  }

  Widget _feedPlaceholder() {
    final String label;
    final IconData icon;
    if (_initializing) {
      return const SizedBox(
        width: 26,
        height: 26,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF8B949E)),
      );
    } else if (widget.deviceId == null || widget.deviceId!.isEmpty) {
      icon = Icons.videocam_off_outlined;
      label = 'No camera assigned';
    } else if (_error != null) {
      icon = Icons.error_outline;
      label = _error!;
    } else {
      icon = Icons.videocam_off_outlined;
      label = 'Camera feed';
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 30, color: const Color(0xFF6E7681)),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: YaruGallery.fontFamily,
            fontSize: 12,
            color: Color(0xFF8B949E),
          ),
        ),
      ],
    );
  }

  Widget _controls() {
    return Container(
      decoration: dashboardCardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title,
                      style: const TextStyle(
                        fontFamily: YaruGallery.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: YaruGallery.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.deviceName ??
                          (_isMirror ? 'Right mirror cam' : 'Rear cam'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: YaruGallery.fontFamily,
                        fontSize: 12,
                        color: YaruGallery.textSecondary,
                      ),
                    ),
                    if (_resolutionLabel != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        '${_resolutionLabel!} px',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: YaruGallery.fontFamily,
                          fontSize: 11,
                          color: YaruGallery.textDisabled,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: 'Camera settings',
                child: Material(
                  color: _showSliders
                      ? YaruGallery.softAccentBg
                      : YaruGallery.surfaceSubtle,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => setState(() => _showSliders = !_showSliders),
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Icon(
                        _showSliders ? Icons.tune : Icons.settings_outlined,
                        size: 18,
                        color: _showSliders
                            ? YaruGallery.accent
                            : YaruGallery.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: YaruGallery.borderSubtle),
          const SizedBox(height: 2),
          if (_showSliders)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    _SliderRow(
                      label: 'Zoom',
                      caption: 'Digital zoom applied to the live feed',
                      valueText: '${widget.zoom.toStringAsFixed(1)} ×',
                      value: widget.zoom,
                      min: 0.5,
                      max: 3.0,
                      divisions: 25,
                      onChanged: (v) => widget.onZoomChanged?.call(v),
                    ),
                    const SizedBox(height: 2),
                    _SliderRow(
                      label: 'Car width (line spacing)',
                      caption: 'Lines reach the view corners at 100%',
                      valueText: '${(widget.carWidth * 100).round()}%',
                      value: (widget.carWidth * 100).clamp(0, 100).toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 10,
                      onChanged: (v) => widget.onCarWidthChanged?.call(v / 100),
                    ),
                    const SizedBox(height: 2),
                    _SliderRow(
                      label: 'Line angle',
                      caption: '0% lines meet at top · 100% parallel',
                      valueText: '${(widget.lineAngle * 100).round()}%',
                      value: (widget.lineAngle * 100).clamp(0, 100).toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 20,
                      onChanged: (v) =>
                          widget.onLineAngleChanged?.call(v / 100),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            _ToggleRow(
              label: 'Beeper sound',
              value: widget.beeperEnabled,
              onChanged: widget.onBeeperChanged,
            ),
            _ToggleRow(
              label: 'Show lines',
              value: widget.linesVisible,
              onChanged: widget.onLinesChanged,
            ),
            const Spacer(),
          ],
        ],
      ),
    );
  }
}

class _LiveChip extends StatelessWidget {
  const _LiveChip();

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
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: YaruGallery.warning,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'LIVE',
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

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: YaruGallery.fontFamily,
                fontSize: 12,
                color: YaruGallery.textPrimary,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.78,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: YaruGallery.accent,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.caption,
    required this.valueText,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String label;
  final String caption;
  final String valueText;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: YaruGallery.fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: YaruGallery.textPrimary,
                    ),
                  ),
                  Text(
                    caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: YaruGallery.fontFamily,
                      fontSize: 10,
                      color: YaruGallery.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              valueText,
              style: const TextStyle(
                fontFamily: YaruGallery.fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: YaruGallery.accent,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 26,
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              activeTrackColor: YaruGallery.accent,
              inactiveTrackColor: YaruGallery.surfaceMuted,
              thumbColor: YaruGallery.accent,
              overlayColor: YaruGallery.accent.withValues(alpha: 0.12),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _OverlayPainter extends CustomPainter {
  _OverlayPainter({
    required this.mirror,
    required this.guidelines,
    required this.amber,
    required this.zoom,
    required this.carWidth,
    required this.lineAngle,
  });

  final bool mirror;
  final bool guidelines;
  final Color amber;
  final double zoom;
  final double carWidth;
  final double lineAngle;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    final center = Offset(size.width / 2, size.height / 2);
    canvas.translate(center.dx, center.dy);
    canvas.scale(zoom);
    canvas.translate(-center.dx, -center.dy);

    if (mirror) {
      _paintMirror(canvas, size);
    } else {
      _paintParking(canvas, size);
    }
    canvas.restore();
  }

  void _paintMirror(Canvas canvas, Size size) {
    final bandWidth = size.width * 0.22;
    canvas.drawRect(
      Rect.fromLTWH(size.width - bandWidth, 0, bandWidth, size.height),
      Paint()..color = YaruGallery.accent.withValues(alpha: 0.16),
    );

    if (guidelines) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = YaruGallery.accent.withValues(alpha: 0.9);
      final path = Path()
        ..moveTo(size.width - bandWidth, size.height * 0.25)
        ..lineTo(size.width - bandWidth, size.height * 0.75);
      canvas.drawPath(path, paint);

      final chevron = Paint()..color = YaruGallery.accent;
      final cx = size.width - bandWidth * 0.5;
      for (var i = 0; i < 3; i++) {
        final x = cx + i * 14 - 14;
        final y = size.height / 2;
        final path2 = Path()
          ..moveTo(x, y - 10)
          ..lineTo(x + 8, y)
          ..lineTo(x, y + 10);
        canvas.drawPath(
          path2,
          chevron
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  void _paintParking(Canvas canvas, Size size) {
    if (guidelines) {
      // Car width is a fraction of the view width; 1.0 spans the corners.
      final bottomGap = carWidth.clamp(0.0, 1.0);
      final topGap = bottomGap * lineAngle.clamp(0.0, 1.0);
      const topY = 0.42;
      final centerX = size.width / 2;

      final linePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFFFFC107);
      final left = Path()
        ..moveTo(centerX - bottomGap / 2 * size.width, size.height)
        ..lineTo(centerX - topGap / 2 * size.width, size.height * topY);
      final right = Path()
        ..moveTo(centerX + bottomGap / 2 * size.width, size.height)
        ..lineTo(centerX + topGap / 2 * size.width, size.height * topY);
      canvas.drawPath(left, linePaint);
      canvas.drawPath(right, linePaint);
    }
  }

  @override
  bool shouldRepaint(_OverlayPainter oldDelegate) {
    return oldDelegate.mirror != mirror ||
        oldDelegate.guidelines != guidelines ||
        oldDelegate.zoom != zoom ||
        oldDelegate.carWidth != carWidth ||
        oldDelegate.lineAngle != lineAngle;
  }
}
