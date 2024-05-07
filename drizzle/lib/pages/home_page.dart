import 'package:drizzle/data/drinks_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  //text controller
  final newDrinksNameController = TextEditingController();

  //add other drinks
  void createNewDrinks() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Other Drinks"),
            content: TextField(
              controller: newDrinksNameController,
            ),
            actions: [
              //save button
              MaterialButton(
                onPressed: save,
                child: const Text('Save'),
              ),
              //cancel button
              MaterialButton(
                onPressed: cancel,
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
          builder: (context) => DrinksPage(),
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
          /*flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [
                Colors.purpleAccent,
                Colors.blueAccent,
              ],
            ),
          ),
        ),*/
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewDrinks,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.getDrinksList().length,
          itemBuilder: (context, index) => ListTile(
            title: Text(value.getDrinksList()[index].name),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: goToDrinksPage,
            ),
          ),
        ),
      ),
    );
  }
}
