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

  Court(
      {required String name,
      required String imageLink,
      required String courtType,
      required Address address,
      required int numberOfHoops,
      required position})
      : _name = name,
        _position = position,
        _imageLink = imageLink,
        _courtType = courtType,
        _address = address,
        _numberOfHoops = numberOfHoops,
        _courtId =
            '${position.latitude.toString()}${position.longitude.toString()}';

  //Getters ---------------------------------------------------------------
  String get courtId => _courtId;
  String get name => _name; // TODO: Remove this getters?? (Viktor)
  String get imageLink => _imageLink;
  String get courtType => _courtType;
  Address get address => _address;
  LatLng get position => _position;
  int get numberOfHoops => _numberOfHoops;
  List<Event> get events => _events;

  //Setters ---------------------------------------------------------------
  set name(String name) {
    _name = name;
  }

  set imageLink(String imageLink) {
    _imageLink = imageLink;
  }

  set courtType(String courtType) {
    _courtType = courtType;
  }

  set address(Address adress) {
    _address = adress;
  }

  //Functions ---------------------------------------------------------------
  void addEvent(Event event) {
    _events.add(event);
  }

  void removeEvent(Event event) {
    int index = _events.indexOf(event);
    if (index >= 0) {
      _events.removeAt(index);
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
