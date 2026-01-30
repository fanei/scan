import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';

/// 语言设置页面
class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageSettings),
        centerTitle: true,
      ),
      body: Consumer<LocaleProvider>(
        builder: (context, provider, _) {
          return ListView(
            children: [
              const SizedBox(height: 8),
              
              // 跟随系统
              RadioListTile<Locale?>(
                title: Text(l10n.followSystem),
                subtitle: Text(l10n.followSystemDesc),
                value: null,
                groupValue: provider.locale,
                onChanged: (_) => provider.clearLocale(),
              ),
              
              const Divider(),
              
              // 简体中文
              RadioListTile<Locale?>(
                title: Text(l10n.chinese),
                value: const Locale('zh'),
                groupValue: provider.locale,
                onChanged: (locale) {
                  if (locale != null) {
                    provider.setLocale(locale);
                  }
                },
              ),
              
              // English
              RadioListTile<Locale?>(
                title: Text(l10n.english),
                value: const Locale('en'),
                groupValue: provider.locale,
                onChanged: (locale) {
                  if (locale != null) {
                    provider.setLocale(locale);
                  }
                },
              ),
              
              const SizedBox(height: 16),
              
              // 提示信息
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.languageChangeHint,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
