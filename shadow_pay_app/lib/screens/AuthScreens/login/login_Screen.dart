import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/widgets/language_dialog.dart';
import 'package:shadow_pay_app/services/shared_pref_service.dart';
import 'package:shadow_pay_app/screens/main_screen.dart';
import '../ForgetPassword/forget_password_screen.dart';
import 'package:shadow_pay_app/services/auth_service.dart';
import 'package:shadow_pay_app/providers/language_provider.dart';
import 'package:shadow_pay_app/providers/theme_provider.dart';
import 'package:shadow_pay_app/screens/AuthScreens/Register/register_screen.dart';
import 'package:shadow_pay_app/theme/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  
  // ==================== Variables ====================
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _obscurePassword = true;
  bool _isLoading = false;
  
  bool _emailValid = true;
  bool _passwordValid = true;
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _isSignUpHovered = false;

  // ==================== Init & Dispose ====================
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ==================== Helper Methods ====================
  
  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  bool isEmailValid(String email) {
    email = email.trim();
    if (email.isEmpty) return false;
    if (email.length < 5 || email.length > 50) return false;
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email)) return false;
    if (email.split('@').length != 2) return false;
    if (["mailinator.com", "tempmail.com"].contains(email.split('@')[1])) return false;
    return true;
  }

  bool isPasswordValid(String password) {
    if (password.isEmpty) return false;
    if (password.length < 6) return false;
    return true;
  }

  // ==================== Login Logic ====================
  
  Future<void> _handleLogin() async {
    setState(() {
      _emailValid = isEmailValid(_emailController.text);
      _passwordValid = isPasswordValid(_passwordController.text);
    });

    if (_emailValid && _passwordValid) {
      setState(() => _isLoading = true);

      try {
        final result = await ApiService.login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (!mounted) return;

        if (result['success'] == true) {
          final token = result['token'];
          await SharedPrefService.saveToken(token);
          await SharedPrefService.setLoggedIn(true);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Login successful! Welcome back."),
                backgroundColor: context.primaryColor,
              ),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? "Invalid email or password"),
              backgroundColor: context.errorColor,
            ),
          );
        }
      } catch (e) {
        debugPrint("Login error: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login failed: $e"),
              backgroundColor: context.errorColor,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  // ==================== Build Method ====================
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = context.isDarkMode;
    
    final theme = Theme.of(context);
    final inputDecorationTheme = theme.inputDecorationTheme;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ========== Theme & Language Buttons ==========
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.progressBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          color: context.primaryColor,
                        ),
                        onPressed: () {
                          themeProvider.toggleTheme();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.progressBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.language,
                          color: context.primaryColor,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const LanguageDialog(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ========== Logo ==========
              MouseRegion(
                onEnter: (_) => _onHover(true),
                onExit: (_) => _onHover(false),
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: context.primaryColor.withOpacity(0.3),
                              blurRadius: 25,
                              spreadRadius: 2,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 1,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "assets/icon/icon.png",
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.payment,
                                size: 40,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // ========== Login Form Container ==========
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localizations.loginTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations.welcomeMessage,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: context.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email Field Label
                      Align(
                        alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(
                          localizations.emailLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Email Field
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: !_emailValid
                              ? [
                                  BoxShadow(
                                    color: context.errorColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textDirection: TextDirection.ltr,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: context.textPrimary,
                          ),
                          onChanged: (value) {
                            if (!_emailValid) {
                              setState(() {
                                _emailValid = true;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'example@gmail.com',
                            hintStyle: inputDecorationTheme.hintStyle,
                            filled: true,
                            fillColor: !_emailValid
                                ? context.errorColor.withOpacity(0.1)
                                : inputDecorationTheme.fillColor,
                            border: inputDecorationTheme.border,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: !_emailValid ? context.errorColor : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: inputDecorationTheme.focusedBorder,
                            prefixIcon: Icon(
                              Icons.email,
                              color: !_emailValid
                                  ? context.errorColor
                                  : context.textSecondary.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),

                      // Email Error Message
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.only(
                          top: !_emailValid ? 8 : 0,
                          left: isRTL ? 0 : 12,
                          right: isRTL ? 12 : 0,
                        ),
                        height: !_emailValid ? 30 : 0,
                        child: !_emailValid
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 16,
                                    color: context.errorColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      _emailController.text.isEmpty
                                          ? localizations.emailRequired
                                          : localizations.emailInvalid,
                                      style: TextStyle(
                                        color: context.errorColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Password Field Label
                      Align(
                        alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(
                          localizations.passwordLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Password Field
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: !_passwordValid
                              ? [
                                  BoxShadow(
                                    color: context.errorColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: context.textPrimary,
                          ),
                          onChanged: (value) {
                            if (!_passwordValid) {
                              setState(() {
                                _passwordValid = true;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: '********',
                            hintStyle: inputDecorationTheme.hintStyle,
                            filled: true,
                            fillColor: !_passwordValid
                                ? context.errorColor.withOpacity(0.1)
                                : inputDecorationTheme.fillColor,
                            border: inputDecorationTheme.border,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: !_passwordValid ? context.errorColor : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: inputDecorationTheme.focusedBorder,
                            prefixIcon: Icon(
                              Icons.lock,
                              color: !_passwordValid
                                  ? context.errorColor
                                  : context.textSecondary.withOpacity(0.7),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: !_passwordValid
                                    ? context.errorColor
                                    : context.textSecondary.withOpacity(0.7),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      // Password Error Message
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.only(
                          top: !_passwordValid ? 8 : 0,
                          left: isRTL ? 0 : 12,
                          right: isRTL ? 12 : 0,
                        ),
                        height: !_passwordValid ? 30 : 0,
                        child: !_passwordValid
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 16,
                                    color: context.errorColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      _passwordController.text.isEmpty
                                          ? localizations.passwordRequired
                                          : localizations.passwordTooShort,
                                      style: TextStyle(
                                        color: context.errorColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // Forgot Password
                      Align(
                        alignment: isRTL ? Alignment.centerLeft : Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            localizations.forgotPassword,
                            style: TextStyle(
                              color: context.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: theme.elevatedButtonTheme.style,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  localizations.loginButton,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Sign Up Link
                      MouseRegion(
                        onEnter: (_) => setState(() => _isSignUpHovered = true),
                        onExit: (_) => setState(() => _isSignUpHovered = false),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: _isSignUpHovered
                                ? context.textPrimary
                                : context.primaryColor,
                            overlayColor: context.primaryColor.withOpacity(0.1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isRTL ? Icons.arrow_back : Icons.arrow_forward,
                                size: 18,
                                color: _isSignUpHovered
                                    ? context.textPrimary
                                    : context.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                localizations.noAccount,
                                style: TextStyle(
                                  color: _isSignUpHovered
                                      ? context.textPrimary
                                      : context.textSecondary.withOpacity(0.7),
                                ),
                              ),
                              Text(
                                localizations.signUp,
                                style: TextStyle(
                                  color: _isSignUpHovered
                                      ? context.textPrimary
                                      : context.primaryColor,
                                  fontWeight: _isSignUpHovered
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}