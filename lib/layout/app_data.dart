import 'package:flutter/material.dart';

class RailSection {
  const RailSection(this.id, this.label, this.icon);
  final String id;
  final String label;
  final IconData icon;
}

const List<RailSection> kPrimarySections = <RailSection>[
  RailSection('home', 'Home', Icons.home_outlined),
  RailSection('map', 'Map', Icons.map_outlined),
  RailSection('right_mirror', 'Right mirror', Icons.videocam_outlined),
  RailSection('parking', 'Parking', Icons.local_parking_outlined),
  RailSection('radio', 'Radio', Icons.radio_outlined),
  RailSection('playlists', 'Playlists', Icons.queue_music_outlined),
];

const RailSection kSettingsSection =
    RailSection('settings', 'Settings', Icons.settings_outlined);

/// Contextual items shown in the secondary sidebar for each rail section.
const Map<String, List<String>> kSidebarItems = <String, List<String>>{
  'home': ['Speedometer', 'Trips', 'History', 'Favorites'],
  'map': ['Overview', 'Route', 'Traffic', 'Saved places'],
  'right_mirror': ['Live view', 'Blind spot', 'Snapshots', 'Settings'],
  'parking': ['Rear view', 'Front view', 'Sensors', 'Guidelines'],
  'radio': ['Stations', 'Genres', 'Podcasts', 'Local radio'],
  'playlists': ['Morning Drive', 'Road Trip', 'Focus', 'Chill', 'Workout'],
  'settings': ['Cameras', 'Appearance', 'Playback', 'Account', 'About'],
};

String railLabelFor(String id) {
  if (id == kSettingsSection.id) return kSettingsSection.label;
  return kPrimarySections.firstWhere((s) => s.id == id).label;
}
