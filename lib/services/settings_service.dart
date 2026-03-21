import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  late SharedPreferences _prefs;

  String _endpoint = 'https://sai.sharedllm.com';
  String _model = 'gpt-4o-mini';
  bool _isDarkMode = true;
  String _language = 'English';

  String get endpoint => _endpoint;
  String get model => _model;
  bool get isDarkMode => _isDarkMode;
  String get language => _language;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _endpoint = _prefs.getString('endpoint') ?? 'https://sai.sharedllm.com';
    _model = _prefs.getString('model') ?? 'gpt-4o-mini';
    _isDarkMode = _prefs.getBool('isDarkMode') ?? true;
    _language = _prefs.getString('language') ?? 'English';
    notifyListeners();
  }

  Future<void> setEndpoint(String value) async {
    _endpoint = value;
    await _prefs.setString('endpoint', value);
    notifyListeners();
  }

  Future<void> setModel(String value) async {
    _model = value;
    await _prefs.setString('model', value);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    await _prefs.setString('language', value);
    notifyListeners();
  }

  Future<void> clearData() async {
    await _prefs.clear();
    _endpoint = 'https://sai.sharedllm.com';
    _model = 'gpt-4o-mini';
    _isDarkMode = true;
    _language = 'English';
    notifyListeners();
  }
}
