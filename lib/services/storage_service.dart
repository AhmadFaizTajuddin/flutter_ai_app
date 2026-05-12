import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveApiKey(String key) async {
    await _prefs.setString('api_key', key);
  }

  String? getApiKey() {
    return _prefs.getString('api_key');
  }

  Future<void> saveSystemPrompt(String prompt) async {
    await _prefs.setString('system_prompt', prompt);
  }

  String? getSystemPrompt() {
    return _prefs.getString('system_prompt');
  }

  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }
}
