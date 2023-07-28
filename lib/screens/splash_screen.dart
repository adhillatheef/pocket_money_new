import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_money_new/screens/user_name_screen.dart';
import 'package:pocket_money_new/theme_bloc/theme_bloc.dart';

import '../constants.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    asyncMethod();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<ThemeBloc, ThemeData>(
  builder: (context, state) {
    return Scaffold(
        backgroundColor: state==ThemeData.dark()?Theme.of(context).scaffoldBackgroundColor:backGroundColor,
        body:  Center(
          child: AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                appName,
                textAlign: TextAlign.center,
                textStyle: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold
                ),
                colors: colorizeColors,
              ),
            ],
            isRepeatingAnimation: true,
          ),
        )
    );
  },
);
  }
  asyncMethod() async{
    Timer(const Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) =>  StaticData.userName == null? const UserNameScreen():const HomePage()
            )
        )
    );
  }
}


