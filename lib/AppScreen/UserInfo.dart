import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur {
  String id, nom = '', prenom = '', etat = '', address = '';
  int NumeroTel = 0, numCarteID = 0;
  double Solde = 0;

  Utilisateur(this.id) {
    FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(id)
        .snapshots()
        .listen((event) {
      nom = event.get('nom');
      prenom = event.get('Prenom');
      etat = event.get('Etat');
      address = event.get('adress');
      NumeroTel = event.get('NumeroTel');
      numCarteID = event.get('Numero de carteID');
      Solde = event.get('Solde');
    });
  }
  double getSolde() {
    return Solde;
  }

  String getNomComplet() {
    return nom + ' ' + prenom;
  }

  setSolde(double _solde) async {
    await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(id)
        .update({'Solde': _solde});
  }

  retirer(double montant, String NomTitulaire, String N_Iban,
      int NumeroCompte) async {
    await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(id)
        .collection('Retrait')
        .add({
      'Montant': montant,
      'NumeroCompte': NumeroCompte,
      'Titulaire': NomTitulaire,
      'IBAN': N_Iban,
      'Date': DateTime.now()
    });
    await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(id)
        .update({'Solde': Solde - montant});
  }

  deposer(double montant, String TitulaireCB, int NumCB) async {
    await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(id)
        .collection('Depot')
        .add({
      'Montant': montant,
      'Carte CB': NumCB,
      'TitulaireCB': TitulaireCB,
      'Date': DateTime.now()
    });
    await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(id)
        .update({'Solde': Solde + montant});
  }

  UpdatePhotodeProfile(String Url) async {
    await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(id)
        .update({'Photo': Url});
  }

  UpdateNumeroTelephone(int PhoneNumber) async {
    await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(id)
        .update({'NumeroTel': PhoneNumber});
  }

  UpdateSeuilQuotidien(double seuil) async {
    await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(id)
        .update({'SeuilQuotidien': seuil});
  }

  Future<double> getSeiul() async {
    DateTime dateTime = DateTime.utc(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime dateTime2 = DateTime.utc(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

    await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(id)
        .collection('Payer')
        .where('Date', isGreaterThanOrEqualTo: dateTime)
        .where('Date', isLessThanOrEqualTo: dateTime2)
        .get()
        .then((value) {
      double sommePayeJour = 0;
      value.docs.forEach((element) {
        sommePayeJour += element['Montant'];
      });
      return sommePayeJour;
    });
    return 0;
  }
}
