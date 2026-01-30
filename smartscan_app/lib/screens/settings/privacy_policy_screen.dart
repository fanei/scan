import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// 隐私政策页面
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyPolicy),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isZh ? _privacyPolicyZh : _privacyPolicyEn,
              style: const TextStyle(fontSize: 14, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  // 中文隐私政策
  static const String _privacyPolicyZh = '''
SmartScan 隐私政策

更新日期：2026年1月29日
生效日期：2026年1月29日

感谢您使用 SmartScan！我们非常重视您的隐私。本隐私政策旨在帮助您了解我们如何收集、使用和保护您的个人信息。

1. 信息收集

1.1 我们收集的信息
SmartScan 是一款完全本地化的应用，我们不会收集或上传您的任何个人信息到服务器。应用收集的信息包括：
- 扫描记录：您扫描的二维码内容，仅存储在您的设备本地
- 相机权限：用于扫描二维码，不会拍摄或保存照片
- 存储权限：用于保存生成的二维码图片到相册

1.2 我们不收集的信息
- 不收集您的个人身份信息
- 不追踪您的位置信息
- 不收集设备唯一标识符
- 不收集任何使用统计数据
- 不使用任何第三方分析工具

2. 信息使用

2.1 本地使用
所有扫描记录和生成的二维码都存储在您的设备本地，仅用于：
- 显示扫描历史记录
- 提供快速访问功能
- 改善您的使用体验

2.2 不与第三方分享
我们不会与任何第三方分享、出售或交易您的信息。

3. 数据存储与安全

3.1 本地存储
- 所有数据存储在您的设备本地数据库中
- 无云端同步
- 数据随应用卸载而删除

3.2 数据安全
- 您的数据受设备系统级安全保护
- 我们采用业界标准的安全措施保护本地数据
- 您可以随时通过应用内设置清空所有数据

4. 您的权利

您对自己的数据拥有完全控制权：
- 查看权：随时查看您的扫描历史
- 删除权：可以删除单条记录或清空所有历史
- 导出权：可以导出扫描数据为CSV或TXT格式
- 卸载权：卸载应用将删除所有本地数据

5. 权限说明

5.1 相机权限
用途：扫描二维码
说明：仅在扫描页面使用，不会拍摄或保存照片

5.2 存储权限
用途：保存生成的二维码图片到相册
说明：仅在用户点击"保存到相册"时使用

6. 儿童隐私

SmartScan 适合所有年龄段用户使用。我们不会故意收集13岁以下儿童的个人信息。

7. 隐私政策变更

我们可能会不时更新本隐私政策。更新后的版本将在应用内显示，并更新"更新日期"。重大变更时，我们会在应用中显著提示。

8. 联系我们

如果您对本隐私政策有任何疑问或建议，请通过以下方式联系我们：
- 邮箱：faneizn@gmail.com

9. 同意

使用 SmartScan 即表示您同意本隐私政策。如果您不同意本政策，请停止使用并卸载应用。

---

fanei
2026年1月
''';

  // English Privacy Policy
  static const String _privacyPolicyEn = '''
SmartScan Privacy Policy

Last Updated: January 29, 2026
Effective Date: January 29, 2026

Thank you for using SmartScan! We take your privacy seriously. This Privacy Policy explains how we collect, use, and protect your personal information.

1. Information Collection

1.1 Information We Collect
SmartScan is a fully local application. We do not collect or upload any of your personal information to servers. The information collected includes:
- Scan Records: QR code content you scan, stored only on your local device
- Camera Permission: Used for scanning QR codes, no photos are taken or saved
- Storage Permission: Used to save generated QR codes to your photo album

1.2 Information We Don't Collect
- No personal identification information
- No location tracking
- No device unique identifiers
- No usage statistics
- No third-party analytics tools

2. Information Use

2.1 Local Use
All scan records and generated QR codes are stored locally on your device, used only for:
- Displaying scan history
- Providing quick access features
- Improving your user experience

2.2 No Third-Party Sharing
We do not share, sell, or trade your information with any third parties.

3. Data Storage and Security

3.1 Local Storage
- All data is stored in your device's local database
- No cloud synchronization
- Data is deleted when the app is uninstalled

3.2 Data Security
- Your data is protected by device system-level security
- We use industry-standard security measures to protect local data
- You can clear all data at any time through the app settings

4. Your Rights

You have complete control over your data:
- Right to View: Access your scan history at any time
- Right to Delete: Delete individual records or clear all history
- Right to Export: Export scan data in CSV or TXT format
- Right to Uninstall: Uninstalling the app will delete all local data

5. Permission Explanation

5.1 Camera Permission
Purpose: Scanning QR codes
Note: Only used on the scan screen, no photos are taken or saved

5.2 Storage Permission
Purpose: Saving generated QR code images to photo album
Note: Only used when you click "Save to Album"

6. Children's Privacy

SmartScan is suitable for users of all ages. We do not knowingly collect personal information from children under 13.

7. Privacy Policy Changes

We may update this Privacy Policy from time to time. The updated version will be displayed in the app with an updated "Last Updated" date. For significant changes, we will provide prominent notice in the app.

8. Contact Us

If you have any questions or suggestions about this Privacy Policy, please contact us:
- Email: faneizn@gmail.com

9. Consent

By using SmartScan, you agree to this Privacy Policy. If you do not agree, please stop using and uninstall the app.

---

fanei
January 2026
''';
}
