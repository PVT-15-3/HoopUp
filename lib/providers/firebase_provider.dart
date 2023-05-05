import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:flutter/material.dart';
import '../classes/event.dart';

class FirebaseProvider with ChangeNotifier {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final DatabaseReference _eventsRef =
      FirebaseDatabase.instance.ref().child('events');
  Future<void> updateFirebaseData(
      String path, Map<String, dynamic> data) async {
    try {
      await database.ref(path).update(data);
      notifyListeners();
    } catch (error) {
      print("Failed to update ${data.keys} : ${error.toString()}");
      rethrow;
    }
  }

  Future<void> setFirebaseDataMap(
      String path, Map<String, dynamic> data) async {
    try {
      await database.ref(path).set(data);
      notifyListeners();
    } catch (error) {
      print("Failed to set ${data.keys} : ${error.toString()}");
      rethrow;
    }
  }

  Future<void> setFirebaseDataList(String path, List<dynamic> data) async {
    try {
      await database.ref(path).set(data);
      notifyListeners();
    } catch (error) {
      print(
          "Failed to set a list of ${data.length} items : ${error.toString()}");
      rethrow;
    }
  }

  Future<void> removeFirebaseData(String path) async {
    try {
      await database.ref(path).remove();
      notifyListeners();
    } catch (error) {
      print("Failed to remove $path : ${error.toString()}");
      rethrow;
    }
  }

  Future<void> uploadFileToFirebaseStorage(File file, String path) async {
    final firebaseStorageRef = FirebaseStorage.instance.ref().child(path);
    final task = firebaseStorageRef.putFile(file);
    notifyListeners();
    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      print('Upload completed: ${snapshot.bytesTransferred} bytes transferred');
    }, onError: (Object e) {
      print(e.toString());
    });
    await task.whenComplete(() => print('File uploaded to Firebase Storage.'));
  }

  Future<Map> getMapFromFirebase(String path, String resource) async {
    String safeId =
        resource.replaceAll('.', ',').replaceAll('[', '-').replaceAll(']', '-');
    final DatabaseReference eventRef = database.ref().child(path).child(safeId);
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
    notifyListeners();
    return map;
  }

  Future<List> getListFromFirebase(String path, String resource) async {
    String safeId =
        resource.replaceAll('.', ',').replaceAll('[', '-').replaceAll(']', '-');
    final DatabaseReference eventRef = database.ref().child(path).child(safeId);
    List<dynamic> list = [];
    await eventRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        list = snapshot.value! as List<dynamic>;
      } else {
        // Event not found
        print('User not found');
      }
    }).catchError((error) {
      // Error occurred while fetching event data
      print('Error: $error');
    });
    notifyListeners();
    return list;
  }

  Future<HoopUpUser> getUserFromFirebase(String id) async {
    Map? userMap = await getMapFromFirebase('users', id);
    notifyListeners();
    HoopUpUser user = HoopUpUser(
        username: userMap['username'] ?? 'unknown',
        skillLevel: userMap['skillLevel'] ?? 0,
        id: id,
        photoUrl: userMap['photoUrl'],
        gender: userMap['gender'] ?? 'other',
        firebaseProvider: this);
    user.events = userMap['events'].cast<String>();
    return user;
  }

  Stream<List<Event>> get eventsStream => _eventsRef.onValue.map((event) {
        DataSnapshot snapshot = event.snapshot;
        List<Event> events = [];

        if (snapshot.value != null) {
          Map<dynamic, dynamic> eventsFromDatabaseMap = snapshot.value as Map;

          eventsFromDatabaseMap.forEach((key, value) {
            final event = Event.fromJson(value, this);
            events.add(event);
          });
        }
        notifyListeners(); //TODO Correct use of notifyListeners()?
        return events;
      });
}
