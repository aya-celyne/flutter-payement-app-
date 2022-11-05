// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:paiement/AppScreen/Chargement.dart';
import 'package:paiement/AppScreen/NavBar.dart';
import 'package:paiement/Mes%20Pages/inscription.dart';

class connexion extends StatefulWidget {
  const connexion({Key? key}) : super(key: key);

  @override
  State<connexion> createState() => _connexionState();
}

class _connexionState extends State<connexion> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isSecret = true;
  String val = '';
  bool chargement = false;
  //Authentifaication firebase
  FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? _timer;

  @override
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
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                Image.asset(
                  'assets/Qrbleu.png',
                  height: 140.0,
                  width: 140.0,
                  //color: Color.fromARGB(255, 2, 41, 73),
                ),
                const SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'assets/logoM.png',
                  height: 100.0,
                  width: 400.0,
                  color: const Color.fromARGB(255, 2, 41, 73),
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(
                  height: 60,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: ((value) => setState(() => _email = value)),
                  validator: (value) =>
                      value!.isEmpty ? 'Entrez votre email' : null,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color.fromARGB(255, 1, 40, 71),
                      ),
                      labelText: ' Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  onChanged: (value) => setState(() => _password = value),
                  validator: (value) =>
                      value!.length < 6 ? 'Mot de passe incorrect' : null,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color.fromARGB(255, 1, 40, 71),
                    ),
                    labelText: 'Mot de passe',
                    fillColor: Colors.blue,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    suffixIcon: InkWell(
                      onTap: () => setState(() => _isSecret = !_isSecret),
                      child: Icon(
                          !_isSecret ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  obscureText: _isSecret,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 120, top: 10),
                  child: InkWell(
                    child: const Text(
                      'Mot de passe oublié?',
                      style: TextStyle(
                          color: Color.fromRGBO(39, 228, 244, 80),
                          fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) {
                          return RenitialiserMotPasse();
                        },
                        fullscreenDialog: true,
                      ));
                    },
                  ),
                ),
                const SizedBox(height: 30.0),
                RaisedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        await SignIn();
                      }
                    },
                    color: Color.fromARGB(255, 2, 41, 73),
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 50),
                    child: const Text(
                      "Connexion",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Row(
                    children: [
                      const Text(
                        "Vous n'avez pas un compte ? ",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) {
                              return inscpts();
                            },
                            fullscreenDialog: true,
                          ));
                        },
                        child: const Text(
                          "S'inscrire",
                          style: TextStyle(
                              color: Color.fromRGBO(39, 228, 244, 80),
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  SignIn() async {
    try {
      EasyLoading.show(status: 'Patientez...');
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);

      if (userCredential.user != null) {
        if (userCredential.user?.emailVerified == true) {
          EasyLoading.dismiss();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return NavBar(
                idUser: _email,
              );
            },
            fullscreenDialog: true,
          ));
        } else {
          EasyLoading.dismiss();
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'Info',
                    style: TextStyle(),
                  ),
                  content: Text(
                      "Inscription non validé \nVeuillez valider votre inscription"),
                  titlePadding: EdgeInsets.all(20),
                  actions: [
                    FlatButton(
                        onPressed: (() {
                          setState(() {
                            chargement = false;
                          });
                          Navigator.of(context).pop();
                        }),
                        child: Text("Ok")),
                  ],
                );
              });
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        EasyLoading.dismiss();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Error',
                  style: TextStyle(),
                ),
                content: Text(' No user found for that email. '),
                titlePadding: EdgeInsets.all(20),
                actions: [
                  FlatButton(
                      onPressed: (() {
                        setState(() {
                          chargement = false;
                        });
                        Navigator.of(context).pop();
                      }),
                      child: Text("Réssayez")),
                ],
              );
            });
      } else if (e.code == 'wrong-password') {
        EasyLoading.dismiss();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Error',
                  style: TextStyle(),
                ),
                content: Text(' Mot de passe incorrect '),
                titlePadding: EdgeInsets.all(20),
                actions: [
                  FlatButton(
                      onPressed: (() {
                        setState(() {
                          chargement = false;
                        });
                        Navigator.of(context).pop();
                      }),
                      child: Text("Réssayez")),
                ],
              );
            });
      } else {
        EasyLoading.dismiss();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Error',
                  style: TextStyle(),
                ),
                content: Text("une erreur s'est produite"),
                titlePadding: EdgeInsets.all(20),
                actions: [
                  FlatButton(
                      onPressed: (() {
                        setState(() {
                          chargement = false;
                        });
                        Navigator.of(context).pop();
                      }),
                      child: Text("Réssayez")),
                ],
              );
            });
      }
    }
  }
}

class RenitialiserMotPasse extends StatefulWidget {
  const RenitialiserMotPasse({Key? key}) : super(key: key);

  @override
  State<RenitialiserMotPasse> createState() => _RenitialiserMotPasseState();
}

class _RenitialiserMotPasseState extends State<RenitialiserMotPasse> {
  String _email = '';
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  showsnackBar(var contentsnack) {
    var snackbar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        '${contentsnack}',
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Color.fromARGB(255, 1, 40, 71),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: EdgeInsets.only(bottom: 100, left: 40, right: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
    scaffoldKey.currentState!.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            margin: EdgeInsets.only(left: 40, right: 40, top: 100, bottom: 100),
            elevation: 10,
            shadowColor: Colors.black,
            child: Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 50),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logoM.png',
                    height: 300.0,
                    width: 400.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      "Réinitialiser Votre Mot de passe",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: ((value) => setState(() => _email = value)),
                    validator: (value) =>
                        value!.isEmpty ? 'Entrez votre email' : null,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 1, 40, 71),
                        ),
                        labelText: ' Saisir votre Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: _email);
                        showsnackBar('Email de Réinitialisation est envoyé');
                      } on FirebaseAuthException catch (e) {
                        showsnackBar(e.message);
                      }
                    },
                    child: Text(
                      'Envoyer',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    color: Color.fromARGB(255, 2, 41, 73),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
