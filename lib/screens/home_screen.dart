import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pocket_money_new/bloc/transaction_bloc.dart';
import 'package:pocket_money_new/constants.dart';
import 'package:pocket_money_new/screens/report_screen.dart';
import 'package:pocket_money_new/screens/transactions_screen.dart';
import 'package:pocket_money_new/theme_bloc/theme_bloc.dart';

import '../widgets/app_drawer.dart';
import '../widgets/colorful_text.dart';
import '../widgets/main_card.dart';
import '../widgets/settings_button.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/user_profile.dart';
import 'add_transaction_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<TransactionBloc>().add(GetTransactions());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context, themeState) {
        return Scaffold(
          backgroundColor: themeState==ThemeData.dark()?Theme.of(context).scaffoldBackgroundColor:backGroundColor,
          key: scaffoldKey,
          endDrawer: AppDrawer(userName:StaticData.userName!=null?StaticData.userName!:""),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar:  BottomAppBar(
            elevation: 10,
            height: 60,
            color: themeState==ThemeData.dark()?darkGrayColor:whiteColor,
            shape: const CircularNotchedRectangle(),
            notchMargin: 5,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon:  const Icon(Icons.grid_view_rounded,color:gradientColor2),
                  onPressed: (){
                  },
                ),
                IconButton(
                  icon:  const Icon(Icons.insert_chart,color:grayColor),
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) => const TransactionPage()),
                          (Route route) => false,);
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: colors)),
              child:  Icon(
                Icons.add,
                size: 40,
                color: themeState==ThemeData.dark()?darkGrayColor:whiteColor,
              ),
            ),
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddTransactionScreen(
                        isUpdate: false,
                      )));
              if (result != null || result == null) {
                setState(() {
                  context.read<TransactionBloc>().add(GetTransactions());
                });
              }
            },
          ),
          body: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
            return DoubleBackToCloseApp(
            snackBar:  SnackBar(
              backgroundColor: themeState==ThemeData.dark()?darkGrayColor:whiteColor,
              duration: const Duration(milliseconds: 500),
              content: const ColourfulText(text: exitApp),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UserProfile(
                              userName: StaticData.userName != null ? StaticData.userName! : ""),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SettingsIcon(onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ReportScreen()));
                              }, icon: Icons.bar_chart,),
                              const SizedBox(
                                width: 5,
                              ),
                              SettingsIcon(onTap: () {
                                scaffoldKey.currentState?.openEndDrawer();
                              }, icon: Icons.settings,),
                            ],
                          )
                        ],
                      )
                  ),
                  normalSizedBox,
                  MainCard(
                      balance: state.totalBalance,
                      expense: state.totalExpense,
                      income: state.totalIncome
                  ),
                  normalSizedBox,
                  const ColourfulText(text: strRecent),
                  state.transactions!.isNotEmpty
                      ? Expanded(
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: ListView.builder(
                        itemCount: state.recentTransaction.length,
                        itemBuilder: (context, index) {
                          final transaction = state.recentTransaction[index];
                          return TransactionTile(
                            transaction: transaction,
                            onTap: () {
                              context.read<TransactionBloc>().add(DeleteTransaction(transaction));
                              context.read<TransactionBloc>().add(GetTransactions());
                            },
                            navigateFunction: () async {
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddTransactionScreen(
                                        transaction: transaction,
                                        isUpdate: true,
                                      )));
                              if (result != null || result == null) {
                                setState(() {
                                  context.read<TransactionBloc>().add(GetTransactions());
                                });
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ) : Expanded(
                      child: Center(
                          child: Lottie.asset(
                              repeat: false,
                              'assets/lottie_files/134394-no-transaction.json'))),
                  state.transactions!.length>7?InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const TransactionPage()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                         ColourfulText(text: viewMore),
                        Icon(Icons.arrow_forward,color: grayColor,)
                      ],
                    ),
                  ):const SizedBox()
                ],
              ),
            ),
          );
  },
),
        );
      },
    );
  }
}

