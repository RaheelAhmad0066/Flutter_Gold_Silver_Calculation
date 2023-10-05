import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ItemsData extends StatefulWidget {
  const ItemsData({Key? key}) : super(key: key);

  @override
  State<ItemsData> createState() => _ItemsDataState();
}

class _ItemsDataState extends State<ItemsData> {
  bool isLoading = false;
  final Stream<QuerySnapshot> myStream =
      FirebaseFirestore.instance.collection('items').snapshots();
  CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('items');
  CollectionReference subItemsCollection =
      FirebaseFirestore.instance.collection('sub_items');

  Future<List<QueryDocumentSnapshot>> fetchItems() async {
    QuerySnapshot snapshot = await itemsCollection.get();
    return snapshot.docs;
  }

  TextEditingController itemController = TextEditingController();
  TextEditingController pricecontroler = TextEditingController();
  // TextEditingController subitems1 = TextEditingController();
  // TextEditingController subitems2 = TextEditingController();

  Future<void> updateitem(
    String documentId,
    String newTitle,
    double price,
  ) async {
    setState(() {
      isLoading = true;
    });

    await FirebaseFirestore.instance
        .collection('items')
        .doc(documentId)
        .update({
      'item': newTitle,
      'price': price,
    }).then((value) {
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
        FirebaseFirestore.instance.collection('items');

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

  // ignore: prefer_typing_uninitialized_variables

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items Data'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
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
                      'No Item',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                                                builder: ((context) =>
                                                    Container(
                                                      height: 300,
                                                      width: double.infinity,
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: TextField(
                                                              readOnly: true,
                                                              controller: itemController =
                                                                  TextEditingController(
                                                                      text: data[
                                                                              index]
                                                                          [
                                                                          'item']),
                                                              decoration: InputDecoration(
                                                                  labelText:
                                                                      'Item name',
                                                                  border:
                                                                      OutlineInputBorder()),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: TextField(
                                                              readOnly: true,
                                                              controller: pricecontroler = TextEditingController(
                                                                  text: snapshot
                                                                      .data![
                                                                          index]
                                                                          [
                                                                          'price']
                                                                      .toString()),
                                                              decoration:
                                                                  InputDecoration(
                                                                      labelText:
                                                                          'Price',
                                                                      border:
                                                                          OutlineInputBorder()),
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                final double?
                                                                    pricee =
                                                                    double.tryParse(
                                                                        pricecontroler
                                                                            .text);
                                                                if (pricee !=
                                                                    null) {
                                                                  updateitem(
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .id,
                                                                    itemController
                                                                        .text,
                                                                    pricee,
                                                                  );
                                                                }
                                                                itemController
                                                                    .clear();
                                                                pricecontroler
                                                                    .clear();
                                                              },
                                                              child: Text(
                                                                  'Update'))
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data[index]['price'].toString(),
                                      ),
                                      // Text(
                                      //   data[index]['sub_item'],
                                      // ),
                                    ],
                                  )),
                            ));
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
