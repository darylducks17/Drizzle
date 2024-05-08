import 'package:drizzle/components/details_tile.dart';
import 'package:drizzle/data/drinks_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore_for_file: must_be_immutable
class DrinksPage extends StatefulWidget {
  final String drinksName;

  const DrinksPage({
    super.key,
    required this.drinksName,
  });

  @override
  State<DrinksPage> createState() => DrinksPageState();
}

class DrinksPageState extends State<DrinksPage> {
  //checkbox was tapped
  void onCheckboxChanged(String drinksName, String detailsAmount) {
    Provider.of<DrinksData>(context, listen: false)
        .checkOffDetails(drinksName, detailsAmount);
  }

  //text controller for new amount
  final newAmountController = TextEditingController();

  //create new details for the drink
  void createNewDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text('Add Amount (ml)'),
          backgroundColor: Colors.lightBlue,
          shadowColor: Colors.lightBlueAccent,
          content: TextField(
            controller: newAmountController,
            cursorColor: Colors.blueGrey,
            decoration: const InputDecoration(
                hintText: 'Type here',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey))),
          ),
          actions: [
            //save button
            MaterialButton(
              onPressed: save,
              highlightColor: Colors.lightBlueAccent,
              child: const Text('Save'),
            ),
            //cancel button
            MaterialButton(
              onPressed: cancel,
              highlightColor: Colors.lightBlueAccent,
              child: const Text('Cancel'),
            ),
          ]),
    );
  }

  //save amount
  void save() {
    //get amount from text controller
    String newAmount = newAmountController.text;
    //add amount to details list
    Provider.of<DrinksData>(context, listen: false).addDetails(widget.drinksName, newAmount);
    //pop dialog box
    Navigator.pop(context);
    clear();
  }

  //cancel
  void cancel() {
    //pop dialog box
    Navigator.pop(context);
    clear();
  }

  //clear
  void clear() {
    newAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrinksData>(
        builder: (context, value, child) => Scaffold(
            appBar: AppBar(
              title: Text(widget.drinksName),
              backgroundColor: Colors.lightBlue,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: createNewDetails,
              backgroundColor: Colors.lightBlue,
              child: const Icon(Icons.add),
            ),
            body: ListView.builder(
                itemCount: value.numberOfDetailsInDrinks(widget.drinksName),
                itemBuilder: (context, index) {
                  return Card(
                      child: DetailsTile(
                    amount: value
                        .getRelevantDrinks(widget.drinksName)
                        .details[index]
                        .amount,
                    isCompleted: value
                        .getRelevantDrinks(widget.drinksName)
                        .details[index]
                        .isCompleted,
                    onCheckboxChanged: (val) => onCheckboxChanged(
                        widget.drinksName,
                        value
                            .getRelevantDrinks(widget.drinksName)
                            .details[index]
                            .amount),
                  ));
                })));
  }
}
