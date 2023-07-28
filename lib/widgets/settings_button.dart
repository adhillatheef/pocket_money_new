import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_money_new/theme_bloc/theme_bloc.dart';

import '../constants.dart';


class SettingsIcon extends StatelessWidget {
  final Function() onTap;
  final IconData icon;

  const SettingsIcon({Key? key, required this.onTap, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context, state) {
        return InkWell(
          onTap: onTap,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: state==ThemeData.dark()?darkGrayColor:whiteColor,
                borderRadius: BorderRadius.circular(15)
            ),
            child:  Icon(icon, color: grayColor,),
          ),
        );
      },
    );
  }
}
