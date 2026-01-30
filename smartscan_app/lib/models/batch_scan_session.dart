import 'package:uuid/uuid.dart';
import 'scan_result.dart';

/// 批量扫描会话
/// 
/// 记录一次批量扫描的所有信息
class BatchScanSession {
  /// 会话 ID
  final String id;

  /// 开始时间
  final DateTime startTime;

  /// 结束时间
  DateTime? endTime;

  /// 扫描结果列表
  final List<ScanResult> results;

  /// 启用去重
  bool enableDeduplicate;

  /// 构造函数
  BatchScanSession({
    String? id,
    DateTime? startTime,
    this.endTime,
    List<ScanResult>? results,
    this.enableDeduplicate = true,
  })  : id = id ?? const Uuid().v4(),
        startTime = startTime ?? DateTime.now(),
        results = results ?? [];

  /// 总扫描次数
  int get totalScans => results.length;

  /// 去重后数量
  int get uniqueScans {
    if (!enableDeduplicate) return totalScans;
    
    final uniqueValues = <String>{};
    for (final result in results) {
      uniqueValues.add(result.rawValue);
    }
    return uniqueValues.length;
  }

  /// 获取去重后的结果
  List<ScanResult> get deduplicatedResults {
    if (!enableDeduplicate) return results;
    
    final seen = <String>{};
    final unique = <ScanResult>[];
    
    for (final result in results) {
      if (seen.add(result.rawValue)) {
        unique.add(result);
      }
    }
    
    return unique;
  }

  /// 添加扫描结果
  void addResult(ScanResult result) {
    results.add(result);
  }

  /// 清空结果
  void clearResults() {
    results.clear();
  }

  /// 检查是否重复
  bool isDuplicate(String rawValue) {
    return results.any((r) => r.rawValue == rawValue);
  }

  /// 结束会话
  void endSession() {
    endTime = DateTime.now();
  }

  /// 会话持续时间（秒）
  int? get durationInSeconds {
    if (endTime == null) return null;
    return endTime!.difference(startTime).inSeconds;
  }

  /// 复制
  BatchScanSession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    List<ScanResult>? results,
    bool? enableDeduplicate,
  }) {
    return BatchScanSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      results: results ?? List.from(this.results),
      enableDeduplicate: enableDeduplicate ?? this.enableDeduplicate,
    );
  }

  /// 转换为 Map（用于序列化）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'results': results.map((r) => r.toMap()).toList(),
      'enableDeduplicate': enableDeduplicate,
    };
  }

  /// 从 Map 创建（用于反序列化）
  factory BatchScanSession.fromMap(Map<String, dynamic> map) {
    return BatchScanSession(
      id: map['id'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: map['endTime'] != null 
          ? DateTime.parse(map['endTime'] as String) 
          : null,
      results: (map['results'] as List?)
          ?.map((r) => ScanResult.fromMap(r as Map<String, dynamic>))
          .toList(),
      enableDeduplicate: map['enableDeduplicate'] as bool? ?? true,
    );
  }
}
