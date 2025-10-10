// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'VPNCN2';

  @override
  String get welcomeTitle => 'Bring You To Freedom Internet';

  @override
  String get welcomeSubtitle => 'With Our Encrypted VPN Tunnel, Your Data Stay Safe, Even Over Public Or Untrusted Internet Connections.';

  @override
  String get createAccount => 'Create An Account';

  @override
  String get signIn => 'Sign In';

  @override
  String get helloAgain => 'Hello Again!';

  @override
  String get welcomeBack => 'Wellcome Back You\'ve Been Missed!';

  @override
  String get usernameOrEmail => 'User Name Or Email';

  @override
  String get password => 'Password';

  @override
  String get forgetPassword => 'Forget Your Password?';

  @override
  String get dontHaveAccount => 'Don\'t Have An Account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get registerTitle => 'REGISTER NEW ACCOUNT';

  @override
  String get fullName => 'Full name';

  @override
  String get userName => 'User name';

  @override
  String get email => 'Email';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get register => 'Register';

  @override
  String get haveAccount => 'Have An Account?';

  @override
  String get forgotTitle => 'Forgot Password';

  @override
  String get forgotSubtitle => 'Enter your email to receive a reset link.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get resetTitle => 'Reset Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get updatePassword => 'Update Password';

  @override
  String get home => 'Home';

  @override
  String hiUser(Object name) {
    return 'Hi, $name';
  }

  @override
  String get payment => 'Payment';

  @override
  String get faq => 'FAQ';

  @override
  String get buy => 'Buy';

  @override
  String get searchYourKey => 'Search your key';

  @override
  String get connect => 'Connect';

  @override
  String remainDays(Object days) {
    return 'Remain: $days Days';
  }

  @override
  String get expired => 'Expired';
}
