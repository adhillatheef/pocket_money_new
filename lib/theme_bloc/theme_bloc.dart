import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_money_new/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc() : super(ThemeData.light()) {
    on<InitialThemeSetEvent>((event, emit) async {
      final bool hasDarkTheme = await isDark();
      if (hasDarkTheme) {
        StaticData.isDarkMode=true;
        emit(ThemeData.dark());
      } else {
        StaticData.isDarkMode=false;
        emit(ThemeData.light());
      }
      debugPrint("isDarkMode:${StaticData.isDarkMode!}");
    });

    on<ThemeSwitchEvent>((event, emit) {
      final isDark = state == ThemeData.dark();
      if(isDark){
        StaticData.isDarkMode=false;
      }else{
        StaticData.isDarkMode=true;
      }
      emit(isDark ? ThemeData.light() : ThemeData.dark());
      setTheme(isDark);
      debugPrint("isDarkMode:${StaticData.isDarkMode!}");
    });
  }
}

Future<bool> isDark() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("is_dark") ?? false;
}

Future<void> setTheme(bool isDark) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("is_dark", !isDark);
}

