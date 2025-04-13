import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  secondary,
  tertiary,
  outline,
  text,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final bool isDisabled;
  final double height;
  final double borderRadius;
  final EdgeInsets padding;
  final TextStyle? textStyle;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.isDisabled = false,
    this.height = 50.0,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine button styling based on type
    Color backgroundColor, foregroundColor;
    BoxBorder? border;
    
    switch (type) {
      case ButtonType.primary:
        backgroundColor = theme.colorScheme.primary;
        foregroundColor = theme.colorScheme.onPrimary;
        border = null;
        break;
      case ButtonType.secondary:
        backgroundColor = theme.colorScheme.secondary;
        foregroundColor = theme.colorScheme.onSecondary;
        border = null;
        break;
      case ButtonType.tertiary:
        backgroundColor = theme.colorScheme.tertiary;
        foregroundColor = theme.colorScheme.onTertiary;
        border = null;
        break;
      case ButtonType.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = theme.colorScheme.primary;
        border = Border.all(color: theme.colorScheme.primary, width: 2);
        break;
      case ButtonType.text:
        backgroundColor = Colors.transparent;
        foregroundColor = theme.colorScheme.primary;
        border = null;
        break;
    }
    
    // Apply disabled styling if needed
    if (isDisabled) {
      backgroundColor = theme.disabledColor.withOpacity(0.1);
      foregroundColor = theme.disabledColor;
      border = null;
    }
    
    Widget buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
              ),
            ),
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(icon, color: foregroundColor, size: 20),
          ),
        Text(
          text,
          style: textStyle ?? TextStyle(
            color: foregroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
    
    return Container(
      width: isFullWidth ? double.infinity : null,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled || isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding,
            child: Center(child: buttonContent),
          ),
        ),
      ),
    );
  }
} 