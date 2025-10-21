import 'package:flutter/material.dart';
import 'package:recipe_gsg/screens/home_screen.dart';
import 'package:recipe_gsg/screens/login_screen.dart';
import 'package:recipe_gsg/screens/onbording_sceen.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import 'package:recipe_gsg/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();

  final bool seenOnboarding = await SharedPrefs.isOnboardingCompleted();
  final bool loggedIn = await SharedPrefs.isLoggedIn();

  runApp(MyApp(seenOnboarding: seenOnboarding, loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  final bool loggedIn;

  const MyApp({
    super.key,
    required this.seenOnboarding,
    required this.loggedIn,
  });

  @override
  Widget build(BuildContext context) {
    String initialRoute;

    if (!seenOnboarding) {
      initialRoute = '/onboarding';
    } else if (!loggedIn) {
      initialRoute = '/login';
    } else {
      initialRoute = '/home';
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: initialRoute,
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },

      theme: ThemeData(
        primaryColor: const Color(0xFFF58700),
        scaffoldBackgroundColor: Color(0xFFFFFAF6),

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          labelStyle: TextStyle(color: AppColors.gray),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        fontFamily: 'DM Sans',
      ),
    );
  }
}
