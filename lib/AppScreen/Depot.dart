import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:paiement/AppScreen/UserInfo.dart';

class Depot extends StatefulWidget {
  final String idUser;
  const Depot({Key? key, required this.idUser}) : super(key: key);

  @override
  State<Depot> createState() => _DepotState(idUser);
}

class _DepotState extends State<Depot> {
  String idUser;
  _DepotState(this.idUser);
  double _Montant = 0;
  int NumCB = 0;
  String TitulaireCB = '';
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

        try {
          _user.deposer(_Montant, TitulaireCB, NumCB);
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
                          hintText: '   Montant ',
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
                          setState(() => NumCB = int.parse(value)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veillez saisir le Nom du titulaire';
                        }
                        if (value.length != 16) {
                          return 'Numero de CB est de 16 chiffres';
                        }
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: '   Numero de CB',
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
                      onChanged: (value) => setState(() => TitulaireCB = value),
                      validator: (value) => value!.isEmpty
                          ? 'Veillez saisir le Nom du titulaire'
                          : null,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: '   Nom du titulaire ',
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
                      keyboardType: TextInputType.datetime,
                      validator: (value) =>
                          value!.isEmpty ? 'Veillez saisir ce champ' : null,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "   Date d'expiration",
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
                      validator: (value) =>
                          value!.isEmpty ? 'Veillez saisir ce champ' : null,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: '   Le code secret ',
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
                        'Déposer',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Color.fromARGB(255, 3, 17, 29),
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 11),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    )
                  ],
                ),
              )),
        ));
  }
}
