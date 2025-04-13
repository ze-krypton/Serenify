import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccessibilityUtils {
  static const double minContrastRatio = 4.5;

  static bool isContrastRatioSufficient(Color foreground, Color background) {
    final double luminance1 = _getRelativeLuminance(foreground);
    final double luminance2 = _getRelativeLuminance(background);
    final double lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final double darker = luminance1 > luminance2 ? luminance2 : luminance1;
    return (lighter + 0.05) / (darker + 0.05) >= minContrastRatio;
  }

  static double _getRelativeLuminance(Color color) {
    final double r = color.red / 255.0;
    final double g = color.green / 255.0;
    final double b = color.blue / 255.0;

    final double rS = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4);
    final double gS = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4);
    final double bS = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4);

    return 0.2126 * rS + 0.7152 * gS + 0.0722 * bS;
  }

  static void announceForAccessibility(BuildContext context, String message) {
    SemanticsService.announce(message, Directionality.of(context));
  }

  static void setFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }

  static Widget buildSemanticLabel(Widget child, String label) {
    return Semantics(
      label: label,
      child: child,
    );
  }

  static Widget buildAccessibleButton({
    required VoidCallback onPressed,
    required Widget child,
    required String label,
  }) {
    return Semantics(
      button: true,
      label: label,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }

  static Widget buildAccessibleTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Semantics(
      textField: true,
      label: label,
      hint: hint,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }
} 