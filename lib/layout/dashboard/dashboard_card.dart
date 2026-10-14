import 'package:flutter/material.dart';

import '../../yaru_gallery/tokens.dart';

BoxDecoration dashboardCardDecoration() {
  return BoxDecoration(
    color: YaruGallery.canvas,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: YaruGallery.borderSubtle),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 14,
        offset: const Offset(0, 3),
      ),
    ],
  );
}
