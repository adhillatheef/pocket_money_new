import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pocket_money_new/repository/model.dart';
import 'package:pocket_money_new/repository/repository.dart';
import 'package:url_launcher/url_launcher.dart';


const Color backGroundColor = Color(0xfff3f5f7);
const Color whiteColor = Colors.white;
const Color blackColor = Colors.black;
const Color grayColor = Color(0xff9CADBF);
const Color gradientColor1 = Color(0xff4ca6ed);
const Color gradientColor2 = Color(0xffcc66ff);
const Color gradientColor3 = Color(0xffef889b);
const Color darkBackGroundColor = Color(0xff222222);
const Color darkGrayColor = Color(0xff444654);

const colorizeColors = [
  gradientColor1,
  gradientColor2,
  gradientColor3
];

final linearGradient = const LinearGradient(colors: <Color>[
  gradientColor1,
  gradientColor2,
  gradientColor3
]).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0));

const colors = [
  gradientColor1,
  gradientColor2,
  gradientColor3
];

const String appName = "TrackMyFinance";
const String welcome = 'Welcome';
const String totalBalance = 'Total Balance';
const String strIncome = 'Income';
const String strExpense = 'Expense';
const String addTransaction = 'Add Transaction';
const String updateTransaction = 'Update Transaction';
const String strEnterYourName = 'Enter your Name';
const String strUserName = 'User Name';
const String strLetsGo = 'Lets Go';
const String strUserNamePrefs = 'userName';
const String strUpdateUserName = 'Edit your name';
const String strUpdate = 'Update';
const String strEnterValidName = 'Please enter a valid user Name!!!';
const String strRecent = "Recent Transactions";
const String transactions = "Transactions";
const String validAmount = "Please Enter a valid amount";
const String category = 'Category';
const String selectCategory = "Select Category";
const String note = 'Note';
const String searchNote = 'Search by note...';
const String validNote = "Please Add a Note";
const String dateFormat = 'DD-MM-YYYY';
const String validDate = "Please select a Date";
const String save = 'SAVE';
const String update = 'UPDATE';
const String dateFormatIntl = 'dd-MM-yyyy';
const String amountHintText = '0.00';
const String deleteTransaction = "Delete Transaction";
const String confirmDelete = "Confirm Delete";
const String areYouSure = "Are you sure you want to delete this transaction?";
const String clearDataText = "Are you sure!, you want to clear the app data?";
const String cancel = "CANCEL";
const String submit = "SUBMIT";
const String delete = "DELETE";
const String yes = "YES";
const String no = "NO";
const String close = "Close";
const String darkMode = 'Dark Mode';
const String lightMode = 'Lite Mode';
const String clearData = "Clear App Data";
const String share = "Share";
const String privacyPolicy = "Privacy Policy";
const String privacyPolicyContent = "Safety starts with understanding how developers collect and share your data. Data privacy and security practices may vary based on your use, region and age The developer provided this information and may update it over time.";
const String about = "About";
const String aboutContent = "$appName is a user-friendly money management application that enables seamless transaction tracking. It aids in maintaining control over expenditures and staying within the budget limit. Additionally, the application offers a detailed analysis of spending patterns.";
const String viewMore = "View More";
const String exitApp = 'Tap back again to Exit';
const String validCategory = "Please Select a valid category";
const String validateNote = "Please Enter Something";
const String exportExcel = "Excel";
const String applyFilter = "Apply Filter";
const String total = "Total: ";
const String totalIncome = "Income: ";
const String totalExpense = "Expense: ";
const String report = "Reports";
const String charts = "Charts";
const String deleteATransaction = 'Delete a Transaction?';
const String transactionDeleteContent = 'Swipe right to delete a Transaction';
const String contact = 'Contact Us';
const String pleaseAddCategory = "Please Add a Category";
const String ok = "OK";


const normalSizedBox = SizedBox(height: 20);
const smallSizedBox =  SizedBox(height: 10);
const miniSizedBox = SizedBox(height: 5,);

final List<CategoryListDataModel> categoryDataList = [
  CategoryListDataModel(category: "Income", categoryIcon: Icons.arrow_circle_down, isIncome: true),
  CategoryListDataModel(category: "Expense", categoryIcon: Icons.arrow_circle_up, isIncome: false)
];

showPopUP(BuildContext context,String title,String text) {
  return  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title:  Center(child: Text(title)),
          content:  Text(
              textAlign: TextAlign.justify,
              text),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(close),
            ),
          ],
        );
      });
}

howToDeletePopup(BuildContext context,String title) {
  return  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title:  Center(child: Text(title)),
          content:  SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/3.5,
            child: const Center(
              child: Image(image:  AssetImage('assets/gif/ezgif.com-video-to-gif.gif')),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(close),
            ),
          ],
        );
      });
}

void snackBar(context,String text){
  SnackBar snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    content: SizedBox(
    height: 50,
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          //color: Colors.red
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientColor1, gradientColor2, gradientColor3])
      ),
      child:  Center(
          child: Text(
            text,
            style: const TextStyle(
                color: whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          )),
    ),
  ),);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class StaticData{
  static String? userName;
  static bool? isDarkMode;
}

class ChartData {
  final String category;
  final double totalAmount;

  ChartData(this.category, this.totalAmount);
}

//Methods
Future<void> exportToExcel(List<Transaction> transactions) async {
  final workbook = Excel.createExcel();
  final sheet = workbook['Sheet1'];
  sheet.appendRow(['Date', 'Note', 'Income/Expense', 'Sub Category', 'Amount']);
  for (final transaction in transactions) {
    sheet.appendRow([
      DateFormat(dateFormatIntl).format(transaction.date!),
      transaction.note,
      transaction.isIncome == true ? "Income" : "Expense",
      transaction.subCategory,
      transaction.amount.toString(),
    ]);
  }
  final file = File('/storage/emulated/0/Download/pocket_money(${DateTime.now().millisecondsSinceEpoch}).xlsx');
  await file.writeAsBytes(workbook.encode()!);
  OpenFilex.open(file.path);
}

contactUs() async{
  String email = Uri.encodeComponent("developeradhil@gmail.com");
  String subject = Uri.encodeComponent("Feedback");
  String body = Uri.encodeComponent("");
  Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
  if (await launchUrl(mail)) {
    //email app opened
  }else{
    debugPrint("Mail app is not opened");
  }
}