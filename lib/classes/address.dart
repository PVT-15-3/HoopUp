class Address {
  final String _street;
  final String _city;
  final int _postalCode;
  final double _long;
  final double _lat;

  Address(this._street, this._city, this._postalCode, this._long, this._lat) {
    if (_postalCode <= 9999) {
      throw ArgumentError('Postal code must be a positive integer.');
    }
    if (_lat < -90 || _lat > 90 || _long < -180 || _long > 180) {
      throw ArgumentError('Invalid latitude or longitude values.');
    }
  }

  //Getters ---------------------------------------------------------------

  String get street => _street;
  String get city => _city;
  int get postalCode => _postalCode;
  double get long => _long;
  double get lat => _lat;

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

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      json['street'],
      json['city'],
      json['postalCode'],
      json['long'],
      json['lat'],
    );
  }

  @override
  int get hashCode {
    return Object.hash(_street, _city, _postalCode, _long, _lat);
  }

  @override
  bool operator ==(other) {
    return other is Address &&
        _street == other._street &&
        _city == other._city &&
        _postalCode == other._postalCode &&
        _long == other._long &&
        _lat == other._lat;
  }

  @override
  String toString() {
    return "$_street, $_postalCode\n$_city";
  }
  toStringOnTheSameLine() {
    return "$_street, $_postalCode, $_city";
  }
}
