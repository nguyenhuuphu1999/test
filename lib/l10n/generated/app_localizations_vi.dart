// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'VPNCN2';

  @override
  String get welcomeTitle => 'Mang Bạn Đến Internet Tự Do';

  @override
  String get welcomeSubtitle => 'Với đường hầm VPN được mã hóa, dữ liệu của bạn luôn an toàn, ngay cả trên mạng công cộng hoặc không tin cậy.';

  @override
  String get createAccount => 'Tạo Tài Khoản';

  @override
  String get signIn => 'Đăng Nhập';

  @override
  String get helloAgain => 'Xin Chào!';

  @override
  String get welcomeBack => 'Chào mừng bạn quay lại, chúng tôi nhớ bạn!';

  @override
  String get usernameOrEmail => 'Tên người dùng hoặc Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get forgetPassword => 'Quên mật khẩu?';

  @override
  String get dontHaveAccount => 'Chưa có tài khoản?';

  @override
  String get signUp => 'Đăng Ký';

  @override
  String get registerTitle => 'ĐĂNG KÝ TÀI KHOẢN MỚI';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get userName => 'Tên đăng nhập';

  @override
  String get email => 'Email';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get register => 'Đăng ký';

  @override
  String get haveAccount => 'Đã có tài khoản?';

  @override
  String get forgotTitle => 'Quên Mật Khẩu';

  @override
  String get forgotSubtitle => 'Nhập email để nhận liên kết đặt lại.';

  @override
  String get sendResetLink => 'Gửi Liên Kết Đặt Lại';

  @override
  String get resetTitle => 'Đặt Lại Mật Khẩu';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get confirmNewPassword => 'Xác nhận mật khẩu mới';

  @override
  String get updatePassword => 'Cập Nhật Mật Khẩu';

  @override
  String get home => 'Trang chủ';

  @override
  String hiUser(Object name) {
    return 'Chào, $name';
  }

  @override
  String get payment => 'Thanh toán';

  @override
  String get faq => 'Hỏi đáp';

  @override
  String get buy => 'Mua';

  @override
  String get searchYourKey => 'Tìm khóa của bạn';

  @override
  String get connect => 'Kết nối';

  @override
  String remainDays(Object days) {
    return 'Còn lại: $days ngày';
  }

  @override
  String get expired => 'Hết hạn';
}
