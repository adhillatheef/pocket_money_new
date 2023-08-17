import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pocket_money_new/bloc/categories_bloc.dart';
import '../constants.dart';

class AddCategoryWidget extends StatelessWidget {
  final bool isIncome;
  final categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AddCategoryWidget({super.key, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    String incomeOrExpense = isIncome ? "Income" : "Expense";
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        final incomeCategoryList = state.incomeCategoryList;
        final expenseCategoryList = state.expenseCategoryList;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Center(
              child: Text(
                "Add New $incomeOrExpense Category",
                style: TextStyle(
                  foreground: Paint()..shader = linearGradient,
                ),
              )),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: categoryController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText: "Enter new category name",
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return "Enter a valid category";
                        } else{
                          return null;
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState!=null && _formKey.currentState!.validate()) {
                              final id = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              if (isIncome) {
                                context.read<CategoriesBloc>().add(
                                    AddIncomeCategory(
                                        id: id, categoryName: categoryController.text));
                                debugPrint("Income Category Added");
                              } else {
                                context.read<CategoriesBloc>().add(
                                    AddExpenseCategory(
                                        id: id, categoryName: categoryController.text));
                                debugPrint("Expense Category Added");
                              }
                              categoryController.clear();
                            }
                          },
                          child: const Text("Add"),
                        ),
                      ],
                    ),
                    isIncome && incomeCategoryList.isEmpty
                        ? Center(
                      child: Lottie.asset(
                          repeat: false,
                          'assets/lottie_files/134394-no-transaction.json'),
                    )
                        : const SizedBox(),
                    !isIncome && expenseCategoryList.isEmpty
                        ? Center(
                      child: Lottie.asset(
                          repeat: false,
                          'assets/lottie_files/134394-no-transaction.json'),
                    )
                        : const SizedBox(),
                    Column(
                      children: isIncome
                          ? incomeCategoryList.map((e) {
                        final int index = incomeCategoryList
                            .indexWhere((element) => element == e);
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              )),
                          child: ListTile(
                            title: Text(
                                incomeCategoryList[index].categoryName),
                            trailing: IconButton(
                                onPressed: () {
                                  context.read<CategoriesBloc>().add(
                                      DeleteIncomeCategory(
                                          incomeCategoryList[index]));
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ),
                        );
                      }).toList()
                          : expenseCategoryList.map((e) {
                        final int index = expenseCategoryList
                            .indexWhere((element) => element == e);
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              )),
                          child: ListTile(
                            title: Text(
                                expenseCategoryList[index].categoryName),
                            trailing: IconButton(
                                onPressed: () {
                                  context.read<CategoriesBloc>().add(
                                      DeleteExpenseCategory(
                                          expenseCategoryList[index]));
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ),
                        );
                      }).toList(),
                    )
                    // Rest of the widget tree
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text("Ok"))
          ],
        );
      },
    );
  }
}
