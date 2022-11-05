import 'package:flutter/material.dart';
import 'package:paiement/AppScreen/CompteScreen.dart';
import 'package:paiement/AppScreen/PayerScreen.dart';
import 'package:paiement/AppScreen/Profile.dart';
import 'package:paiement/AppScreen/QrScanScreen.dart';
import 'package:paiement/AppScreen/TransfereScreen.dart';
import 'package:paiement/AppScreen/profileScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavBar extends StatefulWidget {
  final String idUser;

  const NavBar({
    Key? key,
    required this.idUser,
  }) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState(idUser);
}

class _NavBarState extends State<NavBar> {
  String idUser;
  _NavBarState(this.idUser);
  String id = '';
  int selectedpage = 0;
  List<Widget> MyScreens() {
    return [
      CompteScreen(idUser: idUser),
      PayerScreen(idUser: idUser),
      QrScan(idUser: idUser),
      TransfereScreen(idUser: idUser),
      Profile(idUser: idUser),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          elevation: 35,
          selectedIconTheme: IconThemeData(size: 30),
          currentIndex: selectedpage,
          onTap: (index) {
            setState(() {
              selectedpage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                label: 'Compte',
                icon: Icon(Icons.account_balance_outlined),
                backgroundColor: Color.fromARGB(255, 3, 60, 107)),
            BottomNavigationBarItem(
              label: 'Payer',
              backgroundColor: Color.fromARGB(255, 3, 60, 107),
              icon: Icon(Icons.qr_code),
            ),
            BottomNavigationBarItem(
              label: 'Encaisser',
              icon: Icon(Icons.camera),
              backgroundColor: Color.fromARGB(255, 3, 60, 107),
            ),
            BottomNavigationBarItem(
                label: 'Transférer',
                icon: FaIcon(
                  FontAwesomeIcons.exchangeAlt,
                  color: Colors.white,
                  size: 23,
                ),
                backgroundColor: Color.fromARGB(255, 3, 60, 107)),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(Icons.account_circle),
              backgroundColor: Color.fromARGB(255, 3, 60, 107),
            ),
          ]),
      body: MyScreens().elementAt(selectedpage),
    );
  }
}
