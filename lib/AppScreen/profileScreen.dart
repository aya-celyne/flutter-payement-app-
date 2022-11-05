import 'package:flutter/material.dart';

class Apropos extends StatefulWidget {
  const Apropos({Key? key}) : super(key: key);

  @override
  State<Apropos> createState() => _AproposState();
}

class _AproposState extends State<Apropos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: Image.asset(
            'assets/propos.png',
            // width: double.infinity,
          ).image,
        )),
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Image.asset(
              'assets/Qrbleu.png',
              height: 150.0,
              width: 290.0,
            ),
            Image.asset(
              'assets/logoM.png',
              height: 100.0,
              width: 290.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 100, top: 30),
              child: Text(
                'à propos de nous : ',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 90, top: 20, right: 10),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 120,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 13, 113, 172),
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                  ),
                  child: Text(
                    "Application de paiement en utilisant des codes QR pour faciliter l’échange d’argent entre 2 personnes, l’application permet aussi de faire des transferts distant à des prix limités.",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 100, top: 30),
              child: Text(
                'Paiement en ligne : ',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 70, top: 20, left: 10),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 130,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 13, 113, 172),
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                  ),
                  child: Text(
                    "Un paiement en ligne est le fait de régler des achats grâce à Internet via des appareils connectés, comme des smartphones ou des ordinateurs. Dans notre cas : c’est par votre application mobile QR PAY.",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 100, top: 30),
              child: Text(
                'QR CODE : ',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 70, top: 20, bottom: 20),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 170,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 13, 113, 172),
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                  ),
                  child: Text(
                    "code lisible par une machine, généralement utilisé pour stocker des URL ou d'autres informations qui seront lues par l'appareil photo d'un smartphone. Dans ce cas le code stocke les informations de paiement que vous désirez envoyer ou encaisser and that's the result.",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
