import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paap_punya/models/deed.dart';

class DatabaseService {
  final String uid;
  final String username;

  DatabaseService({this.uid, this.username});
  //collection reference
  final CollectionReference deedCollection =
      FirebaseFirestore.instance.collection("deeds");

 // Future updateUserData(String username, String deedName, String deedDesc,
  //    bool deedType, int deedStrength) async {
  //  return await deedCollection.doc(uid).set({
  //    "username": username,
   //   'deedName': deedName,
  //    'deedDesc': deedDesc,
  //    'deedType': deedType,
  //    'deedStrength': deedStrength,
//});
 // }

  Future updateUserData(String username, String deedName, String deedDesc,
      bool deedType, int deedStrength) async {
    return await deedCollection.doc(uid).set({
      "username": username,
      'deedName': deedName,
      'deedDesc': deedDesc,
      'deedType': deedType,
      'deedStrength': deedStrength,
    });
  }

  // deed list from snapshot
  List<Deed> _deedListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Deed(
        username: doc.data()['username'] ?? '',
        deedName: doc.data()['deedName'] ?? '',
        deedDesc: doc.data()['deedDesc'] ?? '',
        deedType: doc.data()['deedType'] ?? true,
        deedStrength: doc.data()['deedStrength'] ?? 0,
      );
    }).toList();
  }

  //get deeds stream
  Stream<List<Deed>> get deeds {
    return deedCollection.snapshots().map(_deedListFromSnapshot);
  }
}
