import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:paiement/Mes%20Pages/Inscription.dart';
import 'package:paiement/Mes%20Pages/connexion.dart';
import 'package:paiement/Mes%20Pages/inscription.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../AppScreen/UploadImage.dart';

class inscripts2 extends StatefulWidget {
  //final Function(int) onChangedStep;
  List listDonnee = [];
  inscripts2({Key? key, required this.listDonnee}) : super(key: key);
  @override
  State<inscripts2> createState() => _inscripts2State(listDonnee);
}

class _inscripts2State extends State<inscripts2> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final RegExp numerRegExp = RegExp(r'\d+');
  String _adress = '';
  int _numerCarteIdentite = 0;
  int _numero = 0;
  List listDonnee = [];
  _inscripts2State(this.listDonnee);
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 70.0),
          child: Form(
            key: _formkey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: 80.0,
              ),
              Image.asset(
                'assets/Qrbleu.png',
                height: 120.0,
                width: 120.0,
                //color: Color.fromARGB(255, 2, 41, 73),
              ),
              Image.asset(
                'assets/logoM.png',
                height: 130.0,
                width: 300.0,
                color: Color.fromARGB(255, 2, 41, 73),
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                onChanged: (value) =>
                    setState(() => _numero = int.parse(value)),
                validator: (value) => value!.isEmpty ||
                        value.length < 10 ||
                        value.length < 10 ||
                        !numerRegExp.hasMatch(value)
                    ? 'Entrez votre numero correctement'
                    : null,
                decoration: InputDecoration(
                    labelText: ' Numero de téléphone ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                onChanged: (value) => setState(() => _adress = value),
                validator: (value) =>
                    value!.isEmpty ? 'Entrez votre adress' : null,
                decoration: InputDecoration(
                    labelText: " Adress ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    setState(() => _numerCarteIdentite = int.parse(value)),
                validator: (value) => value!.isEmpty ||
                        value.length < 10 ||
                        value.length < 10 ||
                        !numerRegExp.hasMatch(value)
                    ? 'Votre numerode CI est incorrect'
                    : null,
                decoration: InputDecoration(
                    labelText: " Numero de la carte d'identité",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
              ),
              SizedBox(
                height: 20.0,
              ),
              OutlineButton(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 82, 81, 81)),
                  color: Color.fromARGB(255, 99, 98, 98),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  onPressed: () async {
                    chooseImage();
                  },
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    children: [
                      Text(
                        "    Scan de la carte d'identité     ",
                        style: TextStyle(
                          color: Color.fromARGB(255, 97, 96, 96),
                          fontSize: 15,
                        ),
                      ),
                      Icon(
                        Icons.photo,
                        color: Color.fromARGB(255, 2, 41, 73),
                      ),
                    ],
                  )),
              SizedBox(
                height: 60.0,
              ),
              RaisedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      createUser();
                    }
                  },
                  color: Color.fromARGB(255, 2, 41, 73),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 50),
                  child: Text(
                    "Confirmer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )),
            ]),
          ),
        ),
      ),
    );
  }

  createUser() async {
    try {
      EasyLoading.show(status: 'Patientez...');
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: listDonnee[3], password: listDonnee[4]);
      User? user = FirebaseAuth.instance.currentUser;
      if (user!.uid != null) {
        await FirebaseFirestore.instance
            .collection('Utilisateur')
            .doc(listDonnee[3])
            .set({
          'nom': listDonnee[0],
          'Prenom': listDonnee[1],
          'Date de Naissance': listDonnee[2],
          'Email': listDonnee[3],
          'NumeroTel': _numero,
          'adress': _adress,
          'Numero de carteID': _numerCarteIdentite,
          'Solde': 0.0,
          'Etat': 'Actif',
          'AutoPay': 0,
          'ScanCI': _urlScanCI,
          'Photo': ''
        }).catchError((error) => print("Failed to add user: $error"));

        await user.sendEmailVerification();
        EasyLoading.dismiss();

        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Inscription effectué avec succès',
          descTextStyle: TextStyle(fontSize: 15),
          btnCancelOnPress: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) {
                return connexion();
              },
              fullscreenDialog: true,
            ));
          },
          btnCancelColor: Color.fromARGB(255, 1, 39, 46),
        )..show();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        EasyLoading.dismiss();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  e.message!,
                  style: TextStyle(),
                ),
                content: Text("Le mot de passe fourni est trop faible."),
                titlePadding: EdgeInsets.all(20),
                actions: [
                  FlatButton(
                      onPressed: (() {
                        Navigator.of(context).pop();
                      }),
                      child: Text("Réssayez")),
                ],
              );
            });
      } else if (e.code == 'email-already-in-use') {
        EasyLoading.dismiss();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  e.message!,
                  style: TextStyle(),
                ),
                content: Text("Email déjà utilisé"),
                titlePadding: EdgeInsets.all(20),
                actions: [
                  FlatButton(
                      onPressed: (() {
                        Navigator.of(context).pop();
                      }),
                      child: Text("Réssayez")),
                ],
              );
            });
      }
    } catch (e) {
      EasyLoading.dismiss();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'error',
                style: TextStyle(),
              ),
              content: Text(e.toString()),
              titlePadding: EdgeInsets.all(20),
              actions: [
                FlatButton(
                    onPressed: (() {
                      Navigator.of(context).pop();
                    }),
                    child: Text("Réssayez")),
              ],
            );
          });
    }
  }

  String _urlScanCI = '';
  chooseImage() {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        body: Container(
          height: 100,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: <Widget>[
              Text(
                "choisir photo de profile",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton.icon(
                      onPressed: () async {
                        var url = await uploadImage('ScanCI', 0);
                        setState(() {
                          _urlScanCI = url;
                        });
                        showSuccesUploadImage();
                      },
                      icon: Icon(Icons.camera),
                      label: Text("Camera")),
                  FlatButton.icon(
                      onPressed: () async {
                        var url = await uploadImage('ScanCI', 1);
                        setState(() {
                          _urlScanCI = url;
                        });
                        showSuccesUploadImage();
                      },
                      icon: Icon(Icons.image),
                      label: Text("Gallery"))
                ],
              )
            ],
          ),
        ))
      ..show();
  }

  showSuccesUploadImage() {
    AwesomeDialog(
        context: context,
        title: 'La photo de profile a été mis à jour',
        dialogType: DialogType.SUCCES,
        btnCancelOnPress: () {},
        btnCancelColor: Color.fromARGB(255, 3, 60, 107))
      ..show();
  }
}
