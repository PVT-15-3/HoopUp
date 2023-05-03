import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../handlers/firebase_handler.dart';
import 'address.dart';
import 'event.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class Court {
  final String _courtId;
  final LatLng _position;
  String _name;
  String _imageLink;
  String _courtType;
  Address _address;
  bool isSelected = false;
  final List<Event> _events = [];

  Court({
    required String name,
    required String imageLink,
    required String courtType,
    required Address address,
    required position,
  })   // TODO unrequired
  : _name = name,
        _position = position,
        _imageLink = imageLink,
        _courtType = courtType,
        _address = address,
        _courtId = position.toString();

  void addCourtToDatabase() async {
    await setFirebaseDataMap("courts/$courtId", {
      "name": _name,
      "imageLink": _imageLink,
      "courtType": _courtType,
      "address": _address.toJson()
    }).catchError((error) {
      print("Failed to create Court: ${error.toString()}");
    });
  }

  //Getters ---------------------------------------------------------------
  String get courtId => _courtId;
  String get name => _name;
  String get imageLink => _imageLink;
  String get courtType => _courtType;
  Address get address => _address;
  LatLng get position => _position;

  //Setters ---------------------------------------------------------------
  set name(String name) {
    _name = name;
    database.ref("courts/$_courtId").update({"name": name}).catchError((error) {
      print("Failed to set address: ${error.toString()}");
    });
  }

  set imageLink(String imageLink) {
    _imageLink = imageLink;
    database
        .ref("courts/$_courtId")
        .update({"imageLink": imageLink}).catchError((error) {
      print("Failed to set address: ${error.toString()}");
    });
  }

  set courtType(String courtType) {
    _courtType = courtType;
    database
        .ref("courts/$_courtId")
        .update({"courtType": courtType}).catchError((error) {
      print("Failed to set address: ${error.toString()}");
    });
  }

  set address(Address adress) {
    _address = adress;
    database
        .ref("courts/$_courtId")
        .update({"address": adress.toJson()}).catchError((error) {
      print("Failed to set address: ${error.toString()}");
    });
  }

  //Functions ---------------------------------------------------------------
  void addEvent(Event event) {
    var id = event.id;
    _events.add(event);
    database
        .ref("courts/$_courtId/events/$id")
        .set(event.toJson())
        .catchError((error) {
      print("Failed to add event: ${error.toString()}");
    });
  }

  void removeEvent(Event event) {
    int index = _events.indexOf(event);
    if (index >= 0) {
      _events.removeAt(index);
      database
          .ref("courts/$_courtId/events/${event.id}")
          .remove()
          .catchError((error) {
        print("Failed to remove event: ${error.toString()}");
      });
    }
  }

  // Override functions ---------------------------------------------------
  @override
  String toString() => 'Court: $_name, $_courtType, $_courtId';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Court && _courtId == other.courtId;
  }

  @override
  int get hashCode => _name.hashCode ^ _courtType.hashCode ^ _courtId.hashCode;
}
