import 'package:drizzle/data/hive_database.dart';
import 'package:flutter/material.dart';
import '../models/details.dart';
import '../models/drinks.dart';

class DrinksData extends ChangeNotifier {
  final db = HiveDatabase();
  /*
  Drinks Data Structure 
  - This list contains the different drinks 
  - Each drink has an amount that the user has consumed
  */

//default drink
  List<Drinks> drinksList = [
    Drinks(name: "Water", details: [Details(amount: "100")]),
    Drinks(name: "Coffee", details: [Details(amount: "100")]),
    Drinks(name: "Tea", details: [Details(amount: "100")]),
    Drinks(name: "Soda", details: [Details(amount: "100")]),
    Drinks(name: "Alcohol", details: [Details(amount: "100")]),
  ];

  //if there are drinks already in db, then get that list
  void initialiseDrinksList() {
    if (db.previousDataExists()) {
      drinksList = db.readFromDatabase();
    }
    // otherwise use default
    else {
      db.saveToDatabase(drinksList);
    }
  }

//get list of drinks
  List<Drinks> getDrinksList() {
    return drinksList;
  }

  //get length of given drinks
  int numberOfDetailsInDrinks(String drinksName) {
    Drinks relevantDrinks = getRelevantDrinks(drinksName);
    return relevantDrinks.details.length;
  }

  //add a drink
  void addDrinks(String name) {
    //add a new drink with a blank list of amount drank
    drinksList.add(Drinks(name: name, details: []));
    notifyListeners();
    //save to db
    db.saveToDatabase(drinksList);
  }

  //add amount drank to a drink
  void addDetails(String drinksName, String detailsAmount) {
    //find the relevant drink
    Drinks relevantDrinks = getRelevantDrinks(drinksName);

    relevantDrinks.details.add(
      Details(amount: detailsAmount),
    );
    notifyListeners();
    //save to db
    db.saveToDatabase(drinksList);
  }

  //check off amount in details
  void checkOffDetails(String drinksName, String detailsAmount) {
    Details relevantDetails = getRelevantDetails(drinksName, detailsAmount);
    //check off boolean to show user completed the amount drank
    relevantDetails.isCompleted = !relevantDetails.isCompleted;

    notifyListeners();
    //save to db
    db.saveToDatabase(drinksList);
  }

  //return relevant drinks object, given a drinks name
  Drinks getRelevantDrinks(String drinksName) {
    Drinks relevantDrinks =
        drinksList.firstWhere((drinks) => drinks.name == drinksName);
    return relevantDrinks;
  }

  //return relevant details object, given a drinks name and details amount
  Details getRelevantDetails(String drinksName, String detailsAmount) {
    //find relevant drinks first
    Drinks relevantDrinks = getRelevantDrinks(drinksName);
    //then find the relevant details for that drink
    Details relevantDetails = relevantDrinks.details
        .firstWhere((details) => details.amount == detailsAmount);
    return relevantDetails;
  }

  //get start date
  String getStartDate() {
    return db.getStartDate();
  }

}
