import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:elesafe_app/core/other/log_manager.dart';

class EleSafeNavigatorObserver extends NavigatorObserver {
  final Logger log = Logger('NavigatorObserver');

  EleSafeNavigatorObserver() {
    LogManager.init(); // Initialize logging only once
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> ? previousRoute) {
    log.info('Navigator: didPush: ${route.str}, previousRoute= ${previousRoute?.str}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log.info('Navigator: didPop: ${route.str}, previousRoute= ${previousRoute?.str}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log.info('Navigator: didRemove: ${route.str}, previousRoute= ${previousRoute?.str}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    log.info('Navigator: didReplace: new= ${newRoute?.str}, old= ${oldRoute?.str}');
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log.info('Navigator: didStartUserGesture: ${route.str}, previousRoute= ${previousRoute?.str}');
  }

  @override
  void didStopUserGesture() {
    log.info('Navigator: didStopUserGesture');
  }
}

extension on Route<dynamic> {
  String get str {
    return 'Navigator: route(${settings.name}: ${settings.arguments})';
  }
}
