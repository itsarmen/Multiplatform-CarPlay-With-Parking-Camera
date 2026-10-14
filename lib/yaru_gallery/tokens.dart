import 'package:flutter/material.dart';

/// Approximate design tokens inferred from the Yaru Widgets reference.
class YaruGallery {
  YaruGallery._();

  // Colors
  static const Color canvas = Color(0xFFFFFFFF);
  static const Color sidebar = Color(0xFFF7F7F7);
  static const Color surfaceSubtle = Color(0xFFEAEAEA);
  static const Color surfaceMuted = Color(0xFFE7E7E7);
  static const Color textPrimary = Color(0xFF303030);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textDisabled = Color(0xFFA6A6A6);
  static const Color border = Color(0xFFD6D6D6);
  static const Color borderSubtle = Color(0xFFEEEEEE);
  static const Color accent = Color(0xFFE95420);
  static const Color successExample = Color(0xFF078A1D);
  static const Color softAccentBg = Color(0xFFF7E8E4);
  static const Color windowControlBg = Color(0xFFE9E9E9);
  static const Color railBackground = Color(0xFFEDEDED);
  static const Color pageBackground = Color(0xFFF5F5F5);
  static const Color warning = Color(0xFFD32F2F);

  // Radii
  static const double radiusWindow = 17;
  static const double radiusNavItem = 11;
  static const double radiusControl = 10;

  // Layout heights
  static const double titleBarHeight = 70;
  static const double toolbarHeight = 66;
  static const double tabsHeight = 72;
  static const double footerHeight = 95;
  static const double sidebarFraction = 0.34;

  // Typography
  static const String fontFamily = 'Ubuntu';

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  static const TextStyle navLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  static const TextStyle navHeader = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  static const TextStyle toolbarLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  static const TextStyle tabLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle tabLabelActive = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  static const TextStyle sample = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  static const TextStyle footerLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );
}
