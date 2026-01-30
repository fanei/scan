import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'SmartScan'**
  String get appName;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @scanScreen.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanScreen;

  /// No description provided for @generateScreen.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generateScreen;

  /// No description provided for @historyScreen.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyScreen;

  /// No description provided for @scanPrompt.
  ///
  /// In en, this message translates to:
  /// **'Place QR code/barcode within the frame'**
  String get scanPrompt;

  /// No description provided for @torch.
  ///
  /// In en, this message translates to:
  /// **'Flashlight'**
  String get torch;

  /// No description provided for @switchCamera.
  ///
  /// In en, this message translates to:
  /// **'Switch Camera'**
  String get switchCamera;

  /// No description provided for @qrType.
  ///
  /// In en, this message translates to:
  /// **'QR Code Type'**
  String get qrType;

  /// No description provided for @inputContent.
  ///
  /// In en, this message translates to:
  /// **'Enter content'**
  String get inputContent;

  /// No description provided for @generateQRCode.
  ///
  /// In en, this message translates to:
  /// **'Generate QR Code'**
  String get generateQRCode;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @wifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get wifi;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history records'**
  String get noHistory;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get deleteConfirm;

  /// No description provided for @clearAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all history?'**
  String get clearAllConfirm;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @cleared.
  ///
  /// In en, this message translates to:
  /// **'Cleared'**
  String get cleared;

  /// No description provided for @openInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in Browser'**
  String get openInBrowser;

  /// No description provided for @makeCall.
  ///
  /// In en, this message translates to:
  /// **'Make Call'**
  String get makeCall;

  /// No description provided for @sendSMS.
  ///
  /// In en, this message translates to:
  /// **'Send SMS'**
  String get sendSMS;

  /// No description provided for @connectWiFi.
  ///
  /// In en, this message translates to:
  /// **'Connect WiFi'**
  String get connectWiFi;

  /// No description provided for @saveContact.
  ///
  /// In en, this message translates to:
  /// **'Save Contact'**
  String get saveContact;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to Clipboard'**
  String get copyToClipboard;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get confirm;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorCameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission denied'**
  String get errorCameraPermissionDenied;

  /// No description provided for @errorCameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable'**
  String get errorCameraUnavailable;

  /// No description provided for @errorScanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan failed, please try again'**
  String get errorScanFailed;

  /// No description provided for @errorGenerateFailed.
  ///
  /// In en, this message translates to:
  /// **'Generate failed, please try again'**
  String get errorGenerateFailed;

  /// No description provided for @errorPleaseEnterContent.
  ///
  /// In en, this message translates to:
  /// **'Please enter content'**
  String get errorPleaseEnterContent;

  /// No description provided for @errorSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get errorSaveFailed;

  /// No description provided for @errorShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Share failed'**
  String get errorShareFailed;

  /// No description provided for @savedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Saved to gallery'**
  String get savedToGallery;

  /// No description provided for @saveToGalleryFailed.
  ///
  /// In en, this message translates to:
  /// **'Save to gallery failed'**
  String get saveToGalleryFailed;

  /// No description provided for @pleaseGenerateFirst.
  ///
  /// In en, this message translates to:
  /// **'Please generate QR code first'**
  String get pleaseGenerateFirst;

  /// No description provided for @wifiInfo.
  ///
  /// In en, this message translates to:
  /// **'WiFi Information'**
  String get wifiInfo;

  /// No description provided for @hintUrl.
  ///
  /// In en, this message translates to:
  /// **'e.g. https://example.com'**
  String get hintUrl;

  /// No description provided for @hintText.
  ///
  /// In en, this message translates to:
  /// **'Enter any text'**
  String get hintText;

  /// No description provided for @hintWifi.
  ///
  /// In en, this message translates to:
  /// **'e.g. WIFI:T:WPA;S:NetworkName;P:Password;;'**
  String get hintWifi;

  /// No description provided for @hintPhone.
  ///
  /// In en, this message translates to:
  /// **'e.g. +1 234 567 8900'**
  String get hintPhone;

  /// No description provided for @hintSms.
  ///
  /// In en, this message translates to:
  /// **'e.g. smsto:1234567890:Message content'**
  String get hintSms;

  /// No description provided for @hintContact.
  ///
  /// In en, this message translates to:
  /// **'Enter vCard format contact'**
  String get hintContact;

  /// No description provided for @just_now.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get just_now;

  /// No description provided for @minutes_ago.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutes_ago(int count);

  /// No description provided for @hours_ago.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hours_ago(int count);

  /// No description provided for @days_ago.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String days_ago(int count);

  /// No description provided for @batchScan.
  ///
  /// In en, this message translates to:
  /// **'Batch Scan'**
  String get batchScan;

  /// No description provided for @batchScanResults.
  ///
  /// In en, this message translates to:
  /// **'Scan Results'**
  String get batchScanResults;

  /// No description provided for @scanned.
  ///
  /// In en, this message translates to:
  /// **'Scanned'**
  String get scanned;

  /// No description provided for @unique.
  ///
  /// In en, this message translates to:
  /// **'Unique'**
  String get unique;

  /// No description provided for @totalScans.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalScans;

  /// No description provided for @uniqueScans.
  ///
  /// In en, this message translates to:
  /// **'Unique'**
  String get uniqueScans;

  /// No description provided for @deduplicate.
  ///
  /// In en, this message translates to:
  /// **'Remove Duplicates'**
  String get deduplicate;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @clearList.
  ///
  /// In en, this message translates to:
  /// **'Clear List'**
  String get clearList;

  /// No description provided for @clearListConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear all scan results?'**
  String get clearListConfirm;

  /// No description provided for @noScanResults.
  ///
  /// In en, this message translates to:
  /// **'No scan results'**
  String get noScanResults;

  /// No description provided for @recentScans.
  ///
  /// In en, this message translates to:
  /// **'Recent Scans'**
  String get recentScans;

  /// No description provided for @duplicateScanned.
  ///
  /// In en, this message translates to:
  /// **'Already scanned'**
  String get duplicateScanned;

  /// No description provided for @exportCSV.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCSV;

  /// No description provided for @exportTXT.
  ///
  /// In en, this message translates to:
  /// **'Export TXT'**
  String get exportTXT;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export Successful'**
  String get exportSuccess;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export Failed'**
  String get exportFailed;

  /// No description provided for @savedTo.
  ///
  /// In en, this message translates to:
  /// **'Saved to'**
  String get savedTo;

  /// No description provided for @shareFailed.
  ///
  /// In en, this message translates to:
  /// **'Share Failed'**
  String get shareFailed;

  /// No description provided for @exitBatchScan.
  ///
  /// In en, this message translates to:
  /// **'Exit Batch Scan'**
  String get exitBatchScan;

  /// No description provided for @exitBatchScanConfirm.
  ///
  /// In en, this message translates to:
  /// **'Exit batch scan mode? Unsaved results will be lost.'**
  String get exitBatchScanConfirm;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **' seconds'**
  String get seconds;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettings;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get followSystem;

  /// No description provided for @followSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Use system language settings'**
  String get followSystemDesc;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get chinese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @languageChangeHint.
  ///
  /// In en, this message translates to:
  /// **'Language changes will take effect immediately'**
  String get languageChangeHint;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Fast, secure, and easy-to-use QR code scanner and generator'**
  String get appDescription;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacyAndSecurity;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @clearHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Delete all scan history'**
  String get clearHistoryDesc;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all scan history? This action cannot be undone.'**
  String get clearHistoryConfirm;

  /// No description provided for @historyCleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared'**
  String get historyCleared;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reportIssue;

  /// No description provided for @reportIssueDesc.
  ///
  /// In en, this message translates to:
  /// **'Have a problem or suggestion? Contact us'**
  String get reportIssueDesc;

  /// No description provided for @rateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rateUs;

  /// No description provided for @rateUsDesc.
  ///
  /// In en, this message translates to:
  /// **'Like our app? Rate us'**
  String get rateUsDesc;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @shareAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Recommend to friends'**
  String get shareAppDesc;

  /// No description provided for @shareAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out this great QR code scanner: SmartScan'**
  String get shareAppMessage;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @featureScan.
  ///
  /// In en, this message translates to:
  /// **'Fast QR code and barcode scanning'**
  String get featureScan;

  /// No description provided for @featureBatchScan.
  ///
  /// In en, this message translates to:
  /// **'Batch continuous scanning'**
  String get featureBatchScan;

  /// No description provided for @featureGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate various types of QR codes'**
  String get featureGenerate;

  /// No description provided for @featureHistory.
  ///
  /// In en, this message translates to:
  /// **'Scan history'**
  String get featureHistory;

  /// No description provided for @featureMultiLanguage.
  ///
  /// In en, this message translates to:
  /// **'Multi-language support'**
  String get featureMultiLanguage;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by'**
  String get developedBy;

  /// No description provided for @contactEmail.
  ///
  /// In en, this message translates to:
  /// **'Contact Email'**
  String get contactEmail;

  /// No description provided for @openSource.
  ///
  /// In en, this message translates to:
  /// **'Open Source'**
  String get openSource;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
