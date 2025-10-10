// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'VPNCN2';

  @override
  String get welcomeTitle => '带你畅游自由互联网';

  @override
  String get welcomeSubtitle => '通过加密的 VPN 隧道，即使在公共或不受信任的网络上，你的数据也能保持安全。';

  @override
  String get createAccount => '创建账户';

  @override
  String get signIn => '登录';

  @override
  String get helloAgain => '欢迎回来！';

  @override
  String get welcomeBack => '很想你，欢迎再次使用！';

  @override
  String get usernameOrEmail => '用户名或邮箱';

  @override
  String get password => '密码';

  @override
  String get forgetPassword => '忘记密码？';

  @override
  String get dontHaveAccount => '还没有账号？';

  @override
  String get signUp => '注册';

  @override
  String get registerTitle => '注册新账户';

  @override
  String get fullName => '全名';

  @override
  String get userName => '用户名';

  @override
  String get email => '邮箱';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get register => '注册';

  @override
  String get haveAccount => '已有账号？';

  @override
  String get forgotTitle => '找回密码';

  @override
  String get forgotSubtitle => '输入邮箱以接收重置链接。';

  @override
  String get sendResetLink => '发送重置链接';

  @override
  String get resetTitle => '重置密码';

  @override
  String get newPassword => '新密码';

  @override
  String get confirmNewPassword => '确认新密码';

  @override
  String get updatePassword => '更新密码';

  @override
  String get home => '首页';

  @override
  String hiUser(Object name) {
    return '你好，$name';
  }

  @override
  String get payment => '支付';

  @override
  String get faq => '帮助';

  @override
  String get buy => '购买';

  @override
  String get searchYourKey => '搜索你的密钥';

  @override
  String get connect => '连接';

  @override
  String remainDays(Object days) {
    return '剩余：$days 天';
  }

  @override
  String get expired => '已过期';
}
