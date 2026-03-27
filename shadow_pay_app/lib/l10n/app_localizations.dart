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
  /// **'Login successful! Welcome back.'**
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
  /// **'Phone'**
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

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

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

  String get welcomeBack;
String get aiWatchdogActive;
String get system;
String get liveProtection;
String get expiry;
String get quickActions;
String get add;
String get details;
String get freeze;
String get recentActivity;
String get safe;
String get risk;
String get blocked;

String get balance;



// ========== Quick Actions Screens ==========
String get addTransaction;
String get addTransactionDesc;
String get detailsDesc;
String get freezeCard;
String get freezeCardDesc;
String get report;


// Report Screen
String get whatWouldYouLikeToReport;
String get suspiciousTransaction;
String get suspiciousTransactionDesc;
String get cardLostStolen;
String get cardLostStolenDesc;
String get unauthorizedCharge;
String get unauthorizedChargeDesc;
String get other;
String get otherDesc;
String get selectReason;
String get describeIssue;
String get describeIssueHint;
String get submitReport;
String get reportSubmitted;

// Bottom Navigation Bar
String get analytics;
String get cards;
String get profile;

// Quick Actions
String get frozen;

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
