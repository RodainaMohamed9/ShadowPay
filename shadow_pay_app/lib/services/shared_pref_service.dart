import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static const String _keyOnboarding = 'onboarding_seen';
  static const String _keyLoggedIn = 'is_logged_in';

// ✅ مفاتيح جديدة
static const String _keyIsCardFrozen = 'is_card_frozen';

// ✅ جلب حالة البطاقة
static Future<bool> isCardFrozen() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_keyIsCardFrozen) ?? false;
  
}

// ✅ تجميد البطاقة
static Future<void> freezeCard() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_keyIsCardFrozen, true);
}

// ✅ إلغاء تجميد البطاقة
static Future<void> unfreezeCard() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_keyIsCardFrozen, false);
}

 // ✅ مفاتيح بيانات المستخدم
  static const String _keyUserFullName = 'user_full_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserCardNumber = 'user_card_number';
  static const String _keyUserCardName = 'user_card_name';
  static const String _keyUserCardExpiry = 'user_card_expiry';


  // ---- Onboarding ----
  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboarding, true);
  }

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboarding) ?? false;
  }

  // ---- Login Status ----
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  // ---- Logout ----
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    // لا نحذف onboarding_seen لأنه شاهدها مرة واحدة فقط
  }

  // ---- Clear All (اختياري) ----
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }



  // ========== ✅ دوال حفظ واسترجاع بيانات المستخدم ==========
  
  // الاسم الكامل
  static Future<void> setUserFullName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserFullName, name);
  }

  static String? getUserFullName() {
    // ⚠️ ملاحظة: دي مش async عشان نستخدمها بسهولة في الـ UI
    // هنستخدم Future عشان نجيبها بشكل غير متزامن
    return null; // هنستخدم الطريقة الـ async
  }
  
  static Future<String?> getUserFullNameAsync() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserFullName);
  }

  // الإيميل
  static Future<void> setUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  
  static Future<void> setUserPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserPhone, phone);
  }

  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserPhone);
  }

 
  static Future<void> setUserCardNumber(String cardNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserCardNumber, cardNumber);
  }

  static Future<String?> getUserCardNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserCardNumber);
  }

  // اسم حامل البطاقة
  static Future<void> setUserCardName(String cardName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserCardName, cardName);
  }

  static Future<String?> getUserCardName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserCardName);
  }

  // تاريخ انتهاء البطاقة
  static Future<void> setUserCardExpiry(String expiry) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserCardExpiry, expiry);
  }

  static Future<String?> getUserCardExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserCardExpiry);
  }

 
  static Future<Map<String, String?>> getAllUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'fullName': prefs.getString(_keyUserFullName),
      'email': prefs.getString(_keyUserEmail),
      'phone': prefs.getString(_keyUserPhone),
      'cardNumber': prefs.getString(_keyUserCardNumber),
      'cardName': prefs.getString(_keyUserCardName),
      'cardExpiry': prefs.getString(_keyUserCardExpiry),
    };

 } 
 //Tokens
   static const String _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);

  }
}