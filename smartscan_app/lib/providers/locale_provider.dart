import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 语言设置 Provider
class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  
  Locale? _locale;
  
  Locale? get locale => _locale;
  
  /// 初始化语言设置
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);
    
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }
  
  /// 设置语言
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
  
  /// 清除语言设置（跟随系统）
  Future<void> clearLocale() async {
    _locale = null;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);
  }
  
  /// 是否跟随系统
  bool get isFollowSystem => _locale == null;
  
  /// 获取当前语言显示名称
  String getLanguageName(Locale? locale) {
    if (locale == null) return 'followSystem';
    
    switch (locale.languageCode) {
      case 'zh':
        return 'chinese';
      case 'en':
        return 'english';
      default:
        return 'unknown';
    }
  }
}
