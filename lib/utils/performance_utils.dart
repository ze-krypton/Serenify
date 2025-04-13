import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PerformanceUtils {
  static Future<void> optimizeLargeLists(List<Widget> items, {
    required int threshold,
    required Widget Function(BuildContext, int) itemBuilder,
  }) async {
    if (items.length > threshold) {
      debugPrint('List exceeds threshold of $threshold items. Consider implementing pagination or lazy loading.');
    }
  }

  static Future<void> preloadImages(List<String> imageUrls) async {
    for (final url in imageUrls) {
      try {
        await precacheImage(NetworkImage(url), null);
      } catch (e) {
        debugPrint('Failed to preload image: $url');
      }
    }
  }

  static void logPerformance(String operation, Stopwatch stopwatch) {
    debugPrint('$operation took ${stopwatch.elapsedMilliseconds}ms');
  }

  static Future<void> runInBackground(Future<void> Function() task) async {
    await compute((_) async {
      await task();
    }, null);
  }

  static Widget buildLoadingPlaceholder() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget buildErrorWidget(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
} 