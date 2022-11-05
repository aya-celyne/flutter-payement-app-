import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class adduser extends StatefulWidget {
  final String value;
  const adduser({Key? key, required this.value}) : super(key: key);

  @override
  State<adduser> createState() => _adduserState(value);
}

class _adduserState extends State<adduser> {
  final _nomControler = TextEditingController();
  final _prenomControler = TextEditingController();
  final _photoControler = TextEditingController();
  List<String> selected = [];
  String value = '';
  _adduserState(this.value);
  mahrez() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(value),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  Text('nom'),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          //border: InputBorder.none,
                          ),
                      controller: _nomControler,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Row(
                children: [
                  Text('Prenom'),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          //border: InputBorder.none,
                          ),
                      controller: _prenomControler,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Row(
                children: [
                  Text('photo'),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          //border: InputBorder.none,
                          ),
                      controller: _photoControler,
                    ),
                  )
                ],
              ),
            ),
            DropDownMultiSelect(
              onChanged: (List<String> x) {
                setState(() {
                  selected = x;
                });
              },
              options: ['a', 'b', 'c', 'd'],
              selectedValues: selected,
              whenEmpty: 'Select Something',
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  FirebaseFirestore.instance.collection('Utilisateur').add({
                    'nom': _nomControler.value.text,
                    'Prenom': _prenomControler.value.text,
                    'photo': _photoControler.value.text,
                  });
                  Navigator.pop(context);
                },
                child: const Text("AJOUTER"))
          ],
        ),
      ),
    );
  }
}
