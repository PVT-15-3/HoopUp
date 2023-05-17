import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

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
    // _validateEndTime();    // causes issues with loading the times from the database (viktor)
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

  String getFormattedTimeAndDate() {
  final formatter = DateFormat('HH:mm');
  final formattedStartTime = formatter.format(_startTime);
  final formattedEndTime = formatter.format(_endTime);
  return "$formattedStartTime-$formattedEndTime | ${getFormattedDate()}";
}
 String getFormattedDate() {
  final formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(_startTime);
}

 String getFormattedStartAndEndTime() {
  final formattedStartTime = "${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}";
  final formattedEndTime = "${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}";
  return "$formattedStartTime-$formattedEndTime";
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
