import 'package:flutter/material.dart';

class LanguageMapper {
  static const Map<String, String> _languageMap = {
    'vi': 'Vietnamese',
    'en': 'English',
    'zh': 'Chinese',
    'ja': 'Japanese',
    'ko': 'Korean',
    'th': 'Thai',
    'id': 'Indonesian',
    'ms': 'Malay',
    'tl': 'Filipino',
  };

  static String getCurrentLanguage(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return _languageMap[locale.languageCode] ?? 'English';
  }

  static String getLanguageCode(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode;
  }

  static bool isVietnamese(BuildContext context) {
    return getLanguageCode(context) == 'vi';
  }

  static bool isEnglish(BuildContext context) {
    return getLanguageCode(context) == 'en';
  }

  static bool isChinese(BuildContext context) {
    return getLanguageCode(context) == 'zh';
  }

  static String getLocalizedFeature(String feature, BuildContext context) {
    final languageCode = getLanguageCode(context);

    // Feature mapping based on language
    final featureMap = {
      'vi': {
        '365 days premium VPN': 'Sử dụng trong 365 ngày',
        'Saving 40%': 'Tiết kiệm 40%',
        'Unlimited devices': 'Không giới hạn thiết bị',
        'Capacity 150GB/30days': 'Dung lượng 150GB/tháng',
        'Able to extend bandwith by automatically':
            'Có thể nâng cấp dung lượng gói',
        '24/7 support': 'Hỗ trợ 24/7',
      },
      'zh': {
        '365 days premium VPN': '使用365天',
        'Saving 40%': '节约40%',
        'Unlimited devices': '无限制设备的数量',
        'Capacity 150GB/30days': '流量150GB/30天',
        'Able to extend bandwith by automatically': '套餐容量可升级',
        '24/7 support': '24/7 支持',
      },
    };

    return featureMap[languageCode]?[feature] ?? feature;
  }

  static String getLocalizedText(String key, BuildContext context) {
    final languageCode = getLanguageCode(context);

    final textMap = {
      'vi': {
        'Choose Your Plan': 'Chọn Gói Của Bạn',
        'Select Payment Method': 'Chọn Phương Thức Thanh Toán',
        'Proceed to Payment': 'Tiến Hành Thanh Toán',
        'Select Plan': 'Chọn Gói',
        'Selected': 'Đã Chọn',
        'more': 'thêm',
        'hide': 'ẩn',
        'people purchased': 'người đã mua',
        'Features': 'Tính năng',
        'Please select a plan first': 'Vui lòng chọn gói trước',
        'Please select a payment method first':
            'Vui lòng chọn phương thức thanh toán trước',
      },
      'zh': {
        'Choose Your Plan': '选择您的计划',
        'Select Payment Method': '选择付款方式',
        'Proceed to Payment': '进行付款',
        'Select Plan': '选择计划',
        'Selected': '已选择',
        'more': '更多',
        'hide': '隐藏',
        'people purchased': '人已购买',
        'Features': '功能',
        'Please select a plan first': '请先选择一个计划',
        'Please select a payment method first': '请先选择付款方式',
      },
    };

    return textMap[languageCode]?[key] ?? key;
  }
}
