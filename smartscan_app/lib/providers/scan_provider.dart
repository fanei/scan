import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/scan_result.dart';
import '../services/scanner_service.dart';
import '../services/database_service.dart';
import '../models/history_item.dart';

/// 扫描状态管理
class ScanProvider with ChangeNotifier {
  final ScannerService _scannerService = ScannerService();
  final DatabaseService _databaseService = DatabaseService();

  bool _isScanning = false;
  ScanResult? _lastResult;
  String? _error;
  bool _torchEnabled = false;

  bool get isScanning => _isScanning;
  ScanResult? get lastResult => _lastResult;
  String? get error => _error;
  bool get torchEnabled => _torchEnabled;
  MobileScannerController? get controller => _scannerService.controller;

  /// 初始化扫描服务
  Future<void> initialize() async {
    try {
      await _scannerService.initialize();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// 开始扫描
  Future<void> startScan() async {
    try {
      _error = null;
      _isScanning = true;
      notifyListeners();

      await _scannerService.startScanning();
    } catch (e) {
      _error = e.toString();
      _isScanning = false;
      notifyListeners();
    }
  }

  /// 停止扫描
  Future<void> stopScan() async {
    try {
      await _scannerService.stopScanning();
      _isScanning = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// 处理扫描结果
  Future<void> handleScanResult(BarcodeCapture capture) async {
    final result = _scannerService.parseBarcodeCapture(capture);
    if (result == null) return;

    // 避免重复扫描相同内容
    if (_lastResult?.rawValue == result.rawValue) {
      return;
    }

    _lastResult = result;
    notifyListeners();

    // 保存到历史记录
    try {
      final historyItem = HistoryItem(
        id: 0, // 数据库会自动分配
        type: result.type,
        content: result.rawValue,
        formattedContent: result.parsedData,
        scanTime: result.timestamp,
      );

      // 检查是否超过限制
      if (await _databaseService.isHistoryFull()) {
        await _databaseService.deleteOldestHistory();
      }

      await _databaseService.insertScanHistory(historyItem);
    } catch (e) {
      debugPrint('保存扫描结果失败: $e');
    }
  }

  /// 切换手电筒
  Future<void> toggleTorch() async {
    try {
      await _scannerService.toggleTorch();
      _torchEnabled = !_torchEnabled;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// 切换摄像头
  Future<void> switchCamera() async {
    try {
      await _scannerService.switchCamera();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// 清除错误
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// 清除最后的结果
  void clearLastResult() {
    _lastResult = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _scannerService.dispose();
    super.dispose();
  }
}
