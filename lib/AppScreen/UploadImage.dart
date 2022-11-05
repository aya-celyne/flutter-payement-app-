import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

Future<String> uploadImage(String genre, int source) async {
  File? file;
  var imagepiker = ImagePicker();
  var imagePicked;
  if (source == 0) {
    imagePicked = await imagepiker.getImage(source: ImageSource.camera);
  } else {
    imagePicked = await imagepiker.getImage(source: ImageSource.gallery);
  }

  if (imagePicked != null) {
    EasyLoading.show(status: 'Charger....', dismissOnTap: true);
    file = File(imagePicked.path);
    var nameImage = basename(imagePicked.path);
    var refstorage = FirebaseStorage.instance.ref("$genre/$nameImage");

    await refstorage.putFile(file);
    String url = await refstorage.getDownloadURL();
    EasyLoading.showSuccess('image téléchargée');
    return url;
  } else {
    return '';
  }
}

Future<String> getLocaliation(double lat, double long) async {
  List<Placemark> placemarks = [];
  placemarks = await placemarkFromCoordinates(lat, long);
  String s = '';
  s = placemarks[2].street.toString() +
      '-' +
      placemarks[3].street.toString() +
      '-' +
      placemarks[3].locality.toString() +
      '-' +
      placemarks[3].subLocality.toString();

  return s;
}
