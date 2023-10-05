import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';

class subitemlist extends StatefulWidget {
  const subitemlist({Key? key}) : super(key: key);

  @override
  State<subitemlist> createState() => _subitemlistState();
}

class _subitemlistState extends State<subitemlist> {
  bool isLoading = false;
  final Stream<QuerySnapshot> myStream =
      FirebaseFirestore.instance.collection('items').snapshots();
  CollectionReference subItemsCollection =
      FirebaseFirestore.instance.collection('sub_items');

  Future<List<QueryDocumentSnapshot>> fetchItems() async {
    QuerySnapshot snapshot = await subItemsCollection.get();
    return snapshot.docs;
  }

  TextEditingController searchcontroler = TextEditingController();
  TextEditingController subitemcontroler = TextEditingController();

  Future<void> updateitem(
    String documentId,
    String newitem,
  ) async {
    setState(() {
      isLoading = true;
    });

    await FirebaseFirestore.instance
        .collection('sub_items')
        .doc(documentId)
        .update({
      'sub_item': newitem,
    }).then((value) {
      Fluttertoast.showToast(
          msg: "Update",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError(
      (err) {
        print('Error: $err');
        EasyLoading.dismiss();
        setState(() {
          isLoading = false;
        }); // Prints 401.
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteItem(
    String documentId,
  ) async {
    setState(() {
      isLoading = true;
    });
    CollectionReference collection =
        FirebaseFirestore.instance.collection('sub_items');

    await collection.doc(documentId).delete().then((value) {
      Fluttertoast.showToast(
          msg: "delete",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError(
      (err) {
        print('Error: $err');
        EasyLoading.dismiss();
        setState(() {
          isLoading = false;
        }); // Prints 401.
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub Items'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<QueryDocumentSnapshot>>(
              future: fetchItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                List<QueryDocumentSnapshot> data = snapshot.data!;
                return Visibility(
                  visible: data.isNotEmpty,
                  replacement: Center(
                    child: Text(
                      'No SubItem',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 204, 203, 204),
                                // Specify your desired background color
                                borderRadius: BorderRadiusDirectional.only(
                                    topStart: Radius.circular(
                                        16)) // Specify border radius
                                ),
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    // Handle menu item selection
                                    switch (value) {
                                      case 'Option 1':
                                        // Handle Option 1 selection
                                        setState(() {
                                          showBottomSheet(
                                              context: context,
                                              builder: ((context) => Container(
                                                    height: 300,
                                                    width: double.infinity,
                                                    child: Column(
                                                      children: [
                                                        StreamBuilder<
                                                            QuerySnapshot>(
                                                          stream: myStream,
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot<
                                                                      QuerySnapshot>
                                                                  snapshot) {
                                                            if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                  'Error: ${snapshot.error}');
                                                            }

                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return Center(
                                                                  child:
                                                                      CircularProgressIndicator());
                                                            }

                                                            // access the documents in the snapshot
                                                            final List<
                                                                    DocumentSnapshot>
                                                                documents =
                                                                snapshot
                                                                    .data!.docs;

                                                            // build your UI using the data from the snapshot
                                                            return TypeAheadFormField(
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please Select Item from Drop down list';
                                                                }
                                                                return null;
                                                              },
                                                              suggestionsBoxDecoration:
                                                                  SuggestionsBoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              textFieldConfiguration:
                                                                  TextFieldConfiguration(
                                                                controller: searchcontroler =
                                                                    TextEditingController(
                                                                        text: data[index]
                                                                            [
                                                                            'item']),
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  label: Text(
                                                                    "Search Item",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                              suggestionsCallback:
                                                                  (query) async {
                                                                // filter the documents based on the query
                                                                final filteredDocuments = documents.where((doc) => doc[
                                                                        'item']
                                                                    .toLowerCase()
                                                                    .contains(query
                                                                        .toLowerCase()));
                                                                // create a list of suggestions from the filtered documents
                                                                final suggestions =
                                                                    filteredDocuments
                                                                        .map((doc) =>
                                                                            doc['item'])
                                                                        .toList();
                                                                return await suggestions;
                                                              },
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      suggestion) {
                                                                return ListTile(
                                                                  title: Text(
                                                                      suggestion),
                                                                );
                                                              },
                                                              onSuggestionSelected:
                                                                  (suggestion) {
                                                                setState(() {
                                                                  searchcontroler
                                                                          .text =
                                                                      suggestion;
                                                                });
                                                              },
                                                            );
                                                          },
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: TextField(
                                                            controller: subitemcontroler =
                                                                TextEditingController(
                                                                    text: data[
                                                                            index]
                                                                        [
                                                                        'sub_item']),
                                                            decoration:
                                                                InputDecoration(
                                                                    labelText:
                                                                        'Sub Item',
                                                                    border:
                                                                        OutlineInputBorder()),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              updateitem(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .id,
                                                                subitemcontroler
                                                                    .text,
                                                              );

                                                              subitemcontroler
                                                                  .clear();
                                                            },
                                                            child:
                                                                Text('Update'))
                                                      ],
                                                    ),
                                                  )));
                                        });
                                        break;
                                      case 'Option 2':
                                        // Handle Option 2 selection
                                        setState(() {
                                          deleteItem(data[index].id);
                                        });
                                        break;
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'Option 1',
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'Option 2',
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          Text('Delete'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                title: Text(
                                  data[index]['item'].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data[index]['sub_item'].toString(),
                                    ),
                                    // Text(
                                    //   data[index]['sub_item'].toString(),
                                    // ),
                                  ],
                                )),
                          ),
                        );
                      }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
