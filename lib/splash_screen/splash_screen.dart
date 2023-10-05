import 'dart:async';

import 'package:flutter/material.dart';
import 'package:raju/drawer.dart';
import 'package:raju/homepage.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  bool _showsplashscreen = true;
  void initState() {
 
      setState(() {
        _showsplashscreen = false;
      

      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => drawer())));
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _showsplashscreen ? buildsplashcreen() : homepage();
  }
}

class buildsplashcreen extends StatelessWidget {
  const buildsplashcreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Nidhi Jewellers',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Center(
              child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset('imag/hicot.jpg'))),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Text(
              'Designed and Developed by Salaar Tech. +923226096929',
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
