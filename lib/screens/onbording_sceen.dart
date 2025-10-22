import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_gsg/screens/login_screen.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import 'package:recipe_gsg/utils/app_colors.dart';
import 'package:recipe_gsg/utils/text_styles.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'Register',
      finishButtonStyle: FinishButtonStyle(backgroundColor: AppColors.primary),

      onFinish: () async {
  await SharedPrefs.completeOnboarding();

  final loggedIn = await SharedPrefs.isLoggedIn();

  if (loggedIn) {
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    Navigator.pushReplacementNamed(context, '/login');
  }
},


      trailing: Text(
        'Login',
        style: AppTextStyles.heading4.copyWith(color: AppColors.primary),
      ),
      trailingFunction: () {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => const LoginScreen()),
        );
      },

      controllerColor: AppColors.primary,
      totalPage: 3,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,

      background: [
        SvgPicture.asset(
          'assets/img/onbording/onbording1.svg',
          height: 400,
          fit: BoxFit.contain,
        ),
        SvgPicture.asset(
          'assets/img/onbording/onbording2.svg',
          height: 400,
          fit: BoxFit.contain,
        ),
        SvgPicture.asset(
          'assets/img/onbording/onbording3.svg',
          height: 400,
          fit: BoxFit.contain,
        ),
      ],

      speed: 1.8,

      pageBodies: [
        _buildPageBody(
          context,
          title: 'Personalized meal planning',
          subtitle:
              'Pick your week\'s meals in minutes. With over 200 personalization options, eat exactly how you want to eat.',
        ),
        _buildPageBody(
          context,
          title: 'Simple, stress-free grocery shopping',
          subtitle:
              'Grocery shop once per week with an organized "done for you" shopping list.',
        ),
        _buildPageBody(
          context,
          title: 'Delicious, healthy meals made easy',
          subtitle:
              'Easily cook healthy, delicious meals in about 30 minutes, from start to finish.',
        ),
      ],
    );
  }

  Widget _buildPageBody(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 480),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 20),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.body2Mid.copyWith(color: AppColors.gray),
          ),
        ],
      ),
    );
  }
}
