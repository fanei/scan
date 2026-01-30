/// QR 码类型枚举
enum QRType {
  url,
  text,
  contact,
  wifi,
  phone,
  sms,
  unknown;

  /// 从字符串解析 QRType
  static QRType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'url':
        return QRType.url;
      case 'text':
        return QRType.text;
      case 'contact':
        return QRType.contact;
      case 'wifi':
        return QRType.wifi;
      case 'phone':
        return QRType.phone;
      case 'sms':
        return QRType.sms;
      default:
        return QRType.unknown;
    }
  }

  /// 从内容自动检测类型
  static QRType detectFromContent(String content) {
    if (content.startsWith('http://') || content.startsWith('https://')) {
      return QRType.url;
    } else if (content.startsWith('tel:')) {
      return QRType.phone;
    } else if (content.startsWith('sms:') || content.startsWith('smsto:')) {
      return QRType.sms;
    } else if (content.startsWith('WIFI:')) {
      return QRType.wifi;
    } else if (content.startsWith('BEGIN:VCARD')) {
      return QRType.contact;
    } else {
      return QRType.text;
    }
  }

  /// 获取类型的显示名称
  String get displayName {
    switch (this) {
      case QRType.url:
        return '网址';
      case QRType.text:
        return '文本';
      case QRType.contact:
        return '联系人';
      case QRType.wifi:
        return 'WiFi';
      case QRType.phone:
        return '电话';
      case QRType.sms:
        return '短信';
      case QRType.unknown:
        return '未知';
    }
  }

  /// 获取类型的图标名称
  String get iconName {
    switch (this) {
      case QRType.url:
        return 'link';
      case QRType.text:
        return 'text_fields';
      case QRType.contact:
        return 'person';
      case QRType.wifi:
        return 'wifi';
      case QRType.phone:
        return 'phone';
      case QRType.sms:
        return 'message';
      case QRType.unknown:
        return 'help_outline';
    }
  }
}
