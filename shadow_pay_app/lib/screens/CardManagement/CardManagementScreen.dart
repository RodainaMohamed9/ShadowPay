import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'package:shadow_pay_app/l10n/app_localizations.dart';

class CardManagementScreen extends StatefulWidget {
  const CardManagementScreen({super.key});

  @override
  State<CardManagementScreen> createState() => _CardManagementScreenState();
}

class _CardManagementScreenState extends State<CardManagementScreen>
    with TickerProviderStateMixin {
  bool isCardFrozen = false;
  bool isHoveringFreeze = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _snowController;
  late AnimationController _iceCrystalController;
  late Animation<double> _iceCrystalScale;
  late Animation<double> _iceCrystalOpacity;
  late AnimationController _detailsGlowController;
  late Animation<double> _detailsGlowAnimation;
  late AnimationController _shieldRotateController;
  late Animation<double> _shieldRotateAnimation;
  
  // Individual animations for each detail row
  late AnimationController _row1Controller;
  late Animation<double> _row1Slide;
  late Animation<double> _row1Fade;
  late AnimationController _row2Controller;
  late Animation<double> _row2Slide;
  late Animation<double> _row2Fade;
  late AnimationController _row3Controller;
  late Animation<double> _row3Slide;
  late Animation<double> _row3Fade;
  late AnimationController _row4Controller;
  late Animation<double> _row4Slide;
  late Animation<double> _row4Fade;
  
  // Animations for info section rows
  late AnimationController _infoRow1Controller;
  late Animation<double> _infoRow1Slide;
  late Animation<double> _infoRow1Fade;
  late AnimationController _infoRow2Controller;
  late Animation<double> _infoRow2Slide;
  late Animation<double> _infoRow2Fade;
  late AnimationController _infoRow3Controller;
  late Animation<double> _infoRow3Slide;
  late Animation<double> _infoRow3Fade;
  
  Timer? _snowTimer;
  List<Snowflake> snowflakes = [];

  final Color backgroundColor = const Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    
    // Ice crystal animation for card
    _iceCrystalController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _iceCrystalScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _iceCrystalController, curve: Curves.elasticOut),
    );
    _iceCrystalOpacity = Tween<double>(begin: 0, end: 0.8).animate(
      CurvedAnimation(parent: _iceCrystalController, curve: Curves.easeInOut),
    );
    
    // Details glow animation
    _detailsGlowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _detailsGlowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _detailsGlowController, curve: Curves.easeInOut),
    );
    
    // Shield rotate animation
    _shieldRotateController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _shieldRotateAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shieldRotateController, curve: Curves.linear),
    );
    
    // Initialize animations for each detail row
    _row1Controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _row1Slide = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _row1Controller, curve: Curves.easeOutBack),
    );
    _row1Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _row1Controller, curve: Curves.easeOut),
    );
    
    _row2Controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
    _row2Slide = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _row2Controller, curve: Curves.easeOutBack),
    );
    _row2Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _row2Controller, curve: Curves.easeOut),
    );
    
    _row3Controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _row3Slide = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _row3Controller, curve: Curves.easeOutBack),
    );
    _row3Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _row3Controller, curve: Curves.easeOut),
    );
    
    _row4Controller = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );
    _row4Slide = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _row4Controller, curve: Curves.easeOutBack),
    );
    _row4Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _row4Controller, curve: Curves.easeOut),
    );
    
    // Initialize animations for info section rows
    _infoRow1Controller = AnimationController(
      duration: const Duration(milliseconds: 420),
      vsync: this,
    );
    _infoRow1Slide = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _infoRow1Controller, curve: Curves.easeOutBack),
    );
    _infoRow1Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _infoRow1Controller, curve: Curves.easeOut),
    );
    
    _infoRow2Controller = AnimationController(
      duration: const Duration(milliseconds: 480),
      vsync: this,
    );
    _infoRow2Slide = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _infoRow2Controller, curve: Curves.easeOutBack),
    );
    _infoRow2Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _infoRow2Controller, curve: Curves.easeOut),
    );
    
    _infoRow3Controller = AnimationController(
      duration: const Duration(milliseconds: 540),
      vsync: this,
    );
    _infoRow3Slide = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _infoRow3Controller, curve: Curves.easeOutBack),
    );
    _infoRow3Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _infoRow3Controller, curve: Curves.easeOut),
    );
    
    // Start animations on init
    _row1Controller.forward();
    _row2Controller.forward();
    _row3Controller.forward();
    _row4Controller.forward();
    _infoRow1Controller.forward();
    _infoRow2Controller.forward();
    _infoRow3Controller.forward();
    
    _snowController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    )..addListener(() {
      if (showSnow && mounted) {
        setState(() {
          for (var snowflake in snowflakes) {
            snowflake.y += snowflake.speed;
            if (snowflake.y > 1.0) {
              snowflake.y = 0;
              snowflake.x = Random().nextDouble();
            }
          }
        });
      }
    });
    
    // Initialize snowflakes
    for (int i = 0; i < 60; i++) {
      snowflakes.add(Snowflake(
        x: Random().nextDouble(),
        y: Random().nextDouble(),
        speed: 0.003 + Random().nextDouble() * 0.005,
        size: 3 + Random().nextDouble() * 5,
      ));
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    _snowController.dispose();
    _iceCrystalController.dispose();
    _detailsGlowController.dispose();
    _shieldRotateController.dispose();
    _row1Controller.dispose();
    _row2Controller.dispose();
    _row3Controller.dispose();
    _row4Controller.dispose();
    _infoRow1Controller.dispose();
    _infoRow2Controller.dispose();
    _infoRow3Controller.dispose();
    _snowTimer?.cancel();
    super.dispose();
  }

  bool showSnow = false;

  void toggleFreeze(AppLocalizations loc) {
    setState(() {
      isCardFrozen = !isCardFrozen;
    });
    
    _shakeController.forward(from: 0).then((_) => _shakeController.reverse());
    
    // Reset animations
    _row1Controller.reset();
    _row2Controller.reset();
    _row3Controller.reset();
    _row4Controller.reset();
    _infoRow1Controller.reset();
    _infoRow2Controller.reset();
    _infoRow3Controller.reset();
    _row1Controller.forward();
    _row2Controller.forward();
    _row3Controller.forward();
    _row4Controller.forward();
    _infoRow1Controller.forward();
    _infoRow2Controller.forward();
    _infoRow3Controller.forward();
    
    if (isCardFrozen) {
      _iceCrystalController.forward(from: 0);
      _detailsGlowController.repeat(reverse: true);
      setState(() {
        showSnow = true;
      });
      _snowController.repeat();
      
      _snowTimer?.cancel();
      _snowTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            showSnow = false;
          });
          _snowController.stop();
        }
      });
    } else {
      _snowController.stop();
      setState(() {
        showSnow = false;
      });
      _snowTimer?.cancel();
      _iceCrystalController.reverse();
      _detailsGlowController.stop();
    }
    
    _showSnackBar(
      isCardFrozen ? loc.cardFrozenSnackbar : loc.cardUnfrozenSnackbar,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          loc.cardManagement,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          loc.cardManagementSubtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Status Card
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOutCubic,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isCardFrozen
                                  ? [
                                      Colors.blue.withOpacity(0.08),
                                      Colors.blue.withOpacity(0.04),
                                    ]
                                  : [
                                      Colors.green.withOpacity(0.08),
                                      Colors.green.withOpacity(0.04),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isCardFrozen
                                  ? Colors.blue.withOpacity(0.2)
                                  : Colors.green.withOpacity(0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              AnimatedBuilder(
                                animation: _shieldRotateAnimation,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _shieldRotateAnimation.value * 2 * pi,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        isCardFrozen ? Icons.ac_unit : Icons.shield,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      isCardFrozen ? loc.cardFrozen : loc.cardActive,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isCardFrozen ? loc.cardFrozenDesc : loc.cardActiveDesc,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Credit Card
                        RotationTransition(
                          turns: _shakeAnimation,
                          child: TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: 0.95 + (value * 0.05),
                                child: Opacity(opacity: value, child: child),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 25,
                                    offset: const Offset(0, 15),
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Card background - Single color gradient
                                    BackdropFilter(
                                      filter: isCardFrozen
                                          ? ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5)
                                          : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                      child: Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: isCardFrozen
                                                ? [
                                                    const Color(0xFF1B4D6E),
                                                    const Color(0xFF0E3A5F),
                                                  ]
                                                : [
                                                    const Color(0xFF00BBA7),
                                                    const Color(0xFF009688),
                                                  ],
                                          ),
                                          borderRadius: BorderRadius.circular(32),
                                          boxShadow: [
                                            BoxShadow(
                                              color: (isCardFrozen
                                                      ? const Color(0xFF1B4D6E)
                                                      : const Color(0xFF00BBA7))
                                                  .withAlpha(64),
                                              blurRadius: 30,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      loc.availableBalance,
                                                      style: TextStyle(
                                                        color: Colors.white.withOpacity(0.9),
                                                        fontSize: 12,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    const Text(
                                                      "\$12,847.50",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 32,
                                                        fontWeight: FontWeight.bold,
                                                        shadows: [
                                                          Shadow(
                                                            color: Colors.black38,
                                                            blurRadius: 8,
                                                            offset: Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                AnimatedBuilder(
                                                  animation: _shieldRotateAnimation,
                                                  builder: (context, child) {
                                                    return Transform.rotate(
                                                      angle: _shieldRotateAnimation.value * 2 * pi,
                                                      child: Container(
                                                        padding: const EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white.withOpacity(0.15),
                                                          borderRadius: BorderRadius.circular(20),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Colors.black26,
                                                              blurRadius: 8,
                                                              offset: Offset(0, 4),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Icon(
                                                          isCardFrozen ? Icons.ac_unit : Icons.shield,
                                                          color: Colors.white,
                                                          size: 32,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 45),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  loc.cardNumber,
                                                  style: TextStyle(
                                                    color: Colors.white.withOpacity(0.8),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  loc.cardNumberMasked,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    letterSpacing: 2.5,
                                                    fontWeight: FontWeight.w600,
                                                    shadows: const [
                                                      Shadow(
                                                        color: Colors.black26,
                                                        blurRadius: 4,
                                                        offset: Offset(0, 1),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 35),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      loc.cardHolderName,
                                                      style: TextStyle(
                                                        color: Colors.white.withOpacity(0.8),
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      loc.cardHolderValue,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                        shadows: const [
                                                          Shadow(
                                                            color: Colors.black26,
                                                            blurRadius: 4,
                                                            offset: Offset(0, 1),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      loc.expiryDate,
                                                      style: TextStyle(
                                                        color: Colors.white.withOpacity(0.8),
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      loc.expiryDateValue,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                        shadows: const [
                                                          Shadow(
                                                            color: Colors.black26,
                                                            blurRadius: 4,
                                                            offset: Offset(0, 1),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Ice crystal in center
                                    if (isCardFrozen)
                                      AnimatedBuilder(
                                        animation: _iceCrystalController,
                                        builder: (context, child) {
                                          return Opacity(
                                            opacity: _iceCrystalOpacity.value,
                                            child: Transform.rotate(
                                              angle: _shieldRotateAnimation.value * 2 * pi,
                                              child: Transform.scale(
                                                scale: _iceCrystalScale.value,
                                                child: const Icon(
                                                  Icons.ac_unit,
                                                  color: Colors.white,
                                                  size: 85,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Card Details
                        AnimatedBuilder(
                          animation: _detailsGlowController,
                          builder: (context, child) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutCubic,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF1A1F2E).withOpacity(0.6),
                                    const Color(0xFF131826).withOpacity(0.6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.05),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Icon(
                                          Icons.credit_card_outlined,
                                          color: Colors.blue,
                                          size: 22,
                                        ),
                                      ),
                                      Text(
                                        loc.cardDetails,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Animated Row 1
                                  AnimatedBuilder(
                                    animation: _row1Controller,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(_row1Slide.value, 0),
                                        child: Opacity(
                                          opacity: _row1Fade.value,
                                          child: _buildAnimatedDetailRow(
                                            loc.cardHolderName,
                                            loc.cardHolderValue,
                                            Icons.person_outline,
                                            _detailsGlowAnimation.value,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  
                                  // Animated Row 2
                                  AnimatedBuilder(
                                    animation: _row2Controller,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(_row2Slide.value, 0),
                                        child: Opacity(
                                          opacity: _row2Fade.value,
                                          child: _buildAnimatedDetailRow(
                                            loc.cardType,
                                            loc.cardTypeValue,
                                            Icons.credit_card,
                                            _detailsGlowAnimation.value,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  
                                  // Animated Row 3
                                  AnimatedBuilder(
                                    animation: _row3Controller,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(_row3Slide.value, 0),
                                        child: Opacity(
                                          opacity: _row3Fade.value,
                                          child: _buildAnimatedDetailRow(
                                            loc.issueDate,
                                            loc.issueDateValue,
                                            Icons.calendar_today_outlined,
                                            _detailsGlowAnimation.value,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  
                                  // Animated Row 4
                                  AnimatedBuilder(
                                    animation: _row4Controller,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(_row4Slide.value, 0),
                                        child: Opacity(
                                          opacity: _row4Fade.value,
                                          child: _buildAnimatedDetailRow(
                                            loc.expiryDate,
                                            loc.expiryDateValue,
                                            Icons.event_busy_outlined,
                                            _detailsGlowAnimation.value,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // Freeze Button
                        MouseRegion(
                          onEnter: (_) => setState(() => isHoveringFreeze = true),
                          onExit: (_) => setState(() => isHoveringFreeze = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            transform: Matrix4.translationValues(
                                0, isHoveringFreeze ? -2 : 0, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isCardFrozen
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                elevation: isHoveringFreeze ? 8 : 4,
                                shadowColor: isCardFrozen
                                    ? Colors.green.withOpacity(0.5)
                                    : Colors.red.withOpacity(0.5),
                              ),
                              onPressed: () => toggleFreeze(loc),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Icon(
                                      isCardFrozen
                                          ? Icons.lock_open
                                          : Icons.lock_outline,
                                      key: ValueKey(isCardFrozen),
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Text(
                                      isCardFrozen
                                          ? loc.unfreezeCard
                                          : loc.freezeCard,
                                      key: ValueKey(isCardFrozen),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Info Section
                        AnimatedBuilder(
                          animation: _detailsGlowController,
                          builder: (context, child) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutCubic,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF1A1F2E).withOpacity(0.6),
                                    const Color(0xFF131826).withOpacity(0.6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.05),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Icon(
                                          Icons.info_outline,
                                          color: Colors.blue,
                                          size: 22,
                                        ),
                                      ),
                                      Text(
                                        loc.aboutFreeze,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Animated Info Row 1
                                  AnimatedBuilder(
                                    animation: _infoRow1Controller,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(_infoRow1Slide.value, 0),
                                        child: Opacity(
                                          opacity: _infoRow1Fade.value,
                                          child: _buildAnimatedInfoRow(
                                            Icons.block,
                                            loc.freezeInfo1,
                                            _detailsGlowAnimation.value,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  
                                  // Animated Info Row 2
                                  AnimatedBuilder(
                                    animation: _infoRow2Controller,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(_infoRow2Slide.value, 0),
                                        child: Opacity(
                                          opacity: _infoRow2Fade.value,
                                          child: _buildAnimatedInfoRow(
                                            Icons.lock_open,
                                            loc.freezeInfo2,
                                            _detailsGlowAnimation.value,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  
                                  // Animated Info Row 3
                                  AnimatedBuilder(
                                    animation: _infoRow3Controller,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(_infoRow3Slide.value, 0),
                                        child: Opacity(
                                          opacity: _infoRow3Fade.value,
                                          child: _buildAnimatedInfoRow(
                                            Icons.auto_awesome,
                                            loc.freezeInfo3,
                                            _detailsGlowAnimation.value,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Snowflakes
            if (showSnow)
              IgnorePointer(
                child: CustomPaint(
                  painter: SnowPainter(snowflakes: snowflakes),
                  size: Size.infinite,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDetailRow(String label, String value, IconData icon, double glowValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: Colors.grey[400],
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedInfoRow(IconData icon, String text, double glowValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: Colors.grey[400],
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class Snowflake {
  double x;
  double y;
  double speed;
  double size;
  
  Snowflake({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
  });
}

class SnowPainter extends CustomPainter {
  final List<Snowflake> snowflakes;
  
  SnowPainter({required this.snowflakes});
  
  @override
  void paint(Canvas canvas, Size size) {
    for (var snowflake in snowflakes) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.35)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(snowflake.x * size.width, snowflake.y * size.height),
        snowflake.size,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(SnowPainter oldDelegate) => true;
}