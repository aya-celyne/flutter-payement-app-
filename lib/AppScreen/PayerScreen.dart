import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paiement/AppScreen/QRCode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paiement/AppScreen/UserInfo.dart';
import 'package:paiement/AppScreen/generateQRcode.dart';

class PayerScreen extends StatefulWidget {
  final String idUser;
  const PayerScreen({Key? key, required this.idUser}) : super(key: key);

  @override
  State<PayerScreen> createState() => _PayerScreenState(idUser);
}

class _PayerScreenState extends State<PayerScreen> {
  String idUser;
  _PayerScreenState(this.idUser);
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final RegExp numerRegExp = RegExp(r'\d+');
  double Montant = 0;
  double MonSolde = 0;
  String description = '';
  double _solde = 0;
  int AutoPap = 0;
  Utilisateur? user;
  createUser() {
    user = Utilisateur(idUser);
  }

  void initState() {
    super.initState();
    createUser();
  }

  ValiderPaiement() async {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.QUESTION,
        btnOkColor: Color.fromARGB(255, 3, 60, 107),
        animType: AnimType.BOTTOMSLIDE,
        title: 'Êtes-vous sur?',
        desc: 'Confirmez-vous le paiement de $Montant DA ?',
        descTextStyle: TextStyle(fontSize: 15),
        btnCancelOnPress: () {},
        btnCancelColor: Color.fromARGB(255, 1, 10, 12),
        btnOkOnPress: () async {
          CollectionReference _compte =
              FirebaseFirestore.instance.collection('Utilisateur');
          await _compte.doc(idUser).get().then((value) {
            _solde = value.get('Solde');
          });
          Utilisateur _user = Utilisateur(idUser);
          double seuil = await _user.getSeiul();
          if (Montant > _solde) {
            AwesomeDialog(
                    context: context,
                    title: 'Solde Insuffiant',
                    dialogType: DialogType.WARNING,
                    animType: AnimType.BOTTOMSLIDE,
                    btnCancelOnPress: () {},
                    btnCancelColor: Color.fromARGB(255, 3, 60, 107))
                .show();
          } else {
            if (Montant > seuil) {
              AwesomeDialog(
                      context: context,
                      title:
                          'Vous pouvez pas payer cette somme car vous allez dépasser votre seuil Quotidien',
                      dialogType: DialogType.WARNING,
                      animType: AnimType.BOTTOMSLIDE,
                      btnCancelOnPress: () {},
                      btnCancelColor: Color.fromARGB(255, 3, 60, 107))
                  .show();
            } else {
              await _compte.doc(idUser).update({'AutoPay': 1});
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {
                  return generateQRcode(
                    idUser: idUser,
                    Montant: Montant,
                    Solde: MonSolde,
                    Description: description,
                  );
                },
                fullscreenDialog: true,
              ));
            }
          }
        }).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      // color: Color.fromARGB(255, 3, 60, 107),
      margin: EdgeInsets.only(left: 40, right: 40, top: 70, bottom: 10),
      elevation: 20,
      shadowColor: Color.fromRGBO(39, 228, 244, 80),
      child: Container(
        margin: EdgeInsets.only(top: 30, left: 25, right: 25, bottom: 80),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/Qrbleu.png',
                  height: 130.0,
                  width: 130.0,
                ),
                Image.asset(
                  'assets/logoM.png',
                  height: 130.0,
                  width: 300.0,
                  color: Color.fromARGB(255, 3, 60, 107),
                ),
                Text(
                  'Saisir le prix',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                      fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onTap: createUser,
                  keyboardType: TextInputType.number,
                  // autovalidateMode: AutovalidateMode.always,
                  onChanged: ((value) {
                    setState(() {
                      Montant = double.parse(value);
                    });
                  }),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Saisir le prix';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Le prix doit etre supérieure à 0';
                    }
                  },
                  decoration: InputDecoration(
                      hintText: '   Prix',
                      suffixText: 'DA',
                      suffixStyle: TextStyle(
                          fontSize: 15, color: Color.fromARGB(255, 3, 60, 107)),
                      labelStyle: TextStyle(fontSize: 23),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: ((value) {
                    setState(() {
                      description = value;
                    });
                  }),
                  autocorrect: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Donnez une description ' : null,
                  maxLength: 22,
                  decoration: InputDecoration(
                      hintText: '   Description          ',
                      suffixStyle: TextStyle(
                          fontSize: 15, color: Color.fromARGB(255, 3, 60, 107)),
                      labelStyle: TextStyle(fontSize: 23),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      ValiderPaiement();
                    }
                  },
                  child: Text(
                    'Valider',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                  color: Color.fromARGB(255, 3, 60, 107),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 50),
                ),
              ],
            )),
      ),
    )));
  }
}
