import 'package:flutter/material.dart';

enum CardStyle {
  elevated,
  outlined,
  filled,
}

class ContentCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final CardStyle style;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets padding;
  final double borderRadius;
  final double elevation;
  final bool showShadow;
  final Widget? trailing;
  final double? width;
  final double? height;

  const ContentCard({
    Key? key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.style = CardStyle.elevated,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.onLongPress,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16,
    this.elevation = 2,
    this.showShadow = true,
    this.trailing,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Determine card colors based on style
    Color cardColor;
    BoxBorder? border;
    double cardElevation = showShadow ? elevation : 0;
    
    switch (style) {
      case CardStyle.elevated:
        cardColor = backgroundColor ?? theme.cardColor;
        border = null;
        break;
      case CardStyle.outlined:
        cardColor = backgroundColor ?? Colors.transparent;
        border = Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1.5,
        );
        cardElevation = 0;
        break;
      case CardStyle.filled:
        cardColor = backgroundColor ?? (isDarkMode ? Colors.grey[800]! : Colors.grey[100]!);
        border = null;
        cardElevation = 0;
        break;
    }
    
    // Build header if title is provided
    Widget? header;
    if (title != null) {
      header = Padding(
        padding: EdgeInsets.only(bottom: child != null ? 12 : 0),
        child: Row(
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  icon,
                  color: foregroundColor ?? theme.colorScheme.primary,
                  size: 24,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: foregroundColor ?? theme.textTheme.titleMedium?.color,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: foregroundColor != null
                              ? foregroundColor!.withOpacity(0.7)
                              : theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      );
    }
    
    // Build card content
    Widget cardContent = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) header,
          child,
        ],
      ),
    );
    
    // Apply tap functionality if needed
    if (onTap != null || onLongPress != null) {
      cardContent = InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(borderRadius),
        child: cardContent,
      );
    }
    
    // Build final card
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: showShadow && cardElevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: cardElevation * 2,
                  offset: Offset(0, cardElevation),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: cardContent,
      ),
    );
  }
} 