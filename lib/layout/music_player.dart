import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../yaru_gallery/tokens.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool _playing = true;
  double _progress = 0.38;
  double _volume = 0.7;
  double _lastVolume = 0.7;

  static const String _elapsed = '1:24';
  static const String _remaining = '-2:18';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(color: YaruGallery.sidebar),
      child: Column(
        children: [
          _ProgressBar(
            value: _progress,
            onChanged: (v) => setState(() => _progress = v),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const _TrackInfo(),
                  const SizedBox(width: 10),
                  Expanded(child: _controls()),
                  const SizedBox(width: 10),
                  _volumeControls(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _controls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _time(_elapsed),
        const SizedBox(width: 10),
        _IconButton(icon: Icons.skip_previous, size: 26, onTap: () {}),
        const SizedBox(width: 6),
        _PlayButton(playing: _playing, onTap: _togglePlay),
        const SizedBox(width: 6),
        _IconButton(icon: Icons.skip_next, size: 26, onTap: () {}),
        const SizedBox(width: 10),
        _time(_remaining),
      ],
    );
  }

  Widget _volumeControls() {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          setState(() {
            _volume = (_volume - event.scrollDelta.dy / 500).clamp(0.0, 1.0);
          });
        }
      },
      child: Row(
        children: [
          InkWell(
            onTap: _toggleMute,
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                _volume == 0
                    ? Icons.volume_off_outlined
                    : Icons.volume_up_outlined,
                size: 20,
                color: YaruGallery.textSecondary,
              ),
            ),
          ),
          SizedBox(
          width: 100,
          child: SliderTheme(
              data: _sliderTheme(thumbRadius: 7.5),
              child: Slider(
                value: _volume,
                onChanged: (v) => setState(() => _volume = v),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _togglePlay() => setState(() => _playing = !_playing);

  void _toggleMute() {
    setState(() {
      if (_volume == 0) {
        _volume = _lastVolume;
      } else {
        _lastVolume = _volume;
        _volume = 0;
      }
    });
  }

  Widget _time(String value) {
    return Text(
      value,
      style: const TextStyle(
        fontFamily: YaruGallery.fontFamily,
        fontSize: 10,
        color: YaruGallery.textSecondary,
      ),
    );
  }

  SliderThemeData _sliderTheme({double thumbRadius = 4.5}) {
    return SliderThemeData(
      trackHeight: 3,
      activeTrackColor: YaruGallery.accent,
      inactiveTrackColor: YaruGallery.surfaceMuted,
      thumbColor: YaruGallery.accent,
      overlayColor: YaruGallery.accent.withValues(alpha: 0.12),
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: thumbRadius),
      overlayShape: RoundSliderOverlayShape(overlayRadius: thumbRadius + 7),
    );
  }
}

/// Playback progress rendered as the player's top border.
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        void seek(Offset position) {
          onChanged((position.dx / constraints.maxWidth).clamp(0.0, 1.0));
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) => seek(details.localPosition),
          onHorizontalDragUpdate: (details) => seek(details.localPosition),
          child: SizedBox(
            height: 4,
            width: double.infinity,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: ColoredBox(color: YaruGallery.surfaceMuted),
                ),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: const ColoredBox(color: YaruGallery.accent),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TrackInfo extends StatelessWidget {
  const _TrackInfo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: YaruGallery.softAccentBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.music_note,
            size: 18,
            color: YaruGallery.accent,
          ),
        ),
        const SizedBox(width: 9),
        SizedBox(
          width: 112,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Neon Highway',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: YaruGallery.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: YaruGallery.textPrimary,
                ),
              ),
              Text(
                'The Headlights',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: YaruGallery.fontFamily,
                  fontSize: 10,
                  color: YaruGallery.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.playing, required this.onTap});
  final bool playing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: YaruGallery.accent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            playing ? Icons.pause : Icons.play_arrow,
            size: 26,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.size, required this.onTap});
  final IconData icon;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Icon(icon, size: size, color: YaruGallery.textPrimary),
      ),
    );
  }
}
