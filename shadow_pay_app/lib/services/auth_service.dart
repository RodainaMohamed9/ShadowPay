import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://jackeline-cibarious-supergallantly.ngrok-free.dev';

  //Register
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
    final url = Uri.parse('$baseUrl/api/Account/register');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullName": fullName,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
          "phoneNumber": phoneNumber,
          "cardNumberHash": cardNumberHash,
          "cardHolderName": cardHolderName,
          "exprDate": exprDate.toIso8601String(),
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        print('Failed to parse JSON: $e');
        if (context.mounted) {
          _showErrorDialog(context, ["Server error. Please try again."]);
        }
        return false;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
        }
        return true;
      }
      
      List<String> errors = [];
      
      if (data != null) {
        if (data['errors'] != null) {
          if (data['errors'] is List) {
            errors = List<String>.from(data['errors']);
          } else if (data['errors'] is String) {
            errors.add(data['errors']);
          }
        } else if (data['message'] != null) {
          errors.add(data['message']);
        }
      }
      
      if (errors.isEmpty) {
        errors.add("Registration failed. Please try again.");
      }
      
      if (context.mounted) {
        _showErrorDialog(context, errors);
      }
      
      return false;
      
    } catch (e) {
      print("Network error: $e");
      if (context.mounted) {
        _showErrorDialog(context, ["Network error. Please check your connection."]);
      }
      return false;
    }
  }

  static void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Success", style: TextStyle(color: Colors.teal)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK", style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  static void _showErrorDialog(BuildContext context, List<String> errors) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error", style: TextStyle(color: Colors.red)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: errors.map((error) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text("• $error"),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  //Login
    static Future<Map<String, dynamic>> login({
      required String email,
      required String password,
    }) async {
      final url = Uri.parse('$baseUrl/api/Account/login'); 

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": email,
            "password": password,
          }),
        );

        print('Login response status: ${response.statusCode}');
        print('Login response body: ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return {
            'success': true,
            'token': data['token'],
            'expiration': data['expiration'],
          };
        } else if (response.statusCode == 401) {
          return {
            'success': false,
            'message': 'Invalid email or password',
          };
        } else {
          return {
            'success': false,
            'message': 'Server error: ${response.statusCode}',
          };
        }
      } catch (e) {
        print("Login error: $e");
        return {
          'success': false,
          'message': 'Network error: $e',
        };
      }
    }

    // ===== SEND OTP =====
    static Future<Map<String, dynamic>> sendOtp({
      required String email,
      required String purpose, // "register" or "forgot"
    }) async {
      final url = Uri.parse('$baseUrl/api/Account/send-otp');

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": email,
            "purpose": purpose,
          }),
        );

        print('Send OTP response status: ${response.statusCode}');
        print('Send OTP response body: ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return {
            'success': data['success'] ?? true,
            'message': data['message'] ?? 'OTP sent successfully',
          };
        } else {
          dynamic data;
          try {
            data = jsonDecode(response.body);
          } catch (e) {
            return {
              'success': false,
              'message': 'Server error: ${response.statusCode}',
            };
          }

          String errorMessage = 'Failed to send OTP';
          if (data is Map) {
            if (data['message'] != null) {
              errorMessage = data['message'];
            } else if (data['errors'] != null) {
              if (data['errors'] is List) {
                errorMessage = (data['errors'] as List).join('\n');
              } else {
                errorMessage = data['errors'].toString();
              }
            }
          } else if (data is String) {
            errorMessage = data;
          }

          return {
            'success': false,
            'message': errorMessage,
          };
        }
      } catch (e) {
        print("Send OTP error: $e");
        return {
          'success': false,
          'message': 'Network error: $e',
        };
      }
    }


    // ===== VERIFY OTP =====
    static Future<VerifyOtpResponse> verifyOtp({
      required String email,
      required String otp,
      required String purpose, // "register" or "forgot"
    }) async {
      final url = Uri.parse('$baseUrl/api/Account/verify-otp');

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": email,
            "otp": otp,
            "purpose": purpose,
          }),
        );

        print('Verify OTP response status: ${response.statusCode}');
        print('Verify OTP response body: ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return VerifyOtpResponse(
            success: data['success'] ?? false,
            message: data['message'] ?? 'OTP verified successfully',
          );
        } else {
          // محاولة تحليل الخطأ
          dynamic data;
          try {
            data = jsonDecode(response.body);
          } catch (e) {
            return VerifyOtpResponse(
              success: false,
              message: 'Server error: ${response.statusCode}',
            );
          }

          String errorMessage = 'Invalid or expired OTP';
          if (data is Map) {
            if (data['message'] != null) {
              errorMessage = data['message'];
            } else if (data['errors'] != null) {
              if (data['errors'] is List) {
                errorMessage = (data['errors'] as List).join('\n');
              } else {
                errorMessage = data['errors'].toString();
              }
            }
          } else if (data is String) {
            errorMessage = data;
          }

          return VerifyOtpResponse(
            success: false,
            message: errorMessage,
          );
        }
      } catch (e) {
        print("Verify OTP error: $e");
        return VerifyOtpResponse(
          success: false,
          message: 'Network error: $e',
        );
      }
    }

    //RESET PASSWORD
    static Future<Map<String, dynamic>> resetPassword({
      required String email,
      required String otp,
      required String newPassword,
      required String confirmPassword,
    }) async {
      final url = Uri.parse('$baseUrl/api/Account/reset-password');

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": email,
            "otp": otp,
            "newPassword": newPassword,
            "confirmPassword": confirmPassword,
          }),
        );

        print('Reset password response status: ${response.statusCode}');
        print('Reset password response body: ${response.body}');

        if (response.statusCode == 200) {
          return {
            'success': true,
            'message': response.body, 
          };
        } else {
          dynamic data;
          try {
            data = jsonDecode(response.body);
          } catch (e) {
            return {
              'success': false,
              'message': response.body,
            };
          }

          String errorMessage = 'Failed to reset password';
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
      } catch (e) {
        print("Reset password error: $e");
        return {
          'success': false,
          'message': 'Network error: $e',
        };
      }
    }

}
class VerifyOtpResponse {
  final bool success;
  final String message;

  VerifyOtpResponse({required this.success, required this.message});
}