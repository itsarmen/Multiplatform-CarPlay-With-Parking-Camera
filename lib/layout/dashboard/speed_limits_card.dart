import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../yaru_gallery/tokens.dart';
import 'dashboard_card.dart';

class SpeedPreset {
  const SpeedPreset(this.value, this.label);
  final int value;
  final String label;
}

class SpeedLimitsCard extends StatefulWidget {
  const SpeedLimitsCard({
    super.key,
    required this.presets,
    required this.activeValue,
    required this.onSelect,
    required this.onAdd,
  });

  final List<SpeedPreset> presets;
  final int activeValue;
  final ValueChanged<int> onSelect;
  final ValueChanged<int> onAdd;

  @override
  State<SpeedLimitsCard> createState() => _SpeedLimitsCardState();
}

class _SpeedLimitsCardState extends State<SpeedLimitsCard> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = int.tryParse(_controller.text.trim());
    if (value != null && value > 0) {
      widget.onAdd(value);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: dashboardCardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Speed Limits',
            style: TextStyle(
              fontFamily: YaruGallery.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: YaruGallery.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Configure speed thresholds',
            style: TextStyle(
              fontFamily: YaruGallery.fontFamily,
              fontSize: 13,
              color: YaruGallery.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.presets.length,
              itemBuilder: (context, index) {
                final preset = widget.presets[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _PresetRow(
                    preset: preset,
                    selected: preset.value == widget.activeValue,
                    onTap: () => widget.onSelect(preset.value),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 17, color: YaruGallery.borderSubtle),
          Row(
            children: [
              SizedBox(
                width: 58,
                height: 34,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onSubmitted: (_) => _submit(),
                  style: const TextStyle(
                    fontFamily: YaruGallery.fontFamily,
                    fontSize: 14,
                    color: YaruGallery.textPrimary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: '80',
                    hintStyle: const TextStyle(
                      fontFamily: YaruGallery.fontFamily,
                      fontSize: 14,
                      color: YaruGallery.textDisabled,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: YaruGallery.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: YaruGallery.accent),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'km/h',
                style: TextStyle(
                  fontFamily: YaruGallery.fontFamily,
                  fontSize: 12,
                  color: YaruGallery.textSecondary,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 34,
                child: FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: YaruGallery.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: YaruGallery.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PresetRow extends StatelessWidget {
  const _PresetRow({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final SpeedPreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? YaruGallery.softAccentBg : YaruGallery.canvas,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? YaruGallery.accent : YaruGallery.borderSubtle,
            ),
          ),
          child: Row(
            children: [
              Text(
                '${preset.value}',
                style: TextStyle(
                  fontFamily: YaruGallery.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: selected ? YaruGallery.accent : YaruGallery.textPrimary,
                ),
              ),
              const SizedBox(width: 2),
              const Text(
                'km/h',
                style: TextStyle(
                  fontFamily: YaruGallery.fontFamily,
                  fontSize: 10,
                  color: YaruGallery.textSecondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  preset.label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: YaruGallery.fontFamily,
                    fontSize: 12,
                    color: YaruGallery.textSecondary,
                  ),
                ),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.edit_outlined,
                size: 16,
                color: selected ? YaruGallery.accent : YaruGallery.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
