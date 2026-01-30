import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/qr_type.dart';
import '../utils/validators.dart';

/// QR 码生成服务
/// 
/// 负责生成各种类型的 QR 码
class QRGeneratorService {
  /// 生成 QR 码图片数据
  Future<Uint8List> generateQRCode({
    required String data,
    required QRType type,
    Color foregroundColor = Colors.black,
    Color backgroundColor = Colors.white,
    int size = 512,
  }) async {
    // 验证数据
    if (!validateData(data, type)) {
      throw Exception('数据格式不正确');
    }

    // 格式化数据
    final formattedData = formatData(data, type);

    // 创建 QR 码 Widget
    final qrWidget = QrImageView(
      data: formattedData,
      version: QrVersions.auto,
      size: size.toDouble(),
      errorCorrectionLevel: QrErrorCorrectLevel.H,
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: foregroundColor,
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: foregroundColor,
      ),
      backgroundColor: backgroundColor,
    );

    // 将 Widget 转换为图片
    return await _widgetToImage(qrWidget, size);
  }

  /// 验证数据格式
  bool validateData(String data, QRType type) {
    if (data.isEmpty) return false;

    switch (type) {
      case QRType.url:
        return Validators.isValidUrl(data);
      case QRType.phone:
        return Validators.isValidPhone(data.replaceFirst('tel:', ''));
      case QRType.sms:
        final phone = data.replaceFirst(RegExp(r'smsto?:'), '');
        return Validators.isValidPhone(phone.split(':').first);
      case QRType.wifi:
        return data.contains('S:') && data.contains('P:'); // 简单验证
      case QRType.contact:
        return data.contains('BEGIN:VCARD') && data.contains('END:VCARD');
      case QRType.text:
      case QRType.unknown:
        return true;
    }
  }

  /// 格式化数据（根据类型）
  String formatData(String data, QRType type) {
    switch (type) {
      case QRType.url:
        // 确保有协议前缀
        if (!data.startsWith('http://') && !data.startsWith('https://')) {
          return 'https://$data';
        }
        return data;

      case QRType.phone:
        // 电话格式：tel:+86138...
        if (!data.startsWith('tel:')) {
          return 'tel:$data';
        }
        return data;

      case QRType.sms:
        // 短信格式：smsto:phone:message
        if (!data.startsWith('sms')) {
          return 'smsto:$data';
        }
        return data;

      case QRType.wifi:
        // WiFi 格式：WIFI:T:WPA;S:ssid;P:password;;
        if (!data.startsWith('WIFI:')) {
          return 'WIFI:$data;;';
        }
        return data;

      case QRType.contact:
      case QRType.text:
      case QRType.unknown:
        return data;
    }
  }

  /// 创建 WiFi QR 码数据
  String createWifiData({
    required String ssid,
    required String password,
    String encryption = 'WPA',
    bool isHidden = false,
  }) {
    return 'WIFI:T:$encryption;S:$ssid;P:$password;H:${isHidden ? 'true' : 'false'};;';
  }

  /// 创建联系人 QR 码数据（vCard 格式）
  String createContactData({
    required String name,
    String? phone,
    String? email,
    String? organization,
    String? url,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:3.0');
    buffer.writeln('FN:$name');
    if (phone != null) buffer.writeln('TEL:$phone');
    if (email != null) buffer.writeln('EMAIL:$email');
    if (organization != null) buffer.writeln('ORG:$organization');
    if (url != null) buffer.writeln('URL:$url');
    buffer.writeln('END:VCARD');
    return buffer.toString();
  }

  /// 将 Widget 转换为图片
  Future<Uint8List> _widgetToImage(Widget widget, int size) async {
    final repaintBoundary = RenderRepaintBoundary();
    final view = ui.PlatformDispatcher.instance.views.first;
    final logicalSize = ui.Size(size.toDouble(), size.toDouble());

    final renderView = RenderView(
      view: view,
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints.tight(logicalSize),
        devicePixelRatio: view.devicePixelRatio,
      ),
    );

    final pipelineOwner = PipelineOwner();
    final buildOwner = BuildOwner(focusManager: FocusManager());

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: widget,
      ),
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final image = await repaintBoundary.toImage(pixelRatio: view.devicePixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }
}
