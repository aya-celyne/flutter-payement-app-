import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:paiement/AppScreen/UserInfo.dart';

class Retrait extends StatefulWidget {
  final String idUser;
  const Retrait({Key? key, required this.idUser}) : super(key: key);

  @override
  State<Retrait> createState() => _RetraitState(idUser);
}

class _RetraitState extends State<Retrait> {
  String idUser;
  _RetraitState(this.idUser);
  double _Montant = 0;
  int NumeroCompte = 0;
  String NomTitulaire = '', N_Iban = '';
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Utilisateur? user;
  createUser() {
    user = Utilisateur(idUser);
  }

  Retirer(Utilisateur _user) {
    AwesomeDialog(
      context: context,
      animType: AnimType.BOTTOMSLIDE,
      dialogType: DialogType.QUESTION,
      title: 'Confirmez-vous de retirer $_Montant DA ?',
      btnCancelOnPress: () {},
      btnCancelColor: Colors.black,
      btnOkOnPress: () async {
        EasyLoading.show(status: 'Patientez...');

        if (_user.getSolde() >= _Montant) {
          try {
            _user.retirer(_Montant, NomTitulaire, N_Iban, NumeroCompte);
          } catch (e) {
            EasyLoading.dismiss();
            AwesomeDialog(
                context: context,
                title: "Erreur s'est produite",
                animType: AnimType.BOTTOMSLIDE,
                dialogType: DialogType.NO_HEADER,
                btnCancelOnPress: () {},
                btnCancelColor: Colors.black)
              ..show();
          }
          EasyLoading.showSuccess('Retrait effectué');
          EasyLoading.dismiss();
          Navigator.of(context).pop();
        } else {
          EasyLoading.dismiss();
          AwesomeDialog(
              context: context,
              title: 'Solde Insuffisant',
              animType: AnimType.BOTTOMSLIDE,
              dialogType: DialogType.NO_HEADER,
              btnCancelOnPress: () {},
              btnCancelColor: Colors.black)
            ..show();
        }
      },
      btnOkColor: const Color.fromARGB(255, 3, 60, 107),
    )..show();
  }

  Timer? _timer;

  void initState() {
    super.initState();
    createUser();
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
        backgroundColor: Color.fromARGB(255, 3, 60, 107),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 70),
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              padding: EdgeInsets.symmetric(horizontal: 30),
              color: Color.fromARGB(255, 3, 60, 107),
              alignment: Alignment.center,
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/qr_code.png',
                      height: 100.0,
                      width: 100.0,
                      color: Colors.white,
                    ),
                    Image.asset(
                      'assets/logoM.png',
                      height: 100.0,
                      width: 200.0,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      cursorColor: Color.fromARGB(255, 3, 17, 29),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          setState(() => _Montant = double.parse(value)),
                      validator: (value) => value!.isEmpty ||
                              double.parse(value) < 0
                          ? 'Veillez saisir le Montant\n Le Montant doit etre supérieure à 0 DA'
                          : null,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Montant ',
                          suffixText: 'DA',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 1, 28, 49),
                                width: 5),
                            borderRadius: BorderRadius.circular(25.0),
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      cursorColor: Color.fromARGB(255, 3, 17, 29),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          setState(() => NumeroCompte = int.parse(value)),
                      validator: (value) => value!.isEmpty
                          ? 'Veillez saisir votre numero de compte'
                          : null,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Numero de compte ',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 1, 28, 49),
                                width: 5),
                            borderRadius: BorderRadius.circular(25.0),
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      cursorColor: Color.fromARGB(255, 3, 17, 29),
                      onChanged: (value) =>
                          setState(() => NomTitulaire = value),
                      validator: (value) => value!.isEmpty
                          ? 'Veillez saisir le Nom du titulaire'
                          : null,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Nom du titulaire ',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 1, 28, 49),
                                width: 5),
                            borderRadius: BorderRadius.circular(25.0),
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      cursorColor: Color.fromARGB(255, 3, 17, 29),
                      onChanged: (value) => setState(() => N_Iban = value),
                      validator: (value) =>
                          value!.isEmpty ? 'Veillez saisir N° IBAN' : null,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'N° IBAN ',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 1, 28, 49),
                                width: 5),
                            borderRadius: BorderRadius.circular(25.0),
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          Retirer(user!);
                        }
                      },
                      child: Text(
                        'Retirer',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Color.fromARGB(255, 3, 17, 29),
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    )
                  ],
                ),
              )),
        ));
  }
}
