import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:raju/Calculations/calculation1.dart';
import 'package:raju/Calculations/calculation2.dart';
import 'package:raju/Calculations/calculation3.dart';
import 'package:raju/Calculations/calculation4.dart';

import 'Calculations/Purity_Calculation.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text("Calculate Prices")),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Adjust the value as per your preference
                  ),
                  child: ExpansionTile(
                    title: Text('Calculate Prices'),
                    children: [calculation1()],
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Adjust the value as per your preference
                  ),
                  child: ExpansionTile(
                    title: Text('Calculate Prices'),
                    children: [calculation2()],
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Adjust the value as per your preference
                  ),
                  child: ExpansionTile(
                    title: Text('Calculate Prices'),
                    children: [calculation3()],
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Adjust the value as per your preference
                  ),
                  child: ExpansionTile(
                    title: Text('Calculate Prices'),
                    children: [calculation4()],
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Adjust the value as per your preference
                  ),
                  child: ExpansionTile(
                    title: Text('Calculate Old Silver '),
                    children: [Purity()],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
