import 'package:drizzle/datetime/date_time.dart';
import 'package:drizzle/models/details.dart';
import 'package:drizzle/models/drinks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class HiveDatabase {
  //reference hive box
  final _myBox = Hive.box("drinks_database1");

  //check if there is already data stored, if not, record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("previous data does NOT exist");
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("previous data does not exist");
      return true;
    }
  }

  //return start date as yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  //write data
  void saveToDatabase(List<Drinks> drinks) {
    //convert drinks objects into lists of strings so that it can save in hive
    final drinksList = convertObjectToDrinksList(drinks);
    final detailsList = convertObjectToDetailsList(drinks);

    //check if any exercises have been done and then put a 0 or 1 for each yyyymmdd date
    if (detailsCompleted(drinks)) {
      _myBox.put("COMPLETION_STAUS_${todaysDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STAUS_${todaysDateYYYYMMDD()}", 0);
    }

    //save data into hive
    _myBox.put("DRINKS", drinksList);
    _myBox.put("DETAILS", detailsList);
  }

  //read data, and return a list of drinks
  List<Drinks> readFromDatabase() {
    List<Drinks> mySavedDrinks = [];

    List<String> drinkNames = _myBox.get("DRINKS");
    final drinkDetails = _myBox.get("DETAILS");

    //create drink objects
    for (int i = 0; i < drinkNames.length; i++) {
      //each drink can have multiple details
      List<Details> detailsInEachDrink = [];

      for (int j = 0; j < drinkDetails[i].length; j++) {
        //add each detail into a list
        detailsInEachDrink.add(
          Details(
            amount: drinkDetails[i][j][0],
            isCompleted: drinkDetails[i][j][1] == "true" ? true : false,
          ),
        );
      }
      //create individual drinks
      Drinks drinks = Drinks(name: drinkNames[i], details: detailsInEachDrink);
      //add individual drinks to overall list
      mySavedDrinks.add(drinks);
    }
    return mySavedDrinks;
  }

  //check if any details have been checked off
  bool detailsCompleted(List<Drinks> drinks) {
    //go through each drink
    for (var drink in drinks) {
      //go through each detail in drinks
      for (var detail in drink.details) {
        if (detail.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  //return completion status of a given date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    //returns 0 or 1, if null return 0
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }
}

//converts drinks objects into a list
List<String> convertObjectToDrinksList(List<Drinks> drinks) {
  List<String> drinksList = [
    //eg [water, coffee, tea]
  ];

  for (int i = 0; i < drinks.length; i++) {
    drinksList.add(
      drinks[i].name,
    );
  }
  return drinksList;
}

//converts the details in drink objects into a list of strings
List<List<List<String>>> convertObjectToDetailsList(List<Drinks> drinks) {
  List<List<List<String>>> detailsList = [
    /* 
    [
      Water
      [ [ 100ml] [200ml] [300ml]]

      Coffee
      [ [ 100ml] [200ml] [300ml]]
    ]
*/
  ];

  //go through each drink
  for (int i = 0; i < drinks.length; i++) {
    //get exercises form each workout
    List<Details> detailsInDrinks = drinks[i].details;

    List<List<String>> individualDrinks = [
      // Water
      // [ [100ml] [200ml]]
    ];

    //go through each detail in detailsList
    for (int j = 0; j < detailsInDrinks.length; j++) {
      List<String> individualDetails = [
        // [100ml][200ml]
      ];
      individualDetails.addAll(
        [
          detailsInDrinks[j].amount,
          detailsInDrinks[j].isCompleted.toString(),
        ],
      );
      individualDrinks.add(individualDetails);
    }
    detailsList.add(individualDrinks);
  }
  return detailsList;
}
