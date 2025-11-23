// app_router.dart
import 'package:elesafe_app/features/alert/alert_screen.dart';
import 'package:elesafe_app/features/alert/models/alert_data_model.dart';
import 'package:elesafe_app/features/forgot_password/forgot_password_screen.dart';
// import 'package:elesafe_app/features/map/map_screen.dart';
import 'package:elesafe_app/features/map/mock_map_screen.dart';
import 'package:elesafe_app/features/signin/signin_screen.dart';
import 'package:elesafe_app/features/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const loginPath = '/signin';
  static const signupPath = '/signup';
  static const forgotPasswordPath = '/forgot-password';
  static const alertPath = '/alerts';
  static const mapPath = '/map';

  // MUST exist
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: loginPath,
      routes: [
        GoRoute(
          path: loginPath,
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          path: signupPath,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: forgotPasswordPath,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '$alertPath/:email',
          builder: (context, state) {
            final email = state.pathParameters['email']!;
            return AlertScreen(email: email);
          },
        ),
        GoRoute(
          path: mapPath,
          builder: (context, state) {
            // final alertData = state.extra as AlertDataModel?;
            // if (alertData == null) {
            //   return const Scaffold(
            //     body: Center(child: Text('No alert data provided')),
            //   );
            // }
            // return MapScreen(alertData: alertData);
            return const MockMapScreen();
          },
        ),
      ],
    );
  }
}
