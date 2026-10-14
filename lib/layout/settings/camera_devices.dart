import 'package:camera/camera.dart';

class CameraDevice {
  const CameraDevice({
    required this.id,
    required this.name,
    this.model = '',
    this.resolution,
    this.frameRate,
    this.connected = true,
  });

  final String id;
  final String name;
  final String model;
  final String? resolution;
  final int? frameRate;
  final bool connected;

  String get summary {
    if (!connected) return 'Not connected';
    final parts = <String>[
      if (model.isNotEmpty) model,
      ?resolution,
      if (frameRate != null) '$frameRate fps',
    ];
    return parts.isEmpty ? 'Camera' : parts.join(' · ');
  }
}

/// Cameras enumerated from the operating system.
Future<List<CameraDevice>> detectCameras() async {
  final descriptions = await availableCameras();
  final seen = <String>{};
  final devices = <CameraDevice>[];
  for (final description in descriptions) {
    final name = _cleanName(description.name);
    if (name.isEmpty || !seen.add(name)) continue;
    devices.add(
      CameraDevice(
        id: description.name,
        name: name,
        model: _facingLabel(description.lensDirection),
      ),
    );
  }
  return devices;
}

/// `camera_windows` returns names like `Integrated Webcam <\\?\usb#...>`.
/// Keep just the human-readable part.
String _cleanName(String raw) {
  final marker = raw.indexOf(' <');
  final name = marker == -1 ? raw : raw.substring(0, marker);
  return name.trim();
}

String _facingLabel(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.front:
      return 'Front';
    case CameraLensDirection.back:
      return 'Rear';
    case CameraLensDirection.external:
      return 'External';
  }
}

/// Shown before detection completes or when no camera can be enumerated.
const List<CameraDevice> kFallbackCameras = <CameraDevice>[
  CameraDevice(
    id: 'cam-1',
    name: 'Mirror cam',
    model: 'OV2710',
    resolution: '1920 × 1080',
    frameRate: 30,
  ),
  CameraDevice(
    id: 'cam-2',
    name: 'Rear cam',
    model: 'IMX219',
    resolution: '1920 × 1080',
    frameRate: 30,
  ),
  CameraDevice(
    id: 'cam-3',
    name: 'Front cam',
    model: 'USB 2.0',
    resolution: '1280 × 720',
    frameRate: 30,
  ),
  CameraDevice(
    id: 'cam-4',
    name: 'Cabin cam',
    model: 'USB 2.0',
    resolution: '1280 × 720',
    frameRate: 15,
    connected: false,
  ),
];

CameraDevice? cameraById(List<CameraDevice> cameras, String id) {
  for (final device in cameras) {
    if (device.id == id) return device;
  }
  return null;
}
