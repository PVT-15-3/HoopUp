class Address {
  String _street;
  String _city;
  int _postalCode;
  double _long;
  double _lat;

  Address(
      {required String street,
      required String city,
      required int postalCode,
      required double long,
      required double lat})
      : _street = street,
        _city = city,
        _postalCode = postalCode,
        _long = long,
        _lat = lat;
  //Update in database

  //Getters ---------------------------------------------------------------
  String getStreet() => _street;
  String getCity() => _city;
  int getPostalCode() => _postalCode;
  double getLong() => _long;
  double getLat() => _lat;

  //Setters ---------------------------------------------------------------
  set street(String street) {
    _street = street;
    //Update in database
  }

  set city(String city) {
    _city = city;
    //Update in database
  }

  set postalCode(int code) {
    _postalCode = code;
    //Update in database
  }

  set long(double long) {
    _long = long;
    //Update in database
  }

  set lat(double lat) {
    _lat = lat;
    //Update in database
  }
}
