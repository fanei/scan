// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '智能扫码';

  @override
  String get scan => '扫描';

  @override
  String get generate => '生成';

  @override
  String get history => '历史';

  @override
  String get scanScreen => '扫描';

  @override
  String get generateScreen => '生成';

  @override
  String get historyScreen => '历史记录';

  @override
  String get scanPrompt => '将二维码/条码放入框内';

  @override
  String get torch => '手电筒';

  @override
  String get switchCamera => '切换相机';

  @override
  String get qrType => 'QR 码类型';

  @override
  String get inputContent => '输入内容';

  @override
  String get generateQRCode => '生成 QR 码';

  @override
  String get save => '保存';

  @override
  String get share => '分享';

  @override
  String get copy => '复制';

  @override
  String get url => '网址';

  @override
  String get text => '文本';

  @override
  String get wifi => 'WiFi';

  @override
  String get phone => '电话';

  @override
  String get sms => '短信';

  @override
  String get contact => '联系人';

  @override
  String get unknown => '未知';

  @override
  String get search => '搜索';

  @override
  String get delete => '删除';

  @override
  String get clearAll => '清空记录';

  @override
  String get noHistory => '暂无历史记录';

  @override
  String get deleteConfirm => '确定要删除吗？';

  @override
  String get clearAllConfirm => '确定要清空所有历史记录吗？';

  @override
  String get deleted => '已删除';

  @override
  String get cleared => '已清空';

  @override
  String get openInBrowser => '在浏览器打开';

  @override
  String get makeCall => '拨打电话';

  @override
  String get sendSMS => '发送短信';

  @override
  String get connectWiFi => '连接 WiFi';

  @override
  String get saveContact => '保存联系人';

  @override
  String get copyToClipboard => '复制到剪贴板';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get content => '内容';

  @override
  String get close => '关闭';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确定';

  @override
  String get retry => '重试';

  @override
  String get errorCameraPermissionDenied => '相机权限被拒绝，无法使用扫描功能';

  @override
  String get errorCameraUnavailable => '相机不可用';

  @override
  String get errorScanFailed => '扫描失败，请重试';

  @override
  String get errorGenerateFailed => '生成失败，请重试';

  @override
  String get errorPleaseEnterContent => '请输入内容';

  @override
  String get errorSaveFailed => '保存失败';

  @override
  String get errorShareFailed => '分享失败';

  @override
  String get savedToGallery => '已保存到相册';

  @override
  String get saveToGalleryFailed => '保存到相册失败';

  @override
  String get pleaseGenerateFirst => '请先生成 QR 码';

  @override
  String get wifiInfo => 'WiFi 信息';

  @override
  String get hintUrl => '例如: https://example.com';

  @override
  String get hintText => '输入任意文本';

  @override
  String get hintWifi => '例如: WIFI:T:WPA;S:网络名;P:密码;;';

  @override
  String get hintPhone => '例如: +86 138 0000 0000';

  @override
  String get hintSms => '例如: smsto:138****:消息内容';

  @override
  String get hintContact => '输入 vCard 格式联系人';

  @override
  String get just_now => '刚刚';

  @override
  String minutes_ago(int count) {
    return '$count 分钟前';
  }

  @override
  String hours_ago(int count) {
    return '$count 小时前';
  }

  @override
  String days_ago(int count) {
    return '$count 天前';
  }

  @override
  String get batchScan => '批量扫描';

  @override
  String get batchScanResults => '扫描结果';

  @override
  String get scanned => '已扫描';

  @override
  String get unique => '去重后';

  @override
  String get totalScans => '总数';

  @override
  String get uniqueScans => '去重后';

  @override
  String get deduplicate => '去除重复';

  @override
  String get finish => '完成';

  @override
  String get clearList => '清空列表';

  @override
  String get clearListConfirm => '确定要清空所有扫描结果吗？';

  @override
  String get noScanResults => '暂无扫描结果';

  @override
  String get recentScans => '最近扫描';

  @override
  String get duplicateScanned => '已经扫描过了';

  @override
  String get exportCSV => '导出 CSV';

  @override
  String get exportTXT => '导出 TXT';

  @override
  String get exportSuccess => '导出成功';

  @override
  String get exportFailed => '导出失败';

  @override
  String get savedTo => '已保存到';

  @override
  String get shareFailed => '分享失败';

  @override
  String get exitBatchScan => '退出批量扫描';

  @override
  String get exitBatchScanConfirm => '退出批量扫描模式？未保存的结果将丢失。';

  @override
  String get duration => '用时';

  @override
  String get seconds => ' 秒';

  @override
  String get settings => '设置';

  @override
  String get general => '通用';

  @override
  String get languageSettings => '语言设置';

  @override
  String get followSystem => '跟随系统';

  @override
  String get followSystemDesc => '使用系统语言设置';

  @override
  String get chinese => '简体中文';

  @override
  String get english => 'English';

  @override
  String get languageChangeHint => '语言设置将立即生效';

  @override
  String get about => '关于';

  @override
  String get aboutApp => '关于应用';

  @override
  String get appDescription => '快速、安全、易用的二维码扫描与生成工具';

  @override
  String get privacyAndSecurity => '隐私与安全';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get dataManagement => '数据管理';

  @override
  String get clearHistoryDesc => '删除所有扫描历史记录';

  @override
  String get clearHistoryConfirm => '确定要清空所有扫描历史吗？此操作不可恢复。';

  @override
  String get historyCleared => '历史记录已清空';

  @override
  String get other => '其他';

  @override
  String get version => '版本';

  @override
  String get reportIssue => '报告问题';

  @override
  String get reportIssueDesc => '遇到问题或有建议？联系我们';

  @override
  String get rateUs => '为我们评分';

  @override
  String get rateUsDesc => '喜欢我们的应用？给我们评分吧';

  @override
  String get shareApp => '分享应用';

  @override
  String get shareAppDesc => '推荐给朋友';

  @override
  String get shareAppMessage => '推荐一款好用的二维码扫描应用：SmartScan';

  @override
  String get features => '功能特性';

  @override
  String get featureScan => '快速扫描二维码和条形码';

  @override
  String get featureBatchScan => '批量连续扫描';

  @override
  String get featureGenerate => '生成各种类型的二维码';

  @override
  String get featureHistory => '扫描历史记录';

  @override
  String get featureMultiLanguage => '多语言支持';

  @override
  String get developer => '开发者';

  @override
  String get developedBy => '开发者';

  @override
  String get contactEmail => '联系邮箱';

  @override
  String get openSource => '开源';

  @override
  String get licenses => '开源许可';
}
