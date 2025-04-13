import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum LoadingSize {
  small,
  medium,
  large,
}

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final LoadingSize size;
  final Color? color;
  final bool overlay;
  final double? value;

  const LoadingIndicator({
    Key? key,
    this.message,
    this.size = LoadingSize.medium,
    this.color,
    this.overlay = false,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loadingColor = color ?? theme.colorScheme.primary;
    
    // Determine size
    double spinnerSize;
    double textSize;
    
    switch (size) {
      case LoadingSize.small:
        spinnerSize = 24.0;
        textSize = 12.0;
        break;
      case LoadingSize.medium:
        spinnerSize = 40.0;
        textSize = 14.0;
        break;
      case LoadingSize.large:
        spinnerSize = 60.0;
        textSize = 16.0;
        break;
    }
    
    // Create loading content
    Widget loadingContent;
    
    if (value != null) {
      // Determinate progress indicator
      loadingContent = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: spinnerSize,
            height: spinnerSize,
            child: CircularProgressIndicator(
              value: value,
              valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
              strokeWidth: spinnerSize / 10,
            ),
          ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                message!,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      );
    } else {
      // Indeterminate animated spinner
      Widget spinner;
      
      if (size == LoadingSize.small) {
        spinner = SpinKitThreeBounce(
          color: loadingColor,
          size: spinnerSize,
        );
      } else {
        spinner = SpinKitDoubleBounce(
          color: loadingColor,
          size: spinnerSize,
        );
      }
      
      loadingContent = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          spinner,
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                message!,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      );
    }
    
    // Return as overlay or regular widget
    if (overlay) {
      return Container(
        color: Colors.black.withOpacity(0.5),
        alignment: Alignment.center,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: loadingContent,
          ),
        ),
      );
    } else {
      return Center(child: loadingContent);
    }
  }
}

// Extension for easy loading indicator in any container
extension LoadingExtension on Widget {
  Widget withLoading({
    required bool isLoading,
    String? message,
    LoadingSize size = LoadingSize.medium,
    Color? color,
    bool overlay = true,
  }) {
    return Stack(
      children: [
        this,
        if (isLoading)
          Positioned.fill(
            child: LoadingIndicator(
              message: message,
              size: size,
              color: color,
              overlay: overlay,
            ),
          ),
      ],
    );
  }
} 