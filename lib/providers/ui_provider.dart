import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class UiProvider extends ChangeNotifier {

  var _accentColor = const Color.fromARGB(255, 219, 30, 16);

  UiProvider() {
    Future.delayed(Duration(seconds: 2)).then((value) {
    this.setColor(Color.fromARGB(255, 50, 55, 134));
    });
  }

  void setColor(Color newColor) {
    _accentColor = newColor;
    notifyListeners();
  }

  get accentColor {
    return _accentColor;
  }

}