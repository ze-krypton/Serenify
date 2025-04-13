import 'package:flutter/material.dart';

class AnimationUtils {
  static const Duration defaultDuration = Duration(milliseconds: 300);
  static const Curve defaultCurve = Curves.easeInOut;

  static Widget buildFadeTransition(Widget child) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: defaultDuration,
      curve: defaultCurve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget buildScaleTransition(Widget child) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: defaultDuration,
      curve: defaultCurve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget buildSlideTransition(Widget child, {Offset? offset}) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(
        begin: offset ?? const Offset(0, 0.1),
        end: Offset.zero,
      ),
      duration: defaultDuration,
      curve: defaultCurve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget buildRotationTransition(Widget child) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: defaultDuration,
      curve: defaultCurve,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 2 * 3.14159,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget buildStaggeredAnimation({
    required List<Widget> children,
    Duration? duration,
    Curve? curve,
  }) {
    return Column(
      children: List.generate(
        children.length,
        (index) => TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: duration ?? defaultDuration,
          curve: curve ?? defaultCurve,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, (1 - value) * 20),
                child: child,
              ),
            );
          },
          child: children[index],
        ),
      ),
    );
  }

  static Widget buildLoadingAnimation() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget buildPulseAnimation(Widget child) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.2),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget buildShakeAnimation(Widget child) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            value * 10 * (value < 0.5 ? 1 : -1),
            0,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
} 