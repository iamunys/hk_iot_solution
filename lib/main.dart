import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/firebase_options.dart';
import 'package:smart_controller/router.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static NavigatorState get navigator => navigatorKey.currentState!;
  static BuildContext get currentContext => navigatorKey.currentContext!;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'Saron Smart',
        theme: ThemeData(
          useMaterial3: true,
        ),
        // home: const SplashScreen()
      );
    });
  }
}
