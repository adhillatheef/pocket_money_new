import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pocket_money_new/bloc/categories_bloc.dart';
import 'package:pocket_money_new/constants.dart';
import 'package:pocket_money_new/repository/expense_category_model.dart';
import 'package:pocket_money_new/repository/expense_category_repository.dart';
import 'package:pocket_money_new/repository/income_category_model.dart';
import 'package:pocket_money_new/repository/income_category_repository.dart';
import 'package:pocket_money_new/repository/model.dart';
import 'package:pocket_money_new/repository/repository.dart';
import 'package:pocket_money_new/screens/splash_screen.dart';
import 'package:pocket_money_new/theme_bloc/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/transaction_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(TransactionAdapter().typeId)) {
    Hive.registerAdapter(TransactionAdapter());
  }
  if (!Hive.isAdapterRegistered(IncomeCategoryModelAdapter().typeId)) {
    Hive.registerAdapter(IncomeCategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(ExpenseCategoryModelAdapter().typeId)) {
    Hive.registerAdapter(ExpenseCategoryModelAdapter());
  }

  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<IncomeCategoryModel>('incomeCategories');
  await Hive.openBox<ExpenseCategoryModel>('expenseCategories');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userName = prefs.getString("userName");
  if (userName != null) {
    StaticData.userName = userName;
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final Repository repository = Repository();
    final IncomeRepository incomeRepository = IncomeRepository();
    final ExpenseRepository expenseRepository = ExpenseRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TransactionBloc(repository),
        ),
        BlocProvider(
          create: (context) =>
          ThemeBloc()
            ..add(InitialThemeSetEvent()),
        ),
        BlocProvider(create: (context) => CategoriesBloc(incomeRepository: incomeRepository, expenseRepository: expenseRepository)),
      ],
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state == ThemeData.dark()? ThemeData.dark().copyWith(
              textTheme: ThemeData.dark().textTheme.apply(
                fontFamily: 'Poppins',
              )
            ):ThemeData.light().copyWith(
                textTheme: ThemeData.light().textTheme.apply(
                  fontFamily: 'Poppins',
                )
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
