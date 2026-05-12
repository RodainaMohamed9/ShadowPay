import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/screens/AuthScreens/login/login_screen.dart';
import 'package:shadow_pay_app/services/auth_service.dart';
import 'package:shadow_pay_app/screens/AuthScreens/ForgetPassword/otp_screen.dart';
import 'package:shadow_pay_app/theme/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  // Data for both steps
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final phoneController = TextEditingController();
  final cardNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();

  bool showPassword = false;
  bool showConfirm = false;
  bool loading = false;

  int currentStep = 1; // 1 or 2

  // Track errors for each field
  final Map<String, bool> fieldErrors = {
    'fullName': false,
    'email': false,
    'password': false,
    'confirm': false,
    'phone': false,
    'cardName': false,
    'cardNumber': false,
    'expiry': false,
  };

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> stepOneFields = [
    'fullName',
    'email',
    'password',
    'confirm'
  ];
  final List<String> stepTwoFields = [
    'phone',
    'cardName',
    'cardNumber',
    'expiry'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    phoneController.dispose();
    cardNameController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    super.dispose();
  }

  void _changeStep(int newStep) {
    if (newStep == currentStep) return;

    setState(() {
      final fieldsToHide = currentStep == 1 ? stepOneFields : stepTwoFields;
      for (var field in fieldsToHide) {
        fieldErrors[field] = false;
      }
      currentStep = newStep;
    });

    _animationController
      ..reset()
      ..forward();
  }

  // Validation methods
  String? _validateFullName(String? value) {
    if (currentStep != 1) return null;
    final loc = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      fieldErrors['fullName'] = true;
      return loc.requiredField;
    }
    List<String> nameParts = value.trim().split(' ');
    nameParts = nameParts.where((part) => part.isNotEmpty).toList();
    if (nameParts.length < 2) {
      fieldErrors['fullName'] = true;
      return loc.enterFirstAndLastName;
    }
    for (String part in nameParts) {
      if (part.length < 3) {
        fieldErrors['fullName'] = true;
        return loc.eachNamePartMustBeAtLeast3Chars;
      }
    }
    fieldErrors['fullName'] = false;
    return null;
  }

  String? _validateEmail(String? value) {
    if (currentStep != 1) return null;
    final loc = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      fieldErrors['email'] = true;
      return loc.requiredField;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      fieldErrors['email'] = true;
      return loc.invalidEmail;
    }
    fieldErrors['email'] = false;
    return null;
  }

  String? _validatePassword(String? value) {
    if (currentStep != 1) return null;
    final loc = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      fieldErrors['password'] = true;
      return loc.requiredField;
    }

    if (value.length < 8) {
      fieldErrors['password'] = true;
      return loc.passwordShort;
    }

    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      fieldErrors['password'] = true;
      return loc.passwordLowercase;
    }

    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      fieldErrors['password'] = true;
      return loc.passwordUppercase; 
    }

    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      fieldErrors['password'] = true;
      return loc.passwordNumber; 
    }

    if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
      fieldErrors['password'] = true;
      return loc.passwordSpecialChar;
    }

    fieldErrors['password'] = false;
    return null;
  }

  String? _validateConfirm(String? value) {
    if (currentStep != 1) return null;
    final loc = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      fieldErrors['confirm'] = true;
      return loc.requiredField;
    }
    if (value != passwordController.text) {
      fieldErrors['confirm'] = true;
      return loc.passwordMismatch;
    }
    fieldErrors['confirm'] = false;
    return null;
  }

  String? _validatePhone(String? value) {
    if (currentStep != 2) return null;
    final loc = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      setState(() => fieldErrors['phone'] = true);
      return loc.requiredField;
    }
    String cleanNumber = value.trim().replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (!RegExp(r'^\d+$').hasMatch(cleanNumber)) {
      setState(() => fieldErrors['phone'] = true);
      return loc.phoneDigitsOnly;
    }
    if (cleanNumber.length < 9 || cleanNumber.length > 15) {
      setState(() => fieldErrors['phone'] = true);
      return loc.phoneInvalidLength;
    }
    bool isValidEgyptianNumber = false;
    if (cleanNumber.startsWith('01') && cleanNumber.length == 11) {
      String secondDigit = cleanNumber[1];
      if (['0', '1', '2', '5'].contains(secondDigit)) {
        isValidEgyptianNumber = true;
      }
    } else if (cleanNumber.startsWith('201') && cleanNumber.length == 12) {
      String thirdDigit = cleanNumber[2];
      if (['0', '1', '2', '5'].contains(thirdDigit)) {
        isValidEgyptianNumber = true;
      }
    } else if (cleanNumber.startsWith('00201') && cleanNumber.length == 14) {
      String fifthDigit = cleanNumber[4];
      if (['0', '1', '2', '5'].contains(fifthDigit)) {
        isValidEgyptianNumber = true;
      }
    } else if (cleanNumber.length >= 10 && cleanNumber.length <= 15) {
      isValidEgyptianNumber = true;
    }
    if (!isValidEgyptianNumber) {
      setState(() => fieldErrors['phone'] = true);
      return loc.invalidPhone;
    }
    setState(() => fieldErrors['phone'] = false);
    return null;
  }

  String? _validateCardName(String? value) {
    if (currentStep != 2) return null;
    final loc = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      fieldErrors['cardName'] = true;
      return loc.requiredField;
    }
    List<String> nameParts = value.trim().split(' ');
    nameParts = nameParts.where((part) => part.isNotEmpty).toList();
    if (nameParts.length < 2) {
      fieldErrors['cardName'] = true;
      return loc.enterFirstAndLastName;
    }
    for (String part in nameParts) {
      if (part.length < 3) {
        fieldErrors['cardName'] = true;
        return loc.eachNamePartMustBeAtLeast3Chars;
      }
    }
    fieldErrors['cardName'] = false;
    return null;
  }

  String? _validateCardNumber(String? value) {
    if (currentStep != 2) return null;

    final loc = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      fieldErrors['cardNumber'] = true;
      return loc.requiredField;
    }
    final cleanNumber = value.replaceAll(' ', '');
    if (!RegExp(r'^\d{16}$').hasMatch(cleanNumber)) {
      fieldErrors['cardNumber'] = true;
      return loc.invalidCard;
    }
    fieldErrors['cardNumber'] = false;
    return null;
  }

  String? _validateExpiry(String? value) {
    if (currentStep != 2) return null;
    final loc = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      fieldErrors['expiry'] = true;
      return loc.requiredField;
    }
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      fieldErrors['expiry'] = true;
      return loc.invalidExpiry;
    }
    final parts = value.split('/');
    final month = int.tryParse(parts[0]) ?? 0;
    final year = int.tryParse(parts[1]) ?? 0;
    final now = DateTime.now();
    final currentYear = now.year % 100;
    final currentMonth = now.month;
    if (month < 1 || month > 12) {
      fieldErrors['expiry'] = true;
      return loc.invalidMonth;
    }
    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      fieldErrors['expiry'] = true;
      return loc.cardExpired;
    }
    fieldErrors['expiry'] = false;
    return null;
  }

  String formatCardNumber(String text) {
    text = text.replaceAll(" ", "");
    if (text.isEmpty) return "";
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) buffer.write(" ");
    }
    return buffer.toString();
  }

  void nextStep() {
    final isValid = formKey.currentState!.validate();
    setState(() {});
    if (isValid) {
      if (currentStep == 1) {
        _changeStep(2);
      } else {
        submit();
      }
    }
  }

  void prevStep() {
    if (currentStep == 2) {
      formKey.currentState?.reset();
      setState(() {
        for (var field in stepTwoFields) {
          fieldErrors[field] = false;
        }
        currentStep = 1;
      });
      _animationController
        ..reset()
        ..forward();
    }
  }

  void submit() async {
    final loc = AppLocalizations.of(context)!;
    if (!formKey.currentState!.validate()) {
      return;
    }
    setState(() => loading = true);
    try {
      final parts = expiryController.text.split('/');
      final expiryDate = DateTime(
        2000 + int.parse(parts[1]),
        int.parse(parts[0]),
      );
      bool success = await AuthService.registerUser(
        context: context,
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        confirmPassword: confirmController.text,
        phoneNumber: phoneController.text.trim(),
        cardNumberHash: cardNumberController.text.replaceAll(" ", ""),
        cardHolderName: cardNameController.text.trim().toUpperCase(),
        exprDate: expiryDate,
      );
      if (!mounted) return;
      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              email: emailController.text.trim(),
              purpose: 'register',
            ),
          ),
        );
      }
    } catch (e) {
      print("ERROR in submit: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An unexpected error occurred: ${e.toString()}"),
            backgroundColor: context.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  void navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  Color _getLabelColor(String fieldName) {
    return fieldErrors[fieldName] == true
        ? context.errorColor
        : context.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDarkMode = context.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Color(0xff0a1628), Color(0xff0f1f3a), Color(0xff0a1628)]
                : [Color(0xfff5f7fa), Color(0xffe8ecf1), Color(0xfff5f7fa)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with shadow
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
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
                  child: RegisterLogoWidget(isDarkMode: isDarkMode),
                ),
                const SizedBox(height: 30),

                // Step Progress
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: StepProgressRegister(
                    currentStep: currentStep,
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(height: 10),

                // Step text
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut,
                        )),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    currentStep == 1 ? loc.step : loc.stepTwo,
                    key: ValueKey<int>(currentStep),
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Credit Card Preview
                if (currentStep == 2)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutBack,
                            ),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      key: const ValueKey<int>(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: context.primaryColor.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                            offset: const Offset(0, 15),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CreditCardPreviewRegister(
                        cardNameController: cardNameController,
                        cardNumberController: cardNumberController,
                        expiryController: expiryController,
                        loc: loc,
                        hasError: fieldErrors['cardNumber'] == true ||
                            fieldErrors['expiry'] == true ||
                            fieldErrors['cardName'] == true,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  ),

                if (currentStep == 2) const SizedBox(height: 30),

                // Glass Card
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 15),
                      ),
                      BoxShadow(
                        color: context.primaryColor.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: GlassCardRegister(
                    isDarkMode: isDarkMode,
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // Title
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.1),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOut,
                                  )),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              currentStep == 1 ? loc.register : loc.paymentInfo,
                              key: ValueKey<String>(
                                  currentStep == 1 ? 'register' : 'payment'),
                              style: TextStyle(
                                color: context.textPrimary,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Form Fields
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Column(
                                children: [
                                  if (currentStep == 1) ...[
                                    _buildField(
                                      controller: fullNameController,
                                      hint: loc.fullName,
                                      icon: Icons.person,
                                      validator: _validateFullName,
                                      isDarkMode: isDarkMode,
                                      hasError: fieldErrors['fullName'] == true,
                                    ),
                                    const SizedBox(height: 15),
                                    _buildField(
                                      controller: emailController,
                                      hint: loc.email,
                                      icon: Icons.email,
                                      validator: _validateEmail,
                                      keyboardType: TextInputType.emailAddress,
                                      isDarkMode: isDarkMode,
                                      hasError: fieldErrors['email'] == true,
                                    ),
                                    const SizedBox(height: 15),
                                    _buildField(
                                      controller: passwordController,
                                      hint: loc.password,
                                      icon: Icons.lock,
                                      obscure: !showPassword,
                                      validator: _validatePassword,
                                      isDarkMode: isDarkMode,
                                      hasError: fieldErrors['password'] == true,
                                      suffix: IconButton(
                                        icon: Icon(
                                          showPassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: fieldErrors['password'] == true
                                              ? context.errorColor
                                              : context.textSecondary,
                                        ),
                                        onPressed: () => setState(
                                            () => showPassword = !showPassword),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    _buildField(
                                      controller: confirmController,
                                      hint: loc.confirmPassword,
                                      icon: Icons.lock,
                                      obscure: !showConfirm,
                                      validator: _validateConfirm,
                                      isDarkMode: isDarkMode,
                                      hasError: fieldErrors['confirm'] == true,
                                      suffix: IconButton(
                                        icon: Icon(
                                          showConfirm
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: fieldErrors['confirm'] == true
                                              ? context.errorColor
                                              : context.textSecondary,
                                        ),
                                        onPressed: () => setState(
                                            () => showConfirm = !showConfirm),
                                      ),
                                    ),
                                  ],
                                  if (currentStep == 2) ...[
                                    _buildField(
                                      controller: phoneController,
                                      hint: loc.phone,
                                      icon: Icons.phone,
                                      validator: _validatePhone,
                                      keyboardType: TextInputType.phone,
                                      isDarkMode: isDarkMode,
                                      hasError: fieldErrors['phone'] == true,
                                    ),
                                    const SizedBox(height: 15),
                                    _buildField(
                                      controller: cardNameController,
                                      hint: loc.cardHolder,
                                      icon: Icons.person,
                                      validator: _validateCardName,
                                      onChanged: (_) => setState(() {}),
                                      isDarkMode: isDarkMode,
                                      hasError: fieldErrors['cardName'] == true,
                                    ),
                                    const SizedBox(height: 15),
                                    _buildField(
                                      controller: cardNumberController,
                                      hint: loc.cardNumber,
                                      icon: Icons.credit_card,
                                      validator: _validateCardNumber,
                                      onChanged: (value) {
                                        final formatted =
                                            formatCardNumber(value);
                                        cardNumberController.value =
                                            TextEditingValue(
                                          text: formatted,
                                          selection: TextSelection.collapsed(
                                            offset: formatted.length,
                                          ),
                                        );
                                        setState(() {});
                                      },
                                      keyboardType: TextInputType.number,
                                      maxLength: 19,
                                      isDarkMode: isDarkMode,
                                      hasError:
                                          fieldErrors['cardNumber'] == true,
                                    ),
                                    const SizedBox(height: 15),
                                    _buildField(
                                      controller: expiryController,
                                      hint: "MM/YY",
                                      icon: Icons.calendar_month,
                                      validator: _validateExpiry,
                                      onChanged: (value) => setState(() {}),
                                      keyboardType: TextInputType.number,
                                      maxLength: 5,
                                      inputFormatters: [
                                        _ExpiryDateFormatterRegister()
                                      ],
                                      isDarkMode: isDarkMode,
                                      hasError: fieldErrors['expiry'] == true,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Buttons
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: Tween<double>(begin: 0.9, end: 1.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOut,
                                    ),
                                  ),
                                  child: child,
                                ),
                              );
                            },
                            child: currentStep == 1
                                ? SizedBox(
                                    key: const ValueKey<String>('next_button'),
                                    width: double.infinity,
                                    height: 55,
                                    child: ElevatedButton(
                                      onPressed: nextStep,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: context.primaryColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 5,
                                      ),
                                      child: Text(
                                        loc.next,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  )
                                : Row(
                                    key: const ValueKey<String>(
                                        'finish_buttons'),
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: prevStep,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[800],
                                            foregroundColor: Colors.white,
                                            minimumSize:
                                                const Size(double.infinity, 55),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 5,
                                          ),
                                          child: Text(
                                            loc.back,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: loading ? null : nextStep,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                context.primaryColor,
                                            foregroundColor: Colors.white,
                                            minimumSize:
                                                const Size(double.infinity, 55),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 5,
                                          ),
                                          child: loading
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : Text(
                                                  loc.finish,
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                        ),
                                      )
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 20),

                          // Back to Login button
                          InkWell(
                            onTap: navigateToLogin,
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  colors: [
                                    (isDarkMode ? Colors.white : Colors.black)
                                        .withOpacity(0.1),
                                    (isDarkMode ? Colors.white : Colors.black)
                                        .withOpacity(0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(
                                  color:
                                      (isDarkMode ? Colors.white : Colors.black)
                                          .withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    loc.alreadyHaveAccount,
                                    style: TextStyle(
                                      color: context.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    loc.backToLogin,
                                    style: TextStyle(
                                      color: context.primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    TextInputType? keyboardType,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    required bool isDarkMode,
    bool hasError = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        onChanged: onChanged,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        style: TextStyle(
          color: context.textPrimary,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: hasError ? context.errorColor : context.hintColor,
          ),
          prefixIcon: Icon(
            icon,
            color: hasError ? context.errorColor : context.textSecondary,
          ),
          suffixIcon: suffix,
          filled: true,
          fillColor: hasError
              ? context.errorColor.withOpacity(0.1)
              : context.progressBgColor,
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.transparent : Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: context.primaryColor,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.errorColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

// Custom formatter for expiry field
class _ExpiryDateFormatterRegister extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }
    String digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length >= 4) {
      String formatted = '${digits.substring(0, 2)}/${digits.substring(2, 4)}';
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}

// Logo Widget
class RegisterLogoWidget extends StatelessWidget {
  final bool isDarkMode;
  const RegisterLogoWidget({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDarkMode ? Colors.white10 : Colors.grey.shade200,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/icon/icon.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: isDarkMode ? Colors.white10 : Colors.grey.shade200,
              child: Icon(
                Icons.payment,
                color: context.textSecondary,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }
}

// Step Progress Widget
class StepProgressRegister extends StatelessWidget {
  final int currentStep;
  final bool isDarkMode;
  const StepProgressRegister(
      {super.key, required this.currentStep, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 1; i <= 2; i++)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 50,
            height: 6,
            decoration: BoxDecoration(
              color: i <= currentStep
                  ? context.primaryColor
                  : (isDarkMode ? Colors.white24 : Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                if (i <= currentStep)
                  BoxShadow(
                    color: context.primaryColor.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

// Glass Card Widget
class GlassCardRegister extends StatelessWidget {
  final Widget child;
  final bool isDarkMode;
  const GlassCardRegister(
      {super.key, required this.child, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.5),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// Credit Card Preview Widget - Simple version without animations
class CreditCardPreviewRegister extends StatefulWidget {
  final TextEditingController cardNameController;
  final TextEditingController cardNumberController;
  final TextEditingController expiryController;
  final AppLocalizations loc;
  final bool hasError;
  final bool isDarkMode;

  const CreditCardPreviewRegister({
    super.key,
    required this.cardNameController,
    required this.cardNumberController,
    required this.expiryController,
    required this.loc,
    this.hasError = false,
    required this.isDarkMode,
  });

  @override
  State<CreditCardPreviewRegister> createState() =>
      _CreditCardPreviewRegisterState();
}

class _CreditCardPreviewRegisterState extends State<CreditCardPreviewRegister> {
  String _formatNumber(String text) {
    text = text.replaceAll(" ", "");
    if (text.isEmpty) return "•••• •••• •••• ••••";
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) buffer.write(" ");
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    // Colors matching CardManagementScreen
    final List<Color> cardGradient = widget.hasError
        ? [const Color(0xFF7F1D1D), const Color(0xFF991B1B)]
        : (isDarkMode
            ? [const Color(0xFF1A1F2E), const Color(0xFF2A2F3E)]
            : [const Color(0xFFE0E0E0), const Color(0xFFF5F5F5)]);

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: cardGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (widget.hasError ? Colors.red : context.primaryColor)
                .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Decorative circles (like CardManagementScreen)
            if (!widget.hasError) ...[
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.primaryColor.withOpacity(0.15),
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                left: -40,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.primaryColor.withOpacity(0.1),
                  ),
                ),
              ),
            ],
            if (!widget.hasError) ...[
              // Egyptian pattern on top right
              Positioned(
                top: 0,
                right: 0,
                child: CustomPaint(
                  size: const Size(120, 120),
                  painter: EgyptianVisaPatternRegister(
                    color: context.primaryColor.withOpacity(0.15),
                  ),
                ),
              ),
              // Egyptian pattern on bottom left
              Positioned(
                bottom: 0,
                left: 0,
                child: CustomPaint(
                  size: const Size(100, 100),
                  painter: EgyptianVisaPatternRegister(
                    color: context.primaryColor.withOpacity(0.1),
                  ),
                ),
              ),
            ],
            // Card content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card chip only (no balance)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 36,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                        child: const Icon(
                          Icons.wifi,
                          color: Colors.white60,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Card number
                  Text(
                    _formatNumber(widget.cardNumberController.text),
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 19,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Bottom row - Card holder and expiry only
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CARD HOLDER",
                            style: TextStyle(
                              color: context.textSecondary,
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          SizedBox(
                            width: 150,
                            child: Text(
                              widget.cardNameController.text.isEmpty
                                  ? "YOUR NAME HERE"
                                  : widget.cardNameController.text
                                      .toUpperCase(),
                              style: TextStyle(
                                color: context.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "EXPIRES",
                            style: TextStyle(
                              color: context.textSecondary,
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.expiryController.text.isEmpty
                                ? "MM/YY"
                                : widget.expiryController.text,
                            style: TextStyle(
                              color: context.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Egyptian Visa Pattern Painter (matching CardManagementScreen)
class EgyptianVisaPatternRegister extends CustomPainter {
  final Color color;

  EgyptianVisaPatternRegister({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw triangles (pyramid-like)
    final path = Path();
    for (int i = 0; i < 3; i++) {
      final startX = size.width * (0.2 + i * 0.3);
      final startY = size.height * 0.8;
      path.moveTo(startX, startY);
      path.lineTo(startX + 12, startY - 20);
      path.lineTo(startX - 12, startY - 20);
      path.close();
    }
    canvas.drawPath(path, paint);

    // Draw horizontal lines
    for (int i = 0; i < 3; i++) {
      final linePaint = Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(size.width * 0.15, size.height * (0.4 + i * 0.15)),
        Offset(size.width * 0.85, size.height * (0.4 + i * 0.15)),
        linePaint,
      );
    }

    // Draw circles
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * (0.15 + i * 0.175), size.height * 0.6),
        3,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
