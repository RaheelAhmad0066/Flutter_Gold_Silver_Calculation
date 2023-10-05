import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'Purity_Calculation.dart';

class Purity extends StatefulWidget {
  const Purity({Key? key}) : super(key: key);

  @override
  State<Purity> createState() => _PurityState();
}

class _PurityState extends State<Purity> {
  final Stream<QuerySnapshot> myStream =
      FirebaseFirestore.instance.collection('items').snapshots();
  final Stream<QuerySnapshot> mStream =
      FirebaseFirestore.instance.collection('sub_items').snapshots();
  TextEditingController itemController = TextEditingController();
  TextEditingController subItemController = TextEditingController();
  TextEditingController purityController = TextEditingController(text: '70');
  String? selectedItemId;
  dynamic itemPrice = 0;
  double weight = 0;
  double puritypercentage = 0.0;
  double premium = 0;
  double result = 0;
  double purity = 0;
  @override
  void dispose() {
    calculatePurity(weight);
    calculate(puritypercentage);
    // TODO: implement dispose
    super.dispose();
  }

  void calculatePurity(double inputWeight) {
    weight = inputWeight;
    setState(() {
      if (weight <= 40) {
        premium = 150;
      } else if (weight >= 40) {
        premium = 200;
      }
    });
  }

  void calculate(double inputpurity) {
    puritypercentage = inputpurity;
    setState(() {
      purity = weight * puritypercentage / 100;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              calculatePurity(inputWeight);
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
            onChanged: (value) {
              double inputWeight = double.tryParse(value) ?? 0;
              calculate(inputWeight);
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Purity',
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
            readOnly: true,
            controller: TextEditingController(text: premium.toString()),
            decoration: InputDecoration(
              labelText: 'Premium',
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
                "${weight} gm",
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
                'Purity',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Text(
                "${purity.toStringAsFixed(2)} %",
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
                'Premium',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Text(
                "${premium.toStringAsFixed(2)} gm",
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
                "Rs ${(purity * double.parse(itemPrice.toString()) + premium).toStringAsFixed(0)}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
