import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUser(String userId, Map<String, dynamic> userInfoMap) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")  // Ensure the collection name matches exactly
          .doc(userId)
          .set(userInfoMap, SetOptions(merge: true));
      print("User data successfully added/updated for UID: $userId");
    } catch (e) {
      print("Error adding/updating user in Firestore: $e");
    }
  }
}
