import 'package:drizzle/data/drinks_data.dart';
import 'package:flutter/material.dart';
import 'package:drizzle/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  //initialise hive
  await Hive.initFlutter();
  
  //open a hive box - the database
  await Hive.openBox("drinks_database1");
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DrinksData(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
