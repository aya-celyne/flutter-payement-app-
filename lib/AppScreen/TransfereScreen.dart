import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:min_id/min_id.dart';

class TransfereScreen extends StatefulWidget {
  final String idUser;
  const TransfereScreen({Key? key, required this.idUser}) : super(key: key);

  @override
  State<TransfereScreen> createState() => _TransfereScreenState(idUser);
}

class _TransfereScreenState extends State<TransfereScreen> {
  String idUser;
  _TransfereScreenState(this.idUser);
  double _montant = 0;
  String _IDrecepteur = '';
  String _nomRecepteur = '';
  String _nomEmeteur = '';

  int heureOp = DateTime.now().hour;
  int minuteOp = DateTime.now().minute;
  String dateOp = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final IdTrensfer = MinId.getId();
  Timer? _timer;

  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    // EasyLoading.showSuccess('Use in initState');
    // EasyLoading.removeCallbacks();
  }

  @override
  CollectionReference Colleref =
      FirebaseFirestore.instance.collection('Utilisateur');
  transfert() async {
    try {
      EasyLoading.show(status: 'Patientez...');
      await Colleref.doc(_IDrecepteur).get().then((value) {
        _nomRecepteur =
            (value.get('nom') + ' ' + value.get('Prenom')).toUpperCase();
      });
      await Colleref.doc(idUser).get().then((value) {
        _nomEmeteur =
            (value.get('nom') + ' ' + value.get('Prenom')).toUpperCase();
      });
      EasyLoading.dismiss();
      ValiderTransfert();
    } catch (e) {
      EasyLoading.dismiss();
      AwesomeDialog(
          context: context,
          dialogType: DialogType.NO_HEADER,
          btnOkColor: Color.fromARGB(255, 3, 60, 107),
          title: "ID de récepteur est incorrect",
          animType: AnimType.BOTTOMSLIDE,
          btnOkOnPress: () {})
        ..show();
    }
  }

  ValiderTransfert() {
    if (_IDrecepteur.compareTo(idUser) != 0) {
      AwesomeDialog(
          context: context,
          body: Container(
              height: 300,
              width: 400,
              color: Colors.white,
              padding: EdgeInsets.only(left: 10, top: 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Text(
                          'Validez-vous?',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text('Récepteur  : $_nomRecepteur',
                          style: TextStyle(
                            fontSize: 18,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text('Montant     : $_montant DA',
                          style: TextStyle(
                            fontSize: 18,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text('Date            : $dateOp',
                          style: TextStyle(
                            fontSize: 18,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text('Heure          : $heureOp:$minuteOp',
                          style: TextStyle(
                            fontSize: 18,
                          ))
                    ],
                  )
                ],
              )),
          dialogType: DialogType.NO_HEADER,
          btnOkColor: Color.fromARGB(255, 3, 60, 107),
          animType: AnimType.BOTTOMSLIDE,
          btnCancelOnPress: () {},
          btnCancelColor: Color.fromARGB(255, 1, 10, 12),
          btnOkOnPress: () async {
            await transfrerer(_montant, _IDrecepteur);
          })
        ..show();
    } else {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.NO_HEADER,
          btnOkColor: Color.fromARGB(255, 3, 60, 107),
          title: "Vous pouvez pas transférer l'argent à vous même",
          animType: AnimType.BOTTOMSLIDE,
          btnOkOnPress: () {})
        ..show();
    }
  }

  transfrerer(double Montant, String Recepteur) async {
    EasyLoading.show(status: 'Patientez...');
    double soldeEm = 0;
    double soldeRec = 0;
    try {
      await Colleref.doc(idUser).collection('Transferer').add({
        'Recepteur': Recepteur,
        'Montant': Montant,
        'Date': DateTime.now(),
        'NomRecepteur': _nomRecepteur,
      });
      await Colleref.doc(Recepteur).collection('Receptionner').add({
        'Expediteur': Recepteur,
        'Montant': Montant,
        'NomEmeteur': _nomEmeteur,
        'Date': DateTime.now(),
      });
      await Colleref.doc(idUser).get().then((value) {
        soldeEm = value.get('Solde');
      });
      await Colleref.doc(Recepteur).get().then((value) {
        soldeRec = value.get('Solde');
      });
      if (soldeEm >= _montant) {
        await Colleref.doc(idUser).update({
          'Solde': soldeEm - Montant,
        });
        await Colleref.doc(Recepteur).update({
          'Solde': soldeRec + Montant,
        });

        EasyLoading.dismiss();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Transfert effectué',
          descTextStyle: TextStyle(fontSize: 15),
          btnCancelOnPress: () {},
          btnCancelColor: Color.fromARGB(255, 3, 60, 107),
        )..show();
      } else {
        EasyLoading.dismiss();
        AwesomeDialog(
            context: context,
            dialogType: DialogType.NO_HEADER,
            btnOkColor: Color.fromARGB(255, 3, 60, 107),
            title: "Solde Insuffisant\nVeuillez recharger votre compte",
            animType: AnimType.BOTTOMSLIDE,
            btnOkOnPress: () {})
          ..show();
      }
    } catch (e) {
      EasyLoading.dismiss();
      AwesomeDialog(
          context: context,
          dialogType: DialogType.NO_HEADER,
          btnOkColor: Color.fromARGB(255, 3, 60, 107),
          title: "Erreur s'est produite\nRéssayez à nouveau",
          animType: AnimType.BOTTOMSLIDE,
          btnOkOnPress: () {})
        ..show();
    }
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Card(
        color: Color.fromARGB(255, 3, 60, 107),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        margin: EdgeInsets.only(left: 40, right: 40, top: 130, bottom: 80),
        elevation: 10,
        shadowColor: Colors.black,
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                topRight: Radius.circular(250),
              ),
              // border: Border.all(color: Color.fromARGB(255, 12, 11, 11)),
            ),
            padding: EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 50),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logoM.png',
                    height: 100.0,
                    width: 200.0,
                    color: Color.fromARGB(255, 3, 60, 107),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      "Transfert d'argent",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: ((value) =>
                        setState(() => _IDrecepteur = value)),
                    validator: (value) => value!.isEmpty
                        ? 'Vous devez Saisir ID  Récepteur '
                        : null,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.perm_identity,
                          color: Color.fromARGB(255, 1, 40, 71),
                        ),
                        labelText: ' Saisir ID de Récepteur',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>
                        setState(() => _montant = double.parse(value)),
                    validator: (value) =>
                        value!.isEmpty ? 'Vous devez saisir la somme' : null,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.money,
                          color: Color.fromARGB(255, 1, 40, 71),
                        ),
                        labelText: ' Saisir la somme',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        transfert();
                      }
                    },
                    child: Text(
                      'Envoyer',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    color: Color.fromARGB(255, 3, 60, 107),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  )
                ],
              ),
            )),
      ),
    ));
  }

  Patientez() {
    AwesomeDialog(
        context: context,
        animType: AnimType.BOTTOMSLIDE,
        dialogType: DialogType.NO_HEADER,
        body: Container(
          height: 100,
          width: 200,
          alignment: Alignment.center,
          child: SpinKitWave(
            color: Color.fromARGB(255, 3, 60, 107),
            size: 90.0,
          ),
        ))
      ..show();
  }
}
