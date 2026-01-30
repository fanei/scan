import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/batch_scan_session.dart';
import '../models/scan_result.dart';
import '../services/batch_scanner_service.dart';
import '../services/scanner_service.dart';

/// 批量扫描状态管理
class BatchScanProvider extends ChangeNotifier {
  final BatchScannerService _batchService = BatchScannerService();
  final ScannerService _scannerService = ScannerService();

  BatchScanSession? _currentSession;
  bool _isScanning = false;
  String? _errorMessage;

  /// 获取当前会话
  BatchScanSession? get currentSession => _currentSession;

  /// 是否正在扫描
  bool get isScanning => _isScanning;

  /// 错误消息
  String? get errorMessage => _errorMessage;

  /// 是否启用去重
  bool get enableDeduplicate => _currentSession?.enableDeduplicate ?? true;

  /// 扫描结果列表
  List<ScanResult> get results => _currentSession?.results ?? [];

  /// 去重后的结果
  List<ScanResult> get deduplicatedResults => 
      _currentSession?.deduplicatedResults ?? [];

  /// 总扫描数
  int get totalScans => _currentSession?.totalScans ?? 0;

  /// 去重后数量
  int get uniqueScans => _currentSession?.uniqueScans ?? 0;

  /// 开始批量扫描
  Future<void> startBatchScan() async {
    try {
      _errorMessage = null;
      
      // 创建新会话
      _currentSession = BatchScanSession();
      _isScanning = true;
      
      // 初始化扫描器
      await _scannerService.initialize();
      
      // 确保 controller 已初始化
      if (_scannerService.controller == null) {
        throw Exception('扫描器初始化失败');
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isScanning = false;
      notifyListeners();
    }
  }

  /// 停止批量扫描
  void stopBatchScan() {
    _currentSession?.endSession();
    _isScanning = false;
    notifyListeners();
  }

  /// 添加扫描结果
  Future<bool> addResult(ScanResult result) async {
    if (_currentSession == null) return false;

    // 检查是否重复
    if (enableDeduplicate && _currentSession!.isDuplicate(result.rawValue)) {
      return false; // 重复，不添加
    }

    _currentSession!.addResult(result);
    notifyListeners();
    return true; // 成功添加
  }

  /// 切换去重设置
  void toggleDeduplicate() {
    if (_currentSession != null) {
      _currentSession!.enableDeduplicate = !_currentSession!.enableDeduplicate;
      notifyListeners();
    }
  }

  /// 清空结果
  void clearResults() {
    _currentSession?.clearResults();
    notifyListeners();
  }

  /// 删除指定结果
  void removeResult(int index) {
    if (_currentSession != null && index < _currentSession!.results.length) {
      _currentSession!.results.removeAt(index);
      notifyListeners();
    }
  }

  /// 导出为 CSV
  Future<String?> exportToCSV() async {
    if (_currentSession == null || _currentSession!.results.isEmpty) {
      _errorMessage = '没有可导出的数据';
      notifyListeners();
      return null;
    }

    try {
      final filePath = await _batchService.exportToCSV(
        enableDeduplicate ? deduplicatedResults : results,
      );
      return filePath;
    } catch (e) {
      _errorMessage = '导出失败: $e';
      notifyListeners();
      return null;
    }
  }

  /// 导出为 TXT
  Future<String?> exportToTXT() async {
    if (_currentSession == null || _currentSession!.results.isEmpty) {
      _errorMessage = '没有可导出的数据';
      notifyListeners();
      return null;
    }

    try {
      final filePath = await _batchService.exportToTXT(
        enableDeduplicate ? deduplicatedResults : results,
      );
      return filePath;
    } catch (e) {
      _errorMessage = '导出失败: $e';
      notifyListeners();
      return null;
    }
  }

  /// 分享结果（纯文本）
  Future<void> shareResults() async {
    if (_currentSession == null || _currentSession!.results.isEmpty) {
      _errorMessage = '没有可分享的数据';
      notifyListeners();
      return;
    }

    try {
      final text = _batchService.exportToPlainText(
        enableDeduplicate ? deduplicatedResults : results,
      );
      await Share.share(
        text,
        subject: 'SmartScan 批量扫描结果',
      );
    } catch (e) {
      _errorMessage = '分享失败: $e';
      notifyListeners();
    }
  }

  /// 分享文件
  Future<void> shareFile(String filePath) async {
    try {
      await Share.shareXFiles([XFile(filePath)]);
    } catch (e) {
      _errorMessage = '分享失败: $e';
      notifyListeners();
    }
  }

  /// 获取统计信息
  Map<String, dynamic> getStatistics() {
    if (_currentSession == null) return {};
    return _batchService.getStatistics(results);
  }

  /// 获取摘要
  String getSummary() {
    if (_currentSession == null) return '';
    return _batchService.getSummary(_currentSession!);
  }

  /// 清除错误消息
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// 重置（清空所有数据）
  void reset() {
    _currentSession = null;
    _isScanning = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// 获取扫描器服务（用于 UI 绑定相机）
  ScannerService get scannerService => _scannerService;

  @override
  void dispose() {
    _scannerService.dispose();
    super.dispose();
  }
}
