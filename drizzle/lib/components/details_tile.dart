// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class DetailsTile extends StatelessWidget {
  final String amount;
  final bool isCompleted;
  void Function(bool?)? onCheckboxChanged;

  DetailsTile(
      {super.key,
      required this.amount,
      required this.isCompleted,
      required this.onCheckboxChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[200],
        child: ListTile(
          title: Text(
            "${amount}ml",
          ),
          trailing: Checkbox(
            activeColor: Colors.grey,
            value: isCompleted,
            onChanged: (value) => onCheckboxChanged!(value),
          ),
        )
     );
  }
}
