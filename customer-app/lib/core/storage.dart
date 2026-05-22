import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> set(String key, dynamic value, [int? expireSeconds]) async {
    if (_prefs == null) return false;
    final Map<String, dynamic> cacheWrapper = {
      'data': value,
      'expiresAt': expireSeconds != null
          ? DateTime.now().add(Duration(seconds: expireSeconds)).millisecondsSinceEpoch
          : 0
    };
    return await _prefs!.setString(key, jsonEncode(cacheWrapper));
  }

  static T? get<T>(String key) {
    if (_prefs == null) return null;
    final raw = _prefs!.getString(key);
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final expiresAt = decoded['expiresAt'] as int;
      if (expiresAt > 0 && DateTime.now().millisecondsSinceEpoch > expiresAt) {
        _prefs!.remove(key); // Cache expired
        return null;
      }
      return decoded['data'] as T;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> remove(String key) async {
    if (_prefs == null) return false;
    return await _prefs!.remove(key);
  }

  static Future<bool> clear() async {
    if (_prefs == null) return false;
    return await _prefs!.clear();
  }
}
