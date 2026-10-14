import 'package:flutter/material.dart';

import '../yaru_gallery/tokens.dart';

class SecondarySidebar extends StatelessWidget {
  const SecondarySidebar({
    super.key,
    required this.title,
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  final String title;
  final List<String> items;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: YaruGallery.sidebar,
        border: Border(
          right: BorderSide(color: YaruGallery.border, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: YaruGallery.fontFamily,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: YaruGallery.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == selected;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Material(
                    color: isSelected
                        ? YaruGallery.surfaceSubtle
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    child: InkWell(
                      onTap: () => onSelect(item),
                      borderRadius: BorderRadius.circular(9),
                      child: SizedBox(
                        height: 38,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: YaruGallery.fontFamily,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: isSelected
                                    ? YaruGallery.textPrimary
                                    : YaruGallery.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
