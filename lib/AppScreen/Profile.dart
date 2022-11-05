import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:paiement/AppScreen/Parametre.dart';
import 'package:paiement/AppScreen/UserInfo.dart';
import 'package:paiement/AppScreen/profileScreen.dart';

import 'UploadImage.dart';

class Profile extends StatefulWidget {
  final String idUser;
  const Profile({Key? key, required this.idUser}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState(idUser);
}

class _ProfileState extends State<Profile> {
  String idUser;
  _ProfileState(this.idUser);
  photoProfile(String url) async {
    Utilisateur user = Utilisateur(idUser);
    await user.UpdatePhotodeProfile(url);
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> _usersStream =
        FirebaseFirestore.instance
            .collection('Utilisateur')
            .doc(idUser)
            .snapshots();
    CollectionReference users =
        FirebaseFirestore.instance.collection('Utilisateur');
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Utilisateur')
            .doc(idUser)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
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
            );
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          Timestamp _timestamp = data['Date de Naissance'];
          final DateFormat formatter = DateFormat('dd-MM-yyyy');
          String dateN = formatter.format(_timestamp.toDate());

          return Scaffold(
              body: ListView(
            children: [
              Material(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(100),
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
                child: Container(
                    width: double.infinity,
                    height: 340,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 3, 60, 107),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(100),
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                      border:
                          Border.all(color: Color.fromARGB(255, 12, 11, 11)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Stack(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(data['Photo']),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: CircleAvatar(
                                backgroundColor: Color.fromARGB(255, 0, 9, 15),
                                foregroundColor:
                                    Color.fromARGB(255, 248, 245, 245),
                                radius: 20,
                                child: IconButton(
                                    onPressed: () {
                                      chooseImage();
                                    },
                                    icon: Icon(Icons.edit)),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              data['nom'].toUpperCase() +
                                  ' ' +
                                  data['Prenom'].substring(0),
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic),
                            ))
                      ],
                    )),
              ),
              ListTile(
                title: Text(
                  'Adress',
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(data['adress']),
                leading: Icon(Icons.location_on),
                iconColor: Colors.black,
              ),
              ListTile(
                title: Text(
                  'e-mail',
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(idUser),
                leading: Icon(Icons.email),
                iconColor: Colors.black,
              ),
              ListTile(
                title: const Text(
                  'Numero de Telephone',
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text('0' + data['NumeroTel'].toString()),
                leading: Icon(Icons.phone),
                iconColor: Colors.black,
              ),
              ListTile(
                title: const Text(
                  'Date de Naissance',
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(dateN),
                leading: const Icon(Icons.date_range_sharp),
                iconColor: Colors.black,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return Parametre(
                                    idUser: idUser,
                                  );
                                },
                                fullscreenDialog: true,
                              ));
                            },
                            icon: const Icon(Icons.settings)),
                        const Text("Paramètre")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                return Apropos();
                              },
                              fullscreenDialog: true,
                            ));
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.infoCircle,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                        const Text("À propos")
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.exit_to_app)),
                        Text("Déconnecter")
                      ],
                    ),
                  )
                ],
              )
            ],
          ));
        });
  }

  chooseImage() {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        body: Container(
          height: 100,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: <Widget>[
              Text(
                "choisir photo de profile",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton.icon(
                      onPressed: () async {
                        var url = await uploadImage('Profile', 0);
                        photoProfile(url);
                      },
                      icon: Icon(Icons.camera),
                      label: Text("Camera")),
                  FlatButton.icon(
                      onPressed: () async {
                        var url = await uploadImage('Profile', 1);
                        photoProfile(url);
                      },
                      icon: Icon(Icons.image),
                      label: Text("Gallery"))
                ],
              )
            ],
          ),
        ))
      ..show();
  }

  showSuccesUploadImage() {
    AwesomeDialog(
        context: context,
        title: 'La photo de profile a été mis à jour',
        dialogType: DialogType.SUCCES,
        btnCancelOnPress: () {},
        btnCancelColor: Color.fromARGB(255, 3, 60, 107))
      ..show();
  }
}
