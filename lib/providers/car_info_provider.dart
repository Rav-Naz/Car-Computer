import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CarInfoProvider extends ChangeNotifier {
  late String _currentTimeString;
  late String _timeFromStartString;
  late Timer _timer;
  late final DateTime _startTime = DateTime.now();

  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:7890'),
  );

  CarInfoProvider() {
    _getTime();
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      _getTime();
    });
  }

  get getCurrentTimeString {
    return _currentTimeString;
  }

  get getTimeFromStartString {
    return _timeFromStartString;
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    _currentTimeString = formattedDateTime;

    _timeFromStartString = _timeToMinutes(Duration(minutes: now.difference(_startTime).inMinutes));

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
