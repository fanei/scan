/// 应用常量定义
class AppConstants {
  // 应用信息
  static const String appName = 'SmartScan';
  static const String appVersion = '1.0.0';
  
  // 数据库
  static const String dbName = 'smartscan.db';
  static const int dbVersion = 1;
  static const String tableHistory = 'scan_history';
  
  // 历史记录限制
  static const int maxHistoryItems = 1000;  // 免费版最多保存 1000 条
  
  // 扫描配置
  static const Duration scanDelay = Duration(milliseconds: 500);
  static const int defaultQRSize = 512;
  
  // UI 配置
  static const double borderRadius = 12.0;
  static const double padding = 16.0;
  static const double iconSize = 24.0;
  
  // 动画时长
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration normalAnimationDuration = Duration(milliseconds: 300);
  
  // 错误消息
  static const String errorCameraPermissionDenied = '相机权限被拒绝，无法使用扫描功能';
  static const String errorCameraUnavailable = '相机不可用';
  static const String errorScanFailed = '扫描失败，请重试';
  static const String errorGenerateFailed = '生成失败，请重试';
  static const String errorDatabaseFailed = '数据库操作失败';
}
