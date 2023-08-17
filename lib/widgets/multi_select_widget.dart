import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pocket_money_new/constants.dart';

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text(selectCategory),
      content: SingleChildScrollView(
        child: Column(
          children: [
            widget.items.isEmpty? Column(
              children: [
                Center(
                    child: Lottie.asset(
                        repeat: false,
                        'assets/lottie_files/134394-no-transaction.json')),
                const Center(child: Text(pleaseAddCategory),)
              ],
            ): const SizedBox(),
            ListBody(
              children: widget.items
                  .map((item) => CheckboxListTile(
                value: _selectedItems.contains(item),
                title: Text(item),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (isChecked) => _itemChange(item, isChecked!),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text(cancel, style: TextStyle(color: Colors.redAccent)),
        ),
        TextButton(
          onPressed: (){
            if(widget.items.isEmpty){
              Navigator.pop(context);
            }else{
              _submit();
            }
          },
          child:  Text(widget.items.isEmpty?ok:submit,style: const TextStyle(color: gradientColor1)),
        ),
      ],
    );
  }
}