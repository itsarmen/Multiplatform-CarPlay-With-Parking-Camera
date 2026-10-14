import 'package:flutter/material.dart';

import '../yaru_gallery/tokens.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key, required this.sectionTitle, required this.item});

  final String sectionTitle;
  final String item;

  static const List<_Album> _albums = <_Album>[
    _Album('Midnight Drive', 'Synthwave', Icons.nightlight_outlined),
    _Album('Open Road', 'Indie', Icons.route_outlined),
    _Album('Coastal', 'Ambient', Icons.waves_outlined),
  ];

  static const List<_Track> _tracks = <_Track>[
    _Track('Neon Highway', 'The Headlights', '3:42'),
    _Track('Coastline', 'Marta Vega', '4:05'),
    _Track('Rearview', 'Slow Tide', '3:18'),
    _Track('Headlights', 'Nova Lane', '2:57'),
    _Track('Long Way Home', 'The Headlights', '4:31'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: YaruGallery.canvas,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
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
          const SizedBox(height: 2),
          Text(
            '$sectionTitle · featured for you',
            style: const TextStyle(
              fontFamily: YaruGallery.fontFamily,
              fontSize: 13,
              color: YaruGallery.textDisabled,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final album in _albums) _AlbumCard(album: album),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'Recently played',
            style: TextStyle(
              fontFamily: YaruGallery.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: YaruGallery.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          for (var i = 0; i < _tracks.length; i++)
            _TrackRow(index: i + 1, track: _tracks[i]),
        ],
      ),
    );
  }
}

class _Album {
  const _Album(this.title, this.subtitle, this.icon);
  final String title;
  final String subtitle;
  final IconData icon;
}

class _Track {
  const _Track(this.title, this.artist, this.duration);
  final String title;
  final String artist;
  final String duration;
}

class _AlbumCard extends StatelessWidget {
  const _AlbumCard({required this.album});
  final _Album album;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 104,
            decoration: BoxDecoration(
              color: YaruGallery.softAccentBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(album.icon, size: 34, color: YaruGallery.accent),
          ),
          const SizedBox(height: 8),
          Text(
            album.title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: YaruGallery.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: YaruGallery.textPrimary,
            ),
          ),
          Text(
            album.subtitle,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: YaruGallery.fontFamily,
              fontSize: 12,
              color: YaruGallery.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackRow extends StatelessWidget {
  const _TrackRow({required this.index, required this.track});
  final int index;
  final _Track track;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: YaruGallery.borderSubtle, width: 1),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 26,
            child: Text(
              '$index',
              style: const TextStyle(
                fontFamily: YaruGallery.fontFamily,
                fontSize: 13,
                color: YaruGallery.textDisabled,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  track.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: YaruGallery.fontFamily,
                    fontSize: 14,
                    color: YaruGallery.textPrimary,
                  ),
                ),
                Text(
                  track.artist,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: YaruGallery.fontFamily,
                    fontSize: 12,
                    color: YaruGallery.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            track.duration,
            style: const TextStyle(
              fontFamily: YaruGallery.fontFamily,
              fontSize: 13,
              color: YaruGallery.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.favorite_border,
            size: 16,
            color: YaruGallery.textDisabled,
          ),
        ],
      ),
    );
  }
}
