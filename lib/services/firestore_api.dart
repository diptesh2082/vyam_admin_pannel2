import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreAPI {
  Future checkIffiledExists() async {
    DocumentSnapshot _ref = await FirebaseFirestore.instance
        .collection('products_details')
        .doc('mahtab5752@gmail.com')
        .get();

    if (_ref.exists) {
      //Exists
    }
    var email = _ref.get("email");
    if (email != null) {
      // Exists
    } else {
      //Doesn't Exists
    }
  }
}
