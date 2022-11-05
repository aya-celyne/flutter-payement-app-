import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paiement/AppScreen/Depot.dart';
import 'package:paiement/AppScreen/DepotScreen.dart';
import 'package:paiement/AppScreen/Historique.dart';
import 'package:paiement/AppScreen/Profile.dart';
import 'package:paiement/AppScreen/Retrait.dart';
import 'package:paiement/AppScreen/Statistique.dart';
import 'package:paiement/AppScreen/compte.dart';

class CompteScreen extends StatefulWidget {
  final String idUser;
  const CompteScreen({Key? key, required this.idUser}) : super(key: key);

  @override
  State<CompteScreen> createState() => _CompteScreenState(idUser);
}

class _CompteScreenState extends State<CompteScreen> {
  String idUser;
  _CompteScreenState(this.idUser);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Utilisateur')
          .doc(idUser)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Color.fromARGB(255, 3, 60, 107),
            body: Container(
              alignment: Alignment.center,
              child: const Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          );
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/image.png',
                // width: double.infinity,
              ).image,
            )),
            margin: EdgeInsets.all(0),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logoM.png',
                  height: 70.0,
                  width: 200.0,
                ),
                SizedBox(
                  height: 30,
                ),
                Material(
                  color: Colors.transparent,
                  elevation: 5,
                  shape: const CircleBorder(),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFF2F49E3),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data['Solde'].toString() + ' DA',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 20),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Votre Solde',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 163, 165, 165),
                                    fontSize: 15),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Retrait(
                          idUser: idUser,
                        );
                      },
                      fullscreenDialog: true,
                    ));
                  },
                  child: Text(
                    'Retrait',
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                  color: Color.fromARGB(255, 3, 60, 107),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Depot(
                          idUser: idUser,
                        );
                      },
                      fullscreenDialog: true,
                    ));
                  },
                  child: Text(
                    ' Depot ',
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                  color: Color.fromARGB(255, 3, 60, 107),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Historique(
                          idUser: idUser,
                        );
                      },
                      fullscreenDialog: true,
                    ));
                  },
                  child: Text(
                    'Historique',
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                  color: Color.fromARGB(255, 3, 60, 107),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 85),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return statistique(
                          idUser: idUser,
                        );
                      },
                      fullscreenDialog: true,
                    ));
                  },
                  child: Text(
                    'Statistique',
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                  color: Color.fromARGB(255, 3, 60, 107),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 85),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
