import 'env.dart';

class Flavor {
  static String get baseUrl {
    switch (Env.current) {
      case Environment.development:
        return 'https://26d70c194b64.ngrok-free.app/api';
      case Environment.staging:
        return 'https://26d70c194b64.ngrok-free.app/api';
      case Environment.production:
        return 'https://26d70c194b64.ngrok-free.app/api';
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
