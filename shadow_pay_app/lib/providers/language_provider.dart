import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  static const String _languageKey = 'app_language';

  Locale get locale => _locale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);
      
      if (languageCode != null) {
        // ✅ لو فيه لغة مخزنة من قبل، هنستخدمها
        _locale = Locale(languageCode);
      } else {
        // ✅ أول مرة → لغة النظام
        final deviceLocale = ui.window.locale;
        final supportedLocales = ['en', 'ar'];
        final systemLanguageCode = deviceLocale.languageCode;
        
        // نتأكد إن لغة النظام مدعومة
        if (supportedLocales.contains(systemLanguageCode)) {
          _locale = Locale(systemLanguageCode);
        } else {
          _locale = const Locale('en'); // اللغة الافتراضية
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error loading language: $e');
      _locale = const Locale('en');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_locale.languageCode == languageCode) return;
    
    _locale = Locale(languageCode);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      print('Error saving language: $e');
    }
    notifyListeners();
  }
}