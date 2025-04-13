import 'package:flutter/material.dart';

// Create a global RouteObserver instance
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

// Creates a mixin that subscribes to route changes for the given navigator
// Use this as a mixin for classes that need to be aware of route changes
mixin RouteAwareMixin<T extends StatefulWidget> on State<T> implements RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route changes for this screen
    final modalRoute = ModalRoute.of(context) as PageRoute?;
    if (modalRoute != null) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Override these methods as needed in your StatefulWidget
  @override
  void didPush() {
    // Called when this route is pushed onto the navigator
  }

  @override
  void didPopNext() {
    // Called when the top route is popped and this route is exposed
  }

  @override
  void didPop() {
    // Called when this route is popped
  }

  @override
  void didPushNext() {
    // Called when a new route is pushed on top of this route
  }
}

// A widget that wraps its child with route awareness functionality
class RouteAwareWidget extends StatefulWidget {
  final Widget child;
  final RouteAware routeAware;

  const RouteAwareWidget({
    Key? key,
    required this.child,
    required this.routeAware,
  }) : super(key: key);

  @override
  State<RouteAwareWidget> createState() => _RouteAwareWidgetState();
}

class _RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context) as PageRoute?;
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    widget.routeAware.didPush();
  }

  @override
  void didPopNext() {
    widget.routeAware.didPopNext();
  }

  @override
  void didPop() {
    widget.routeAware.didPop();
  }

  @override
  void didPushNext() {
    widget.routeAware.didPushNext();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
} 