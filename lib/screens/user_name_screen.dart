import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pocket_money_new/theme_bloc/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'home_screen.dart';

class UserNameScreen extends StatelessWidget {
  final String? userName;
   const UserNameScreen({Key? key,this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userNameController = TextEditingController(text: userName??"");
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context, state) {
        return Scaffold(
        backgroundColor: state==ThemeData.dark()?Theme.of(context).scaffoldBackgroundColor:backGroundColor,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Lottie.asset(
                          repeat: true,
                          'assets/lottie_files/lf30_editor_egaflvdu.json'),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            strEnterYourName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          )),
                      normalSizedBox,
                      TextField(
                        controller: userNameController,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        style: const TextStyle(fontSize: 18,),
                        cursorColor: blackColor,
                        decoration: InputDecoration(
                          hintText: strUserName,
                          prefixIcon: const Icon(
                            Icons.person,
                            color: grayColor,
                          ),
                          filled: true,
                          fillColor: state==ThemeData.dark()?darkGrayColor:whiteColor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      normalSizedBox,
                      InkWell(
                        onTap: () {
                          submitData(userNameController.text, context);
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 150,
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: grayColor,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 10.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: colors)),
                              child:  Center(
                                  child: Padding(
                                    padding:  const EdgeInsets.all(20.0),
                                    child: Text(
                                      userName==null?strLetsGo:strUpdate,
                                      style: const TextStyle(
                                          color: whiteColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      );
  },
),
    );
  }
  submitData(String text, BuildContext context) async {
    if (text.isEmpty) {
      return snackBar(context,strEnterValidName);
    } else {
      final navigator = Navigator.of(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(strUserNamePrefs, text);
      var userName = prefs.getString("userName");
      if(userName!=null){
        StaticData.userName=userName;
      }
      await Future.delayed(const Duration(milliseconds: 500));
      navigator.pushAndRemoveUntil(MaterialPageRoute(
          builder: (context) => const HomePage()),
            (Route route) => false,
      );
    }
  }
}
