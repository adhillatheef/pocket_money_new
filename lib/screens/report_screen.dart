import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pocket_money_new/bloc/transaction_bloc.dart';
import 'package:pocket_money_new/theme_bloc/theme_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../constants.dart';
import '../repository/model.dart';
import '../repository/repository.dart';
import '../widgets/app_drawer.dart';
import '../widgets/multi_select_widget.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/settings_button.dart';
import 'add_transaction_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  CategoryListDataModel? categoryChoose;
  List<String> subCategoryList = [];
  DateTimeRange? date;
  DateTime? firstDate;
  DateTime? lastDate;
  List<String> selectedItems = [];
  List<Transaction> transactions = [];
  List<Transaction> filteredList = [];
  bool valid = false;


  void _showMultiSelect() async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: subCategoryList);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        selectedItems = results;
      });
    }
  }

  onIncomeExpenseChange(){
    if(categoryChoose!.isIncome){
      setState(() {
        subCategoryList = incomeCategories;
        selectedItems = [];
      });
    }else{
      subCategoryList = expenseCategories;
      selectedItems = [];
    }
  }

  getFilteredTransactions({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? categories,
  }) {
    final filteredTransactions = <Transaction>[];
    for (final transaction in transactions) {
      if (categories != null && !categories.contains(transaction.subCategory)) {
        continue;
      }
      if (startDate != null && transaction.date!.isBefore(startDate)) {
        continue;
      }
      if (endDate != null && transaction.date!.isAfter(endDate)) {
        continue;
      }
      filteredTransactions.add(transaction);
    }
    // return filteredTransactions;
    setState(() {
      filteredList = filteredTransactions;
    });
  }

  double getTotal(List<Transaction> transactions) {
    double total = 0;
    if (transactions.isNotEmpty) {
      total = transactions.fold(0, (previousValue, element) => previousValue + element.amount!);
    }
    return total;
  }


  @override
  void initState() {
    context.read<TransactionBloc>().add(GetTransactions());
    categoryChoose = categoryDataList[0];
    subCategoryList = incomeCategories;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return BlocBuilder<ThemeBloc,ThemeData>(
      builder: (context, themeState){
        return SafeArea(child: Scaffold(
          key: scaffoldKey,
          backgroundColor: themeState==ThemeData.dark()?Theme.of(context).scaffoldBackgroundColor:backGroundColor,
          endDrawer: AppDrawer(userName:StaticData.userName!=null?StaticData.userName!:""),
          appBar: AppBar(
            leading:  IconButton(icon:const  Icon(Icons.arrow_back),color: grayColor,onPressed: (){
              Navigator.pop(context);
            }),
            title:  Text(report,style: TextStyle(
                foreground: Paint()..shader = linearGradient,
                fontSize: 30,
                fontWeight: FontWeight.bold),),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SettingsIcon(onTap: () {
                  scaffoldKey.currentState?.openEndDrawer();
                }, icon: Icons.settings,),
              )
            ],
          ),
          body: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              transactions = state.transactions!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        cursorColor: blackColor,
                        controller: searchController,
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(
                              color: gradientColor3,fontSize: 16),
                          hintText: searchNote,
                          suffixIcon: IconButton(onPressed:() {
                            if(searchController.text.isNotEmpty){
                              setState(() {
                                valid = false;
                                filteredList = transactions.where((transaction) =>
                                    transaction.note!.toLowerCase().contains(searchController.text.toLowerCase())).toList();
                              });
                            }else{
                              setState(() {
                                valid = true;
                              });
                            }
                          }, icon:const Icon(Icons.search) ),
                          filled: true,
                          fillColor: themeState==ThemeData.dark()?darkGrayColor:whiteColor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      valid?const Column(
                        children: [
                          miniSizedBox,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(validateNote,style: TextStyle(
                                color: gradientColor3,fontSize: 16
                            ),),
                          ),
                          miniSizedBox
                        ],
                      ):const SizedBox(),
                      const Divider(thickness: 2),
                      normalSizedBox,
                      TextFormField(
                        controller: dateController,
                        readOnly: true,
                        cursorColor: blackColor,
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(
                              color: gradientColor3,fontSize: 16),
                          hintText: dateFormat,
                          prefixIcon: const Icon(
                            Icons.timer_rounded,
                            color: grayColor,
                          ),
                          filled: true,
                          fillColor: themeState==ThemeData.dark()?darkGrayColor:whiteColor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onTap: () async {
                          _selectDate(context);
                        },
                      ),
                            normalSizedBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 6,
                                child: FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        hintText: category,
                                        prefixIcon: const Icon(
                                          Icons.compare_outlined,
                                          color: grayColor,
                                        ),
                                        filled: true,
                                        fillColor: themeState==ThemeData.dark()?darkGrayColor:whiteColor,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<CategoryListDataModel>(
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: grayColor,
                                          ),
                                          hint: const Text(
                                            selectCategory,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                            ),
                                          ),
                                          items: categoryDataList
                                              .map<DropdownMenuItem<CategoryListDataModel>>(
                                                  (CategoryListDataModel value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor: Colors.transparent,
                                                        child: Icon(value.categoryIcon,
                                                          color: value.isIncome?Colors.green:Colors.red,),
                                                      ),
                                                      const SizedBox(width: 15,),
                                                      Text(value.category),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                          isExpanded: true,
                                          isDense: true,
                                          onChanged: (newSelectedCategory) {
                                            setState(() {
                                              categoryChoose = newSelectedCategory;
                                              onIncomeExpenseChange();
                                            });
                                          },
                                          value: categoryChoose,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width:5),
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  readOnly: true,
                                  textCapitalization: TextCapitalization.words,
                                  onTap: _showMultiSelect,
                                  decoration: InputDecoration(
                                    errorStyle: const TextStyle(
                                        color: gradientColor3,fontSize: 16),
                                    hintText: category,
                                    prefixIcon: const Icon(
                                      Icons.grid_view_rounded,
                                      color: grayColor,
                                    ),
                                    filled: true,
                                    fillColor: themeState==ThemeData.dark()?darkGrayColor:whiteColor,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                )
                              ),
                            ],
                            ),
                      normalSizedBox,
                      InkWell(
                        onTap:() {
                          getFilteredTransactions(startDate:firstDate?? DateTime(2000),endDate: lastDate ?? DateTime(2101),categories: selectedItems.isNotEmpty?selectedItems:subCategoryList);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow:  const [
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
                          child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  applyFilter,
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                      ),
                      normalSizedBox,
                      filteredList.isNotEmpty?Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(total,style: TextStyle(color: grayColor,fontWeight: FontWeight.bold),),
                              Text(getTotal(filteredList).toStringAsFixed(2),style:const  TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SettingsIcon(onTap: () {
                                  exportToExcel(filteredList);
                                }, icon: Icons.add_chart,),
                                const SizedBox(
                                  width: 5,
                                ),
                                SettingsIcon(onTap: () {
                                  showChart(transactions: filteredList);
                                }, icon: Icons.pie_chart,),
                              ],
                            ),
                          ),
                        ],
                      ):const SizedBox(),
                      normalSizedBox,
                      filteredList.isNotEmpty?Column(
                        children: filteredList.map((e) {
                          int index = filteredList.indexWhere((element) => element == e);
                          final transaction = filteredList[index];
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
                        }).toList() ,
                      ): Center(
                          child: Lottie.asset(
                              repeat: false,
                              'assets/lottie_files/134394-no-transaction.json')),
                          ],
                        ),
                ),
                    );
            },
          ),
        ));
      },
    );
  }

  showChart({required List<Transaction> transactions}) {
    // Group transactions by subcategory
    Map<String, List<Transaction>> transactionMap = {};
    for (Transaction transaction in transactions) {
      String subCategory = transaction.subCategory ?? '';
      transactionMap.putIfAbsent(subCategory, () => []);
      transactionMap[subCategory]?.add(transaction);
    }

    // Create list of ChartData objects
    List<ChartData> chartDataList = [];
    transactionMap.forEach((subCategory, transactionList) {
      double totalAmount = transactionList.fold(0.0, (sum, transaction) => sum + transaction.amount!);
      chartDataList.add(ChartData(subCategory, totalAmount));
    });

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Center(child: Text(charts)),
          content: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: SfCircularChart(
                  legend: Legend(isVisible: true),
                  series: <CircularSeries>[
                    PieSeries<ChartData, String>(
                      enableTooltip: true,
                      dataSource: chartDataList,
                      xValueMapper: (ChartData data, _) => data.category,
                      yValueMapper: (ChartData data, _) => data.totalAmount,
                      dataLabelMapper: (ChartData data, _) => '${data.category}: ${data.totalAmount}',
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(close),
            ),
          ],
        );
      },
    );
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? pickedDate = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        currentDate: DateTime.now(),
        saveText: 'Done',
        builder: (context,child){
          return Theme(data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: gradientColor2,
                onPrimary: whiteColor,
                onSurface: gradientColor3,
              )
          ), child: child!);
        }
    );
    if(pickedDate != null ){
      debugPrint(pickedDate.toString());
      setState(() {
        date = pickedDate;
        firstDate = pickedDate.start;
        lastDate = pickedDate.end;
        String formattedFirstDate = DateFormat(dateFormatIntl).format(firstDate!);
        String formattedLastDate = DateFormat(dateFormatIntl).format(lastDate!);
        dateController.text = '$formattedFirstDate To $formattedLastDate';
        debugPrint(dateController.text);
      });
    }else{
      debugPrint("Date is not selected");
    }
  }
}
