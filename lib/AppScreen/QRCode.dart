import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:min_id/min_id.dart';

class QrCodeScreen extends StatefulWidget {
  final String idUser;
  final double Montant;
  final double Solde;
  final String Description;
  const QrCodeScreen(
      {Key? key,
      required this.idUser,
      required this.Montant,
      required this.Solde,
      required this.Description})
      : super(key: key);

  @override
  State<QrCodeScreen> createState() =>
      _QrCodeScreenState(idUser, Montant, Solde, Description);
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  String idUser;
  double Montant;
  double Solde;
  String Description;
  _QrCodeScreenState(this.idUser, this.Montant, this.Solde, this.Description);
  final ReferenceQRCode = MinId.getId();
  Map<String, dynamic> donnees() {
    return {
      'id': idUser,
      'prix': Montant,
      'Description': Description,
      'ReferenceQRCode': ReferenceQRCode
    };
  }

  int AutoPay = 1;
  getAutorisation() async {
    FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(idUser)
        .snapshots()
        .listen((event) {
      setState(() {
        AutoPay = event.get('AutoPay');
      });
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
    build(context) => getAutorisation();
    return AutoPay != 1
        ? PaiementEffectue()
        : Scaffold(
            appBar: AppBar(
              title: Text('QR Code'),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
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
}
