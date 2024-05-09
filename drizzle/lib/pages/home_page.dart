import 'package:drizzle/data/drinks_data.dart';
import 'package:drizzle/pages/drinks_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<DrinksData>(context, listen: false).initialiseDrinksList();
  }

  //text controller
  final newDrinksNameController = TextEditingController();

  //add other drinks
  void createNewDrinks() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Other Drinks"),
            backgroundColor: Colors.lightBlue,
            shadowColor: Colors.lightBlueAccent,
            content: TextField(
              controller: newDrinksNameController,
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
            ],
          );
        });
  }

  //go to drinks page
  void goToDrinksPage(String drinksName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DrinksPage(
            drinksName: drinksName,
          ),
        ));
  }

  //save other drinks
  void save() {
    //get drinks name from text controller
    String newDrinksName = newDrinksNameController.text;
    //add drinks to drinksList
    Provider.of<DrinksData>(context, listen: false).addDrinks(newDrinksName);
    //pop dialog box
    Navigator.pop(context);
    clear();
  }

  //cancel other drinks
  void cancel() {
    //pop dialog box
    Navigator.pop(context);
    clear();
  }

  //clear controllers
  void clear() {
    newDrinksNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrinksData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Drizzle'),
          backgroundColor: Colors.lightBlue,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewDrinks,
          backgroundColor: Colors.lightBlue,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: value.getDrinksList().length,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                tileColor: Colors.grey[200],
                title: Text(value.getDrinksList()[index].name),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () =>
                      goToDrinksPage(value.getDrinksList()[index].name),
                ),
              ));
            }),
      ),
    );
  }
}
