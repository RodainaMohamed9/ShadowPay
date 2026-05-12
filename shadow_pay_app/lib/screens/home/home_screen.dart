import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadow_pay_app/logic/profile/cubit/profile_cubit.dart';
import 'package:shadow_pay_app/logic/profile/cubit/profile_state.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/welcome_header.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/shield_status.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/virtual_card.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/quick_actions.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/recent_activity.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const HomeScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: HomeContent(
          onNavigate: onNavigate,
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final Function(int) onNavigate;
  final bool isDarkMode;

  const HomeContent({
    super.key,
    required this.onNavigate,
    required this.isDarkMode,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  void _handleFreeze() {
    widget.onNavigate(1); // CardManagementScreen
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;

    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
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
      } else if (state is ProfileSuccessState) {
        return Column(
          children: [
            WelcomeHeader(
              userName: state.profile?.fullName ?? "User",
              // isFrozen: isCardFrozen,
              // onManageTap: isCardFrozen ? _handleFreeze : null,
              isDarkMode: isDarkMode,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    ShieldStatus(isDarkMode: isDarkMode),
                    const SizedBox(height: 20),
                    VirtualCard(
                      cardNumber: state.profile?.cardNumberHash.toString() ??
                          "**** **** **** 1234",
                      cardHolder:
                          state.profile?.cardHolderName ?? "Card Holder",
                      expiry:
                          state.profile?.formattedExpiry ?? "12/24",                      // balance: cardBalance,
                      // isFrozen: isCardFrozen,
                      isDarkMode: isDarkMode,
                      balance: 0.0,
                    ),
                    const SizedBox(height: 24),
                    QuickActions(
                      onAddTap: () =>
                          widget.onNavigate(4), // AddTransactionScreen
                      onReportTap: () => widget.onNavigate(2), // ReportScreen
                      onDetailsTap: () =>
                          widget.onNavigate(1), // CardDetailsScreen
                      onFreezeTap: _handleFreeze, // CardManagementScreen
                      onManageTap: _handleFreeze,
                      // isCardFrozen: isCardFrozen,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 24),
                    RecentActivity(isDarkMode: isDarkMode),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        );
      } else {
        return Center(
          child: Text("No profile data available"),
        );
      }
    });
  }
}
