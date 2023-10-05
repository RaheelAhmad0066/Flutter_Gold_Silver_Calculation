import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';

class admin extends StatefulWidget {
  const admin({Key? key}) : super(key: key);

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  final TextEditingController t1 = TextEditingController();
  final TextEditingController pricecontroler = TextEditingController();

  final TextEditingController t2 = TextEditingController();
  final TextEditingController t3 = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('items');
  final subitems = FirebaseFirestore.instance.collection('sub_items');
  final Stream<QuerySnapshot> myStream =
      FirebaseFirestore.instance.collection('items').snapshots();
  final country_key = GlobalKey<FormState>();
  final subitem_key = GlobalKey<FormState>();
  final subitem_key1 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Column(
              children: [
                Text("Add New Item"),
                Form(
                    key: country_key,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: t1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Item';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                t1.clear();
                              },
                            ),
                            label: Text(
                              "Add New Item",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: pricecontroler,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Item';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                pricecontroler.clear();
                              },
                            ),
                            label: Text(
                              "Add price",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final double? price =
                          double.tryParse(pricecontroler.text);
                      if (country_key.currentState!.validate()) {
                        setState(() {});
                        String id = FirebaseFirestore.instance
                            .collection("items")
                            .doc()
                            .id;
                        await firestore.doc(id).set({
                          'item': t1.text.toString(),
                          'price': price.toString(),
                          'id': id,
                        }).then((value) {
                          Fluttertoast.showToast(
                              msg: "New Item added",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 4,
                              backgroundColor: Colors.black38,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          EasyLoading.dismiss();
                        }).catchError(
                          (err) {
                            print('Error: $err');
                            EasyLoading.dismiss(); // Prints 401.
                          },
                        );
                        t1.clear();
                        pricecontroler.clear();
                      }
                    },
                    child: Text("Save")),
                SizedBox(
                  height: 20,
                ),
                Text("Add New Sub Item"),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: subitem_key,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: myStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      // access the documents in the snapshot
                      final List<DocumentSnapshot> documents =
                          snapshot.data!.docs;

                      // build your UI using the data from the snapshot
                      return TypeAheadFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Select Item from Drop down list';
                          }
                          return null;
                        },
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: t2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                t2.clear();
                              },
                            ),
                            label: Text(
                              "Search Item",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        suggestionsCallback: (query) async {
                          // filter the documents based on the query
                          final filteredDocuments = documents.where((doc) =>
                              doc['item']
                                  .toLowerCase()
                                  .contains(query.toLowerCase()));
                          // create a list of suggestions from the filtered documents
                          final suggestions = filteredDocuments
                              .map((doc) => doc['item'])
                              .toList();
                          return await suggestions;
                        },
                        itemBuilder: (BuildContext context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          setState(() {
                            t2.text = suggestion;
                          });
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: subitem_key1,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Sub item';
                      }
                      return null;
                    },
                    controller: t3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          t3.clear();
                        },
                      ),
                      label: Text(
                        "Sub Item",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (subitem_key.currentState!.validate() &&
                          subitem_key1.currentState!.validate()) {
                        setState(() {});
                        String id = FirebaseFirestore.instance
                            .collection("sub_items")
                            .doc()
                            .id;
                        await subitems.doc(id).set({
                          'item': t2.text.toString(),
                          'sub_item': t3.text.toString(),
                          'id': id,
                        }).then((value) {
                          Fluttertoast.showToast(
                              msg: "New Sub Item added",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 4,
                              backgroundColor: Colors.black38,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }).catchError(
                          (err) {
                            print('Error: $err');
                            EasyLoading.dismiss(); // Prints 401.
                          },
                        );
                        t2.clear();
                        t3.clear();
                      }
                    },
                    child: Text("Save"))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
