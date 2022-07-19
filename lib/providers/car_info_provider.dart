import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class CarInfoProvider extends ChangeNotifier {
  late String _currentTimeString;
  late String _timeFromStartString;
  String? _pathToMusic;
  Map<String, dynamic>? _carInfo;
  Map<String, dynamic>? _weatherInfo;
  double _distanceTraveled = 0;
  double _averageSpeed = 0;
  int _averageSpeedIncrements = 0;
  late Timer _timer;
  late final DateTime _startTime = DateTime.now();
  late DateTime _lastDistanceUpdate = DateTime.now();

  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:7890'),
  );

  CarInfoProvider() {
    _getTime();
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      _getTime();
    });
    channel.stream.listen((event) {
      _carInfo = jsonDecode((event as String).replaceAll("'", "\""));
      if (_pathToMusic == null &&
          _carInfo != null &&
          _carInfo!["music_path"] != null) {
        _pathToMusic = _carInfo!["music_path"];
      }
      if (_carInfo != null &&
          _carInfo!["vehicle_speed"] != null &&
          _carInfo!["refresh_delay"] != null) {
        addDistance(_carInfo!["vehicle_speed"]);
        addToSpeedAverage(_carInfo!["vehicle_speed"]);
      }
      if (_weatherInfo == null && _carInfo!.containsKey("latitude") && _carInfo!.containsKey("longitude")) {
        _getWeatherInfo();
        Timer.periodic(const Duration(minutes: 1), (Timer t) {
          _getWeatherInfo();
        });
      }
      notifyListeners();
    });
  }

  get getPathToMusic {
    return _pathToMusic;
  }

  get getCurrentTimeString {
    return _currentTimeString;
  }

  get getTimeFromStartString {
    return _timeFromStartString;
  }

  get getWeatherInfo {
    return _weatherInfo;
  }

  get isConnectedToCar {
    return _carInfo != null;
  }

  String get getAverageSpeedString {
    return _averageSpeed.toStringAsFixed(0);
  }

  String get getDistanceTraveledInKm {
    return _distanceTraveled.toStringAsFixed(1);
  }

  void addDistance(double velocity) {
    var now = DateTime.now();
    var diffInMillis = now.difference(_lastDistanceUpdate).inMilliseconds;
    _lastDistanceUpdate = now;
    _distanceTraveled += (velocity * (diffInMillis / 3600000));
  }

  void addToSpeedAverage(double value) {
    _averageSpeed= (_averageSpeedIncrements * _averageSpeed + value) / (_averageSpeedIncrements + 1);
    _averageSpeedIncrements++;
  }
//b8f07ce448a4464bbc5dbd9f3c38dd0d
  dynamic getCarInfoValue(String key) {
    if (_carInfo != null && _carInfo!.containsKey(key)) {
      return _carInfo![key];
    } else {
      return null;
    }
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    _currentTimeString = formattedDateTime;

    _timeFromStartString =
        _timeToMinutes(Duration(minutes: now.difference(_startTime).inMinutes));

    notifyListeners();
  }

  Future<http.Response> weatherApiCall() {
    return http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=${getCarInfoValue("latitude")}&lon=${getCarInfoValue("longitude")}&appid=fce814f3a8dd45cb0184f5753ec2efe4&units=metric&lang=pl'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  void _getWeatherInfo() {
    weatherApiCall().then((value) {
      _weatherInfo = jsonDecode(value.body);
    });
    notifyListeners();
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  String _timeToMinutes(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }
}
