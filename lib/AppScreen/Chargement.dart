import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Chargement extends StatefulWidget {
  @override
  _ChargementState createState() => _ChargementState();
}

class _ChargementState extends State<Chargement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 0),
            padding: EdgeInsets.only(bottom: 10),
            child: Image.asset(
              'assets/logoM.png',
              height: 200.0,
              width: 230.0,
              color: Color.fromARGB(255, 3, 60, 107),
            ),
          ),
          SizedBox(height: 60.0),
          SpinKitWave(
            color: Color.fromARGB(255, 3, 60, 107),
            size: 100.0,
          ),
          SizedBox(height: 100.0),
        ],
      ),
    );
  }
}
