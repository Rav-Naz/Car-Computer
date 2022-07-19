import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UiProvider extends ChangeNotifier {

  var _accentColor = const Color.fromARGB(255, 219, 30, 16);
  late SharedPreferences _preferences;
    Map<String, dynamic>? _news;

  Map<String, dynamic> _otherSettings = {
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
    "twoje_imię": "Rafał"
  };

  UiProvider() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
      if (_preferences.containsKey("UiSettings")) {
        String string = _preferences.getString("UiSettings")!;
        Map<String, dynamic> userMap =
            jsonDecode(string) as Map<String, dynamic>;
        _otherSettings = userMap;
        _accentColor = _stringToColor(_otherSettings['accent_color']);
        notifyListeners();
      } else {
        _savePreferences();
      }
      if (_preferences.containsKey("news")) {
        _news = jsonDecode(_preferences.getString("news")!);
        var lastDownload =  DateTime.parse(_news!["downloaded"]);
        notifyListeners();
        if (lastDownload.difference(DateTime.now()).inHours > 1) {
          _getNews();
        }
      } else {
          _getNews();
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

  Color get accentColor {
    return _accentColor;
  }

    get getNews {
    return _news;
  }

  dynamic getSetting(String key) {
    if (_otherSettings.containsKey(key))
    {
      return _otherSettings[key];
    } else {
      setSetting(key,"");
      return "";
    }
  }

  Future<http.Response> newsApiCall() {
    return http.get(
      Uri.parse('https://newsapi.org/v2/top-headlines?country=pl&apiKey=b8f07ce448a4464bbc5dbd9f3c38dd0d'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
  void _getNews() {
    print("pobieranie newsów");
    newsApiCall().then((value) {
      _news = jsonDecode(value.body);
      _news!["downloaded"] = DateTime.now().toString();
      _preferences.setString("news", jsonEncode(_news));
    });
    notifyListeners();
  }
}
