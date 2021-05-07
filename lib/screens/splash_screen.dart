import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:maple_tech_test_app/utils/constants.dart';

import 'city_select_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Container(
          child: AnimatedSplashScreen(splash: Container(
              child: Image.asset(logoString,)), nextScreen: CitySelectScreen(),
            splashTransition: SplashTransition.sizeTransition,duration: 3000,),
        ),
      ),
    );
  }
}
