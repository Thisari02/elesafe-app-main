// app_router.dart
import 'package:elesafe_app/features/alert/alert_screen.dart';
import 'package:elesafe_app/features/alert/models/alert_data_model.dart';
import 'package:elesafe_app/features/map/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class AppRouter {
  static const alertPath = '/alerts';
  static const mapPath = '/map';

  // MUST exist
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: alertPath,
      routes: [
        GoRoute(
          path: alertPath,
          builder: (context, state) => const AlertScreen(),
        ),
        GoRoute(
          path: mapPath,
          builder: (context, state) {
            final alertData = state.extra as AlertDataModel?;
            if (alertData == null) {
              return const Scaffold(
                body: Center(child: Text('No alert data provided')),
              );
            }
            return MapScreen(alertData: alertData);
          },
        ),
      ],
    );
  }
}
