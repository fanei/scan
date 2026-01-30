import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import '../models/qr_type.dart';
import '../services/qr_generator_service.dart';

/// 生成状态管理
class GenerateProvider with ChangeNotifier {
  final QRGeneratorService _generatorService = QRGeneratorService();

  QRType _selectedType = QRType.url;
  String _inputData = '';
  Uint8List? _qrImageData;
  Color _foregroundColor = Colors.black;
  Color _backgroundColor = Colors.white;
  int _size = 512;
  bool _isGenerating = false;
  String? _error;

  QRType get selectedType => _selectedType;
  String get inputData => _inputData;
  Uint8List? get qrImageData => _qrImageData;
  Color get foregroundColor => _foregroundColor;
  Color get backgroundColor => _backgroundColor;
  int get size => _size;
  bool get isGenerating => _isGenerating;
  String? get error => _error;

  /// 设置选中的类型
  void setSelectedType(QRType type) {
    _selectedType = type;
    _qrImageData = null; // 清除之前的图片
    notifyListeners();
  }

  /// 设置输入数据
  void setInputData(String data) {
    _inputData = data;
    notifyListeners();
  }

  /// 设置前景色
  void setForegroundColor(Color color) {
    _foregroundColor = color;
    if (_qrImageData != null) {
      // 如果已经生成过，重新生成
      generateQRCode();
    }
    notifyListeners();
  }

  /// 设置背景色
  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    if (_qrImageData != null) {
      // 如果已经生成过，重新生成
      generateQRCode();
    }
    notifyListeners();
  }

  /// 设置尺寸
  void setSize(int size) {
    _size = size;
    if (_qrImageData != null) {
      // 如果已经生成过，重新生成
      generateQRCode();
    }
    notifyListeners();
  }

  /// 生成 QR 码
  Future<void> generateQRCode() async {
    if (_inputData.isEmpty) {
      _error = '请输入内容';
      notifyListeners();
      return;
    }

    try {
      _error = null;
      _isGenerating = true;
      notifyListeners();

      _qrImageData = await _generatorService.generateQRCode(
        data: _inputData,
        type: _selectedType,
        foregroundColor: _foregroundColor,
        backgroundColor: _backgroundColor,
        size: _size,
      );

      _isGenerating = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isGenerating = false;
      notifyListeners();
    }
  }

  /// 保存到相册
  Future<bool> saveToGallery() async {
    if (_qrImageData == null) {
      _error = '请先生成 QR 码';
      notifyListeners();
      return false;
    }

    try {
      // 检查并请求权限
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          _error = '需要存储权限才能保存到相册';
          notifyListeners();
          return false;
        }
      }

      // 先保存到临时文件
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${tempDir.path}/smartscan_qr_$timestamp.png');
      await file.writeAsBytes(_qrImageData!);
      
      // 保存到相册
      await Gal.putImage(file.path, album: 'SmartScan');
      
      // 删除临时文件
      await file.delete();
      
      return true;
    } catch (e) {
      _error = '保存失败: $e';
      notifyListeners();
      return false;
    }
  }

  /// 分享 QR 码
  Future<void> share() async {
    if (_qrImageData == null) {
      _error = '请先生成 QR 码';
      notifyListeners();
      return;
    }

    try {
      // 保存到临时目录
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/qr_code_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(_qrImageData!);

      // 分享文件
      await Share.shareXFiles(
        [XFile(file.path)],
        text: _inputData,
      );
    } catch (e) {
      _error = '分享失败: $e';
      notifyListeners();
    }
  }

  /// 清除生成的图片
  void clearQRImage() {
    _qrImageData = null;
    notifyListeners();
  }

  /// 重置所有状态
  void reset() {
    _selectedType = QRType.url;
    _inputData = '';
    _qrImageData = null;
    _foregroundColor = Colors.black;
    _backgroundColor = Colors.white;
    _size = 512;
    _error = null;
    notifyListeners();
  }

  /// 清除错误
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
