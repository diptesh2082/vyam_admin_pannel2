import 'package:cloud_firestore/cloud_firestore.dart';

matchID({String? newId, CollectionReference? matchStream, String? idField}) {
  matchStream!.doc(newId).set({'$idField': newId});
}
