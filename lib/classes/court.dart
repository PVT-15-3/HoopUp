import 'dart:ffi';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'address.dart';
import 'event.dart';

class Court {
  final String _courtId;
  final LatLng _position;
  String _name;
  String _imageLink;
  String _courtType;
  Address _address;
  final int _numberOfHoops;
  bool isSelected = false;
  final List<Event> _events = [];
  // final FirebaseProvider _firebaseProvider;

  Court(
      {required String name,
      required String imageLink,
      required String courtType,
      required Address address,
      required int numberOfHoops,
      // required FirebaseProvider firebaseProvider,
      required position})
      : _name = name,
        // _firebaseProvider = firebaseProvider,
        _position = position,
        _imageLink = imageLink,
        _courtType = courtType,
        _address = address,
        _numberOfHoops = numberOfHoops,
        _courtId = position.toString();

  /* void addCourtToDatabase() async {
    _firebaseProvider.setFirebaseDataMap("courts/$courtId", {
      "position": _position,
      "name": _name,
      "imageLink": _imageLink,
      "courtType": _courtType,
      "address": _address.toJson(),
    });
  } */

  //Getters ---------------------------------------------------------------
  String get courtId => _courtId;
  String get name => _name;
  String get imageLink => _imageLink;
  String get courtType => _courtType;
  Address get address => _address;
  LatLng get position => _position;
  int get numberOfHoops => _numberOfHoops;

  //Setters ---------------------------------------------------------------
  set name(String name) {
    _name = name;
    // _firebaseProvider.updateFirebaseData("courts/$_courtId", {"name": name});
  }

  set imageLink(String imageLink) {
    _imageLink = imageLink;
    //_firebaseProvider
    //    .updateFirebaseData("courts/$_courtId", {"imageLink": imageLink});
  }

  set courtType(String courtType) {
    _courtType = courtType;
    //_firebaseProvider
    //    .updateFirebaseData("courts/$_courtId", {"courtType": courtType});
  }

  set address(Address adress) {
    _address = adress;
    // _firebaseProvider
    //     .updateFirebaseData("courts/$_courtId", {"address": adress.toJson()});
  }

  //Functions ---------------------------------------------------------------
  void addEvent(Event event) {
    var id = event.id;
    _events.add(event);
    //  _firebaseProvider.setFirebaseDataMap(
    //      "courts/$_courtId/events/$id", event.toJson());
  }

  void removeEvent(Event event) {
    int index = _events.indexOf(event);
    if (index >= 0) {
      _events.removeAt(index);
      //   _firebaseProvider
      //     .removeFirebaseData("courts/$_courtId/events/${event.id}");
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
