class Address {
  final String _street;
  final String _city;
  final int _postalCode;
  final double _long;
  final double _lat;

  Address(this._street, this._city, this._postalCode, this._long, this._lat);

  //Getters ---------------------------------------------------------------
  get street => _street;
  get city => _city;
  get postalCode => _postalCode;
  get long => _long;
  get lat => _lat;

  //Functions --------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'street': _street,
      'city': _city,
      'postalCode': _postalCode,
      'long': _long,
      'lat': _lat
    };
  }
}
