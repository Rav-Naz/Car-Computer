import 'package:car_computer/views/home.dart';
import 'package:car_computer/views/settings.dart';
import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {

  dynamic _currentView = const SettingsView();

  NavigationProvider();

  void setView(dynamic newView) {
    _currentView = newView;
    notifyListeners();
  }

  get currentView {
    return _currentView;
  }

}