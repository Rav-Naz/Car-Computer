import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class UiProvider extends ChangeNotifier {
  var _accentColor = const Color.fromARGB(255, 219, 30, 16);
  late SharedPreferences _preferences;
  Map<String,dynamic> _otherSettings = {
          "accent_color": "ff4caf50",
          "jednostka_miary": "Kilometry",
          "jednostka_temperatury": "Celsjusz",
          "marka_i_model_pojazdu": "Mitsubihi Lancer",
          "rok_produkcji": "2009",
          "rodzaj_paliwa": "Benzyna",
          "moc_silnika": "360",
          "pojemność_skokowa_silnika": "1998",
          "maksymalne_obroty": "7000",
          "data_ważności_przeglądu": "04-02-2023",
        };

  UiProvider() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;      
      if (_preferences.containsKey("UiSettings")) {
        String string = _preferences.getString("UiSettings")!;
        Map<String,dynamic> userMap = jsonDecode(string) as Map<String, dynamic>;
        _otherSettings = userMap;
        _accentColor = _stringToColor(_otherSettings['accent_color']);
        notifyListeners();
      } else {
        _savePreferences();
      }
    });
  }

  void setColor(Color newColor) {
    _accentColor = newColor;
    setSetting("accent_color", _colorToString(newColor));
    notifyListeners();
  }

  void _savePreferences() {
    _preferences.setString("UiSettings", jsonEncode(_otherSettings));
  }

  void setSetting(String key, String value) {
    _otherSettings[key] = value;
    notifyListeners();
    _savePreferences();
  }

  String _colorToString(Color color) {
    String colorString = color.toString();
    String valueString = colorString.split('(0x')[1].split(')')[0];
    return valueString;
  }

  Color _stringToColor(String valueString) {
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  get accentColor {
    return _accentColor;
  }


  dynamic getSetting(String key) {
    return _otherSettings[key];
  }
}
