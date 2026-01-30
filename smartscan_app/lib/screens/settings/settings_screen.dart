import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';
import '../../providers/history_provider.dart';
import '../../config/app_config.dart';
import 'privacy_policy_screen.dart';
import 'about_screen.dart';
import 'language_settings_screen.dart';

/// 设置页面
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // 通用设置
          _buildSection(
            context,
            title: l10n.general,
            children: [
              Consumer<LocaleProvider>(
                builder: (context, localeProvider, _) {
                  String currentLanguage;
                  if (localeProvider.isFollowSystem) {
                    currentLanguage = l10n.followSystem;
                  } else if (localeProvider.locale?.languageCode == 'zh') {
                    currentLanguage = l10n.chinese;
                  } else {
                    currentLanguage = l10n.english;
                  }
                  
                  return _buildTile(
                    context,
                    icon: Icons.language,
                    title: l10n.languageSettings,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentLanguage,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LanguageSettingsScreen()),
                    ),
                  );
                },
              ),
            ],
          ),

          // 关于应用
          _buildSection(
            context,
            title: l10n.about,
            children: [
              _buildTile(
                context,
                icon: Icons.info_outline,
                title: l10n.aboutApp,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                ),
              ),
            ],
          ),

          // 隐私与安全
          _buildSection(
            context,
            title: l10n.privacyAndSecurity,
            children: [
              _buildTile(
                context,
                icon: Icons.privacy_tip_outlined,
                title: l10n.privacyPolicy,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                ),
              ),
              _buildTile(
                context,
                icon: Icons.open_in_new,
                title: '在线查看隐私政策',
                subtitle: 'View Privacy Policy Online',
                onTap: () => _openPrivacyPolicyOnline(context),
              ),
            ],
          ),

          // 数据管理
          _buildSection(
            context,
            title: l10n.dataManagement,
            children: [
              _buildTile(
                context,
                icon: Icons.delete_outline,
                title: l10n.clearAll,
                subtitle: l10n.clearHistoryDesc,
                onTap: () => _showClearHistoryDialog(context),
              ),
            ],
          ),

          // 反馈与支持
          _buildSection(
            context,
            title: l10n.other,
            children: [
              _buildTile(
                context,
                icon: Icons.bug_report_outlined,
                title: l10n.reportIssue,
                subtitle: l10n.reportIssueDesc,
                onTap: () => _reportIssue(context),
              ),
              _buildTile(
                context,
                icon: Icons.star_outline,
                title: l10n.rateUs,
                subtitle: l10n.rateUsDesc,
                onTap: () => _rateApp(context),
              ),
              _buildTile(
                context,
                icon: Icons.share_outlined,
                title: l10n.shareApp,
                subtitle: l10n.shareAppDesc,
                onTap: () => _shareApp(context),
              ),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  final version = snapshot.data?.version ?? '1.0.0';
                  return _buildTile(
                    context,
                    icon: Icons.system_update_outlined,
                    title: l10n.version,
                    trailing: Text(
                      'v$version',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ],
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

  /// 构建设置项
  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  /// 显示清空历史确认对话框
  void _showClearHistoryDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearAll),
        content: Text(l10n.clearHistoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              // 清空历史记录
              final historyProvider = context.read<HistoryProvider>();
              final success = await historyProvider.clearAll();
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? l10n.historyCleared : l10n.errorShareFailed),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  /// 报告问题
  Future<void> _reportIssue(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: AppConfig.contactEmail,
        queryParameters: {
          'subject': '${l10n.reportIssue} - SmartScan v${packageInfo.version}',
          'body': '\n\n\n---\nApp Version: ${packageInfo.version} (${packageInfo.buildNumber})',
        },
      );

      final canLaunch = await canLaunchUrl(emailUri);
      if (canLaunch) {
        await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.errorShareFailed}\n请确保设备上已安装邮件应用'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorShareFailed}: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// 为应用评分
  Future<void> _rateApp(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final InAppReview inAppReview = InAppReview.instance;

    try {
      // 直接打开应用商店页面,更可靠
      await inAppReview.openStoreListing(
        appStoreId: '123456789', // iOS App Store ID (暂时不需要)
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorShareFailed}\n错误: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// 分享应用
  Future<void> _shareApp(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    try {
      await Share.share(
        '${l10n.shareAppMessage}\n\nAndroid: ${AppConfig.playStoreUrl}\niOS: ${AppConfig.appStoreUrl}',
        subject: 'SmartScan',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.shareFailed)),
        );
      }
    }
  }

  /// 打开在线隐私政策
  Future<void> _openPrivacyPolicyOnline(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    try {
      final Uri uri = Uri.parse(AppConfig.privacyPolicyUrl);
      final canLaunch = await canLaunchUrl(uri);
      
      if (canLaunch) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.errorShareFailed}\n无法打开浏览器'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorShareFailed}: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
