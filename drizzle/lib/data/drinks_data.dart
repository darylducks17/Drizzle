import 'package:flutter/material.dart';
import '../models/details.dart';
import '../models/drinks.dart';

class DrinksData extends ChangeNotifier {
  /*
  Drinks Data Structure 
  - This list contains the different drinks 
  - Each drink has an amount that the user has consumed
  */

//default drink
  List<Drinks> drinksList = [
    Drinks(name: "Water", details: [Details(amount: "100")])
  ];

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
  }

  //add amount drank to a drink
  void addDetails(String drinksName, String detailsAmount) {
    //find the relevant drink
    Drinks relevantDrinks = getRelevantDrinks(drinksName);

    relevantDrinks.details.add(
      Details(amount: detailsAmount),
    );
    notifyListeners();
  }

  //check off amount in details
  void checkOffDetails(String drinksName, String detailsAmount) {
    Details relevantDetails = getRelevantDetails(drinksName, detailsAmount);
    //check off boolean to show user completed the amount drank
    relevantDetails.isCompleted = !relevantDetails.isCompleted;

    notifyListeners();
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
}
