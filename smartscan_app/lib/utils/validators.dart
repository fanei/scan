/// 数据验证工具类
class Validators {
  /// 验证 URL
  static bool isValidUrl(String value) {
    try {
      final uri = Uri.parse(value);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// 验证电话号码（简单验证）
  static bool isValidPhone(String value) {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    return phoneRegex.hasMatch(value) && value.length >= 7;
  }

  /// 验证邮箱
  static bool isValidEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  /// 验证是否为空
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// 验证 WiFi SSID
  static bool isValidSSID(String value) {
    return value.isNotEmpty && value.length <= 32;
  }
}
