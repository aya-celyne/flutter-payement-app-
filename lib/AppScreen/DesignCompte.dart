import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DesignCompte extends StatefulWidget {
  const DesignCompte({Key? key}) : super(key: key);

  @override
  State<DesignCompte> createState() => _DesignCompteState();
}

class _DesignCompteState extends State<DesignCompte> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {},
              child: Text('Get Location'),
            ),
          ],
        ),
      ),
    );
  }
}
