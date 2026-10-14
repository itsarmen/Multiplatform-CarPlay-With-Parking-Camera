import 'package:flutter/material.dart';

import '../../yaru_gallery/tokens.dart';
import '../dashboard/dashboard_card.dart';
import 'camera_devices.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.item,
    required this.cameras,
    required this.mirrorCameraId,
    required this.rearCameraId,
    required this.onMirrorCamera,
    required this.onRearCamera,
    required this.onDetect,
  });

  final String item;
  final List<CameraDevice> cameras;
  final String mirrorCameraId;
  final String rearCameraId;
  final ValueChanged<String> onMirrorCamera;
  final ValueChanged<String> onRearCamera;
  final VoidCallback onDetect;

  @override
  Widget build(BuildContext context) {
    if (item != 'Cameras') {
      return _placeholder(item);
    }
    return Container(
      color: YaruGallery.pageBackground,
      child: Scrollbar(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Cameras',
              style: TextStyle(
                fontFamily: YaruGallery.fontFamily,
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: YaruGallery.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Detect devices and assign the right-mirror and rear/parking cameras',
              style: TextStyle(
                fontFamily: YaruGallery.fontFamily,
                fontSize: 13,
                color: YaruGallery.textDisabled,
              ),
            ),
            const SizedBox(height: 16),
            _detectionCard(),
            const SizedBox(height: 16),
            _assignmentsCard(),
            const SizedBox(height: 16),
            _hintCard(),
          ],
        ),
      ),
    );
  }

  Widget _detectionCard() {
    final connected = cameras.where((c) => c.connected).length;
    return Container(
      decoration: dashboardCardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.videocam_outlined,
              size: 22, color: YaruGallery.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Camera detection',
                  style: TextStyle(
                    fontFamily: YaruGallery.fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: YaruGallery.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$connected of ${cameras.length} cameras connected',
                  style: const TextStyle(
                    fontFamily: YaruGallery.fontFamily,
                    fontSize: 12,
                    color: YaruGallery.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: onDetect,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Detect cameras'),
            style: FilledButton.styleFrom(
              backgroundColor: YaruGallery.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontFamily: YaruGallery.fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _assignmentsCard() {
    return Container(
      decoration: dashboardCardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Assignments',
            style: TextStyle(
              fontFamily: YaruGallery.fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: YaruGallery.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _DropdownRow(
            label: 'Right mirror camera',
            devices: cameras,
            value: mirrorCameraId,
            onChanged: onMirrorCamera,
          ),
          const SizedBox(height: 12),
          _DropdownRow(
            label: 'Rear / parking camera',
            devices: cameras,
            value: rearCameraId,
            onChanged: onRearCamera,
          ),
        ],
      ),
    );
  }

  Widget _hintCard() {
    return Container(
      decoration: dashboardCardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.tune, size: 20, color: YaruGallery.textSecondary),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Zoom and guideline calibration are tuned live on each camera '
              'screen (Right mirror / Parking).',
              style: TextStyle(
                fontFamily: YaruGallery.fontFamily,
                fontSize: 12,
                color: YaruGallery.textSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(String item) {
    return Container(
      color: YaruGallery.pageBackground,
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: dashboardCardDecoration(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item,
              style: const TextStyle(
                fontFamily: YaruGallery.fontFamily,
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: YaruGallery.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Settings for "$item" will appear here.',
              style: const TextStyle(
                fontFamily: YaruGallery.fontFamily,
                fontSize: 13,
                color: YaruGallery.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownRow extends StatelessWidget {
  const _DropdownRow({
    required this.label,
    required this.devices,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final List<CameraDevice> devices;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: YaruGallery.fontFamily,
              fontSize: 13,
              color: YaruGallery.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 240,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: YaruGallery.sidebar,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: YaruGallery.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              borderRadius: BorderRadius.circular(10),
              icon: const Icon(Icons.expand_more,
                  size: 18, color: YaruGallery.textSecondary),
              style: const TextStyle(
                fontFamily: YaruGallery.fontFamily,
                fontSize: 13,
                color: YaruGallery.textPrimary,
              ),
              dropdownColor: YaruGallery.canvas,
              items: [
                for (final device in devices)
                  if (device.connected)
                    DropdownMenuItem<String>(
                      value: device.id,
                      child: Text(
                        device.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
              ],
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}
