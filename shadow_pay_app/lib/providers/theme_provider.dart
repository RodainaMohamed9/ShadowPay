import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  // تحميل الثيم المحفوظ، أو استخدام النظام إذا لم يكن محفوظاً
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString('theme_mode');
    if (savedMode == null) {
      _themeMode = ThemeMode.system;
    } else if (savedMode == 'light') {
      _themeMode = ThemeMode.light;
    } else if (savedMode == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  // حفظ الثيم المختار من قبل المستخدم
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    String? value;
    if (mode == ThemeMode.light) value = 'light';
    else if (mode == ThemeMode.dark) value = 'dark';
    else value = 'system';
    await prefs.setString('theme_mode', value);
    notifyListeners();
  }

  // دالة مساعدة لتبديل الوضع (فاتح/غامق) بغض النظر عن الوضع الحالي
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      // إذا كان النظام، فعند التبديل لأول مرة نختار الوضع الغامق مثلاً
      // أو يمكنك استخدام MediaQuery لتحديد الوضع الحالي للنظام
      setThemeMode(ThemeMode.dark);
    }
  }
}