import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// SmartScan 应用图标生成器
/// 
/// 设计说明：
/// - 渐变绿色背景（Material Green）
/// - 白色扫描框四角
/// - 中心 3x3 QR 点阵
/// - 符合 Material Design 3 风格

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final generator = IconGenerator();
  
  // 生成不同尺寸的图标
  final sizes = [
    // Google Play
    512,
    // iOS
    1024, 180, 120, 167, 152,
    // Android
    192, 144, 96, 72, 48,
  ];
  
  for (final size in sizes) {
    await generator.generateIcon(size, 'icon_${size}x$size.png');
    print('✅ 生成图标: ${size}x$size px');
  }
  
  print('\n🎉 所有图标生成完成！');
  print('📁 图标位置: ${Directory.current.path}');
}

class IconGenerator {
  /// 生成指定尺寸的图标
  Future<void> generateIcon(int size, String filename) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = IconPainter(size: size.toDouble());
    
    painter.paint(canvas, Size(size.toDouble(), size.toDouble()));
    
    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    if (byteData != null) {
      final file = File(filename);
      await file.writeAsBytes(byteData.buffer.asUint8List());
    }
  }
}

/// 图标绘制器
class IconPainter extends CustomPainter {
  final double size;
  
  IconPainter({required this.size});
  
  @override
  void paint(Canvas canvas, Size canvasSize) {
    final rect = Rect.fromLTWH(0, 0, size, size);
    
    // 1. 绘制渐变背景
    _drawBackground(canvas, rect);
    
    // 2. 绘制扫描框四角
    _drawScanCorners(canvas, rect);
    
    // 3. 绘制中心 QR 点阵
    _drawQRDots(canvas, rect);
  }
  
  /// 绘制渐变背景
  void _drawBackground(Canvas canvas, Rect rect) {
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF4CAF50), // Material Green 500
        Color(0xFF2E7D32), // Material Green 800
      ],
    );
    
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;
    
    // 圆角矩形背景（Android adaptive icon 风格）
    final radius = size * 0.22; // 22% 圆角
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    
    canvas.drawRRect(rrect, paint);
  }
  
  /// 绘制扫描框四角
  void _drawScanCorners(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.04 // 线条粗细：4%
      ..strokeCap = StrokeCap.round;
    
    final cornerSize = size * 0.18; // 角的大小：18%
    final margin = size * 0.22; // 距离边缘：22%
    
    // 左上角
    canvas.drawLine(
      Offset(margin, margin),
      Offset(margin + cornerSize, margin),
      paint,
    );
    canvas.drawLine(
      Offset(margin, margin),
      Offset(margin, margin + cornerSize),
      paint,
    );
    
    // 右上角
    canvas.drawLine(
      Offset(size - margin, margin),
      Offset(size - margin - cornerSize, margin),
      paint,
    );
    canvas.drawLine(
      Offset(size - margin, margin),
      Offset(size - margin, margin + cornerSize),
      paint,
    );
    
    // 左下角
    canvas.drawLine(
      Offset(margin, size - margin),
      Offset(margin + cornerSize, size - margin),
      paint,
    );
    canvas.drawLine(
      Offset(margin, size - margin),
      Offset(margin, size - margin - cornerSize),
      paint,
    );
    
    // 右下角
    canvas.drawLine(
      Offset(size - margin, size - margin),
      Offset(size - margin - cornerSize, size - margin),
      paint,
    );
    canvas.drawLine(
      Offset(size - margin, size - margin),
      Offset(size - margin, size - margin - cornerSize),
      paint,
    );
  }
  
  /// 绘制中心 QR 点阵
  void _drawQRDots(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final dotRadius = size * 0.028; // 点的半径：2.8%
    final spacing = size * 0.08; // 点之间的间距：8%
    final centerX = size / 2;
    final centerY = size / 2;
    
    // 绘制 3x3 点阵
    for (int row = -1; row <= 1; row++) {
      for (int col = -1; col <= 1; col++) {
        // 跳过某些点，形成更有趣的图案
        if ((row == 0 && col == 0) || 
            (row == -1 && col == -1) || 
            (row == 1 && col == 1)) {
          continue; // 跳过这些位置
        }
        
        final x = centerX + (col * spacing);
        final y = centerY + (row * spacing);
        
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
    
    // 在中心绘制一个稍大的圆点
    canvas.drawCircle(
      Offset(centerX, centerY),
      dotRadius * 1.5,
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
