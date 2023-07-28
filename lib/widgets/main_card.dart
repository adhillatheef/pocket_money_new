import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../constants.dart';


class MainCard extends StatelessWidget {
  final double income;
  final double expense;
  final double balance;
  const MainCard({Key? key, required this.income, required this.expense, required this.balance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      decoration: BoxDecoration(
          boxShadow:  const [
            BoxShadow(
              color: grayColor,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 10.0,
            ),
          ],
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              totalBalance,
              style: TextStyle(
                fontSize: 18,
                color: whiteColor.withOpacity(0.8),
              ),
            ),
            smallSizedBox,
            AutoSizeText(
              textAlign: TextAlign.center,
              maxLines: 1,
              balance.toStringAsFixed(2),
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: whiteColor),
            ),
            normalSizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: whiteColor.withOpacity(0.3),
                        radius: 15,
                        child: const Icon(
                          Icons.arrow_downward_rounded,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strIncome,
                              style: TextStyle(
                                fontSize: 18,
                                color: whiteColor.withOpacity(0.8),
                              ),
                            ),
                            AutoSizeText(income.toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Flexible(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        backgroundColor: whiteColor.withOpacity(0.3),
                        radius: 15,
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strExpense,
                              style: TextStyle(
                                fontSize: 18,
                                color: whiteColor.withOpacity(0.8),
                              ),
                            ),
                            AutoSizeText(expense.toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
