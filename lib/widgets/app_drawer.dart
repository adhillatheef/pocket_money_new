import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_money_new/bloc/transaction_bloc.dart';
import 'package:pocket_money_new/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../screens/user_name_screen.dart';
import '../theme_bloc/theme_bloc.dart';

class AppDrawer extends StatefulWidget {
  final String userName;
  const AppDrawer({Key? key, required this.userName}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeData>(
  builder: (context, themeData) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        welcome,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: blackColor),
                      ),
                      Row(
                        children: [
                          Text(widget.userName,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: whiteColor)),
                          IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>UserNameScreen(userName: widget.userName,)));
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: blackColor,
                              ))
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        SwitchListTile(
        title:  Text(themeData == ThemeData.dark()?lightMode:darkMode),
        value: themeData == ThemeData.dark(),
        onChanged: (bool value) {
          BlocProvider.of<ThemeBloc>(context).add(ThemeSwitchEvent());
        },
        secondary:  Icon(themeData == ThemeData.dark()? Icons.sunny:Icons.nightlight_outlined,
          color: themeData == ThemeData.dark()?Colors.yellow:Colors.black,),
      ),
          buildListTile(iconData: Icons.delete,text: clearData, onTap: () {
            confirmDismiss(context);
          }, color: Colors.redAccent),
          buildListTile(iconData: Icons.perm_device_info_rounded,text: deleteATransaction, onTap: () {
            howToDeletePopup(context,transactionDeleteContent);
          }, color: Colors.orange),
          buildListTile(iconData: Icons.share,text: share, onTap: () {}, color: gradientColor2),
          buildListTile(iconData: Icons.contact_support_outlined,text: contact, onTap: () {
            contactUs();
          }, color: Colors.yellow),
          buildListTile(iconData: Icons.privacy_tip_sharp,text: privacyPolicy, onTap: () {
            showPopUP(context, privacyPolicy, privacyPolicyContent);
          }, color: gradientColor3),
          buildListTile(iconData: Icons.info,text: about, onTap: () {
            showPopUP(context, about, aboutContent);
          }, color: gradientColor1),
        ],
      ),
    );
  },
);
  }
  confirmDismiss(BuildContext context) {
    TransactionBloc? authBloc = BlocProvider.of<TransactionBloc>(context);
    final navigator = Navigator.of(context);
    return  showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text(confirmDelete),
            content: const Text(clearDataText),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(no),
              ),
              TextButton(
                onPressed: () async{
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.clear();
                  authBloc.add(ClearData());
                  StaticData.userName=null;
                  await Future.delayed(const Duration(milliseconds: 200));
                  navigator.pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context) => const SplashScreen()),
                        (Route route) => false,
                  );
                },
                child: const Text(yes,style: TextStyle(color: Colors.red),),
              ),
            ],
          );
        });
  }

  ListTile buildListTile({required IconData iconData, required String text,required Function() onTap,required Color color}) {
    return  ListTile(
          onTap: onTap,
          leading:  Icon(iconData,color: color,),
          title: Text(text),
        );
  }
}
