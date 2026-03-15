import 'package:flutter/material.dart';

/// Defines a single segment item used by [AnxSegmentedButton].
class SegmentButtonItem<T> {
  const SegmentButtonItem({
    required this.value,
    required this.label,
    this.icon,
    this.labelStyle,
    this.maxLines,
    this.overflow,
  });

  final T value;
  final String label;
  final Widget? icon;
  final TextStyle? labelStyle;
  final int? maxLines;
  final TextOverflow? overflow;
}

/// A custom segmented button with cleaner, minimal styling.
/// Replaces Material 3 SegmentedButton with a simpler implementation.
class AnxSegmentedButton<T> extends StatelessWidget {
  const AnxSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    this.onSelectionChanged,
    this.multiSelectionEnabled = false,
    this.emptySelectionAllowed = false,
    this.showSelectedIcon = true,
    this.enabled = true,
    this.style,
  });

  final List<SegmentButtonItem<T>> segments;
  final Set<T> selected;
  final ValueChanged<Set<T>>? onSelectionChanged;
  final bool multiSelectionEnabled;
  final bool emptySelectionAllowed;
  final bool showSelectedIcon;
  final ButtonStyle? style;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _buildSegments(context, colorScheme),
        ),
      ),
    );
  }

  List<Widget> _buildSegments(BuildContext context, ColorScheme colorScheme) {
    return List.generate(segments.length, (index) {
      final segment = segments[index];
      final isSelected = selected.contains(segment.value);

      return Expanded(
        child: InkWell(
          onTap: enabled ? () => _handleTap(segment.value) : null,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.primary : null,
              border: index > 0
                  ? Border(left: BorderSide(color: colorScheme.outline))
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSelected && showSelectedIcon) ...[
                  Icon(
                    Icons.check,
                    size: 16,
                    color: colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 4),
                ] else if (segment.icon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      size: 18,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                    child: segment.icon!,
                  ),
                  const SizedBox(width: 4),
                ],
                Flexible(
                  child: Text(
                    segment.label,
                    textAlign: TextAlign.center,
                    softWrap: false,
                    style: (segment.labelStyle ?? const TextStyle()).copyWith(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                    maxLines: segment.maxLines ?? 1,
                    overflow: segment.overflow ?? TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _handleTap(T value) {
    final newSelection = Set<T>.from(selected);
    if (multiSelectionEnabled) {
      if (newSelection.contains(value)) {
        if (emptySelectionAllowed || newSelection.length > 1) {
          newSelection.remove(value);
        }
      } else {
        newSelection.add(value);
      }
    } else {
      newSelection.clear();
      newSelection.add(value);
    }
    onSelectionChanged?.call(newSelection);
  }
}