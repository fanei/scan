import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/batch_scan_session.dart';
import '../models/scan_result.dart';

/// 批量扫描服务
/// 
/// 提供批量扫描的核心功能
class BatchScannerService {
  /// 导出为 CSV
  /// 
  /// 返回文件路径
  Future<String> exportToCSV(
    List<ScanResult> results, {
    bool includeHeader = true,
  }) async {
    // 准备 CSV 数据
    final List<List<dynamic>> csvData = [];

    // 添加表头
    if (includeHeader) {
      csvData.add(['序号', '类型', '内容', '扫描时间']);
    }

    // 添加数据行
    for (int i = 0; i < results.length; i++) {
      final result = results[i];
      csvData.add([
        i + 1,
        result.type.displayName,
        result.rawValue,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(result.timestamp),
      ]);
    }

    // 转换为 CSV 字符串
    final csvString = const ListToCsvConverter().convert(csvData);

    // 保存到文件
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'smartscan_batch_$timestamp.csv';
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsString(csvString);

    return filePath;
  }

  /// 导出为 TXT
  /// 
  /// 返回文件路径
  Future<String> exportToTXT(
    List<ScanResult> results, {
    bool includeHeader = true,
    bool includeStatistics = true,
  }) async {
    final buffer = StringBuffer();

    // 添加头部
    if (includeHeader) {
      buffer.writeln('SmartScan 批量扫描结果');
      buffer.writeln('=' * 40);
      buffer.writeln();
    }

    // 添加统计信息
    if (includeStatistics) {
      buffer.writeln('扫描时间：${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}');
      buffer.writeln('总计：${results.length} 条');
      buffer.writeln('-' * 40);
      buffer.writeln();
    }

    // 添加扫描结果
    for (int i = 0; i < results.length; i++) {
      final result = results[i];
      buffer.writeln('${i + 1}. ${result.rawValue}');
      buffer.writeln('   类型: ${result.type.displayName}');
      buffer.writeln('   时间: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(result.timestamp)}');
      buffer.writeln();
    }

    // 保存到文件
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'smartscan_batch_$timestamp.txt';
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsString(buffer.toString());

    return filePath;
  }

  /// 导出为纯文本（仅内容，用于快速复制）
  String exportToPlainText(List<ScanResult> results) {
    return results.map((r) => r.rawValue).join('\n');
  }

  /// 去重
  List<ScanResult> deduplicate(List<ScanResult> results) {
    final seen = <String>{};
    final unique = <ScanResult>[];

    for (final result in results) {
      if (seen.add(result.rawValue)) {
        unique.add(result);
      }
    }

    return unique;
  }

  /// 按类型分组
  Map<String, List<ScanResult>> groupByType(List<ScanResult> results) {
    final Map<String, List<ScanResult>> grouped = {};

    for (final result in results) {
      final typeName = result.type.displayName;
      grouped.putIfAbsent(typeName, () => []);
      grouped[typeName]!.add(result);
    }

    return grouped;
  }

  /// 统计信息
  Map<String, dynamic> getStatistics(List<ScanResult> results) {
    final stats = <String, dynamic>{
      'total': results.length,
      'unique': deduplicate(results).length,
      'byType': <String, int>{},
    };

    // 按类型统计
    for (final result in results) {
      final typeName = result.type.displayName;
      stats['byType'][typeName] = (stats['byType'][typeName] ?? 0) + 1;
    }

    return stats;
  }

  /// 验证是否为有效的批量扫描（至少2条）
  bool isValidBatchScan(BatchScanSession session) {
    return session.totalScans >= 2;
  }

  /// 计算扫描速度（每分钟扫描数）
  double calculateScanSpeed(BatchScanSession session) {
    if (session.durationInSeconds == null || session.durationInSeconds == 0) {
      return 0;
    }
    
    final minutes = session.durationInSeconds! / 60.0;
    return session.totalScans / minutes;
  }

  /// 获取扫描摘要
  String getSummary(BatchScanSession session) {
    final buffer = StringBuffer();
    
    buffer.writeln('扫描总数: ${session.totalScans}');
    buffer.writeln('去重后: ${session.uniqueScans}');
    
    if (session.durationInSeconds != null) {
      buffer.writeln('用时: ${session.durationInSeconds}秒');
      buffer.writeln('速度: ${calculateScanSpeed(session).toStringAsFixed(1)}个/分钟');
    }
    
    return buffer.toString();
  }
}
