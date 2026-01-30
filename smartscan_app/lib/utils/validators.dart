/// 数据验证工具类
class Validators {
  /// 验证 URL（支持多种协议）
  static bool isValidUrl(String value) {
    if (value.isEmpty) return false;
    
    // 移除首尾空白字符和换行符
    final trimmed = value.trim();
    if (trimmed.isEmpty) return false;
    
    try {
      final uri = Uri.parse(trimmed);
      // 支持常见的 URL 协议
      final validSchemes = ['http', 'https', 'ftp', 'ftps'];
      // 确保有 scheme 且 host 不为空
      return uri.hasScheme && 
             validSchemes.contains(uri.scheme.toLowerCase()) &&
             uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// 验证 HTTP(S) URL（严格模式，仅用于 Web URL）
  static bool isValidHttpUrl(String value) {
    if (value.isEmpty) return false;
    
    try {
      final uri = Uri.parse(value);
      return uri.hasScheme && 
             (uri.scheme == 'http' || uri.scheme == 'https') &&
             uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// 验证电话号码（国际格式支持）
  static bool isValidPhone(String value) {
    if (value.isEmpty) return false;
    
    // 移除所有空格、括号、连字符、换行符
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)\n\r\t]'), '');
    
    // 基本格式验证：可选的 +，后跟数字
    final phoneRegex = RegExp(r'^\+?[\d]{7,15}$');
    return phoneRegex.hasMatch(cleaned);
  }

  /// 验证邮箱
  static bool isValidEmail(String value) {
    if (value.isEmpty) return false;
    
    // 更严格的邮箱验证
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    return emailRegex.hasMatch(value);
  }

  /// 验证是否为空
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// 验证 WiFi SSID
  static bool isValidSSID(String value) {
    // SSID 长度：1-32 字符
    return value.isNotEmpty && value.length <= 32;
  }

  /// 验证 WiFi 密码
  static bool isValidWifiPassword(String value, {bool isOpen = false}) {
    // 开放网络可以没有密码
    if (isOpen) return true;
    
    // WPA/WPA2 密码长度：8-63 字符
    return value.length >= 8 && value.length <= 63;
  }

  /// 验证 vCard 格式
  static bool isValidVCard(String value) {
    if (value.isEmpty) return false;
    
    // 基本的 vCard 结构检查
    return value.contains('BEGIN:VCARD') && 
           value.contains('END:VCARD') &&
           value.contains('FN:'); // 必须有姓名字段
  }
}
