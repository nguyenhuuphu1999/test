import 'env.dart';

class Flavor {
  static String get baseUrl {
    switch (Env.current) {
      case Environment.development:
        // Try localhost first, fallback to ngrok if needed
        return 'http://localhost:3001/api'; // Change this to your backend URL
      case Environment.staging:
        return 'https://d29653d5a8e9.ngrok-free.app/api';
      case Environment.production:
        return 'https://d29653d5a8e9.ngrok-free.app/api';
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

  static bool get isDevelopment => Env.current == Environment.development;
  static bool get isStaging => Env.current == Environment.staging;
  static bool get isProduction => Env.current == Environment.production;
}
