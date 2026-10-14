import 'package:flutter/material.dart';

import '../settings/settings_store.dart';
import '../yaru_gallery/tokens.dart';
import 'app_data.dart';
import 'app_toast.dart';
import 'camera/camera_screen.dart';
import 'content_page.dart';
import 'dashboard/speedometer_dashboard.dart';
import 'map/map_screen.dart';
import 'music_player.dart';
import 'nav_rail.dart';
import 'secondary_sidebar.dart';
import 'settings/camera_devices.dart';
import 'settings/settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    this.store,
    this.initialSection = 'home',
    this.initialItem,
  });

  /// Persistent settings store, or null when storage is unavailable (tests).
  final SettingsStore? store;

  final String initialSection;
  final String? initialItem;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late String _section = _resolve(widget.initialSection);
  late String _item = _initialItem();

  List<CameraDevice> _cameras = kFallbackCameras;
  late String _mirrorCameraId = widget.store?.mirrorCameraId ?? '';
  late String _rearCameraId = widget.store?.rearCameraId ?? '';
  final Map<String, double> _zoom = <String, double>{};
  final Map<String, double> _distance = <String, double>{};
  final Map<String, double> _carWidth = <String, double>{};
  final Map<String, double> _lineAngle = <String, double>{};
  late bool _beeperEnabled = widget.store?.beeperEnabled ?? true;
  late bool _linesVisible = widget.store?.linesVisible ?? true;

  SettingsStore? get _store => widget.store;

  bool get _showSidebar =>
      _section != 'home' &&
      _section != 'right_mirror' &&
      _section != 'parking';

  @override
  void initState() {
    super.initState();
    final stored = _store?.cameras;
    if (stored != null) {
      for (final entry in stored.entries) {
        _zoom[entry.key] = entry.value.zoom;
        _distance[entry.key] = entry.value.distance;
        _carWidth[entry.key] = entry.value.carWidth;
      }
    }
    _syncAssignments();
    _loadCameras(showScanning: false);
  }

  String _resolve(String id) {
    final exists = kPrimarySections.any((s) => s.id == id) ||
        id == kSettingsSection.id;
    return exists ? id : kPrimarySections.first.id;
  }

  String _initialItem() {
    final requested = widget.initialItem;
    final items = kSidebarItems[_section]!;
    if (requested != null && items.contains(requested)) return requested;
    return items.first;
  }

  void _syncAssignments() {
    final ids = _cameras.map((c) => c.id).toList();
    if (_mirrorCameraId.isEmpty || !ids.contains(_mirrorCameraId)) {
      _mirrorCameraId = ids.isNotEmpty ? ids.first : '';
    }
    if (_rearCameraId.isEmpty || !ids.contains(_rearCameraId)) {
      _rearCameraId =
          ids.length > 1 ? ids[1] : (ids.isNotEmpty ? ids.first : '');
    }
    for (final camera in _cameras) {
      final config = _store?.configFor(camera.id);
      _zoom.putIfAbsent(camera.id, () => config?.zoom ?? 1.0);
      _distance.putIfAbsent(camera.id, () => config?.distance ?? 0.5);
      _carWidth.putIfAbsent(camera.id, () => config?.carWidth ?? 0.6);
      _lineAngle.putIfAbsent(camera.id, () => config?.lineAngle ?? 0.45);
    }
  }

  Future<void> _loadCameras({bool showScanning = true}) async {
    if (showScanning && mounted) {
      showAppToast(context, 'Scanning for cameras…', icon: Icons.refresh);
    }
    List<CameraDevice> result = _cameras;
    try {
      final found = await detectCameras();
      if (found.isNotEmpty) result = found;
    } catch (_) {
      // Detection unavailable (e.g. tests / no driver) — keep current list.
    }
    if (!mounted) return;
    setState(() {
      _cameras = result;
      _syncAssignments();
    });
    if (showScanning && mounted) {
      final count = result.where((c) => c.connected).length;
      showAppToast(
        context,
        count == 1 ? '1 camera detected' : '$count cameras detected',
        icon: Icons.videocam_outlined,
      );
    }
  }

  void _selectSection(String id) {
    setState(() {
      _section = id;
      _item = kSidebarItems[id]!.first;
    });
    _store?.setLastSection(id);
  }

  void _setMirrorCamera(String id) {
    setState(() {
      if (_rearCameraId == id) _rearCameraId = _mirrorCameraId;
      _mirrorCameraId = id;
    });
    _store?.setMirrorCamera(_mirrorCameraId);
    _store?.setRearCamera(_rearCameraId);
  }

  void _setRearCamera(String id) {
    setState(() {
      if (_mirrorCameraId == id) _mirrorCameraId = _rearCameraId;
      _rearCameraId = id;
    });
    _store?.setMirrorCamera(_mirrorCameraId);
    _store?.setRearCamera(_rearCameraId);
  }

  void _setBeeperEnabled(bool value) {
    setState(() => _beeperEnabled = value);
    _store?.setBeeperEnabled(value);
  }

  void _setLinesVisible(bool value) {
    setState(() => _linesVisible = value);
    _store?.setLinesVisible(value);
  }

  void _setZoom(String id, double value) {
    setState(() => _zoom[id] = value);
    _store?.setZoom(id, value);
  }

  void _setDistance(String id, double value) {
    setState(() => _distance[id] = value);
    _store?.setDistance(id, value);
  }

  void _setCarWidth(String id, double value) {
    setState(() => _carWidth[id] = value);
    _store?.setCarWidth(id, value);
  }

  void _setLineAngle(String id, double value) {
    setState(() => _lineAngle[id] = value);
    _store?.setLineAngle(id, value);
  }

  void _detectCameras() => _loadCameras();

  Widget _content(String sectionLabel) {
    switch (_section) {
      case 'home':
        return const SpeedometerDashboard();
      case 'map':
        return const MapScreen();
      case 'right_mirror':
        final mirror = cameraById(_cameras, _mirrorCameraId);
        return CameraScreen(
          kind: CameraKind.rightMirror,
          deviceId: mirror?.id,
          deviceName: mirror?.name,
          zoom: _zoom[_mirrorCameraId] ?? 1.0,
          referenceDistance: _distance[_mirrorCameraId] ?? 0.5,
          carWidth: _carWidth[_mirrorCameraId] ?? 0.6,
          lineAngle: _lineAngle[_mirrorCameraId] ?? 0.45,
          linesVisible: _linesVisible,
          beeperEnabled: _beeperEnabled,
          onZoomChanged: (v) => _setZoom(_mirrorCameraId, v),
          onDistanceChanged: (v) => _setDistance(_mirrorCameraId, v),
          onCarWidthChanged: (v) => _setCarWidth(_mirrorCameraId, v),
          onLineAngleChanged: (v) => _setLineAngle(_mirrorCameraId, v),
          onLinesChanged: _setLinesVisible,
          onBeeperChanged: _setBeeperEnabled,
          onOpenSettings: () => _selectSection('settings'),
        );
      case 'parking':
        final rear = cameraById(_cameras, _rearCameraId);
        return CameraScreen(
          kind: CameraKind.parking,
          deviceId: rear?.id,
          deviceName: rear?.name,
          zoom: _zoom[_rearCameraId] ?? 1.0,
          referenceDistance: _distance[_rearCameraId] ?? 0.5,
          carWidth: _carWidth[_rearCameraId] ?? 0.6,
          lineAngle: _lineAngle[_rearCameraId] ?? 0.45,
          linesVisible: _linesVisible,
          beeperEnabled: _beeperEnabled,
          onZoomChanged: (v) => _setZoom(_rearCameraId, v),
          onDistanceChanged: (v) => _setDistance(_rearCameraId, v),
          onCarWidthChanged: (v) => _setCarWidth(_rearCameraId, v),
          onLineAngleChanged: (v) => _setLineAngle(_rearCameraId, v),
          onLinesChanged: _setLinesVisible,
          onBeeperChanged: _setBeeperEnabled,
          onOpenSettings: () => _selectSection('settings'),
        );
      case 'settings':
        return SettingsScreen(
          item: _item,
          cameras: _cameras,
          mirrorCameraId: _mirrorCameraId,
          rearCameraId: _rearCameraId,
          onMirrorCamera: _setMirrorCamera,
          onRearCamera: _setRearCamera,
          onDetect: _detectCameras,
        );
      default:
        return ContentPage(sectionTitle: sectionLabel, item: _item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sectionLabel = railLabelFor(_section);
    final items = kSidebarItems[_section]!;

    return Scaffold(
      backgroundColor: YaruGallery.canvas,
      body: Row(
        children: [
          NavRail(selected: _section, onSelect: _selectSection),
          if (_showSidebar)
            SecondarySidebar(
              title: sectionLabel,
              items: items,
              selected: _item,
              onSelect: (value) => setState(() => _item = value),
            ),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _content(sectionLabel)),
                const MusicPlayer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
