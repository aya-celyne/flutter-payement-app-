import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paiement/Mes%20Pages/connexion.dart';
import 'package:paiement/Mes%20Pages/inscription2.dart';
import 'package:intl/intl.dart';

class inscpts extends StatefulWidget {
  //final Function(int) onChangedStep;
  const inscpts({Key? key}) : super(key: key);

  @override
  State<inscpts> createState() => _inscptsState();
}

class _inscptsState extends State<inscpts> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final RegExp numerRegExp = RegExp(r'\d+');
  String _nom = '';
  String _prenom = '';
  String _email = '';
  String _password = '';
  bool _isSecret = true;

  DateTime date = DateTime.now();
  String dateSelected = 'Date de naissance';
  Future<Null> selectTimePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(1900),
        lastDate: DateTime(2030));
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        print(date.toString());
      });
    }
  }

  List ListDonnee = [];
  void setListDonnee(String nom, String prenom, DateTime dateN, String email,
      String password) {
    ListDonnee.add(nom);
    ListDonnee.add(prenom);
    ListDonnee.add(dateN);
    ListDonnee.add(email);
    ListDonnee.add(password);
  }

  List getListDonnee() {
    return this.ListDonnee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 70.0),
          child: Form(
            key: _formkey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 60,
                  ),

                  Image.asset(
                    'assets/logoM.png',
                    height: 180.0,
                    width: 300.0,
                    color: const Color.fromARGB(255, 2, 41, 73),
                  ),

                  //SizedBox(height: 10.0),
                  TextFormField(
                    onChanged: (value) => setState(() => _nom = value),
                    validator: (value) =>
                        value!.isEmpty ? 'Entrez votre nom' : null,
                    decoration: InputDecoration(
                        labelText: '   Nom ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                  ),
                  const SizedBox(height: 25.0),
                  TextFormField(
                    onChanged: (value) => setState(() => _prenom = value),
                    validator: (value) =>
                        value!.isEmpty ? 'Entrez votre prénom' : null,
                    decoration: InputDecoration(
                        labelText: '   Prénom',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),

                  OutlineButton(
                      color: Colors.white,
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 82, 81, 81)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      onPressed: () {
                        selectTimePicker(context);
                        setState(() {
                          final DateFormat formatter = DateFormat('dd-MM-yyyy');
                          dateSelected = formatter.format(date);
                        });
                      },
                      padding: EdgeInsets.symmetric(vertical: 17.0),
                      child: Row(
                        children: [
                          Text(
                            '     ' + dateSelected + '           ',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 82, 81, 81),
                              fontSize: 17,
                            ),
                          ),
                          const Icon(
                            Icons.date_range,
                            color: Color.fromARGB(255, 1, 54, 97),
                          )
                        ],
                      )),
                  const SizedBox(height: 25.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => setState(() => _email = value),
                    validator: (value) =>
                        value!.isEmpty || !emailRegExp.hasMatch(value)
                            ? 'Entrez un email correct'
                            : null,
                    decoration: InputDecoration(
                        labelText: '   Email ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                  ),
                  const SizedBox(height: 25.0),
                  TextFormField(
                    onChanged: (value) => setState(() => _password = value),
                    validator: (value) =>
                        value!.length < 6 ? 'Mot de passe incorrect' : null,
                    decoration: InputDecoration(
                      labelText: '   Mot de passe',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      suffixIcon: InkWell(
                        onTap: () => setState(() => _isSecret = !_isSecret),
                        child: Icon(!_isSecret
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    obscureText: _isSecret,
                  ),
                  const SizedBox(height: 30.0),
                  RaisedButton(
                      color: Color.fromARGB(255, 2, 41, 73),
                      elevation: 0,
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          setListDonnee(_nom, _prenom, date, _email, _password);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) {
                              return inscripts2(listDonnee: getListDonnee());
                            },
                          ));
                        }
                      },
                      padding:
                          EdgeInsets.symmetric(vertical: 13.0, horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: const Text(
                        "Continuer",
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
}
