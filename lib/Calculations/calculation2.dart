import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'Purity_Calculation.dart';

class calculation2 extends StatefulWidget {
  const calculation2({Key? key}) : super(key: key);

  @override
  State<calculation2> createState() => _calculation2State();
}

class _calculation2State extends State<calculation2> {
  final Stream<QuerySnapshot> myStream =
      FirebaseFirestore.instance.collection('items').snapshots();
  final Stream<QuerySnapshot> mStream =
      FirebaseFirestore.instance.collection('sub_items').snapshots();
  TextEditingController itemController = TextEditingController();
  TextEditingController subItemController = TextEditingController();

  String? selectedItemId;
  dynamic itemPrice = 0;
  double weight = 0;
  double wastage = 0;
  double makingCharges = 0;
  double tottalvalue = 0;
  double result = 0;

  double second = 0;
  @override
  void dispose() {
    calculateSilverValues(weight);
    calculateGoldValues(weight);
    // TODO: implement dispose
    super.dispose();
  }

  void calculateGoldValues(double inputWeight) {
    setState(() {
      weight = inputWeight;
      if (weight >= 1 && weight < 2) {
        wastage = 0.250;
      } else if (weight >= 2 && weight < 3) {
        wastage = 0.300;
      } else if (weight == 3) {
        wastage = 0.4;
      } else if (weight > 3 && weight <= 4) {
        wastage = 0.6;
      } else if (weight > 4 && weight <= 7) {
        wastage = 0.7;
      } else if (weight > 7 && weight <= 8) {
        wastage = 0.8;
      } else if (weight > 8) {
        wastage = weight * 0.1;
      } else {
        wastage = 0.0;
      }

      // Making charges
      if (weight <= 4) {
        makingCharges = 400;
      } else if (weight > 4 && weight <= 6) {
        makingCharges = 500;
      } else if (weight > 6) {
        makingCharges = (weight - 6) * 100 + 500;
      } else {
        // Handle invalid weight
        makingCharges = 0;
      }
    });
  }

  void calculateSilverValues(double inputWeight) {
    setState(() {
      weight = inputWeight;
      if (weight < 25) {
        wastage = 3;
      } else if (weight >= 25 && weight <= 40) {
        wastage = 4;
      } else if (weight > 40 && weight <= 60) {
        wastage = 5;
      } else if (weight > 60 && weight <= 80) {
        wastage = 7;
      } else if (weight > 80 && weight <= 100) {
        wastage = 8;
      } else if (weight > 100) {
        // Handle weights outside the specified ranges
        wastage = weight * 0.08;
      } else {
        wastage = 0.0;
      }

      if (weight <= 40) {
        makingCharges = 300;
      } else if (weight > 40 && weight <= 70) {
        makingCharges = 400;
      } else if (weight > 70 && weight <= 100) {
        makingCharges = 500;
      } else if (weight > 100) {
        makingCharges = 6 * weight - 100;
      } else {
        // Handle invalid weight
        makingCharges = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    tottalvalue = weight + wastage;
    second = tottalvalue * double.parse(itemPrice.toString());
    result = second + makingCharges;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: myStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Access the documents in the snapshot
              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

              // Build your UI using the data from the snapshot
              return TypeAheadFormField<String>(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an item from the drop-down list';
                  }
                  return null;
                },
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                textFieldConfiguration: TextFieldConfiguration(
                  controller: itemController,
                  decoration: InputDecoration(
                    isDense: true,
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: 'Items',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                suggestionsCallback: (query) async {
                  // Filter the documents based on the query
                  final filteredDocuments = documents.where((doc) =>
                      doc['item'].toLowerCase().contains(query.toLowerCase()));
                  // Create a list of suggestions from the filtered documents
                  final suggestions = filteredDocuments
                      .take(2)
                      .map((doc) => doc['item'] as String)
                      .toList();
                  return suggestions;
                },
                itemBuilder: (BuildContext context, String suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (String suggestion) {
                  final selectedDocument =
                      documents.firstWhere((doc) => doc['item'] == suggestion);
                  final price = selectedDocument['price'];

                  setState(() {
                    itemController.text = suggestion;
                    itemPrice = price;
                    final itemType = selectedDocument['type'];
                    if (itemType == 'Gold') {
                      calculateGoldValues(weight);
                    } else if (itemType == 'Silver') {
                      calculateSilverValues(weight);
                    }
                    return;
                  });
                },
              );
            },
          ),
          SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: mStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Access the documents in the snapshot
              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

              // Filter the documents based on the selected item
              final filteredDocuments = documents.where((doc) =>
                  doc['item'].toLowerCase() ==
                  itemController.text.toLowerCase());

              // Build your UI using the filtered documents
              return TypeAheadFormField<String>(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a sub-item from the drop-down list';
                  }
                  return null;
                },
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                textFieldConfiguration: TextFieldConfiguration(
                  controller: subItemController,
                  decoration: InputDecoration(
                    isDense: true,
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: 'Sub Items',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                suggestionsCallback: (query) async {
                  // Filter the documents based on the query and selected item
                  final filteredSubItems = filteredDocuments.where((doc) =>
                      doc['sub_item']
                          .toLowerCase()
                          .contains(query.toLowerCase()));
                  // Create a list of suggestions from the filtered sub-items
                  final suggestions = filteredSubItems
                      .map((doc) => doc['sub_item'] as String)
                      .toList();
                  return suggestions;
                },
                itemBuilder: (BuildContext context, String suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (String suggestion) {
                  setState(() {
                    subItemController.text = suggestion;
                    selectedItemId = filteredDocuments.firstWhere(
                        (doc) => doc['sub_item'] == suggestion)['id'];
                  });
                },
              );
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) {
              double inputWeight = double.tryParse(value) ?? 0;

              if (itemController.text == 'Gold') {
                calculateGoldValues(inputWeight);
              } else if (itemController.text == 'Silver') {
                calculateSilverValues(inputWeight);
              }
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Weight',
              labelStyle: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: TextEditingController(text: wastage.toStringAsFixed(3)),
            keyboardType: TextInputType.number,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Wastage',
              labelStyle: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: TextEditingController(text: makingCharges.toString()),
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Making Charges',
              labelStyle: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Item Rate',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Text(
                "Rs ${itemPrice.toString()}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weight',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Text(
                "${weight.toStringAsFixed(3)} gm",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Wastage',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Text(
                "${wastage.toStringAsFixed(3)} gm",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Making Charges',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Text(
                "Rs ${makingCharges}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total =',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Text(
                "Rs ${result.toStringAsFixed(0)}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Colors.red),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
