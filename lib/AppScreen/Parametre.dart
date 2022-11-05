import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:paiement/AppScreen/UserInfo.dart';

class Parametre extends StatefulWidget {
  final String idUser;
  const Parametre({Key? key, required this.idUser}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<Parametre> createState() => _ParametreState(idUser);
}

class _ParametreState extends State<Parametre> {
  String idUser;
  _ParametreState(this.idUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 3, 60, 107),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 60, 107),
        elevation: 0,
        title: Text('Paramètres'),
        centerTitle: true,
        leading: IconButton(
            onPressed: (() => Navigator.of(context).pop()),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logoM.png',
              height: 100.0,
              width: 350.0,
              color: Colors.white,
            ),
            Image.asset(
              'assets/Qrbleu.png',
              height: 170.0,
              width: 200.0,
              color: Colors.white,
            ),
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                title: const Text(
                  'Profile',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                iconColor: Colors.white,
                shape: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ChangeNumerotelephone(
                        idUser: idUser,
                      );
                    },
                    fullscreenDialog: true,
                  ));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                title: const Text(
                  'Changer le mot de passe',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                iconColor: Colors.white,
                shape: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ChangeMotPasse(
                        idUser: idUser,
                      );
                    },
                    fullscreenDialog: true,
                  ));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                title: const Text(
                  'Seuil Quotidien',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                iconColor: Colors.white,
                shape: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ChangeSeuil(
                        idUser: idUser,
                      );
                    },
                    fullscreenDialog: true,
                  ));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                title: const Text(
                  'Signaler un problème',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                iconColor: Colors.white,
                shape: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeNumerotelephone extends StatefulWidget {
  final String idUser;
  const ChangeNumerotelephone({Key? key, required this.idUser})
      : super(key: key);

  @override
  State<ChangeNumerotelephone> createState() =>
      _ChangeNumerotelephoneState(idUser);
}

class _ChangeNumerotelephoneState extends State<ChangeNumerotelephone> {
  String idUser;
  _ChangeNumerotelephoneState(this.idUser);
  int _numero = 0;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
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
        backgroundColor: Color.fromARGB(255, 3, 60, 107),
        body: SingleChildScrollView(
            child: Card(
          elevation: 10,
          shadowColor: Colors.white,
          color: Color.fromARGB(255, 3, 60, 107),
          margin: EdgeInsets.only(
            left: 40,
            right: 40,
            top: 150,
          ),
          child: Container(
            padding: EdgeInsets.only(bottom: 80, top: 80),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/Qrbleu.png',
                            height: 170.0,
                            width: 200.0,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            onChanged: (value) =>
                                setState(() => _numero = int.parse(value)),
                            validator: (value) =>
                                value!.isEmpty || value.length != 10
                                    ? 'Entrez votre numero correctement'
                                    : null,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: '    Saisir le nouveau numéro ',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                )),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          RaisedButton(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                EasyLoading.show(status: 'Patientez');
                                Utilisateur _user = Utilisateur(idUser);
                                await _user.UpdateNumeroTelephone(_numero);
                                EasyLoading.showSuccess('Updated');
                                EasyLoading.dismiss();
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              'Changer',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: Color.fromARGB(255, 3, 17, 29),
                            padding: EdgeInsets.symmetric(
                                horizontal: 60, vertical: 11),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        )));
  }
}

class ChangeMotPasse extends StatefulWidget {
  final String idUser;
  const ChangeMotPasse({Key? key, required this.idUser}) : super(key: key);

  @override
  State<ChangeMotPasse> createState() => _ChangeMotPasseState(idUser);
}

