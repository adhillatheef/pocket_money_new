import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pocket_money_new/theme_bloc/theme_bloc.dart';

import '../bloc/transaction_bloc.dart';
import '../constants.dart';
import '../repository/model.dart';
import '../repository/repository.dart';
import '../widgets/app_drawer.dart';
import '../widgets/settings_button.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? transaction;
  final bool isUpdate;
   const AddTransactionScreen({Key? key, this.transaction, required this.isUpdate}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  CategoryListDataModel? categoryChoose;
  DateTime? date;
  String? subCategory;
  List<String> subCategoryList = [];
  bool isValidate = false;

  @override
  void initState() {
    super.initState();
    date = widget.transaction!=null?widget.transaction!.date:DateTime.now();
    categoryChoose = widget.transaction!=null&&widget.transaction!.isIncome!=true?categoryDataList[1]:categoryDataList[0];
    dateController.text = widget.transaction!=null?(DateFormat('dd-MM-yyyy').format(widget.transaction!.date!)):(DateFormat('dd-MM-yyyy').format(date!));
    amountController.text = widget.transaction!=null?widget.transaction!.amount.toString():"";
    noteController.text = widget.transaction!=null?widget.transaction!.note!:"";
    subCategoryList = categoryChoose!.isIncome?incomeCategories:expenseCategories;
    subCategory = widget.transaction!=null?widget.transaction!.subCategory:null;
  }

  onIncomeExpenseChange(){
    if(categoryChoose!.isIncome){
      setState(() {
        subCategoryList = incomeCategories;
        subCategory = null;
      });
    }else{
      subCategoryList = expenseCategories;
      subCategory = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return  BlocBuilder<ThemeBloc, ThemeData>(
  builder: (context, themeData) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          key: scaffoldKey,
          endDrawer: AppDrawer(userName:StaticData.userName!=null?StaticData.userName!:""),
          appBar: AppBar(
            leading:  IconButton(icon:const  Icon(Icons.arrow_back),color: grayColor,onPressed: (){
              Navigator.pop(context);
            }),
            title:  AutoSizeText( widget.transaction!=null?updateTransaction:addTransaction,style: TextStyle(
                foreground: Paint()..shader = linearGradient,
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
          backgroundColor: themeData==ThemeData.dark()?Theme.of(context).scaffoldBackgroundColor:backGroundColor,
          body: SingleChildScrollView(
            child: Padding(padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width ,
                      child: TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        cursorColor: blackColor,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = linearGradient,
                            fontSize: 25),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(
                              color: gradientColor3,fontSize: 16),
                          hintText: amountHintText,
                          filled: true,
                          fillColor: themeData==ThemeData.dark()?darkGrayColor:whiteColor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        validator: (value){
                          if(value==null||value.isEmpty){
                            return validAmount;
                          }else {
                            return null;
                          }
                        },
                      ),
                    ),
                    normalSizedBox,
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            hintText: category,
                            prefixIcon: const Icon(
                              Icons.compare_outlined,
                              color: grayColor,
                            ),
                            filled: true,
                            fillColor: themeData==ThemeData.dark()?darkGrayColor:whiteColor,
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
                    normalSizedBox,
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(
                                color: gradientColor3,fontSize: 16),
                            hintText: category,
                            prefixIcon: const Icon(
                              Icons.grid_view_rounded,
                              color: grayColor,
                            ),
                            filled: true,
                            fillColor: themeData==ThemeData.dark()?darkGrayColor:whiteColor,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
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
                              items: subCategoryList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                              isExpanded: true,
                              isDense: true,
                              onChanged: (newSelectedCategory) {
                                setState(() {
                                  subCategory = newSelectedCategory;
                                });
                              },
                              value: subCategory,
                            ),
                          ),
                        );
                      },
                      validator: (value) {
                        if(subCategory==null){
                          setState(() {
                            isValidate = true;
                          });
                          return validCategory;
                        }else{
                          setState(() {
                            isValidate = false;
                          });
                          return null;
                        }
                      },
                    ),
                    isValidate?const Column(
                      children: [
                        miniSizedBox,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(validCategory,style: TextStyle(
                              color: gradientColor3,fontSize: 16
                          ),),
                        ),
                        miniSizedBox
                      ],
                    ):const SizedBox(),
                    normalSizedBox,
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      cursorColor: blackColor,
                      controller: noteController,
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(
                            color: gradientColor3,fontSize: 16),
                        hintText: note,
                        prefixIcon: const Icon(
                          Icons.edit_note,
                          color: grayColor,
                        ),
                        filled: true,
                        fillColor: themeData==ThemeData.dark()?darkGrayColor:whiteColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value){
                        if(value==null||value.isEmpty){
                          return validNote;
                        }else {
                          return null;
                        }
                      },
                    ),
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
                        fillColor: themeData==ThemeData.dark()?darkGrayColor:whiteColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value){
                        if(value==null||value.isEmpty){
                          return validDate;
                        }else {
                          return null;
                        }
                      },
                      onTap: () async {
                        _selectDate(context);
                      },
                    ),
                    normalSizedBox,
                    InkWell(
                      onTap:() {
                        submitData();
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
                                save,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  },
);
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
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
      String formattedDate = DateFormat(dateFormatIntl).format(pickedDate);
      debugPrint(formattedDate);
      setState(() {
        date = pickedDate;
        dateController.text = formattedDate;
      });
    }else{
      debugPrint("Date is not selected");
    }
  }

  submitData(){
    debugPrint("submitData OnPressed");
    if(_formKey.currentState!=null&&_formKey.currentState!.validate()){
      final amount = double.parse(amountController.text);
      final isIncome = categoryChoose!.isIncome;
      final note = noteController.text;
      final dateSelected =  date ?? DateTime.now();
      final subCategorySelected = subCategory;
      if(widget.isUpdate){
        debugPrint("Update Transaction");
        debugPrint("amount:$amount, date:$date, note:$note, isIncome:$isIncome, subCategory:$subCategorySelected id:${widget.transaction!.id!}");
        context.read<TransactionBloc>().add(UpdateTransaction(amount: amount, isExpense: isIncome, notes: note, date: dateSelected, id: widget.transaction!.id!,transaction: widget.transaction!, subCategory: subCategorySelected!));
        Navigator.pop(context);
      }else{
        debugPrint(widget.isUpdate.toString());
        debugPrint("Add Transaction");
        debugPrint("amount:$amount, date:$date, note:$note, isIncome:$isIncome , subCategory:$subCategorySelected");
        context.read<TransactionBloc>().add(AddTransactionEvent(amount: amount, isExpense: isIncome, notes: note, date: dateSelected, subCategory: subCategorySelected!));
        Navigator.pop(context);
      }
    }
  }
}
