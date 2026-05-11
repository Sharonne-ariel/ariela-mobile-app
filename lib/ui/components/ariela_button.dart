import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';

/// Button variants supported by [ArielaButton].
enum ArielaButtonVariant {
  /// Primary action — lavender background, white text.
  primary,

  /// Secondary action — outlined, lavender text.
  secondary,

  /// Text-only action — no background, no border, lavender text.
  text,
}

/// ARIELA's standard button.
///
/// Used for all interactive primary, secondary, and text actions throughout
/// the app. Always prefer this over a raw [ElevatedButton] or [TextButton]
/// to keep visuals consistent with the brand.
class ArielaButton extends StatelessWidget {
  const ArielaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ArielaButtonVariant.primary,
    this.icon,
    this.fullWidth = true,
  });

  /// The text shown inside the button.
  final String label;

  /// Called when the user taps the button. Pass `null` to disable.
  final VoidCallback? onPressed;

  /// Visual style of the button.
  final ArielaButtonVariant variant;

  /// Optional trailing icon (e.g., arrow for "Get started").
  final IconData? icon;

  /// Whether the button stretches to fill its parent's width.
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == ArielaButtonVariant.primary;
    final isSecondary = variant == ArielaButtonVariant.secondary;

    final foreground = isPrimary ? Colors.white : ArielaTheme.lavender600;
    final background = isPrimary ? ArielaTheme.lavender600 : Colors.transparent;
    final border = isSecondary
        ? const BorderSide(color: ArielaTheme.lavender600, width: 1.5)
        : BorderSide.none;

    final button = TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        disabledForegroundColor: ArielaTheme.textMuted,
        disabledBackgroundColor: ArielaTheme.surfaceMuted,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: border,
        ),
        textStyle: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.16,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (icon != null) ...[
            const SizedBox(width: 8),
            Icon(icon, size: 18),
          ],
        ],
      ),
    );

    if (!fullWidth) return button;

    return SizedBox(width: double.infinity, child: button);
  }
}