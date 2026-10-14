import 'dart:async';

import 'package:flutter/material.dart';

import '../yaru_gallery/tokens.dart';

OverlayEntry? _current;

/// Shows a small floating toast inside the app instead of a full-width
/// Material banner. Auto-dismisses and replaces any toast already showing.
void showAppToast(
  BuildContext context,
  String message, {
  IconData icon = Icons.check_circle_outline,
  Duration duration = const Duration(seconds: 20),
}) {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;

  // Replace any in-flight toast so they never stack.
  _current?.remove();
  _current = null;

  late OverlayEntry entry;
  var removed = false;
  void remove() {
    if (removed) return;
    removed = true;
    entry.remove();
    if (_current == entry) _current = null;
  }

  entry = OverlayEntry(
    builder: (_) => _Toast(
      message: message,
      icon: icon,
      duration: duration,
      onDone: remove,
    ),
  );
  _current = entry;
  overlay.insert(entry);
}

class _Toast extends StatefulWidget {
  const _Toast({
    required this.message,
    required this.icon,
    required this.duration,
    required this.onDone,
  });

  final String message;
  final IconData icon;
  final Duration duration;
  final VoidCallback onDone;

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  )..forward();

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, _hide);
  }

  Future<void> _hide() async {
    _timer?.cancel();
    if (!mounted) return;
    await _controller.reverse();
    if (mounted) widget.onDone();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    return Positioned(
      left: 0,
      right: 0,
      bottom: 82,
      child: IgnorePointer(
        child: FadeTransition(
          opacity: _controller,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.25),
              end: Offset.zero,
            ).animate(curve),
            child: Center(
              child: GestureDetector(
                onTap: _hide,
                child: _pill(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pill() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: YaruGallery.canvas,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: YaruGallery.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: YaruGallery.softAccentBg,
              shape: BoxShape.circle,
            ),
            child: Icon(widget.icon, size: 15, color: YaruGallery.accent),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              widget.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: YaruGallery.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: YaruGallery.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
