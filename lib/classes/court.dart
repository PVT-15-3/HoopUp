import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'address.dart';
import 'event.dart';

class Court {
  final String _courtId;
  final LatLng _position;
  final String _name;
  final String _imageLink;
  final String _courtType;
  final Address _address;
  final int _numberOfHoops;
  final bool isSelected = false;
  final List<Event> _events = [];

  Court({
    required String name,
    required String imageLink,
    required String courtType,
    required Address address,
    required int numberOfHoops,
    required LatLng position,
  })  : _name = name,
        _imageLink = imageLink,
        _courtType = courtType,
        _address = address,
        _numberOfHoops = numberOfHoops,
        _position = position,
        _courtId = '${position.latitude.toString()}${position.longitude.toString()}';

  // Getters
  String get courtId => _courtId;
  String get name => _name;
  String get imageLink => _imageLink;
  String get courtType => _courtType;
  Address get address => _address;
  LatLng get position => _position;
  int get numberOfHoops => _numberOfHoops;
  List<Event> get events => _events;

  // Functions
  void addEvent(Event event) {
    _events.add(event);
  }

  void removeEvent(Event event) {
    _events.remove(event);
  }

  // Override functions
  @override
  String toString() => 'Court: $_name, $_courtType, $_courtId';

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is Court && _courtId == other.courtId);
  }

  @override
  int get hashCode => _courtId.hashCode;
}
