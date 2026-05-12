import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shadow_pay_app/services/tokens/api_service.dart'; 
import 'package:shadow_pay_app/services/tokens/token_storage.dart';

class AuthService {

  // ===== REGISTER =====
  static Future<bool> registerUser({
    required BuildContext context,
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String cardNumberHash,
    required String cardHolderName,
    required DateTime exprDate,
  }) async {
    try {
      final dioClient = DioClient().dio;
      final response = await dioClient.post(
        '/Account/register',
        data: {
          "fullName": fullName,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
          "phoneNumber": phoneNumber,
          "cardNumberHash": cardNumberHash,
          "cardHolderName": cardHolderName,
          "exprDate": exprDate.toIso8601String(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      final errorData = _handleDioErrorResponse(e.response?.data, defaultMessage: "Registration failed.");
      if (context.mounted) {
        _showErrorDialog(context, [errorData['message']]);
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog(context, ["Network error. Please check your connection."]);
      }
      return false;
    }
  }

// ===== LOGIN =====
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final dioClient = DioClient().dio;
      final response = await dioClient.post('/Account/login', data: {
        "email": email,
        "password": password,
      });

      final data = response.data;
      
      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];

      if (accessToken != null && refreshToken != null) {
        await TokenStorage.saveAccessToken(accessToken);
        await TokenStorage.saveRefreshToken(refreshToken);
      }

      return {
        'success': true,
        'token': accessToken, 
      };
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return {'success': false, 'message': 'Invalid email or password'};
      }
      return _handleDioErrorResponse(e.response?.data, defaultMessage: 'Server error during login');
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ===== SEND OTP =====
  static Future<Map<String, dynamic>> sendOtp({
    required String email,
    required String purpose,
  }) async {
    try {
      final dioClient = DioClient().dio;
      final response = await dioClient.post('/Account/send-otp', data: {
        "email": email,
        "purpose": purpose,
      });

      return {
        'success': response.data['success'] ?? true,
        'message': response.data['message'] ?? 'OTP sent successfully',
      };
    } on DioException catch (e) {
      return _handleDioErrorResponse(e.response?.data, defaultMessage: 'Failed to send OTP');
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ===== VERIFY OTP =====
  static Future<VerifyOtpResponse> verifyOtp({
    required String email,
    required String otp,
    required String purpose,
  }) async {
    try {
      final dioClient = DioClient().dio;
      final response = await dioClient.post('/Account/verify-otp', data: {
        "email": email,
        "otp": otp,
        "purpose": purpose,
      });

      return VerifyOtpResponse(
        success: response.data['success'] ?? false,
        message: response.data['message'] ?? 'OTP verified successfully',
      );
    } on DioException catch (e) {
      final errorData = _handleDioErrorResponse(e.response?.data, defaultMessage: 'Invalid or expired OTP');
      return VerifyOtpResponse(success: false, message: errorData['message']);
    } catch (e) {
      return VerifyOtpResponse(success: false, message: 'Network error: $e');
    }
  }

  // ===== RESET PASSWORD =====
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final dioClient = DioClient().dio;
      final response = await dioClient.post('/Account/reset-password', data: {
        "email": email,
        "otp": otp,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      });

      return {
        'success': true,
        'message': response.data['message'] ?? 'Password reset successfully',
      };
    } on DioException catch (e) {
      return _handleDioErrorResponse(e.response?.data, defaultMessage: 'Failed to reset password');
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  // ===== LOGOUT =====
  static Future<void> logout() async {
    await TokenStorage.deleteTokens();
  }

  static Map<String, dynamic> _handleDioErrorResponse(dynamic data, {String defaultMessage = 'An error occurred'}) {
    String errorMessage = defaultMessage;
    if (data is Map) {
      if (data['errors'] != null) {
        if (data['errors'] is List) {
          errorMessage = (data['errors'] as List).join('\n');
        } else if (data['errors'] is String) {
          errorMessage = data['errors'];
        }
      } else if (data['message'] != null) {
        errorMessage = data['message'];
      }
    } else if (data is String) {
      errorMessage = data;
    }

    return {
      'success': false,
      'message': errorMessage,
    };
  }

  // ===== DIALOGS =====
  static void _showErrorDialog(BuildContext context, List<String> errors) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error", style: TextStyle(color: Colors.red)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: errors.map((error) => Text("• $error")).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

class VerifyOtpResponse {
  final bool success;
  final String message;
  VerifyOtpResponse({required this.success, required this.message});
}