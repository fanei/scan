import 'dart:convert';
import 'qr_type.dart';

/// 历史记录项模型
class HistoryItem {
  final int id;
  final QRType type;
  final String content;
  final Map<String, dynamic>? formattedContent;
  final DateTime scanTime;
  final String? previewImagePath;

  HistoryItem({
    required this.id,
    required this.type,
    required this.content,
    this.formattedContent,
    required this.scanTime,
    this.previewImagePath,
  });

  /// 获取显示用的摘要
  String get displaySummary {
    if (content.length > 50) {
      return '${content.substring(0, 50)}...';
    }
    return content;
  }

  /// 转换为 Map（用于数据库存储）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'content': content,
      'formatted_content': formattedContent != null ? jsonEncode(formattedContent) : null,
      'scan_time': scanTime.millisecondsSinceEpoch ~/ 1000,
      'preview_image_path': previewImagePath,
    };
  }

  /// 从 Map 创建实例
  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id'] as int,
      type: QRType.fromString(map['type'] as String),
      content: map['content'] as String,
      formattedContent: map['formatted_content'] != null
          ? jsonDecode(map['formatted_content'] as String) as Map<String, dynamic>
          : null,
      scanTime: DateTime.fromMillisecondsSinceEpoch((map['scan_time'] as int) * 1000),
      previewImagePath: map['preview_image_path'] as String?,
    );
  }

  /// 创建副本
  HistoryItem copyWith({
    int? id,
    QRType? type,
    String? content,
    Map<String, dynamic>? formattedContent,
    DateTime? scanTime,
    String? previewImagePath,
  }) {
    return HistoryItem(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      formattedContent: formattedContent ?? this.formattedContent,
      scanTime: scanTime ?? this.scanTime,
      previewImagePath: previewImagePath ?? this.previewImagePath,
    );
  }

  @override
  String toString() {
    return 'HistoryItem(id: $id, type: $type, content: ${content.substring(0, content.length > 20 ? 20 : content.length)}...)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HistoryItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
