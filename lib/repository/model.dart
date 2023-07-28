import 'package:hive/hive.dart';
part 'model.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  double? amount;
  @HiveField(1)
  bool isIncome;
  @HiveField(2)
  DateTime? date;
  @HiveField(3)
  String? id;
  @HiveField(4)
  String? note;
  @HiveField(5)
  String? subCategory;
  Transaction({this.amount, this.isIncome = false, this.date, this.id, this.note, this.subCategory});

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, isIncome: $isIncome, note: $note, date: $date, subCategory: $subCategory)';
  }
}