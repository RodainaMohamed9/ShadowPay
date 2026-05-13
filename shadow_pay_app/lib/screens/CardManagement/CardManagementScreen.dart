import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/logic/profile/cubit/profile_cubit.dart';
import 'package:shadow_pay_app/logic/profile/cubit/profile_state.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/services/shared_pref_service.dart';

class CardManagementScreen extends StatefulWidget {
   final VoidCallback? onBack;
  const CardManagementScreen({super.key ,this.onBack,});

  @override
  State<CardManagementScreen> createState() => _CardManagementScreenState();
}

class _CardManagementScreenState extends State<CardManagementScreen>
    with TickerProviderStateMixin {
  bool isCardFrozen = false;
  bool showSnowEffect = false;
  late AnimationController _animationController;
  late AnimationController _snowController;
  late AnimationController _iceCrystalController;
  late AnimationController _alertController;
  late AnimationController _cardTapController;
  late AnimationController _flipController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _iceRotationAnimation;
  late Animation<double> _iceScaleAnimation;
  late Animation<double> _icePulseAnimation;
  late Animation<double> _cardTapScaleAnimation;
  late Animation<double> _cardTapRotationAnimation;
  late Animation<double> _flipAnimation;
  late List<Snowflake> snowflakes = [];

  bool isAlertExpanded = false;
  bool _isFromUserAction = false;

  @override
  void initState() {
    super.initState();
    _loadCardStatus();
    _initAnimations();
    context.read<ProfileCubit>().getProfile();
  }
  String _formatCardNumber(String number) {
    if (number.isEmpty) return '•••• •••• •••• 4829';
    final last4 = number.length >= 4 ? number.substring(number.length - 4) : number;
    return '•••• •••• •••• $last4';
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _snowController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _iceCrystalController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _alertController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();

    _cardTapController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0.08).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuad),
    );

    _iceRotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _iceCrystalController, curve: Curves.linear),
    );

    _iceScaleAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(
          parent: _iceCrystalController, curve: Curves.easeInOutSine),
    );

    _icePulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
          parent: _iceCrystalController, curve: Curves.easeInOutCubic),
    );

    _cardTapScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _cardTapController, curve: Curves.easeOutBack),
    );

    _cardTapRotationAnimation = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(parent: _cardTapController, curve: Curves.easeOutQuad),
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _flipController.reverse();
          }
        });
      }
    });

    _snowController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            showSnowEffect = false;
            snowflakes.clear();
          });
        }
      }
    });

    _cardTapController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _cardTapController.reverse();
      }
    });
  }

  Future<void> _loadCardStatus() async {
    final frozen = await SharedPrefService.getCardFrozenStatus();
    setState(() {
      isCardFrozen = frozen;
    });
  }

  Future<void> _saveCardStatusToPreferences() async {
    await SharedPrefService.setCardFrozen(isCardFrozen);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void toggleFreeze([AppLocalizations? loc]) {
    _animationController.forward(from: 0);
    setState(() {
      isCardFrozen = !isCardFrozen;
      if (isCardFrozen) {
        showSnowEffect = true;
        _generateSnowflakes();
        _snowController.forward(from: 0);
        _alertController.stop();
      } else {
        showSnowEffect = false;
        _snowController.stop();
        snowflakes.clear();
        _alertController.forward(from: 0);
      }
    });
    
    _saveCardStatusToPreferences();

    if (loc != null && _isFromUserAction) {
      _showSnackBar(
        isCardFrozen ? loc.cardFrozenSnackbar : loc.cardUnfrozenSnackbar,
      );
      _isFromUserAction = false;
    }

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        _animationController.reset();
      }
    });
  }

  void onCardTap() {
    _cardTapController.forward(from: 0);
    _flipController.forward(from: 0);
  }

  void _generateSnowflakes() {
    snowflakes.clear();
    for (int i = 0; i < 120; i++) {
      snowflakes.add(Snowflake(
        id: i,
        startX: (i * 97) % 1.0,
        startY: -((i * 43) % 0.8),
        size: 2 + (i % 14).toDouble(),
        speed: 0.7 + (i % 8) / 10,
        opacity: 0.4 + (i % 10) / 10,
        sway: (i % 15) / 15,
      ));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _snowController.dispose();
    _iceCrystalController.dispose();
    _alertController.dispose();
    _cardTapController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    final isDarkMode = context.isDarkMode;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: -40, end: 0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        builder: (context, double value, child) {
                          return Transform.translate(
                            offset: Offset(0, value),
                            child: Opacity(
                              opacity: 1 - (value / -40),
                              child: child,
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            IconButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  (isDarkMode
                                          ? const Color(0xff1D293D)
                                          : Colors.grey.shade200)
                                      .withOpacity(0.4),
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                    color:
                                        context.textSecondary.withOpacity(0.4),
                                    width: 1,
                                  ),
                                ),
                              ),
                              iconSize: 25,
onPressed: () {
  if (widget.onBack != null) {
    widget.onBack!();
  } else {
    Navigator.pop(context);
  }
},
                              icon: Icon(Icons.arrow_back,
                                  color: context.textSecondary),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loc.cardManagement,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: context.textPrimary,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    loc.cardManagementSubtitle,
                                    style: TextStyle(
                                      color: context.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1 + (_scaleAnimation.value - 1) * 0.2,
                            child: Opacity(
                              opacity: 1 - (_animationController.value * 0.05),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isCardFrozen
                                        ? Colors.blue.withOpacity(0.5)
                                        : context.primaryColor.withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                  color: isCardFrozen
                                      ? Colors.blue.withOpacity(0.12)
                                      : context.primaryColor.withOpacity(0.12),
                                ),
                                child: Row(
                                  children: [
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      transitionBuilder: (child, animation) {
                                        return ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        );
                                      },
                                      child: Icon(
                                        isCardFrozen
                                            ? Icons.ac_unit
                                            : Icons.shield,
                                        key: ValueKey(isCardFrozen),
                                        color: isCardFrozen
                                            ? Colors.blue[300]
                                            : context.primaryColor,
                                        size: 35,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 400),
                                            transitionBuilder:
                                                (child, animation) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: SlideTransition(
                                                  position: Tween<Offset>(
                                                    begin:
                                                        const Offset(0, -0.2),
                                                    end: Offset.zero,
                                                  ).animate(animation),
                                                  child: child,
                                                ),
                                              );
                                            },
                                            child: Text(
                                              isCardFrozen
                                                  ? loc.cardFrozen
                                                  : loc.cardActive,
                                              key: ValueKey(isCardFrozen),
                                              style: TextStyle(
                                                color: context.textPrimary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 400),
                                            transitionBuilder:
                                                (child, animation) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                            child: Text(
                                              isCardFrozen
                                                  ? loc.cardFrozenDesc
                                                  : loc.cardActiveDesc,
                                              key: ValueKey(isCardFrozen),
                                              style: TextStyle(
                                                color: isCardFrozen
                                                    ? Colors.blue[200]
                                                    : context.primaryColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        height: 230,
                        child: GestureDetector(
                          onTap: onCardTap,
                          child: AnimatedBuilder(
                            animation: Listenable.merge([
                              _cardTapController,
                              _animationController,
                            ]),
                            builder: (context, child) {
                              final tapScale = _cardTapScaleAnimation.value;
                              final tapRotateX =
                                  _cardTapRotationAnimation.value *
                                      (isCardFrozen ? -1 : 1);
                              final tapRotateY =
                                  _cardTapRotationAnimation.value * 0.5;

                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateX(tapRotateX)
                                  ..rotateY(tapRotateY)
                                  ..scale(tapScale),
                                child: AnimatedBuilder(
                                  animation: _flipAnimation,
                                  builder: (context, child) {
                                    final flipValue = _flipAnimation.value;
                                    final isFront = flipValue <= 0.5;

                                    return Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..rotateY(math.pi * flipValue),
                                      child: isFront
                                          ? _buildCardFront(
                                              loc, isCardFrozen, flipValue)
                                          : Transform(
                                              alignment: Alignment.center,
                                              transform: Matrix4.identity()
                                                ..rotateY(math.pi),
                                              child: _buildCardBack(
                                                  loc, isCardFrozen, flipValue),
                                            ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutCubic,
                        builder: (context, double value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 30 * (1 - value)),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      (isDarkMode ? Colors.white : Colors.black)
                                          .withOpacity(0.06),
                                  border: Border.all(
                                    color: (isDarkMode
                                            ? Colors.white
                                            : Colors.black)
                                        .withOpacity(0.08),
                                    width: 1,
                                  ),
                                ),
                                child: BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state){
                                  String cardHolder = loc.cardHolderValue;
                                  String cardType = loc.cardTypeValue; 
                                  String issueDate = loc.issueDateValue;
                                  String expiryDate = loc.expiryDateValue;

                                  if (state is ProfileSuccessState && state.profile != null) {
                                    cardHolder = state.profile!.cardHolderName.toUpperCase();
                                    if (state.profile!.cardNumberHash.startsWith('4')) {
                                      cardType = 'Visa';
                                    } else if (state.profile!.cardNumberHash.startsWith('5')) {
                                      cardType = 'MasterCard';
                                    } else if (state.profile!.cardNumberHash.startsWith('3')) {
                                      cardType = 'American Express';
                                    } else {
                                      cardType = 'Unknown';
                                    }
                                    issueDate = "${state.profile!.exprDate.month.toString().padLeft(2, '0')}/${state.profile!.exprDate.year}";
                                    expiryDate = state.profile!.formattedExpiry;
                                  }

                                  return Column(
                                      children: [
                                        _row(loc.cardHolder, cardHolder, value),
                                        const SizedBox(height: 8),
                                        _row(loc.cardType, cardType, value),
                                        const SizedBox(height: 8),
                                        _row(loc.issueDate, issueDate, value),
                                        const SizedBox(height: 8),
                                        _row(loc.expiryDate, expiryDate, value),
                                      ],
                                    );
                                }),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 25),

                      GestureDetector(
                        onTap: () {
                          _isFromUserAction = true;
                          _animationController.forward(from: 0);
                          toggleFreeze(loc);
                        },
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1 + (_animationController.value * 0.02),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: isCardFrozen
                                      ? Colors.green.withOpacity(0.8)
                                      : context.primaryColor,
                                  border: Border.all(
                                    color: isCardFrozen
                                        ? Colors.green.withOpacity(0.8)
                                        : context.primaryColor,
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isCardFrozen
                                          ? Colors.green.withOpacity(0.8)
                                          : context.primaryColor,
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 400),
                                    transitionBuilder: (child, animation) {
                                      return ScaleTransition(
                                        scale: animation,
                                        child: FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      isCardFrozen
                                          ? loc.unfreezeCard
                                          : loc.freezeCard,
                                      key: ValueKey(isCardFrozen),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (!isCardFrozen)
                        AnimatedBuilder(
                          animation: _alertController,
                          builder: (context, child) {
                            return TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutCubic,
                              builder: (context, double value, child) {
                                return Transform.translate(
                                  offset: Offset(30 * (1 - value), 0),
                                  child: Opacity(
                                    opacity: value,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isAlertExpanded = !isAlertExpanded;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeOutCubic,
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              context.primaryColor
                                                  .withOpacity(0.08),
                                              context.primaryColor
                                                  .withOpacity(0.04),
                                            ],
                                          ),
                                          border: Border.all(
                                            color: isAlertExpanded
                                                ? context.primaryColor
                                                    .withOpacity(0.5)
                                                : context.primaryColor
                                                    .withOpacity(0.2),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        context.primaryColor,
                                                        context.primaryColor
                                                            .withOpacity(0.7),
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: context
                                                            .primaryColor
                                                            .withOpacity(0.3),
                                                        blurRadius: 10,
                                                        offset:
                                                            const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Icon(
                                                    Icons.shield,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        loc.securityControlCenter,
                                                        style: TextStyle(
                                                          color: context
                                                              .textPrimary,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: -0.3,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        loc.securityControlSubtitle,
                                                        style: TextStyle(
                                                          color: context
                                                              .textSecondary,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                AnimatedRotation(
                                                  duration: const Duration(
                                                      milliseconds: 400),
                                                  turns: isAlertExpanded
                                                      ? 0.5
                                                      : 0.0,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: context
                                                          .primaryColor
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Icon(
                                                      Icons
                                                          .keyboard_arrow_down_rounded,
                                                      color:
                                                          context.primaryColor,
                                                      size: 22,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            AnimatedCrossFade(
                                              firstChild:
                                                  const SizedBox.shrink(),
                                              secondChild: Column(
                                                children: [
                                                  const SizedBox(height: 20),
                                                  Container(
                                                    height: 1,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.transparent,
                                                          context.primaryColor
                                                              .withOpacity(0.3),
                                                          Colors.transparent,
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  _buildSecurityFeature(
                                                    icon: Icons.ac_unit,
                                                    title: loc.aboutFreeze,
                                                    description:
                                                        loc.freezeInfo1,
                                                    color: context.primaryColor,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  _buildSecurityFeature(
                                                    icon: Icons.touch_app,
                                                    title: loc.fullControl,
                                                    description:
                                                        loc.freezeInfo2,
                                                    color: Colors.green[300]!,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  _buildSecurityFeature(
                                                    icon: Icons.auto_awesome,
                                                    title: loc.advancedAI,
                                                    description:
                                                        loc.freezeInfo3,
                                                    color:
                                                        const Color(0xFF3DB892),
                                                  ),
                                                ],
                                              ),
                                              crossFadeState: isAlertExpanded
                                                  ? CrossFadeState.showSecond
                                                  : CrossFadeState.showFirst,
                                              duration: const Duration(
                                                  milliseconds: 400),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            if (showSnowEffect)
              AnimatedBuilder(
                animation: _snowController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: SnowPainter(
                      snowflakes: snowflakes,
                      progress: _snowController.value,
                    ),
                    size: Size.infinite,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFront(
      AppLocalizations loc, bool isCardFrozen, double flipValue) {
    final textOpacity = flipValue <= 0.3
        ? 1.0
        : (1.0 - (flipValue - 0.3) / 0.2).clamp(0.0, 1.0);
    final isDarkMode = context.isDarkMode;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadingState) {
        return Center(
          child: CircularProgressIndicator(
            color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
          ),
        );
      } else if (state is ProfileFailureState) {
        return Center(
          child: Text(state.errorMessage),
        );
      }
        if(state is ProfileSuccessState){
          return Container(
          height: 230,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: isCardFrozen
                  ? [const Color(0xFF2A4A7A), const Color(0xFF3A6A9A)] 
                  : (isDarkMode
                      ? [const Color(0xFF1A1F2E), const Color(0xFF2A2F3E)]
                      : [const Color(0xFFE0E0E0), const Color(0xFFF5F5F5)]),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    (isCardFrozen ? const Color(0xFF3A6A9A) : context.primaryColor)
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
                if (isCardFrozen) ...[
                  Positioned(
                    top: -50,
                    right: -50,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1 + (_animationController.value * 0.15),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withOpacity(0.3),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    left: -40,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1 + (_animationController.value * 0.15),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.cyan.withOpacity(0.2),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                if (!isCardFrozen) ...[
                  Positioned(
                    top: 0,
                    right: 0,
                    child: CustomPaint(
                      size: const Size(120, 120),
                      painter: EgyptianVisaPattern(
                        color: context.primaryColor.withOpacity(0.15),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: CustomPaint(
                      size: const Size(100, 100),
                      painter: EgyptianVisaPattern(
                        color: context.primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 20,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.landscape,
                        color: context.primaryColor.withOpacity(0.4),
                        size: 28,
                      ),
                    ),
                  ),
                ],
                Opacity(
                  opacity: textOpacity,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color: context.textSecondary, fontSize: 12),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "\$12,847.50",
                                  style: TextStyle(
                                    color: context.textPrimary,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox.shrink(),
                          ],
                        ),
                        const Spacer(),
                        if (!isCardFrozen)
                            Text(
                        _formatCardNumber(state.profile?.cardNumberHash.toString() ?? "**** **** **** 1234"),
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 18,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                        if (isCardFrozen)
                          Text(state.profile?.cardNumberHash.toString() ?? "**** **** **** 1234",
                              style: TextStyle(
                                  color: context.textPrimary,
                                  fontSize: 20,
                                  letterSpacing: 2.5,
                                  fontWeight: FontWeight.w500)),
                        const SizedBox(height: 15),
                        if (!isCardFrozen)
                          Row(
                            children: [
                              Container(
                                width: 35,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.amber.withOpacity(0.5),
                                      width: 1),
                                ),
                                child: const Icon(Icons.sim_card,
                                    color: Colors.amber, size: 16),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(state.profile?.cardHolderName.toUpperCase() ?? "Card Holder",
                                        style: TextStyle(
                                            color: context.textPrimary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            letterSpacing: 0.5)),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text(state.profile?.formattedExpiry ?? "12/24",
                                            style: TextStyle(
                                                color: context.textSecondary,
                                                fontSize: 10)),
                                        const SizedBox(width: 12),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("VISA",
                                      style: TextStyle(
                                          color:
                                              context.primaryColor.withOpacity(0.7),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5)),
                                  Container(
                                    width: 30,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colors.amber.withOpacity(0.6),
                                        Colors.orange.withOpacity(0.4)
                                      ]),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (isCardFrozen)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(state.profile?.cardHolderName.toUpperCase() ?? "Card Holder",
                                  style: TextStyle(
                                      color: context.textSecondary, fontSize: 12)),
                              Text(state.profile?.formattedExpiry ?? "12/24",
                                  style: TextStyle(
                                      color: context.textSecondary, fontSize: 12)),
                              const Text("***",
                                  style:
                                      TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                if (isCardFrozen)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          color: Colors.black.withOpacity(0.3),
                          child: Center(
                            child: AnimatedBuilder(
                              animation: _iceCrystalController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _iceScaleAnimation.value,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Transform.rotate(
                                        angle: _iceRotationAnimation.value,
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: RadialGradient(
                                              colors: [
                                                Colors.blue.withOpacity(0.7),
                                                Colors.blue.withOpacity(0.3),
                                                Colors.transparent
                                              ],
                                              stops: const [0.3, 0.6, 1.0],
                                            ),
                                          ),
                                          child: const Icon(Icons.ac_unit,
                                              color: Colors.blue, size: 70),
                                        ),
                                      ),
                                      for (int i = 0; i < 3; i++)
                                        _buildIceRing(
                                            i, _iceRotationAnimation.value),
                                      for (int i = 0; i < 12; i++)
                                        _buildFloatingIceParticle(
                                            i, _icePulseAnimation.value),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
        }
        else {
        return Center(
          child: Text("No data available"),
        );
      }
      }
    );
  }

  Widget _buildCardBack(
      AppLocalizations loc, bool isCardFrozen, double flipValue) {
    final textOpacity =
        flipValue >= 0.7 ? ((flipValue - 0.7) / 0.3).clamp(0.0, 1.0) : 0.0;
    final isDarkMode = context.isDarkMode;

    return Container(
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isCardFrozen
              ? [const Color(0xFF2A2F3E), const Color(0xFF2A2F3E)]
              : (isDarkMode
                  ? [const Color(0xFF1A1F2E), const Color(0xFF2A2F3E)]
                  : [const Color(0xFFE0E0E0), const Color(0xFFF5F5F5)]),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
              color: (isCardFrozen
                      ? const Color(0xFF800020)
                      : context.primaryColor)
                  .withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isCardFrozen
                          ? const Color(0xFF2A2F3E)
                          : context.primaryColor)
                      .withOpacity(0.15),
                ),
              ),
            ),
            Opacity(
              opacity: textOpacity,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: double.infinity,
                        height: 45,
                        color: Colors.black.withOpacity(0.5),
                        margin: const EdgeInsets.only(top: 10)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("CVV",
                                style: TextStyle(
                                    color: context.textSecondary,
                                    fontSize: 10)),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(
                                  color:
                                      (isDarkMode ? Colors.white : Colors.black)
                                          .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text("***",
                                  style: TextStyle(
                                      color: context.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 4)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("CARD TYPE",
                                style: TextStyle(
                                    color: context.textSecondary,
                                    fontSize: 10)),
                            const SizedBox(height: 5),
                            Text("PREMIUM",
                                style: TextStyle(
                                    color: (isCardFrozen
                                            ? const Color(0xFF800020)
                                            : context.primaryColor)
                                        .withOpacity(0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1)),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("24/7 Support",
                            style: TextStyle(
                                color: context.textSecondary, fontSize: 10)),
                        Text("www.shadowpay.com",
                            style: TextStyle(
                                color: context.textSecondary, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIceRing(int index, double rotation) {
    double size = 120 + (index * 15);
    double opacity = 0.4 - (index * 0.1);
    double speed = 1.0 - (index * 0.2);
    return Transform.rotate(
      angle: rotation * speed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: Colors.blue.withOpacity(opacity),
                width: 2.0 - (index * 0.5))),
        child: Center(
            child: Container(
                width: size - 20,
                height: size - 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.cyan.withOpacity(opacity * 0.6),
                        width: 1.0)))),
      ),
    );
  }

  Widget _buildFloatingIceParticle(int index, double pulseValue) {
    double angle = (index * 30) * (math.pi / 180);
    double radius = 70 + (pulseValue * 20);
    double x = radius * math.cos(angle + pulseValue * 2);
    double y = radius * math.sin(angle + pulseValue * 2);
    return Positioned(
      left: 100 + x,
      top: 100 + y,
      child: AnimatedBuilder(
        animation: _iceCrystalController,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.6 + (pulseValue * 0.4),
            child: Transform.rotate(
              angle: _iceRotationAnimation.value * (index + 1),
              child: Container(
                width: 8 + (index % 5).toDouble(),
                height: 8 + (index % 5).toDouble(),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.6 + (pulseValue * 0.3)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.withOpacity(0.4),
                          blurRadius: 6,
                          spreadRadius: 2)
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSecurityFeature(
      {required IconData icon,
      required String title,
      required String description,
      required Color color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20)),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: TextStyle(
                  color: context.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(description,
              style: TextStyle(
                  color: context.textSecondary, fontSize: 12, height: 1.4)),
        ])),
      ],
    );
  }

  Widget _row(String title, String value, double animationValue) {
    return Transform.translate(
      offset: Offset(30 * (1 - animationValue), 0),
      child: Opacity(
        opacity: animationValue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: TextStyle(color: context.textSecondary, fontSize: 14)),
            Text(value,
                style: TextStyle(
                    color: context.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class EgyptianVisaPattern extends CustomPainter {
  final Color color;
  EgyptianVisaPattern({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
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
    for (int i = 0; i < 3; i++) {
      final linePaint = Paint()
        ..color = color
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(size.width * 0.15, size.height * (0.4 + i * 0.15)),
          Offset(size.width * 0.85, size.height * (0.4 + i * 0.15)), linePaint);
    }
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
          Offset(size.width * (0.15 + i * 0.175), size.height * 0.6),
          2.5,
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Snowflake {
  final int id;
  final double startX, startY, size, speed, opacity, sway;
  Snowflake(
      {required this.id,
      required this.startX,
      required this.startY,
      required this.size,
      required this.speed,
      required this.opacity,
      required this.sway});
}

class SnowPainter extends CustomPainter {
  final List<Snowflake> snowflakes;
  final double progress;
  SnowPainter({required this.snowflakes, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var snowflake in snowflakes) {
      double y = snowflake.startY + (progress * snowflake.speed);
      if (y > 1.2) continue;
      double swayOffset =
          math.sin(progress * 2 * math.pi * 0.6 + snowflake.id) *
              snowflake.sway;
      double x = snowflake.startX + swayOffset;
      if (x < 0) x += 1.0;
      if (x > 1.0) x -= 1.0;
      final paint = Paint()
        ..color =
            Colors.white.withOpacity(snowflake.opacity * (1 - progress * 0.2))
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
      canvas.drawCircle(
          Offset(x * size.width, y * size.height), snowflake.size, paint);
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(snowflake.opacity * 0.6)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x * size.width - 1, y * size.height - 1),
          snowflake.size * 0.4, highlightPaint);
      if (snowflake.size > 6) {
        final glowPaint = Paint()
          ..color = Colors.blue.withOpacity(0.15)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(Offset(x * size.width, y * size.height),
            snowflake.size * 1.3, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(SnowPainter oldDelegate) =>
      oldDelegate.progress != progress;
}