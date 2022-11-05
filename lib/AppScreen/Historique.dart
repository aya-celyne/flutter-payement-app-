import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:paiement/AppScreen/Historique2.dart';
import 'package:paiement/AppScreen/UserInfo.dart';
import 'package:geocoding/geocoding.dart';

import 'UploadImage.dart';

class Historique extends StatefulWidget {
  final String idUser;
  const Historique({Key? key, required this.idUser}) : super(key: key);

  @override
  State<Historique> createState() => _HistoriqueState(idUser);
}

class _HistoriqueState extends State<Historique> {
  String idUser;
  _HistoriqueState(this.idUser);
  getdat() {}
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 6,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Historique',
                  style: TextStyle(fontSize: 25, color: Colors.white)),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Image.asset(
                  'assets/QRCode.png',
                  color: Colors.white,
                  cacheWidth: 20,
                  cacheHeight: 20,
                  alignment: Alignment.center,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 3, 60, 107),
              bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Text('Paiements'),
                      icon: Icon(Icons.payment_outlined),
                    ),
                    Tab(
                        child: Text('Encaissements'),
                        icon: Icon(Icons.payments_outlined)),
                    Tab(
                        child: Text('Transferts'),
                        icon: Icon(Icons.trending_up)),
                    Tab(
                        child: Text('Recevoir'),
                        icon: Icon(Icons.trending_down)),
                    Tab(
                      child: Text('Mes Dépot'),
                      icon: Icon(Icons.add_card),
                    ),
                    Tab(
                      child: Text('Mes Retraits'),
                      icon: Icon(Icons.sell),
                    ),
                  ]),
            ),
            body: TabBarView(
              children: [
                PaiementHistorique(idUser: idUser),
                EncaissementHistorique(idUser: idUser),
                TransfertHistorique(idUser: idUser),
                RecevoirHistorique(idUser: idUser),
                DepotHistorique(
                  idUser: idUser,
                ),
                RetraitHistorique(idUser: idUser)
              ],
            )));
  }
}

class PaiementHistorique extends StatefulWidget {
  final String idUser;

  const PaiementHistorique({Key? key, required this.idUser}) : super(key: key);

  @override
  State<PaiementHistorique> createState() => _PaiementHistoriqueState(idUser);
}

class _PaiementHistoriqueState extends State<PaiementHistorique> {
  String idUser;
  _PaiementHistoriqueState(this.idUser);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Utilisateur')
            .doc(idUser)
            .collection('Payer')
            .orderBy('Date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'loading...',
                    style: TextStyle(fontSize: 30),
                  )),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              Utilisateur recepteur = Utilisateur(data['Recepteur']);
              Timestamp _timestamp = data['Date'];
              final DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm');
              String dateN = formatter.format(_timestamp.toDate());
              return Container(
                  height: 70,
                  //color: Color.fromARGB(255, 184, 12, 92),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Color.fromARGB(255, 15, 33, 138),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      data['Montant'].toString() + ' DA',
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(dateN,
                        style:
                            TextStyle(color: Color.fromARGB(255, 1, 47, 85))),
                    trailing: Icon(
                      Icons.call_made_rounded,
                      size: 30,
                      color: Colors.red,
                    ),
                    onLongPress: () async {
                      String _lieu = await getLocaliation(
                          data['Latitude'], data['Longitude']);
                      AwesomeDialog(
                          context: context,
                          body: Container(
                              height: 350,
                              width: 400,
                              color: Colors.white,
                              padding: EdgeInsets.only(left: 10, top: 10),
                              child: Column(
                                children: [
                                  Image.asset('assets/logoM.png', height: 60),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 0),
                                        child: Text(
                                          'Informations',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 35,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text('Réference  : ${document.id} ',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text(
                                            'Récepteur  : ${data['Recepteur']}',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          'Montant     : ${data['Montant']} DA',
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
                                      Text('Date            : $dateN',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text('Lieu             : ${_lieu}',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              )),
                          dialogType: DialogType.NO_HEADER,
                          btnOkColor: Color.fromARGB(255, 3, 60, 107),
                          animType: AnimType.BOTTOMSLIDE,
                          btnCancelOnPress: () {},
                          btnCancelColor: Color.fromARGB(255, 3, 60, 107))
                        ..show();
                    },
                  ));
            }).toList(),
          );
        });
  }
}

//Widget des Encaissement
class EncaissementHistorique extends StatefulWidget {
  final String idUser;

  const EncaissementHistorique({Key? key, required this.idUser})
      : super(key: key);

  @override
  State<EncaissementHistorique> createState() =>
      _EncaissementHistoriqueState(idUser);
}

class _EncaissementHistoriqueState extends State<EncaissementHistorique> {
  String idUser;
  _EncaissementHistoriqueState(this.idUser);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Utilisateur')
            .doc(idUser)
            .collection('Encaisser')
            .orderBy('Date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'loading...',
                    style: TextStyle(fontSize: 30),
                  )),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              Utilisateur expiditeur = Utilisateur(data['Expediteur']);
              Timestamp _timestamp = data['Date'];
              final DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm');
              String dateN = formatter.format(_timestamp.toDate());
              return Container(
                  height: 70,
                  //color: Color.fromARGB(255, 184, 12, 92),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Color.fromARGB(255, 15, 33, 138),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      data['Montant'].toString() + ' DA',
                      style: TextStyle(fontSize: 22),
                    ),
                    subtitle: Text(dateN),
                    trailing: Icon(
                      Icons.call_received_rounded,
                      size: 30,
                      color: Colors.green,
                    ),
                    onLongPress: () async {
                      String _lieu = await getLocaliation(
                          data['Latitude'], data['Longitude']);
                      AwesomeDialog(
                          context: context,
                          body: Container(
                              height: 350,
                              width: 400,
                              color: Colors.white,
                              padding: EdgeInsets.only(left: 10, top: 20),
                              child: Column(
                                children: [
                                  Image.asset('assets/logoM.png', height: 60),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 0),
                                        child: Text(
                                          'Informations',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text('Réference  :${document.id} ',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text(
                                            'Récepteur  : ${data['Expediteur']}',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Text('Montant     :${data['Montant']} DA',
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
                                      Text('Date            : $dateN',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text('Lieu             : ${_lieu}',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              )),
                          dialogType: DialogType.NO_HEADER,
                          btnOkColor: Color.fromARGB(255, 3, 60, 107),
                          animType: AnimType.BOTTOMSLIDE,
                          btnCancelOnPress: () {},
                          btnCancelColor: Color.fromARGB(255, 3, 60, 107))
                        ..show();
                    },
                  ));
            }).toList(),
          );
        });
  }
}