class _ChangeMotPasseState extends State<ChangeMotPasse> {
  String idUser;
  _ChangeMotPasseState(this.idUser);
  String _password = '';
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Timer? _timer;
  bool _isSecret = true;
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
        backgroundColor: Color.fromARGB(255, 3, 60, 107),
        body: SingleChildScrollView(
            child: Card(
          elevation: 10,
          shadowColor: Colors.white,
          color: Color.fromARGB(255, 3, 60, 107),
          margin: EdgeInsets.only(
            left: 40,
            right: 40,
            top: 150,
          ),
          child: Container(
            padding: EdgeInsets.only(bottom: 80, top: 80),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/Qrbleu.png',
                            height: 170.0,
                            width: 200.0,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            onChanged: (value) =>
                                setState(() => _password = value),
                            validator: (value) =>
                                value!.isEmpty || value.length < 6
                                    ? 'Mot de passe Incorrecte'
                                    : null,
                            decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () =>
                                      setState(() => _isSecret = !_isSecret),
                                  child: Icon(!_isSecret
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "Entrez l'ancien mot de passe ",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                )),
                            obscureText: _isSecret,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          RaisedButton(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                EasyLoading.show(status: 'Patientez');
                                try {
                                  UserCredential userCredential =
                                      await FirebaseAuth
                                          .instance
                                          .signInWithEmailAndPassword(
                                              email: idUser,
                                              password: _password);
                                  if (userCredential.user != null) {
                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(email: idUser);
                                    EasyLoading.dismiss();
                                    AwesomeDialog(
                                            context: context,
                                            title:
                                                'Vous allez recevoir un email de changement de mot de passe',
                                            btnOkOnPress: () {
                                              Navigator.of(context).pop();
                                            },
                                            btnOkColor: Colors.black,
                                            dialogType: DialogType.NO_HEADER,
                                            animType: AnimType.BOTTOMSLIDE)
                                        .show();
                                  }
                                } on FirebaseAuthException catch (e) {
                                  EasyLoading.dismiss();
                                  AwesomeDialog(
                                          context: context,
                                          title: 'Mot de passe Incorrecte',
                                          btnOkOnPress: () {},
                                          btnOkColor: Colors.black,
                                          dialogType: DialogType.NO_HEADER,
                                          animType: AnimType.BOTTOMSLIDE)
                                      .show();
                                }
                              }
                            },
                            child: Text(
                              'Confirmer',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: Color.fromARGB(255, 3, 17, 29),
                            padding: EdgeInsets.symmetric(
                                horizontal: 60, vertical: 11),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        )));
  }
}

class ChangeSeuil extends StatefulWidget {
  final String idUser;
  const ChangeSeuil({Key? key, required this.idUser}) : super(key: key);

  @override
  State<ChangeSeuil> createState() => _ChangeSeuilState(idUser);
}

class _ChangeSeuilState extends State<ChangeSeuil> {
  String idUser;
  _ChangeSeuilState(this.idUser);
  double _seuil = 0;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Timer? _timer;
  bool chargementseuil = false;

  double seuilActuel = 0;
  getSeuilActuel() async {
    try {
      await FirebaseFirestore.instance
          .collection('Utilisateur')
          .doc(idUser)
          .get()
          .then((value) {
        seuilActuel = value.get('SeuilQuotidien');
      });
      print(seuilActuel);
      setState(() {
        chargementseuil = true;
      });
      print(chargementseuil);
    } catch (e) {
      print(e);
      setState(() {
        chargementseuil = true;
      });
    }
  }

  void initState() {
    super.initState();
    getSeuilActuel();
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
    return chargementseuil == false
        ? Scaffold(
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
          )
        : Scaffold(
            backgroundColor: Color.fromARGB(255, 3, 60, 107),
            body: SingleChildScrollView(
                child: Card(
              elevation: 10,
              shadowColor: Colors.white,
              color: Color.fromARGB(255, 3, 60, 107),
              margin: EdgeInsets.only(
                left: 40,
                right: 40,
                top: 150,
              ),
              child: Container(
                padding: EdgeInsets.only(bottom: 80, top: 80),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/Qrbleu.png',
                                height: 170.0,
                                width: 200.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Card(
                                elevation: 10,
                                shadowColor: Colors.white,
                                margin: EdgeInsets.only(
                                    right: 0, left: 0, bottom: 20, top: 20),
                                child: Container(
                                  color: Colors.black,
                                  height: 50,
                                  width: double.infinity,
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '  Votre Seuil Actuel est :',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      Text(
                                        seuilActuel == 0
                                            ? ' Non defini'
                                            : '$seuilActuel DA',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) => setState(
                                    () => _seuil = double.parse(value)),
                                validator: (value) => value!.isEmpty ||
                                        double.parse(value) < 0 ||
                                        double.parse(value) > 50000
                                    ? 'Montant invalide'
                                    : null,
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelText:
                                        '    Saisir votre Seuil Quotidien ',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    )),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              RaisedButton(
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    EasyLoading.show(status: 'Patientez');
                                    Utilisateur _user = Utilisateur(idUser);
                                    await _user.UpdateSeuilQuotidien(_seuil);
                                    EasyLoading.showSuccess('Updated');
                                    EasyLoading.dismiss();
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Text(
                                  'Changer',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                color: Color.fromARGB(255, 3, 17, 29),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 11),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            )));
  }
}
