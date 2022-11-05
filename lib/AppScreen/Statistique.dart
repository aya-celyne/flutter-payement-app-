import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:paiement/AppScreen/Chargement.dart';

class statistique extends StatefulWidget {
  final String idUser;

  const statistique({Key? key, required this.idUser}) : super(key: key);

  @override
  State<statistique> createState() => _statistiqueState(idUser);
}

class _statistiqueState extends State<statistique> {
  String idUser;
  _statistiqueState(this.idUser);
  Map<String, dynamic>? _NombreOperationPaiementDansMois = {};
  Map<String, dynamic>? _NombreOperationDansEncaissementMois = {};
  Map<String, dynamic>? _SommePayerDansMois = {};
  bool chargement = false;
  double SommePayer = 0;
  double SommeEncaisser = 0;
  double sommeRecharger = 0;
  double sommeRetirer = 0;

  List _SommeEncaisserDansMois = [];
  getSommeRechargement() async {
    DateTime dateTime = DateTime.utc(DateTime.now().year, DateTime.now().month);
    DateTime dateTime2 =
        DateTime.utc(DateTime.now().year, DateTime.now().month + 1);
    await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(idUser)
        .collection('Depot')
        .where('Date', isGreaterThanOrEqualTo: dateTime)
        .where('Date', isLessThanOrEqualTo: dateTime2)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        sommeRecharger = sommeRecharger + element['Montant'];
      });
    });
    print(sommeRecharger);
  }

  getSommeRetirer() async {
    DateTime dateTime = DateTime.utc(DateTime.now().year, DateTime.now().month);
    DateTime dateTime2 =
        DateTime.utc(DateTime.now().year, DateTime.now().month + 1);
    await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(idUser)
        .collection('Retrait')
        .where('Date', isGreaterThanOrEqualTo: dateTime)
        .where('Date', isLessThanOrEqualTo: dateTime2)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        sommeRetirer = sommeRetirer + element['Montant'];
      });
    });
    print(sommeRetirer);
  }

  getSommePayer() async {
    DateTime dateTime = DateTime.utc(DateTime.now().year, DateTime.now().month);
    DateTime dateTime2 =
        DateTime.utc(DateTime.now().year, DateTime.now().month + 1);
    await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(idUser)
        .collection('Payer')
        .where('Date', isGreaterThanOrEqualTo: dateTime)
        .where('Date', isLessThanOrEqualTo: dateTime2)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        SommePayer = SommePayer + element['Montant'];
      });
      print(SommePayer);
    });
  }

  getSommeEncaisser() async {
    DateTime dateTime = DateTime.utc(DateTime.now().year, DateTime.now().month);
    DateTime dateTime2 =
        DateTime.utc(DateTime.now().year, DateTime.now().month + 1);
    await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(idUser)
        .collection('Encaisser')
        .where('Date', isGreaterThanOrEqualTo: dateTime)
        .where('Date', isLessThanOrEqualTo: dateTime2)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        SommeEncaisser = SommeEncaisser + element['Montant'];
      });
    });
  }

  getDataPaiement(int month) async {
    DateTime dateTime = DateTime.utc(DateTime.now().year, month);
    DateTime dateTime2 = DateTime.utc(DateTime.now().year, month + 1);

    await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(idUser)
        .collection('Payer')
        .where('Date', isGreaterThanOrEqualTo: dateTime)
        .where('Date', isLessThanOrEqualTo: dateTime2)
        .get()
        .then((value) {
      _NombreOperationPaiementDansMois![(month).toString()] = value.docs.length;
    });
  }

  getDataEncaissement(int month) async {
    DateTime dateTime = DateTime.utc(DateTime.now().year, month);
    DateTime dateTime2 = DateTime.utc(DateTime.now().year, month + 1);

    await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(idUser)
        .collection('Encaisser')
        .where('Date', isGreaterThanOrEqualTo: dateTime)
        .where('Date', isLessThanOrEqualTo: dateTime2)
        .get()
        .then((value) {
      _NombreOperationDansEncaissementMois![(month).toString()] =
          value.docs.length;
    });
  }

  getStistiqueNombrepaiement() async {
    await getSommeRechargement();
    await getSommeRetirer();
    await getSommePayer();
    await getSommeEncaisser();
    for (int i = 1; i <= 12; i++) {
      await getDataPaiement(i);
      await getDataEncaissement(i);
      setState(() {
        chargement = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getStistiqueNombrepaiement();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return chargement == false
        ? Chargement()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 3, 60, 107),
              elevation: 0,
              title: Text(
                'Statistiques',
                style: TextStyle(fontSize: 25),
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: (() => Navigator.of(context).pop()),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            ),
            backgroundColor: Color.fromARGB(255, 3, 60, 107),
            body: SingleChildScrollView(
              child: Container(
                  alignment: Alignment.center,
                  // color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Image.asset(
                        'assets/Qrbleu.png',
                        height: 140.0,
                        width: 350.0,
                        //color: Colors.white,
                      ),
                      Image.asset(
                        'assets/logoM.png',
                        height: 100.0,
                        width: 350.0,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 20),
                        child: Text(
                          "1- Le nombre d'opérations de Paiement et Encaissement réalisées dans chaque mois durant l'année courante",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 150, top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '__',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '  Paiement',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '__',
                                  style: TextStyle(
                                      color: Color.fromRGBO(39, 228, 244, 80),
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '  Encaissement',
                                  style: TextStyle(
                                      color: Color.fromRGBO(39, 228, 244, 80),
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            children: [
                              RotatedBox(
                                  quarterTurns: 3,
                                  child: Text(
                                    'Nombre Opérations',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  )),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: DChartLine(
                                        lineColor: (lineData, index, id) {
                                          return id == 'Line 1'
                                              ? Colors.red
                                              : Color.fromRGBO(
                                                  39, 228, 244, 80);
                                        },
                                        data: [
                                          {
                                            'id': 'Line 1',
                                            'data': [
                                              {
                                                'domain': 1,
                                                'measure':
                                                    _NombreOperationPaiementDansMois![
                                                        '1']
                                              },
                                              {
                                                'domain': 2,
                                                'measure':
                                                    _NombreOperationPaiementDansMois![
                                                        '2']
                                              },
                                              {
                                                'domain': 3,
                                                'measure':
                                                    _NombreOperationPaiementDansMois![
                                                        '3']
                                              },
                                              {
                                                'domain': 4,
                                                'measure':
                                                    _NombreOperationPaiementDansMois![
                                                        '4'],
                                              },
                                              {
                                                'domain': 5,
                                                'measure':
                                                    _NombreOperationPaiementDansMois![
                                                        '5']
                                              },
                                              {
                                                'domain': 6,
                                                'measure':
                                                    _NombreOperationPaiementDansMois![
                                                        '6']
                                              },
                                              {
                                                'domain': 7,
                                                'measure':
                                                    _NombreOperationPaiementDansMois![
                                                        '7']
                                              },
                                              {
                                                'domain': 8,
                                                'measure':
                                                    _NombreOperationPaiementDansMois![
                                                        '8'],
                                              },
                                              {
                                                'domain': 9,
                                                'measure':
                                                    _NombreOperationPaiementDansMois![
                                                        '9']
                                              },
                                              {
                                                'domain': 10,
                                                'measure':
                                                    _NombreOperationPaiementDansMois![
                                                        '10']
                                              },
                                              {
                                                'domain': 11,
                                                'measure':
                                                    _NombreOperationPaiementDansMois![
                                                        '11']
                                              },
                                              {
                                                'domain': 12,
                                                'measure':
                                                    _NombreOperationPaiementDansMois![
                                                        '12'],
                                              },
                                            ],
                                          },
                                          {
                                            'id': 'Line 2',
                                            'data': [
                                              {
                                                'domain': 1,
                                                'measure':
                                                    _NombreOperationDansEncaissementMois![
                                                        '1']
                                              },
                                              {
                                                'domain': 2,
                                                'measure':
                                                    _NombreOperationDansEncaissementMois![
                                                        '2']
                                              },
                                              {
                                                'domain': 3,
                                                'measure':
                                                    _NombreOperationDansEncaissementMois![
                                                        '3']
                                              },
                                              {
                                                'domain': 4,
                                                'measure':
                                                    _NombreOperationDansEncaissementMois![
                                                        '4'],
                                              },
                                              {
                                                'domain': 5,
                                                'measure':
                                                    _NombreOperationDansEncaissementMois![
                                                        '5']
                                              },
                                              {
                                                'domain': 6,
                                                'measure':
                                                    _NombreOperationDansEncaissementMois![
                                                        '6']
                                              },
                                              {
                                                'domain': 7,
                                                'measure':
                                                    _NombreOperationDansEncaissementMois![
                                                        '7']
                                              },
                                              {
                                                'domain': 8,
                                                'measure':
                                                    _NombreOperationDansEncaissementMois![
                                                        '8'],
                                              },
                                              {
                                                'domain': 9,
                                                'measure':
                                                    _NombreOperationDansEncaissementMois![
                                                        '9']
                                              },
                                              {
                                                'domain': 10,
                                                'measure':
                                                    _NombreOperationDansEncaissementMois![
                                                        '10']
                                              },
                                              {
                                                'domain': 11,
                                                'measure':
                                                    _NombreOperationDansEncaissementMois![
                                                        '11']
                                              },
                                              {
                                                'domain': 12,
                                                'measure':
                                                    _NombreOperationDansEncaissementMois![
                                                        '12'],
                                              },
                                            ],
                                          },
                                        ],
                                        includePoints: true,
                                      ),
                                    ),
                                    Text(
                                      'Mois',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 20, top: 40),
                        child: Text(
                          "2- Les sommes des paiements et encaissements faites durant le mois courant:",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 150, top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '__',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '  Payer',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '__',
                                  style: TextStyle(
                                      color: Color.fromRGBO(39, 228, 244, 80),
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '  Encaisser',
                                  style: TextStyle(
                                      color: Color.fromRGBO(39, 228, 244, 80),
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: DChartPie(
                            data: [
                              {'domain': 'Payer', 'measure': SommePayer},
                              {
                                'domain': 'Encaisser',
                                'measure': SommeEncaisser
                              },
                            ],
                            fillColor: (pieData, index) {
                              switch (pieData['domain']) {
                                case 'Payer':
                                  return Colors.red;
                                case 'Encaisser':
                                  return Color.fromRGBO(39, 228, 244, 80);
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 20, top: 40),
                        child: Text(
                          "3- La somme des rechargement et la somme retirée durant le mois courant:",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 150, top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '__',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '  Retrait',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '__',
                                  style: TextStyle(
                                      color: Color.fromRGBO(39, 228, 244, 80),
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '  Dépôt',
                                  style: TextStyle(
                                      color: Color.fromRGBO(39, 228, 244, 80),
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: DChartPie(
                              data: [
                                {'domain': 'P', 'measure': sommeRetirer},
                                {'domain': 'E', 'measure': sommeRecharger},
                              ],
                              fillColor: (pieData, index) {
                                switch (pieData['domain']) {
                                  case 'P':
                                    return Colors.red;
                                  case 'E':
                                    return Color.fromRGBO(39, 228, 244, 80);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ));
  }
}
