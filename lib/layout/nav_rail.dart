import 'package:flutter/material.dart';

import '../yaru_gallery/tokens.dart';
import 'app_data.dart';

class NavRail extends StatelessWidget {
  const NavRail({super.key, required this.selected, required this.onSelect});

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      decoration: const BoxDecoration(
        color: YaruGallery.railBackground,
        border: Border(
          right: BorderSide(color: YaruGallery.border, width: 1),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          const _RailAvatar(),
          const SizedBox(height: 8),
          for (final section in kPrimarySections)
            RailButton(
              section: section,
              selected: section.id == selected,
              onTap: () => onSelect(section.id),
            ),
          const Spacer(),
          RailButton(
            section: kSettingsSection,
            selected: kSettingsSection.id == selected,
            onTap: () => onSelect(kSettingsSection.id),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _RailAvatar extends StatelessWidget {
  const _RailAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: YaruGallery.accent,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.music_note, size: 18, color: Colors.white),
    );
  }
}

class RailButton extends StatelessWidget {
  const RailButton({
    super.key,
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final RailSection section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: section.label,
      waitDuration: const Duration(milliseconds: 400),
      child: SizedBox(
        width: 64,
        height: 44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (selected)
              Positioned(
                left: 0,
                top: 8,
                bottom: 8,
                child: Container(
                  width: 3,
                  decoration: const BoxDecoration(
                    color: YaruGallery.accent,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(2),
                    ),
                  ),
                ),
              ),
            Material(
              color: selected ? YaruGallery.surfaceSubtle : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 40,
                  height: 34,
                  child: Icon(
                    section.icon,
                    size: 21,
                    color: selected
                        ? YaruGallery.accent
                        : YaruGallery.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
