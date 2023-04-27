import 'package:uuid/uuid.dart';

class Time {
  late final DateTime _startTime;
  late final DateTime _endTime;
  final String _id;

  Time({
    required DateTime startTime,
    required DateTime endTime,
  })  : _id = const Uuid().v4(),
        _startTime = startTime,
        _endTime = endTime {
    // _validateStartTime();  // causes issues with loading the times from the database (viktor)
    // _validateEndTime();
  }

  // Getters
  DateTime get startTime => _startTime;
  DateTime get endTime => _endTime;
  String get id => _id;

  // Setters
  set startTime(DateTime startTime) {
    _startTime = startTime;
    validateStartTime();
    validateEndTime();
  }

  set endTime(DateTime endTime) {
    _endTime = endTime;
    validateStartTime();
    validateEndTime();
  }

  // Validate inputs
  void validateStartTime() {
    if (_startTime.isBefore(DateTime.now())) {
      throw ArgumentError('Start time cannot be in the past.');
    }
  }

  void validateEndTime() {
    if (_endTime.isBefore(_startTime)) {
      throw ArgumentError('End time cannot be earlier than start time.');
    }
  }

  String getFormattedStartTime() {
  final formattedDate =
      "${_startTime.day}/${_startTime.month}/${_startTime.year}";
  final formattedStartTime = "${_startTime.hour}:${_startTime.minute}";
  final formattedEndTime = "${_endTime.hour}:${_endTime.minute}";
  return "$formattedDate $formattedStartTime - $formattedEndTime";
}

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'startTime': _startTime.toIso8601String(),
      'endTime': _endTime.toIso8601String(),
    };
  }

  factory Time.fromJson(Map<dynamic, dynamic> json) {
  final startTime = DateTime.parse(json['startTime']);
  final endTime = DateTime.parse(json['endTime']);
  return Time(startTime: startTime, endTime: endTime);
}

}
