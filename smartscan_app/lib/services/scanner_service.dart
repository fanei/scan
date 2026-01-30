import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/scan_result.dart';
import '../models/qr_type.dart';

/// 扫描服务类
/// 
/// 负责处理 QR 码和条码的扫描功能
class ScannerService {
  MobileScannerController? _controller;
  bool _isInitialized = false;

  /// 初始化扫描器
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 请求相机权限
    final hasPermission = await requestCameraPermission();
    if (!hasPermission) {
      throw Exception('相机权限被拒绝');
    }

    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    _isInitialized = true;
  }

  /// 请求相机权限
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.status;
    
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      // 引导用户到设置页面
      await openAppSettings();
      return false;
    }

    return false;
  }

  /// 获取扫描控制器
  MobileScannerController? get controller => _controller;

  /// 开始扫描
  Future<void> startScanning() async {
    if (!_isInitialized) {
      await initialize();
    }
    // 启动扫描
    await _controller?.start();
  }

  /// 停止扫描
  Future<void> stopScanning() async {
    await _controller?.stop();
  }

  /// 切换手电筒
  Future<void> toggleTorch() async {
    await _controller?.toggleTorch();
  }

  /// 切换摄像头
  Future<void> switchCamera() async {
    await _controller?.switchCamera();
  }

  /// 解析扫描结果
  ScanResult? parseBarcodeCapture(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return null;

    final barcode = barcodes.first;
    final rawValue = barcode.rawValue;
    if (rawValue == null || rawValue.isEmpty) return null;

    // 检测 QR 码类型
    final type = QRType.detectFromContent(rawValue);

    return ScanResult(
      rawValue: rawValue,
      type: type,
      timestamp: DateTime.now(),
      parsedData: _parseBarcode(barcode, type),
    );
  }

  /// 解析条码详细信息
  Map<String, dynamic>? _parseBarcode(Barcode barcode, QRType type) {
    final data = <String, dynamic>{
      'format': barcode.format.name,
    };

    // 根据类型解析特定数据
    switch (type) {
      case QRType.url:
        if (barcode.url != null) {
          data['url'] = barcode.url!.url;
          data['title'] = barcode.url!.title;
        }
        break;

      case QRType.phone:
        if (barcode.phone != null) {
          data['number'] = barcode.phone!.number;
          data['type'] = barcode.phone!.type.name;
        }
        break;

      case QRType.sms:
        if (barcode.sms != null) {
          data['phone'] = barcode.sms!.phoneNumber;
          data['message'] = barcode.sms!.message;
        }
        break;

      case QRType.wifi:
        if (barcode.wifi != null) {
          data['ssid'] = barcode.wifi!.ssid;
          data['password'] = barcode.wifi!.password;
          data['encryption'] = barcode.wifi!.encryptionType.name;
        }
        break;

      case QRType.contact:
        if (barcode.contactInfo != null) {
          data['name'] = barcode.contactInfo!.name?.formattedName;
          data['phones'] = barcode.contactInfo!.phones.map((p) => p.number).toList();
          data['emails'] = barcode.contactInfo!.emails.map((e) => e.address).toList();
          data['addresses'] = barcode.contactInfo!.addresses.map((a) => a.addressLines).toList();
        }
        break;

      default:
        break;
    }

    return data;
  }

  /// 从图片扫描（未来实现）
  Future<ScanResult?> scanFromImage(String imagePath) async {
    // TODO: 实现从图片扫描
    // 可以使用 google_mlkit_barcode_scanning
    throw UnimplementedError('从图片扫描功能将在后续版本实现');
  }

  /// 释放资源
  Future<void> dispose() async {
    _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }

  /// 检查是否已初始化
  bool get isInitialized => _isInitialized;
}
