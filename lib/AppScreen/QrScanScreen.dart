import 'dart:async';
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:geolocator/geolocator.dart';

class QrScan extends StatefulWidget {
  final String idUser;
  const QrScan({Key? key, required this.idUser}) : super(key: key);

  @override
  State<QrScan> createState() => _QrScanState(idUser);
}

class _QrScanState extends State<QrScan> {
  String idUser;
  _QrScanState(this.idUser);

  Map<String, dynamic> qrCodeResult = {};
  Map<String, dynamic> localisation = {};
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

  getLocalisation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {}

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position _Localisation = await Geolocator.getCurrentPosition();
    localisation['latitude'] = _Localisation.latitude;
    localisation['longitude'] = _Localisation.longitude;
  }

  /*getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    EasyLoading.show(status: 'Recherche localisation...');
    _serviceEnabled = await location.serviceEnabled();
    location.enableBackgroundMode(enable: true);
    location.onLocationChanged.listen((LocationData currentLocation) {});
    print('=============================');
    print(_serviceEnabled);
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    print(_permissionGranted);
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    print('=============================');
    location.changeSettings(interval: 50);
    _locationData = await location.getLocation();
    print(_locationData);
    localisation['latitude'] = _locationData.latitude;
    localisation['longitude'] = _locationData.longitude;
    EasyLoading.dismiss();
    print('==============================');
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(top: 180),
          alignment: Alignment.center,
          child: Column(children: [
            Image.asset(
              'assets/QRCode.png',
              height: 300.0,
              width: 300.0,
              color: Color.fromARGB(255, 3, 60, 107),
            ),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              padding:
                  EdgeInsets.only(left: 60, right: 60, top: 20, bottom: 20),
              onPressed: () async {
                await getLocalisation();

                var result = await BarcodeScanner.scan();
                setState(() {
                  qrCodeResult = jsonDecode(result.rawContent);
                });
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return InfoExpediteur(
                        idUserExpediteur: qrCodeResult['id'],
                        Montant: qrCodeResult['prix'],
                        idUserCurrent: idUser,
                        Description: qrCodeResult['Description'],
                        localisation: localisation);
                  },
                  fullscreenDialog: true,
                ));
              },
              child: const Text(
                "Scanner",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              shape: RoundedRectangleBorder(
                  side: const BorderSide(
                      color: Color.fromARGB(255, 3, 60, 107), width: 2.0),
                  borderRadius: BorderRadius.circular(30.0)),
              color: const Color.fromARGB(255, 3, 60, 107),
            ),
          ])),
    );
  }
}

class InfoExpediteur extends StatefulWidget {
  final String idUserExpediteur;
  final double Montant;
  final String idUserCurrent;
  final String Description;
  final Map<String, dynamic> localisation;
  const InfoExpediteur(
      {Key? key,
      required this.idUserExpediteur,
      required this.Montant,
      required this.idUserCurrent,
      required this.Description,
      required this.localisation})
      : super(key: key);

  @override
  State<InfoExpediteur> createState() => _InfoExpediteurState(
      idUserExpediteur, Montant, idUserCurrent, Description, localisation);
}

class _InfoExpediteurState extends State<InfoExpediteur> {
  String idUserExpediteur;
  double Montant;
  String idUserCurrent;
  String Description;
  Map<String, dynamic> localisation = {};
  _InfoExpediteurState(this.idUserExpediteur, this.Montant, this.idUserCurrent,
      this.Description, this.localisation);
  @override
  int heureOp = DateTime.now().hour;
  int minuteOp = DateTime.now().minute;
  String dateOp = DateFormat('dd-MM-yyyy').format(DateTime.now());
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

  getData() async {
    if (idUserExpediteur.compareTo(idUserCurrent) != 0) {
      CollectionReference CollecRef =
          FirebaseFirestore.instance.collection('Utilisateur');
      await CollecRef.doc(idUserExpediteur).get().then((value) async {
        if (value.get('AutoPay') == 1) {
          CollecRef.doc(idUserExpediteur).update({
            'Solde': value.get('Solde') - Montant,
          });
          await CollecRef.doc(idUserCurrent).get().then((value) {
            CollecRef.doc(idUserCurrent).update({
              'Solde': value.get('Solde') + Montant,
            });
          });
          CollecRef.doc(idUserCurrent).collection('Encaisser').add({
            'Expediteur': idUserExpediteur,
            'Date': DateTime.now(),
            'Montant': Montant,
            'Description': Description,
            'Latitude': localisation['latitude'],
            'Longitude': localisation['longitude']
          });
          CollecRef.doc(idUserExpediteur).collection('Payer').add({
            'Recepteur': idUserCurrent,
            'Date': DateTime.now(),
            'Montant': Montant,
            'Description': Description,
            'Latitude': localisation['latitude'],
            'Longitude': localisation['longitude']
          });
          EasyLoading.dismiss();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Encaissement effectué avec succès',
            descTextStyle: TextStyle(fontSize: 15),
            btnCancelOnPress: () {
              Navigator.of(context).pop();
            },
            btnCancelColor: Color.fromARGB(255, 1, 39, 46),
          ).show();
          CollecRef.doc(idUserExpediteur).update({
            'AutoPay': 0,
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
                  content: Text("Vous pouvez pas effectuer cet encaissement"),
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
                      Navigator.of(context).pop();
                    }),
                    child: Text("Réssayez")),
              ],
            );
          });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 100, left: 25, right: 25, bottom: 100),
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/logoM.png',
            height: 160.0,
            width: 300.0,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Informations',
              style: TextStyle(fontSize: 35, color: Colors.black),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text(
                    'Expéditeur          : $idUserExpediteur',
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Date                     : $dateOp',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Heure                   : $heureOp:$minuteOp',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Prix à encaisser : $Montant   DA',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Description         : $Description',
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: RaisedButton(
                  onPressed: () async {
                    EasyLoading.show(
                        status: 'Patientez...', dismissOnTap: true);
                    await getData();
                  },
                  child: Text(
                    'Valider',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  color: Color.fromARGB(255, 3, 96, 172),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                  child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Annluer',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              )),
            ],
          )
        ],
      ),
    ));
  }
}
