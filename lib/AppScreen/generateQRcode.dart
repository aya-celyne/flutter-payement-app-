import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paiement/AppScreen/Chargement.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:min_id/min_id.dart';

class generateQRcode extends StatefulWidget {
  final String idUser;
  final double Montant;
  final double Solde;
  final String Description;
  const generateQRcode(
      {Key? key,
      required this.idUser,
      required this.Montant,
      required this.Solde,
      required this.Description})
      : super(key: key);

  @override
  State<generateQRcode> createState() =>
      _generateQRcodeState(idUser, Montant, Solde, Description);
}

class _generateQRcodeState extends State<generateQRcode> {
  String idUser;
  double Montant;
  double Solde;
  String Description;
  _generateQRcodeState(this.idUser, this.Montant, this.Solde, this.Description);
  final ReferenceQRCode = MinId.getId();
  Map<String, dynamic> donnees() {
    return {
      'id': idUser,
      'prix': Montant,
      'Description': Description,
      'ReferenceQRCode': ReferenceQRCode
    };
  }

  bool awesomeshow = true;
  int AutoPay = 1;
  getAutorisation() async {
    FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(idUser)
        .snapshots()
        .listen((event) {
      if (event.get('AutoPay') == 0 && awesomeshow == true) {
        PaiementEffectue();
      }
    });
  }

  PaiementEffectue() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Paiement effectué avec succès',
      descTextStyle: TextStyle(fontSize: 15),
      btnCancelOnPress: () {
        Navigator.of(context).pop();
      },
      btnCancelColor: Color.fromARGB(255, 1, 39, 46),
    )..show();
  }

  @override
  void initState() {
    getAutorisation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> _usersStream =
        FirebaseFirestore.instance
            .collection('Utilisateur')
            .doc(idUser)
            .snapshots();
    CollectionReference users =
        FirebaseFirestore.instance.collection('Utilisateur');
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
            return Text('loading...');
          }
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Scaffold(
              appBar: AppBar(
                title: Text('QR Code'),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () async {
                    awesomeshow = false;
                    await users.doc(idUser).update({'AutoPay': 0});
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: Color.fromARGB(255, 3, 60, 107),
              ),
              body: Container(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: QrImage(
                      data: jsonEncode(donnees()),
                      version: QrVersions.auto,
                      size: 350,
                      gapless: false,
                    ),
                  )),
            );
          }
          return Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/logoM.png',
                    height: 100.0,
                    width: 200.0,
                  ),
                  SpinKitChasingDots(
                    color: Color.fromARGB(255, 3, 60, 107),
                    size: 50.0,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
