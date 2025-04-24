import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_controller/landing.dart';
import 'package:smart_controller/main.dart';
import 'package:smart_controller/views/AuthScreens/MobileAuthScreen.dart';
import 'package:smart_controller/views/helpCenter.dart';
import 'package:smart_controller/views/SplashScreen.dart';
import 'package:smart_controller/views/add_devices.dart';
import 'package:smart_controller/views/landing/profile_screen.dart';
import 'package:smart_controller/views/listMotorDevice.dart';
import 'package:smart_controller/views/select_category.dart';

final GoRouter router = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const SplashScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: 'mobileAuth',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const MobileAuthScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: 'landing',
          pageBuilder: (context, state) {
            String motorId = state.extra as String;
            return CustomTransitionPage(
              key: state.pageKey,
              child: LandingScreen(motorId: motorId),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: 'addDevice',
          builder: (BuildContext context, GoRouterState state) =>
              const AddADevice(),
        ),
        GoRoute(
          path: 'listDevice',
          builder: (BuildContext context, GoRouterState state) =>
              const ListDeviceScreen(),
        ),
        GoRoute(
          path: 'helpCenter',
          builder: (BuildContext context, GoRouterState state) =>
              const HelpCenterScreen(),
        ),
        GoRoute(
          path: 'profile',
          builder: (BuildContext context, GoRouterState state) =>
              const ProfileScreen(
            motorId: '',
          ),
        ),
      ],
    ),
  ],
);
