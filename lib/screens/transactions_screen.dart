import 'package:auto_size_text/auto_size_text.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pocket_money_new/bloc/transaction_bloc.dart';
import 'package:pocket_money_new/constants.dart';
import 'package:pocket_money_new/screens/home_screen.dart';
import 'package:pocket_money_new/screens/report_screen.dart';
import 'package:pocket_money_new/theme_bloc/theme_bloc.dart';
import 'package:pocket_money_new/widgets/colorful_text.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../repository/model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/settings_button.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_screen.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  int _currentIndex = 0;

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
        return SafeArea(
          child: Scaffold(
            backgroundColor: themeState == ThemeData.dark()
                ? Theme.of(context).scaffoldBackgroundColor
                : backGroundColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: AppBar(
                  elevation: 0,
                  iconTheme: const IconThemeData(color: grayColor),
                  backgroundColor: themeState == ThemeData.dark()
                      ? Theme.of(context).scaffoldBackgroundColor
                      : backGroundColor,
                  automaticallyImplyLeading: false,
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: SalomonBottomBar(
                            currentIndex: _currentIndex,
                            onTap: (i) => setState(() => _currentIndex = i),
                            itemPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            items: [
                              SalomonBottomBarItem(
                                  icon: const Icon(Icons.compare_arrows),
                                  title: const Text(transactions),
                                  selectedColor: gradientColor1,
                                  unselectedColor: grayColor),
                              SalomonBottomBarItem(
                                icon: const Icon(Icons.arrow_circle_down_outlined),
                                title: const Text(strIncome),
                                selectedColor: Colors.green,
                                unselectedColor: Colors.green,
                              ),
                              SalomonBottomBarItem(
                                  icon: const Icon(Icons.arrow_circle_up_outlined),
                                  title: const Text(strExpense),
                                  selectedColor: Colors.red,
                                  unselectedColor: Colors.red),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SettingsIcon(onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const ReportScreen()));
                          }, icon: Icons.bar_chart,),
                          const SizedBox(width: 8,),
                          SettingsIcon(onTap: () {
                            scaffoldKey.currentState?.openEndDrawer();
                          }, icon: Icons.settings,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            key: scaffoldKey,
            endDrawer: AppDrawer(
                userName: StaticData.userName != null ? StaticData.userName! : ""),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              elevation: 10,
              height: 60,
              color: themeState == ThemeData.dark() ? darkGrayColor : whiteColor,
              shape: const CircularNotchedRectangle(),
              notchMargin: 5,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.grid_view_rounded, color: grayColor),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()),
                        (Route route) => false,
                      );
                    },
                  ),
                  const IconButton(
                    icon: Icon(Icons.insert_chart, color: gradientColor3),
                    onPressed: null,
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
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: themeState == ThemeData.dark() ? darkGrayColor : whiteColor,
                ),
              ),
              onPressed: () async {
                var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTransactionScreen(isUpdate: false,)));
                if (result != null || result == null) {
                  setState(() {
                    context.read<TransactionBloc>().add(GetTransactions());
                  });
                }
              },
            ),
            body: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                final List<Transaction> chartData = state.recentTransaction;
                return DoubleBackToCloseApp(
                  snackBar: SnackBar(
                    backgroundColor: themeState == ThemeData.dark() ? darkGrayColor : whiteColor,
                    duration: const Duration(milliseconds: 500),
                    content: const ColourfulText(text: exitApp),
                  ),
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: state.transactions!.isNotEmpty
                          ? Column(
                              children: [
                                _currentIndex == 0 && state.transactions!.isNotEmpty ||
                                _currentIndex == 1 && state.getIncomeTransactions().isNotEmpty ||
                                _currentIndex == 2 && state.getExpenseTransactions().isNotEmpty
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _currentIndex == 0 && state.transactions!.isNotEmpty?Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(totalIncome,style: TextStyle(color: grayColor,fontWeight: FontWeight.bold),),
                                              AutoSizeText(state.totalIncome.toStringAsFixed(2),style:const  TextStyle(fontWeight: FontWeight.bold),),
                                              const SizedBox(width: 5,),
                                              const Text(totalExpense,style: TextStyle(color: grayColor,fontWeight: FontWeight.bold),),
                                              AutoSizeText(state.totalExpense.toStringAsFixed(2),style:const  TextStyle(fontWeight: FontWeight.bold),),
                                            ],
                                          ):_currentIndex == 1 && state.getIncomeTransactions().isNotEmpty?Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text(totalIncome,style: TextStyle(color: grayColor,fontWeight: FontWeight.bold),),
                                              AutoSizeText(state.totalIncome.toStringAsFixed(2),style:const  TextStyle(fontWeight: FontWeight.bold),),
                                            ],
                                          ):Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text(totalExpense,style: TextStyle(color: grayColor,fontWeight: FontWeight.bold),),
                                              AutoSizeText(state.totalExpense.toStringAsFixed(2),style:const  TextStyle(fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                          SettingsIcon(onTap: () {
                                            final transaction = _currentIndex == 0 ? state.transactions! :
                                            _currentIndex == 1 ? state.getIncomeTransactions() : state.getExpenseTransactions();
                                            exportToExcel(transaction);
                                          }, icon: Icons.add_chart,),
                                        ],
                                      )
                                    : const SizedBox(),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: _currentIndex == 0
                                            ? SfCartesianChart(
                                                primaryXAxis: CategoryAxis(),
                                                legend: Legend(
                                                    position: LegendPosition.bottom,
                                                    isVisible: true),
                                                series: <CartesianSeries>[
                                                    ColumnSeries<Transaction, String>(
                                                        dataSource: chartData,
                                                        xValueMapper: (Transaction data, _) => DateFormat('E').format(data.date!),
                                                        yValueMapper: (Transaction data, _) => data.isIncome ? data.amount : 0.0,
                                                        name: strIncome,
                                                        color: Colors.green[400]),
                                                    ColumnSeries<Transaction, String>(
                                                        dataSource: chartData,
                                                        xValueMapper: (Transaction data, _) => DateFormat('E').format(data.date!),
                                                        yValueMapper: (Transaction data, _) => !data.isIncome ? data.amount : 0.0,
                                                        name: strExpense,
                                                        color: Colors.red[400]),
                                                  ]) : _currentIndex == 1 ? SfCartesianChart(
                                                    primaryXAxis: CategoryAxis(),
                                                    legend: Legend(position: LegendPosition.bottom,
                                                        isVisible: true),
                                                    series: <CartesianSeries>[
                                                      ColumnSeries<Transaction, String>(
                                                            dataSource: chartData,
                                                            xValueMapper: (Transaction data, _) => DateFormat('E').format(data.date!),
                                                            yValueMapper: (Transaction data, _) => data.isIncome ? data.amount : 0.0,
                                                            name: strIncome,
                                                            color: Colors
                                                                .green[400])
                                                      ]) : SfCartesianChart(
                                                    primaryXAxis: CategoryAxis(),
                                                    legend: Legend(position: LegendPosition.bottom,
                                                        isVisible: true),
                                                    series: <CartesianSeries>[
                                                        ColumnSeries<Transaction, String>(
                                                            dataSource: chartData,
                                                            xValueMapper: (Transaction data, _) => DateFormat('E').format(data.date!),
                                                            yValueMapper: (Transaction data, _) => !data.isIncome ? data.amount : 0.0,
                                                            name: strExpense,
                                                            color: Colors.red[400]),
                                                      ]))),
                                Column(
                                  children: _currentIndex == 0 ? state.transactions!.map((e) {
                                          int index = state.transactions!.indexWhere((element) => element == e);
                                          final transaction = state.transactions![index];
                                          return TransactionTile(
                                            transaction: transaction,
                                            onTap: () {
                                              context.read<TransactionBloc>().add(DeleteTransaction(transaction));
                                              context.read<TransactionBloc>().add(GetTransactions());
                                            },
                                            navigateFunction: () async {
                                              var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddTransactionScreen(transaction: transaction, isUpdate: true,)));
                                              if (result != null || result == null) {
                                                setState(() {
                                                  context.read<TransactionBloc>().add(GetTransactions());
                                                });
                                              }
                                            },
                                          );
                                        }).toList() : _currentIndex == 1 ?
                                          state.getIncomeTransactions().map((e) {
                                              int index = state.getIncomeTransactions().indexWhere((element) => element == e);
                                              final transaction = state.getIncomeTransactions()[index];
                                              return TransactionTile(
                                                transaction: transaction,
                                                onTap: () {
                                                  context.read<TransactionBloc>().add(DeleteTransaction(transaction));
                                                  context.read<TransactionBloc>().add(GetTransactions());
                                                },
                                                navigateFunction: () async {
                                                  var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddTransactionScreen(transaction: transaction, isUpdate: true,)));
                                                  if (result != null || result == null) {
                                                    setState(() {
                                                      context.read<TransactionBloc>().add(GetTransactions());
                                                    });
                                                  }
                                                },
                                              );
                                            }).toList() : state.getExpenseTransactions().map((e) {
                                              int index = state.getExpenseTransactions().indexWhere((element) => element == e);
                                              final transaction = state.getExpenseTransactions()[index];
                                              return TransactionTile(
                                                transaction: transaction,
                                                onTap: () {
                                                  context.read<TransactionBloc>().add(DeleteTransaction(transaction));
                                                  context.read<TransactionBloc>().add(GetTransactions());
                                                },
                                                navigateFunction: () async {
                                                  var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddTransactionScreen(transaction: transaction, isUpdate: true,)));
                                                  if (result != null || result == null) {
                                                    setState(() {
                                                      context.read<TransactionBloc>().add(GetTransactions());
                                                    });
                                                  }
                                                },
                                              );
                                            }).toList(),
                                ),
                              ],
                            )
                          : Center(
                              child: Lottie.asset(
                                  repeat: false,
                                  'assets/lottie_files/134394-no-transaction.json')),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
