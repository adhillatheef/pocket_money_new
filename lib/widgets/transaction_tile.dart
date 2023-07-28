import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pocket_money_new/theme_bloc/theme_bloc.dart';

import '../constants.dart';
import '../repository/model.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    Key? key,
    required this.transaction, required this.onTap, required this.navigateFunction,
  }) : super(key: key);

  final Transaction transaction;
  final Function onTap;
  final Function() navigateFunction;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeData>(
  builder: (context, state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 5),
      child: Dismissible(
        key:  Key(transaction.id!),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (direction) {
          return confirmDismiss(context);
        },
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red[400],
          ),
          child:  const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  Text(deleteTransaction,
                    style: TextStyle(
                    color: whiteColor,
                    fontSize: 18,
                  ),)
                ],
              ),
            ),
          ),
        ),
        child: ListTile(
          onTap: navigateFunction,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color:grayColor.withOpacity(0.5), )),
          tileColor: state==ThemeData.dark()?darkGrayColor:whiteColor,
          leading: CircleAvatar(
              backgroundColor: grayColor.withOpacity(0.3),
              child: Icon(transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,color:transaction.isIncome ?Colors.green:Colors.redAccent,)),
          title: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            transaction.subCategory!,style: TextStyle(color: transaction.isIncome ? Colors.green: Colors.redAccent,
          ),),
          subtitle: Text(
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              transaction.note!),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(transaction.amount!.toStringAsFixed(2),style: TextStyle(
                  fontSize: 16,
                  color: transaction.isIncome ? Colors.green:Colors.redAccent
              ),),
              Text(DateFormat(dateFormatIntl).format(transaction.date!))
            ],
          ),
        ),
      ),
    );
  },
);
  }

  Future<bool> confirmDismiss(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text(confirmDelete),
            content: const Text(areYouSure),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(cancel),
              ),
              TextButton(
                onPressed: () {
                  onTap();
                  Navigator.of(context).pop(true);
                },
                child: const Text(delete,style: TextStyle(color: Colors.red),),
              ),
            ],
          );
        });
  }
}