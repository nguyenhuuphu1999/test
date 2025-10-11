import 'env.dart';

class Flavor {
  static String get baseUrl {
    switch (Env.current) {
      case Environment.development:
        return 'https://api.vpncn2.net/api';
      case Environment.staging:
        return 'https://staging-api.vpncn2.com/api';
      case Environment.production:
        return 'https://api.vpncn2.net/api';
    }
  }

  static String get appName {
    switch (Env.current) {
      case Environment.development:
        return 'VPNCN2 Dev';
      case Environment.staging:
        return 'VPNCN2 Staging';
      case Environment.production:
        return 'VPNCN2';
    }
  }

  static bool get enableLogging {
    switch (Env.current) {
      case Environment.development:
      case Environment.staging:
        return true;
      case Environment.production:
        return false;
    }
  }
}
