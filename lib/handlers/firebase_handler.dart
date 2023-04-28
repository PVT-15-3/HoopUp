import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

Future<void> updateFirebaseData(String path, Map<String, dynamic> data) async {
  try {
    await database.ref(path).update(data);
  } catch (error) {
    print("Failed to update ${data.keys} : ${error.toString()}");
    rethrow;
  }
}

Future<void> setFirebaseDataMap(String path, Map<String, dynamic> data) async {
  try {
    await database.ref(path).set(data);
  } catch (error) {
    print("Failed to set ${data.keys} : ${error.toString()}");
    rethrow;
  }
}

Future<void> setFirebaseDataList(String path, List<dynamic> data) async {
  try {
    await database.ref(path).set(data);
  } catch (error) {
    print("Failed to set a list of ${data.length} items : ${error.toString()}");
    rethrow;
  }
}

Future<void> setFirebaseDataString(String path, String data) async {
  try {
    await database.ref(path).set(data);
  } catch (error) {
    print("Failed to set $data : ${error.toString()}");
    rethrow;
  }
}


Future<void> removeFirebaseData(String path) async {
  try {
    await database.ref(path).remove();
  } catch (error) {
    print("Failed to remove $path : ${error.toString()}");
    rethrow;
  }
}

Future<void> uploadFileToFirebaseStorage(File file, String path) async {
  final firebaseStorageRef = FirebaseStorage.instance
      .ref()
      .child(path);
  final task = firebaseStorageRef.putFile(file);
  task.snapshotEvents.listen((TaskSnapshot snapshot) {
    print(
        'Upload completed: ${snapshot.bytesTransferred} bytes transferred');
  }, onError: (Object e) {
    print(e.toString());
  });
  await task.whenComplete(() => print('File uploaded to Firebase Storage.'));
}

Future<Map> getMapFromFirebase(String path, String resource) async {
  String safeId =
      resource.replaceAll('.', ',').replaceAll('[', '-').replaceAll(']', '-');
  final DatabaseReference eventRef =
      database.ref().child(path).child(safeId);
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
