import 'package:firebase_database/firebase_database.dart';

Future<Map> getMapFromFirebase(String resource, String id) async {
  String safeId =
      id.replaceAll('.', ',').replaceAll('[', '-').replaceAll(']', '-');
  final DatabaseReference eventRef =
      FirebaseDatabase.instance.ref().child(resource).child(safeId);
      Map<dynamic, dynamic> map = {};
  await eventRef.once().then((DatabaseEvent event) {
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      map = snapshot.value! as Map<dynamic, dynamic>;
    } else {
      // Event not found
      print('User not found');
    }
  }).catchError((error) {
    // Error occurred while fetching event data
    print('Error: $error');
  });
  return map;
}
