import 'package:flutter/material.dart';

class DrinksPage extends StatefulWidget {
  final String drinksName;
  const DrinksPage({super.key, required this.drinksName});

  @override
  State<DrinksPage> createState() => DrinksPageState();
}

class DrinksPageState extends State<DrinksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.drinksName)),
    );
  }
}
