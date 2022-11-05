import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paiement/AppScreen/CompteScreen.dart';
import 'package:intl/intl.dart';

class depotScreen extends StatefulWidget {
  final String idUser;
  const depotScreen({Key? key, required this.idUser}) : super(key: key);

  @override
  State<depotScreen> createState() => _depotScreenState(idUser);
}

class _depotScreenState extends State<depotScreen> {
  String idUser;
  _depotScreenState(this.idUser);
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  double _Montant = 0;
  String NumCB = '';
  String TitulaireCB = '';
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

  UpdateSolde(double montant) async {
    double _solde = 0;
    int heureOp = DateTime.now().hour;
    int minuteOp = DateTime.now().minute;
    String dateOp = DateFormat('dd-MM-yyyy').format(DateTime.now());
    CollectionReference _compte =
        FirebaseFirestore.instance.collection('Utilisateur');
    await _compte.doc(idUser).get().then((value) {
      _solde = value.get('Solde');
    });
    if (_compte != null) {
      if (_solde + montant < 50000) {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.QUESTION,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Êtes-vous sur?',
            desc: 'Confirmez-vous le dépôt de $montant DA dans votre compte?',
            descTextStyle: TextStyle(fontSize: 15),
            btnCancelOnPress: () {},
            btnCancelColor: Color.fromARGB(255, 1, 39, 46),
            btnOkOnPress: () {
              EasyLoading.show(status: 'Patientez...');
              _compte.doc(idUser).update({
                "Solde": _solde + montant,
              });
              _compte.doc(idUser).collection('Depot').add({
                'Montant': _Montant,
                'Date': dateOp,
                'Heure': heureOp,
                'Minute': minuteOp,
                'Carte CB': NumCB,
                'Titulaire': TitulaireCB,
              });
              EasyLoading.dismiss();
              AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Dépot effectué avec succès',
                descTextStyle: TextStyle(fontSize: 15),
                btnCancelOnPress: () {
                  Navigator.of(context).pop();
                },
                btnCancelColor: Color.fromARGB(255, 1, 39, 46),
              )..show();
            })
          ..show();
      } else {
        double _MontantAutoriser = 50000 - _solde;
        AwesomeDialog(
          context: context,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Dépassement de Seuil',
          desc:
              'Car le solde maximum autoriser est 50000 DA Vous pouvez recharger $_MontantAutoriser DA au maximum ',
          descTextStyle: TextStyle(fontSize: 15),
          btnCancelOnPress: () {
            Navigator.of(context).pop();
          },
          btnCancelColor: Color.fromARGB(255, 1, 39, 46),
        )..show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(
            'Effectuer un dépôt',
            style: TextStyle(fontSize: 22, color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 4, 106, 124),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Montant à créditer',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.always,
                        onChanged: (value) =>
                            setState(() => _Montant = double.parse(value)),
                        validator: (value) =>
                            value!.isEmpty || double.parse(value) < 1000
                                ? 'Le Montant doit etre supérieure à 1000 DA'
                                : null,
                        decoration: InputDecoration(
                            hintText: 'Montant supérieure à 1000 DA ',
                            suffixText: 'DA',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                'Numéro de CB       ',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Image.asset(
                                'assets/cards.png',
                                height: 80,
                                width: 80,
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            NumCB = value;
                          });
                        },
                        validator: (value) =>
                            value!.isEmpty || value.length < 16
                                ? 'Saisir le numéro de CB correctement'
                                : null,
                        decoration: InputDecoration(
                            hintText: 'XXXX XXXX XXXX XXXX  ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            "Nom du titulaire     ",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        onChanged: ((value) {
                          setState(() {
                            TitulaireCB = value;
                          });
                        }),
                        validator: (value) =>
                            value!.isEmpty ? 'Entrez le titulaire' : null,
                        decoration: InputDecoration(
                            hintText: 'Titulaire ',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                gapPadding: 10)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            "Date d'expiration     ",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) => value!.isEmpty
                            ? "Entrez La date d'expiration de votre CB"
                            : null,
                        decoration: InputDecoration(
                            hintText: ' MM/AA ',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 0),
                                borderRadius: BorderRadius.circular(10.0),
                                gapPadding: 10)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            "Code secret     ",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? 'Entrez votre Code secret' : null,
                        decoration: InputDecoration(
                            hintText: ' Code ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                UpdateSolde(_Montant);
                              }
                            },
                            child: Text(
                              'Créditer Mon Compte',
                              style: TextStyle(fontSize: 20),
                            ),
                            color: Color.fromARGB(255, 4, 106, 124),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: EdgeInsets.all(15.0),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ))));
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
