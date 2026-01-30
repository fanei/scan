import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import '../../models/scan_result.dart';
import '../../models/qr_type.dart';

/// 扫描结果页面
class ScanResultScreen extends StatelessWidget {
  final ScanResult result;

  const ScanResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTypeDisplayName(context, result.type)),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => _copyToClipboard(context),
            tooltip: l10n.copy,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _share(context),
            tooltip: l10n.share,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTypeIcon(),
            const SizedBox(height: 24),
            _buildContent(context),
            const SizedBox(height: 24),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeIcon() {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _getIconData(result.type),
          size: 40,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.content,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            SelectableText(
              result.rawValue,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final actions = _getActionsForType(result.type, context);
    
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: actions.map((action) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ElevatedButton.icon(
            onPressed: () => action.onPressed(context),
            icon: Icon(action.icon),
            label: Text(action.label),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconData(QRType type) {
    switch (type) {
      case QRType.url:
        return Icons.link;
      case QRType.text:
        return Icons.text_fields;
      case QRType.contact:
        return Icons.person;
      case QRType.wifi:
        return Icons.wifi;
      case QRType.phone:
        return Icons.phone;
      case QRType.sms:
        return Icons.message;
      case QRType.unknown:
        return Icons.help_outline;
    }
  }

  List<QuickAction> _getActionsForType(QRType type, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (type) {
      case QRType.url:
        return [
          QuickAction(
            label: l10n.openInBrowser,
            icon: Icons.open_in_browser,
            onPressed: (context) => _openUrl(),
          ),
        ];

      case QRType.phone:
        return [
          QuickAction(
            label: l10n.makeCall,
            icon: Icons.phone,
            onPressed: (context) => _makePhoneCall(),
          ),
        ];

      case QRType.sms:
        return [
          QuickAction(
            label: l10n.sendSMS,
            icon: Icons.message,
            onPressed: (context) => _sendSms(),
          ),
        ];

      case QRType.wifi:
        return [
          QuickAction(
            label: l10n.connectWiFi,
            icon: Icons.wifi,
            onPressed: (context) => _showWifiInfo(context),
          ),
        ];

      default:
        return [];
    }
  }

  Future<void> _openUrl() async {
    final uri = Uri.parse(result.rawValue);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _makePhoneCall() async {
    final phoneNumber = result.rawValue.replaceFirst('tel:', '');
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sendSms() async {
    final uri = Uri.parse(result.rawValue);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String _getTypeDisplayName(BuildContext context, QRType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case QRType.url:
        return l10n.url;
      case QRType.text:
        return l10n.text;
      case QRType.contact:
        return l10n.contact;
      case QRType.wifi:
        return l10n.wifi;
      case QRType.phone:
        return l10n.phone;
      case QRType.sms:
        return l10n.sms;
      case QRType.unknown:
        return l10n.unknown;
    }
  }

  void _showWifiInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final wifiData = result.rawValue;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.wifiInfo),
        content: SelectableText(wifiData),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: result.rawValue));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.copiedToClipboard)),
    );
  }

  void _share(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // TODO: 实现分享功能
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.errorShareFailed)),
    );
  }
}

class QuickAction {
  final String label;
  final IconData icon;
  final void Function(BuildContext) onPressed;

  QuickAction({
    required this.label,
    required this.icon,
    required this.onPressed,
  });
}
