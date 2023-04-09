import 'package:uuid/uuid.dart';

class Court {
  final String _courtId;
  String _name;
  String _imageLink;
  String _courtType;

  Court(
      {required String name,
      required String imageLink,
      required String courtType})
      : _name = name,
        _imageLink = imageLink,
        _courtType = courtType,
        _courtId = Uuid().v4();
  //Update database

  //Getters ---------------------------------------------------------------
  String getCourtId() => _courtId;
  String getName() => _name;
  String getImageLink() => _imageLink;
  String getCourtType() => _courtType;

  //Setters ---------------------------------------------------------------
  set name(String name) {
    _name = name;
    //Update database
  }

  set imageLink(String imageLink) {
    _imageLink = imageLink;
    //Update database
  }

  set courtType(String courtType) {
    _courtType = courtType;
    //Update database
  }
}
