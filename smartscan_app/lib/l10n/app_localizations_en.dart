// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SmartScan';

  @override
  String get scan => 'Scan';

  @override
  String get generate => 'Generate';

  @override
  String get history => 'History';

  @override
  String get scanScreen => 'Scan';

  @override
  String get generateScreen => 'Generate';

  @override
  String get historyScreen => 'History';

  @override
  String get scanPrompt => 'Place QR code/barcode within the frame';

  @override
  String get torch => 'Flashlight';

  @override
  String get switchCamera => 'Switch Camera';

  @override
  String get qrType => 'QR Code Type';

  @override
  String get inputContent => 'Enter content';

  @override
  String get generateQRCode => 'Generate QR Code';

  @override
  String get save => 'Save';

  @override
  String get share => 'Share';

  @override
  String get copy => 'Copy';

  @override
  String get url => 'URL';

  @override
  String get text => 'Text';

  @override
  String get wifi => 'WiFi';

  @override
  String get phone => 'Phone';

  @override
  String get sms => 'SMS';

  @override
  String get contact => 'Contact';

  @override
  String get unknown => 'Unknown';

  @override
  String get search => 'Search';

  @override
  String get delete => 'Delete';

  @override
  String get clearAll => 'Clear All';

  @override
  String get noHistory => 'No history records';

  @override
  String get deleteConfirm => 'Are you sure you want to delete?';

  @override
  String get clearAllConfirm => 'Are you sure you want to clear all history?';

  @override
  String get deleted => 'Deleted';

  @override
  String get cleared => 'Cleared';

  @override
  String get openInBrowser => 'Open in Browser';

  @override
  String get makeCall => 'Make Call';

  @override
  String get sendSMS => 'Send SMS';

  @override
  String get connectWiFi => 'Connect WiFi';

  @override
  String get saveContact => 'Save Contact';

  @override
  String get copyToClipboard => 'Copy to Clipboard';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get content => 'Content';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'OK';

  @override
  String get retry => 'Retry';

  @override
  String get errorCameraPermissionDenied => 'Camera permission denied';

  @override
  String get errorCameraUnavailable => 'Camera unavailable';

  @override
  String get errorScanFailed => 'Scan failed, please try again';

  @override
  String get errorGenerateFailed => 'Generate failed, please try again';

  @override
  String get errorPleaseEnterContent => 'Please enter content';

  @override
  String get errorSaveFailed => 'Save failed';

  @override
  String get errorShareFailed => 'Share failed';

  @override
  String get savedToGallery => 'Saved to gallery';

  @override
  String get saveToGalleryFailed => 'Save to gallery failed';

  @override
  String get pleaseGenerateFirst => 'Please generate QR code first';

  @override
  String get wifiInfo => 'WiFi Information';

  @override
  String get hintUrl => 'e.g. https://example.com';

  @override
  String get hintText => 'Enter any text';

  @override
  String get hintWifi => 'e.g. WIFI:T:WPA;S:NetworkName;P:Password;;';

  @override
  String get hintPhone => 'e.g. +1 234 567 8900';

  @override
  String get hintSms => 'e.g. smsto:1234567890:Message content';

  @override
  String get hintContact => 'Enter vCard format contact';

  @override
  String get just_now => 'Just now';

  @override
  String minutes_ago(int count) {
    return '$count minutes ago';
  }

  @override
  String hours_ago(int count) {
    return '$count hours ago';
  }

  @override
  String days_ago(int count) {
    return '$count days ago';
  }

  @override
  String get batchScan => 'Batch Scan';

  @override
  String get batchScanResults => 'Scan Results';

  @override
  String get scanned => 'Scanned';

  @override
  String get unique => 'Unique';

  @override
  String get totalScans => 'Total';

  @override
  String get uniqueScans => 'Unique';

  @override
  String get deduplicate => 'Remove Duplicates';

  @override
  String get finish => 'Finish';

  @override
  String get clearList => 'Clear List';

  @override
  String get clearListConfirm => 'Clear all scan results?';

  @override
  String get noScanResults => 'No scan results';

  @override
  String get recentScans => 'Recent Scans';

  @override
  String get duplicateScanned => 'Already scanned';

  @override
  String get exportCSV => 'Export CSV';

  @override
  String get exportTXT => 'Export TXT';

  @override
  String get exportSuccess => 'Export Successful';

  @override
  String get exportFailed => 'Export Failed';

  @override
  String get savedTo => 'Saved to';

  @override
  String get shareFailed => 'Share Failed';

  @override
  String get exitBatchScan => 'Exit Batch Scan';

  @override
  String get exitBatchScanConfirm =>
      'Exit batch scan mode? Unsaved results will be lost.';

  @override
  String get duration => 'Duration';

  @override
  String get seconds => ' seconds';

  @override
  String get settings => 'Settings';

  @override
  String get general => 'General';

  @override
  String get languageSettings => 'Language';

  @override
  String get followSystem => 'Follow System';

  @override
  String get followSystemDesc => 'Use system language settings';

  @override
  String get chinese => '简体中文';

  @override
  String get english => 'English';

  @override
  String get languageChangeHint =>
      'Language changes will take effect immediately';

  @override
  String get about => 'About';

  @override
  String get aboutApp => 'About App';

  @override
  String get appDescription =>
      'Fast, secure, and easy-to-use QR code scanner and generator';

  @override
  String get privacyAndSecurity => 'Privacy & Security';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get clearHistoryDesc => 'Delete all scan history';

  @override
  String get clearHistoryConfirm =>
      'Are you sure you want to clear all scan history? This action cannot be undone.';

  @override
  String get historyCleared => 'History cleared';

  @override
  String get other => 'Other';

  @override
  String get version => 'Version';

  @override
  String get reportIssue => 'Report Issue';

  @override
  String get reportIssueDesc => 'Have a problem or suggestion? Contact us';

  @override
  String get rateUs => 'Rate Us';

  @override
  String get rateUsDesc => 'Like our app? Rate us';

  @override
  String get shareApp => 'Share App';

  @override
  String get shareAppDesc => 'Recommend to friends';

  @override
  String get shareAppMessage =>
      'Check out this great QR code scanner: SmartScan';

  @override
  String get features => 'Features';

  @override
  String get featureScan => 'Fast QR code and barcode scanning';

  @override
  String get featureBatchScan => 'Batch continuous scanning';

  @override
  String get featureGenerate => 'Generate various types of QR codes';

  @override
  String get featureHistory => 'Scan history';

  @override
  String get featureMultiLanguage => 'Multi-language support';

  @override
  String get developer => 'Developer';

  @override
  String get developedBy => 'Developed by';

  @override
  String get contactEmail => 'Contact Email';

  @override
  String get openSource => 'Open Source';

  @override
  String get licenses => 'Licenses';
}