class TransfertHistorique extends StatefulWidget {
  final String idUser;

  const TransfertHistorique({Key? key, required this.idUser}) : super(key: key);

  @override
  State<TransfertHistorique> createState() => _TransfertHistoriqueState(idUser);
}

class _TransfertHistoriqueState extends State<TransfertHistorique> {
  String idUser;
  _TransfertHistoriqueState(this.idUser);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Utilisateur')
            .doc(idUser)
            .collection('Transferer')
            .orderBy('Date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'loading...',
                    style: TextStyle(fontSize: 30),
                  )),
            );
          }

          return ListView(
              children: snapshot.data!.docs.map(
            (DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              Utilisateur recepteur = Utilisateur(data['Recepteur']);
              Timestamp _timestamp = data['Date'];
              final DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm');
              String dateN = formatter.format(_timestamp.toDate());

              return Container(
                  height: 80,
                  //color: Color.fromARGB(255, 184, 12, 92),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Color.fromARGB(255, 3, 60, 107),
                    ),
                  ),
                  alignment: Alignment.center,
                  //padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                  child: ListTile(
                    title: Text(
                      data['NomRecepteur'],
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      data['Montant'].toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: const Icon(
                      Icons.trending_up_rounded,
                      color: Colors.red,
                      size: 30,
                    ),
                    onLongPress: () {
                      AwesomeDialog(
                          context: context,
                          body: Container(
                              height: 350,
                              width: 400,
                              color: Colors.white,
                              padding: EdgeInsets.only(left: 10, top: 20),
                              child: Column(
                                children: [
                                  Image.asset('assets/logoM.png', height: 60),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 0),
                                        child: Text(
                                          'Informations',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text('Réference  :${document.id} ',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text(
                                            'Récepteur  : ${data['Recepteur']}',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Text('Montant     :${data['Montant']} DA',
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
                                      Text('Date            : $dateN',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ))
                                    ],
                                  ),
                                ],
                              )),
                          dialogType: DialogType.NO_HEADER,
                          btnOkColor: Color.fromARGB(255, 3, 60, 107),
                          animType: AnimType.BOTTOMSLIDE,
                          btnCancelOnPress: () {},
                          btnCancelColor: Color.fromARGB(255, 3, 60, 107))
                        ..show();
                    },
                  ));
            },
          ).toList());
        });
  }
}

class RecevoirHistorique extends StatefulWidget {
  final String idUser;
  const RecevoirHistorique({Key? key, required this.idUser}) : super(key: key);

  @override
  State<RecevoirHistorique> createState() => _RecevoirHistoriqueState(idUser);
}

class _RecevoirHistoriqueState extends State<RecevoirHistorique> {
  String idUser;
  _RecevoirHistoriqueState(this.idUser);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Utilisateur')
            .doc(idUser)
            .collection('Receptionner')
            .orderBy('Date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'loading...',
                    style: TextStyle(fontSize: 30),
                  )),
            );
          }

          return ListView(
              children: snapshot.data!.docs.map(
            (DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              Utilisateur expediteur = Utilisateur('mahrez.aberkane@gmail.com');
              Timestamp _timestamp = data['Date'];
              final DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm');
              String dateN = formatter.format(_timestamp.toDate());
              return Container(
                  height: 80,
                  //color: Color.fromARGB(255, 184, 12, 92),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Color.fromARGB(255, 3, 60, 107),
                    ),
                  ),
                  alignment: Alignment.center,
                  //padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                  child: ListTile(
                    title: Text(
                      data['NomEmeteur'],
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(data['Montant'].toString()),
                    trailing: Icon(
                      Icons.trending_down_rounded,
                      color: Colors.green,
                      size: 30,
                    ),
                    onLongPress: () {
                      AwesomeDialog(
                          context: context,
                          body: Container(
                              height: 330,
                              width: 400,
                              color: Colors.white,
                              padding: EdgeInsets.only(left: 10, top: 20),
                              child: Column(
                                children: [
                                  Image.asset('assets/logoM.png', height: 60),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 0),
                                        child: Text(
                                          'Informations',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text('Réference  :${document.id} ',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text(
                                            'Récepteur  : ${data['Expediteur']}',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Text('Montant     :${data['Montant']} DA',
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
                                      Text('Date            : $dateN',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ))
                                    ],
                                  ),
                                ],
                              )),
                          dialogType: DialogType.NO_HEADER,
                          btnOkColor: Color.fromARGB(255, 3, 60, 107),
                          animType: AnimType.BOTTOMSLIDE,
                          btnCancelOnPress: () {},
                          btnCancelColor: Color.fromARGB(255, 3, 60, 107))
                        ..show();
                    },
                  ));
            },
          ).toList());
        });
  }
}
