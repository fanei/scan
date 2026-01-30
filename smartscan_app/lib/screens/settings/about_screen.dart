import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import '../../config/app_config.dart';

/// 关于页面
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aboutApp),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 32),
          
          // 应用图标
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/icon/icon.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.qr_code_scanner, size: 50, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 应用名称
          Center(
            child: Text(
              'SmartScan',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 应用版本
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.data?.version ?? '1.0.0';
              final buildNumber = snapshot.data?.buildNumber ?? '1';
              return Center(
                child: Text(
                  'Version $version ($buildNumber)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          // 应用简介
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                l10n.appDescription,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // 功能特性
          _buildSection(
            context,
            title: l10n.features,
            children: [
              _buildFeatureItem(context, Icons.qr_code_scanner, l10n.featureScan),
              _buildFeatureItem(context, Icons.qr_code_2, l10n.featureBatchScan),
              _buildFeatureItem(context, Icons.qr_code, l10n.featureGenerate),
              _buildFeatureItem(context, Icons.history, l10n.featureHistory),
              _buildFeatureItem(context, Icons.language, l10n.featureMultiLanguage),
            ],
          ),

          // 开发者信息
          _buildSection(
            context,
            title: l10n.developer,
            children: [
              ListTile(
                leading: const Icon(Icons.code),
                title: Text(l10n.developedBy),
                subtitle: Text(AppConfig.developerName),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(l10n.contactEmail),
                subtitle: Text(AppConfig.contactEmail),
                onTap: () => _launchEmail(AppConfig.contactEmail),
              ),
            ],
          ),

          // 开源许可
          _buildSection(
            context,
            title: l10n.openSource,
            children: [
              ListTile(
                leading: const Icon(Icons.description),
                title: Text(l10n.licenses),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: 'SmartScan',
                  applicationIcon: Image.asset(
                    'assets/icon/icon.png',
                    width: 48,
                    height: 48,
                    errorBuilder: (_, __, ___) => const Icon(Icons.qr_code_scanner, size: 48),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // 版权信息
          Center(
            child: Text(
              AppConfig.copyright,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// 构建分组
  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(children: children),
        ),
      ],
    );
  }

  /// 构建功能项
  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
      title: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  /// 启动邮箱
  Future<void> _launchEmail(String email) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          'subject': 'SmartScan Feedback',
        },
      );
      
      final canLaunch = await canLaunchUrl(emailUri);
      if (canLaunch) {
        await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      // 静默失败,不显示错误提示
      debugPrint('Failed to launch email: $e');
    }
  }
}
