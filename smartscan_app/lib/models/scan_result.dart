import 'qr_type.dart';

/// 扫描结果模型
class ScanResult {
  final String rawValue;
  final QRType type;
  final DateTime timestamp;
  final Map<String, dynamic>? parsedData;

  ScanResult({
    required this.rawValue,
    required this.type,
    required this.timestamp,
    this.parsedData,
  });

  /// 获取显示用的摘要文本
  String get displayText {
    if (rawValue.length > 100) {
      return '${rawValue.substring(0, 100)}...';
    }
    return rawValue;
  }

  /// 转换为 Map（用于数据库存储）
  Map<String, dynamic> toMap() {
    return {
      'raw_value': rawValue,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'parsed_data': parsedData?.toString(),
    };
  }

  /// 从 Map 创建实例
  factory ScanResult.fromMap(Map<String, dynamic> map) {
    return ScanResult(
      rawValue: map['raw_value'] as String,
      type: QRType.fromString(map['type'] as String),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      parsedData: null, // TODO: 解析 parsed_data
    );
  }

  @override
  String toString() {
    return 'ScanResult(type: $type, value: ${rawValue.substring(0, rawValue.length > 20 ? 20 : rawValue.length)}...)';
  }
}
