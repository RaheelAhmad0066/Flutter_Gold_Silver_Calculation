import 'package:flutter/material.dart';

import 'package:raju/homepage.dart';
import 'package:raju/Items_data/subitemlist.dart';
import 'admin.dart';
import 'Items_data/itemlist.dart';

class drawer extends StatefulWidget {
  const drawer({Key? key}) : super(key: key);

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 236, 229, 229),
          title: (Text("Calculation")),
        ),
        // other properties of Scaffold...
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                          radius: 60,
                          child: Text(
                            "R",
                            style: TextStyle(
                                fontSize: 53,
                                decoration: TextDecoration.underline),
                          ))
                    ],
                  )),
              Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => homepage()));
                    },
                    title: Text("Home"),
                    leading: Icon(Icons.home),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => admin()));
                    },
                    title: Text("Admin Page"),
                    leading: Icon(Icons.admin_panel_settings),
                  ),
                  ListTile(
                    title: ExpansionTile(
                      title: Text('Itemsdata'),
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ItemsData()));
                            },
                            child: Text('ItemsList')),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => subitemlist()));
                            },
                            child: Row(
                              children: [
                                Text('SubitemList'),
                              ],
                            )),
                      ],
                    ),
                    leading: Icon(Icons.insert_emoticon),
                  ),
                ],
              )
            ],
          ),
        ),
        body: homepage());
  }
  
}
