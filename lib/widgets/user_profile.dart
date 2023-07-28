import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_money_new/theme_bloc/theme_bloc.dart';

import '../constants.dart';


class UserProfile extends StatelessWidget {
  final String userName;

  const UserProfile({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(welcome, style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: grayColor
              ),),
              Text(userName, style:  TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: state==ThemeData.dark()?whiteColor:blackColor,
              )),
            ],
          );
        },
      );
  }
}
