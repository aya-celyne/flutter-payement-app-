import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paiement/AppScreen/UserInfo.dart';

class DepotHistorique extends StatefulWidget {
  final String idUser;
  const DepotHistorique({Key? key, required this.idUser}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<DepotHistorique> createState() => _DepotHistoriqueState(idUser);
}

class _DepotHistoriqueState extends State<DepotHistorique> {
  String idUser;
  _DepotHistoriqueState(this.idUser);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Utilisateur')
            .doc(idUser)
            .collection('Depot')
            .orderBy('Date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'loading...',
                    style: TextStyle(fontSize: 30),
                  )),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              // Utilisateur recepteur = Utilisateur(data['Recepteur']);
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
                      Icons.arrow_drop_up,
                      size: 60,
                      color: Colors.green,
                    ),
                    onLongPress: () async {
                      AwesomeDialog(
                              context: context,
                              body: Container(
                                  height: 350,
                                  width: 400,
                                  color: Colors.white,
                                  padding: EdgeInsets.only(left: 10, top: 30),
                                  child: Column(
                                    children: [
                                      Image.asset('assets/logoM.png',
                                          height: 60),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 0),
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
                                            Text(
                                                'Réference     : ${document.id} ',
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
                                              'Numero CB   : ${data['Carte CB']}',
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
                                          Text(
                                              'Titulaire CB   : ${data['TitulaireCB']}',
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
                                          Text(
                                              'Montant         : ${data['Montant']} DA',
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
                                          Text('Date                : $dateN',
                                              style: const TextStyle(
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
                          .show();
                    },
                  ));
            }).toList(),
          );
        });
  }
}

class RetraitHistorique extends StatefulWidget {
  final String idUser;
  const RetraitHistorique({Key? key, required this.idUser}) : super(key: key);

  @override
  State<RetraitHistorique> createState() => _RetraitHistoriqueState(idUser);
}

class _RetraitHistoriqueState extends State<RetraitHistorique> {
  String idUser;
  _RetraitHistoriqueState(this.idUser);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Utilisateur')
            .doc(idUser)
            .collection('Retrait')
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
                      Icons.arrow_drop_down,
                      size: 60,
                      color: Colors.red,
                    ),
                    onLongPress: () async {
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
                                    height: 20,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text('Réference    : ${document.id} ',
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
                                          'N° Compte   : ${data['NumeroCompte']}',
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
                                      Text(
                                          'Titulaire       : ${data['Titulaire']} ',
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
                                      Text(
                                          'Montant       : ${data['Montant']} DA',
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
                                      Text('Date              : $dateN',
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
            }).toList(),
          );
        });
  }
}
