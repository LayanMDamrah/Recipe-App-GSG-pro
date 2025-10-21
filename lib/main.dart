import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_gsg/provider/bottom_nav_provider.dart';
import 'package:recipe_gsg/screens/home_screen.dart';
import 'package:recipe_gsg/screens/login_screen.dart';
import 'package:recipe_gsg/screens/onbording_sceen.dart';
import 'package:recipe_gsg/screens/splash_screem.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import 'package:recipe_gsg/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => BottomNavProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
      theme: ThemeData(
        primaryColor: const Color(0xFFF58700),
        scaffoldBackgroundColor: const Color(0xFFFFFAF6),
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
