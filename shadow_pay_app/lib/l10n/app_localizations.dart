import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Shadow Pay'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @freeze_card.
  ///
  /// In en, this message translates to:
  /// **'Freeze Card'**
  String get freeze_card;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello, Welcome!'**
  String get welcomeMessage;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login Successfully'**
  String get loginSuccess;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 2'**
  String get step;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @passwordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordShort;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhone;

  /// No description provided for @invalidCard.
  ///
  /// In en, this message translates to:
  /// **'Invalid card number'**
  String get invalidCard;

  /// No description provided for @invalidExpiry.
  ///
  /// In en, this message translates to:
  /// **'Invalid expiry format'**
  String get invalidExpiry;

  /// No description provided for @nameShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get nameShort;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone number linked with your card'**
  String get phone;

  /// No description provided for @cardHolder.
  ///
  /// In en, this message translates to:
  /// **'Card holder name'**
  String get cardHolder;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get cardNumber;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @invalidMonth.
  ///
  /// In en, this message translates to:
  /// **'Invalid month'**
  String get invalidMonth;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get accountCreated;

  /// No description provided for @stepTwo.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 2'**
  String get stepTwo;

  /// No description provided for @paymentInfo.
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get paymentInfo;

  /// No description provided for @enterFirstAndLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter first and last name separated by a space'**
  String get enterFirstAndLastName;

  /// No description provided for @eachNamePartMustBeAtLeast3Chars.
  ///
  /// In en, this message translates to:
  /// **'Each part of the name must be at least 3 characters'**
  String get eachNamePartMustBeAtLeast3Chars;

  /// No description provided for @pleaseEnterExactlyTwoNames.
  ///
  /// In en, this message translates to:
  /// **'Please enter exactly two names (first name and last name)'**
  String get pleaseEnterExactlyTwoNames;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get backToLogin;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @cardExpired.
  ///
  /// In en, this message translates to:
  /// **'Your card has been expired'**
  String get cardExpired;

  /// No description provided for @cardNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Card holder name must be at least 3 characters'**
  String get cardNameTooShort;

  /// No description provided for @cardNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Card holder name must contain only letters'**
  String get cardNameInvalid;

  /// No description provided for @phoneDigitsOnly.
  ///
  /// In en, this message translates to:
  /// **'Phone number must contain only digits'**
  String get phoneDigitsOnly;

  /// No description provided for @phoneInvalidLength.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number (incorrect length)'**
  String get phoneInvalidLength;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @enterEmailResetCode.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a reset code'**
  String get enterEmailResetCode;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailHint;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @enter6DigitCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6 digit code sent to your email'**
  String get enter6DigitCode;

  /// No description provided for @enterCompleteCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete 6-digit code'**
  String get enterCompleteCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password Reset Successfully'**
  String get passwordResetSuccess;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordButton;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get loginError;

  /// No description provided for @add_transaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get add_transaction;

  /// No description provided for @enter_transaction_details.
  ///
  /// In en, this message translates to:
  /// **'Enter Transaction Details:'**
  String get enter_transaction_details;

  /// No description provided for @transaction_amount.
  ///
  /// In en, this message translates to:
  /// **'Transaction Amount'**
  String get transaction_amount;

  /// No description provided for @amount_hint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get amount_hint;

  /// No description provided for @transaction_hour.
  ///
  /// In en, this message translates to:
  /// **'Transaction Hour (0–23)'**
  String get transaction_hour;

  /// No description provided for @transaction_category.
  ///
  /// In en, this message translates to:
  /// **'Transaction Category'**
  String get transaction_category;

  /// No description provided for @category_hint.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get category_hint;

  /// No description provided for @zip_code.
  ///
  /// In en, this message translates to:
  /// **'Zip Code '**
  String get zip_code;

  /// No description provided for @zip_code_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter zip code'**
  String get zip_code_hint;

  /// No description provided for @analyze_transaction.
  ///
  /// In en, this message translates to:
  /// **'Analyze Transaction'**
  String get analyze_transaction;

  /// No description provided for @transaction_added_success.
  ///
  /// In en, this message translates to:
  /// **'Transaction added successfully!'**
  String get transaction_added_success;

  /// No description provided for @error_category.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get error_category;

  /// No description provided for @error_amount_empty.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get error_amount_empty;

  /// No description provided for @error_amount_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get error_amount_invalid;

  /// No description provided for @error_zip_invalid.
  ///
  /// In en, this message translates to:
  /// **'ZIP code must contain only numbers'**
  String get error_zip_invalid;

  /// No description provided for @error_amount_zero.
  ///
  /// In en, this message translates to:
  /// **'Amount cannot be zero'**
  String get error_amount_zero;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @premium_member.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get premium_member;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logout_confirmation;

  /// No description provided for @personal_info.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_info;

  /// No description provided for @copied_to_clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copied_to_clipboard;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @whatWouldYouLikeToReport.
  ///
  /// In en, this message translates to:
  /// **'What Would You Like To Report ?'**
  String get whatWouldYouLikeToReport;

  /// No description provided for @selectReason.
  ///
  /// In en, this message translates to:
  /// **'Please select a reason'**
  String get selectReason;

  /// No description provided for @describeIssue.
  ///
  /// In en, this message translates to:
  /// **'Please describe the issue'**
  String get describeIssue;

  /// No description provided for @describeIssueHint.
  ///
  /// In en, this message translates to:
  /// **'Please describe your issue in detail...'**
  String get describeIssueHint;

  /// No description provided for @submitReport.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submitReport;

  /// No description provided for @reportSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Report submitted successfully!'**
  String get reportSubmitted;

  /// No description provided for @suspiciousTransaction.
  ///
  /// In en, this message translates to:
  /// **'Suspicious Transaction'**
  String get suspiciousTransaction;

  /// No description provided for @suspiciousTransactionDesc.
  ///
  /// In en, this message translates to:
  /// **'A transaction you don\'t recognize or seems unusual'**
  String get suspiciousTransactionDesc;

  /// No description provided for @cardLostStolen.
  ///
  /// In en, this message translates to:
  /// **'Card Lost or Stolen'**
  String get cardLostStolen;

  /// No description provided for @cardLostStolenDesc.
  ///
  /// In en, this message translates to:
  /// **'My card has been lost, stolen, or I suspect it\'s compromised'**
  String get cardLostStolenDesc;

  /// No description provided for @unauthorizedCharge.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized Charge'**
  String get unauthorizedCharge;

  /// No description provided for @unauthorizedChargeDesc.
  ///
  /// In en, this message translates to:
  /// **'A charge I did not authorize or approve'**
  String get unauthorizedChargeDesc;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @otherDesc.
  ///
  /// In en, this message translates to:
  /// **'Other issue not listed above'**
  String get otherDesc;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cards;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @freeze.
  ///
  /// In en, this message translates to:
  /// **'Freeze'**
  String get freeze;

  /// No description provided for @frozen.
  ///
  /// In en, this message translates to:
  /// **'Frozen'**
  String get frozen;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @safe.
  ///
  /// In en, this message translates to:
  /// **'Safe Transaction'**
  String get safe;

  /// No description provided for @risk.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get risk;

  /// No description provided for @blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blocked;

  /// No description provided for @expiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get expiry;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @aiWatchdogActive.
  ///
  /// In en, this message translates to:
  /// **'AI Watchdog Active'**
  String get aiWatchdogActive;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @liveProtection.
  ///
  /// In en, this message translates to:
  /// **'Live protection monitoring all transactions'**
  String get liveProtection;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your preferences and account'**
  String get settingsSubtitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive instant alerts about transactions'**
  String get pushNotificationsDesc;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @emailNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive reports and updates via email'**
  String get emailNotificationsDesc;

  /// No description provided for @sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @smsDesc.
  ///
  /// In en, this message translates to:
  /// **'Critical transaction alerts'**
  String get smsDesc;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @soundDesc.
  ///
  /// In en, this message translates to:
  /// **'Play notification sound'**
  String get soundDesc;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @vibrationDesc.
  ///
  /// In en, this message translates to:
  /// **'Vibrate device on notifications'**
  String get vibrationDesc;

  /// No description provided for @securityPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Security & Privacy'**
  String get securityPrivacy;

  /// No description provided for @biometric.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometric;

  /// No description provided for @biometricDesc.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint or face recognition'**
  String get biometricDesc;

  /// No description provided for @twoFA.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication (2FA)'**
  String get twoFA;

  /// No description provided for @twoFADesc.
  ///
  /// In en, this message translates to:
  /// **'Extra protection for your account'**
  String get twoFADesc;

  /// No description provided for @autoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto Lock'**
  String get autoLock;

  /// No description provided for @autoLockDesc.
  ///
  /// In en, this message translates to:
  /// **'Lock app when not in use'**
  String get autoLockDesc;

  /// No description provided for @hideBalance.
  ///
  /// In en, this message translates to:
  /// **'Hide Balance'**
  String get hideBalance;

  /// No description provided for @hideBalanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Hide balances on home screen'**
  String get hideBalanceDesc;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @supportInfo.
  ///
  /// In en, this message translates to:
  /// **'Support & Info'**
  String get supportInfo;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @securedByAI.
  ///
  /// In en, this message translates to:
  /// **'AI Protected'**
  String get securedByAI;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutDialogMessage;

  /// No description provided for @deleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteDialogTitle;

  /// No description provided for @deleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? This action cannot be undone'**
  String get deleteDialogMessage;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cardManagement.
  ///
  /// In en, this message translates to:
  /// **'Card Management'**
  String get cardManagement;

  /// No description provided for @cardManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control your cards and security'**
  String get cardManagementSubtitle;

  /// No description provided for @cardFrozen.
  ///
  /// In en, this message translates to:
  /// **'Card Frozen'**
  String get cardFrozen;

  /// No description provided for @cardActive.
  ///
  /// In en, this message translates to:
  /// **'Card Active'**
  String get cardActive;

  /// No description provided for @cardFrozenDesc.
  ///
  /// In en, this message translates to:
  /// **'All transactions are temporarily suspended'**
  String get cardFrozenDesc;

  /// No description provided for @cardActiveDesc.
  ///
  /// In en, this message translates to:
  /// **'You can perform transactions normally'**
  String get cardActiveDesc;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available Balance'**
  String get availableBalance;

  /// No description provided for @cardNumberMasked.
  ///
  /// In en, this message translates to:
  /// **'****  ****  ****  4829'**
  String get cardNumberMasked;

  /// No description provided for @cardHolderName.
  ///
  /// In en, this message translates to:
  /// **'Card Holder'**
  String get cardHolderName;

  /// No description provided for @cardHolderValue.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Al-Sayed'**
  String get cardHolderValue;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @expiryDateValue.
  ///
  /// In en, this message translates to:
  /// **'12/28'**
  String get expiryDateValue;

  /// No description provided for @cardDetails.
  ///
  /// In en, this message translates to:
  /// **'Card Details'**
  String get cardDetails;

  /// No description provided for @cardType.
  ///
  /// In en, this message translates to:
  /// **'Card Type'**
  String get cardType;

  /// No description provided for @cardTypeValue.
  ///
  /// In en, this message translates to:
  /// **'Visa Platinum'**
  String get cardTypeValue;

  /// No description provided for @issueDate.
  ///
  /// In en, this message translates to:
  /// **'Issue Date'**
  String get issueDate;

  /// No description provided for @issueDateValue.
  ///
  /// In en, this message translates to:
  /// **'12/2023'**
  String get issueDateValue;

  /// No description provided for @freezeCard.
  ///
  /// In en, this message translates to:
  /// **'Freeze Card'**
  String get freezeCard;

  /// No description provided for @unfreezeCard.
  ///
  /// In en, this message translates to:
  /// **'Unfreeze Card'**
  String get unfreezeCard;

  /// No description provided for @aboutFreeze.
  ///
  /// In en, this message translates to:
  /// **'About Freezing Card'**
  String get aboutFreeze;

  /// No description provided for @freezeInfo1.
  ///
  /// In en, this message translates to:
  /// **'Freezing the card immediately blocks all transactions'**
  String get freezeInfo1;

  /// No description provided for @freezeInfo2.
  ///
  /// In en, this message translates to:
  /// **'You can unfreeze at any time to restore normal usage'**
  String get freezeInfo2;

  /// No description provided for @freezeInfo3.
  ///
  /// In en, this message translates to:
  /// **'AI automatically freezes high-risk transactions'**
  String get freezeInfo3;

  /// No description provided for @cardFrozenSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Card Frozen'**
  String get cardFrozenSnackbar;

  /// No description provided for @cardUnfrozenSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Card Unfrozen'**
  String get cardUnfrozenSnackbar;

  /// No description provided for @fullControl.
  ///
  /// In en, this message translates to:
  /// **'Full Control'**
  String get fullControl;

  /// No description provided for @advancedAI.
  ///
  /// In en, this message translates to:
  /// **'Advanced AI'**
  String get advancedAI;

  /// No description provided for @freeze_detail_message.
  ///
  /// In en, this message translates to:
  /// **'When you freeze your card, all purchases and instant withdrawals are stopped immediately to protect your money. You can unfreeze with one tap when you need to use it.\n\nRecurring scheduled payments are not affected by freezing.'**
  String get freeze_detail_message;

  /// No description provided for @full_control_detail_message.
  ///
  /// In en, this message translates to:
  /// **'Full control of your card is in your hands.\n\n• Freeze or unfreeze it anytime\n• Do it from anywhere through the app\n• Absolute security with ease of use\n• Instant notifications for every change'**
  String get full_control_detail_message;

  /// No description provided for @advanced_ai_detail_message.
  ///
  /// In en, this message translates to:
  /// **'Advanced AI system:\n\n• Analyzes your transaction patterns in real-time\n• Detects any unusual or high-risk activity\n• Automatically freezes your card to protect you from fraud\n• Learns from your financial habits to improve accuracy'**
  String get advanced_ai_detail_message;

  /// No description provided for @securityControlCenter.
  ///
  /// In en, this message translates to:
  /// **'Security Control Center'**
  String get securityControlCenter;

  /// No description provided for @securityControlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced card protection features'**
  String get securityControlSubtitle;

  /// No description provided for @cardStyle.
  ///
  /// In en, this message translates to:
  /// **'Card Style'**
  String get cardStyle;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @allTransactions.
  ///
  /// In en, this message translates to:
  /// **'All Transactions'**
  String get allTransactions;

  /// No description provided for @numTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get numTransactions;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @transactionsCount.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsCount;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a transaction....'**
  String get searchHint;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @fraud.
  ///
  /// In en, this message translates to:
  /// **'Fraud'**
  String get fraud;

  /// No description provided for @restaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurant;

  /// No description provided for @flightTicket.
  ///
  /// In en, this message translates to:
  /// **'Flight Ticket'**
  String get flightTicket;

  /// No description provided for @gym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get gym;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'%'**
  String get percentage;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateTime;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No Transactions Yet!!'**
  String get noTransactionsYet;

  /// No description provided for @startAddingTransactions.
  ///
  /// In en, this message translates to:
  /// **'Start adding your first transaction'**
  String get startAddingTransactions;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @risk_analysis_title.
  ///
  /// In en, this message translates to:
  /// **'Risk Analysis'**
  String get risk_analysis_title;

  /// No description provided for @transaction_details.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transaction_details;

  /// No description provided for @detection_mode_label.
  ///
  /// In en, this message translates to:
  /// **'Detection Mode'**
  String get detection_mode_label;

  /// No description provided for @detection_mode_description.
  ///
  /// In en, this message translates to:
  /// **'Your transaction was analyzed using security standards'**
  String get detection_mode_description;

  /// No description provided for @amount_label.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount_label;

  /// No description provided for @hour_label.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hour_label;

  /// No description provided for @category_label.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category_label;

  /// No description provided for @zip_code_label.
  ///
  /// In en, this message translates to:
  /// **'Zip Code'**
  String get zip_code_label;

  /// No description provided for @back_to_home.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get back_to_home;

  /// No description provided for @high_risk.
  ///
  /// In en, this message translates to:
  /// **'High Risk'**
  String get high_risk;

  /// No description provided for @medium_risk.
  ///
  /// In en, this message translates to:
  /// **'Medium Risk'**
  String get medium_risk;

  /// No description provided for @low_risk.
  ///
  /// In en, this message translates to:
  /// **'Low Risk'**
  String get low_risk;

  /// No description provided for @fraudulent.
  ///
  /// In en, this message translates to:
  /// **'Fraudulent Transaction'**
  String get fraudulent;

  /// No description provided for @passwordLowercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get passwordLowercase;

  /// No description provided for @passwordUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get passwordUppercase;

  /// No description provided for @passwordNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get passwordNumber;

  /// No description provided for @passwordSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character (@\$!%*?&)'**
  String get passwordSpecialChar;

  /// No description provided for @passwordComplexity.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters and contain uppercase, lowercase, number and special character'**
  String get passwordComplexity;

  /// No description provided for @this_month.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get this_month;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @settings_privacy.
  ///
  /// In en, this message translates to:
  /// **'Settings & Privacy'**
  String get settings_privacy;

  /// No description provided for @logout_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout_dialog_title;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
