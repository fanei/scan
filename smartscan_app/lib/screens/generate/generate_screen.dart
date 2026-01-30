import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/generate_provider.dart';
import '../../models/qr_type.dart';

/// 生成页面
class GenerateScreen extends StatelessWidget {
  const GenerateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.generateScreen),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTypeSelector(),
            const SizedBox(height: 24),
            _buildInputField(),
            const SizedBox(height: 24),
            _buildGenerateButton(),
            const SizedBox(height: 24),
            _buildQRPreview(),
            const SizedBox(height: 24),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Consumer<GenerateProvider>(
      builder: (context, provider, _) {
        final l10n = AppLocalizations.of(context)!;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.qrType,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    QRType.url,
                    QRType.text,
                    QRType.wifi,
                    QRType.phone,
                    QRType.sms,
                    QRType.contact,
                  ].map((type) {
                    final isSelected = provider.selectedType == type;
                    return ChoiceChip(
                      label: Text(_getTypeDisplayName(context, type)),
                      selected: isSelected,
                      onSelected: (_) => provider.setSelectedType(type),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField() {
    return Consumer<GenerateProvider>(
      builder: (context, provider, _) {
        final l10n = AppLocalizations.of(context)!;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                labelText: l10n.inputContent,
                hintText: _getHintForType(provider.selectedType, context),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: provider.setInputData,
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenerateButton() {
    return Consumer<GenerateProvider>(
      builder: (context, provider, _) {
        final l10n = AppLocalizations.of(context)!;
        
        return ElevatedButton(
          onPressed: provider.isGenerating ? null : provider.generateQRCode,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
          ),
          child: provider.isGenerating
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.generateQRCode),
        );
      },
    );
  }

  Widget _buildQRPreview() {
    return Consumer<GenerateProvider>(
      builder: (context, provider, _) {
        if (provider.qrImageData == null) {
          return const SizedBox.shrink();
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Image.memory(
                  provider.qrImageData!,
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                Text(
                  provider.inputData.length > 50
                      ? '${provider.inputData.substring(0, 50)}...'
                      : provider.inputData,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActions() {
    return Consumer<GenerateProvider>(
      builder: (context, provider, _) {
        final l10n = AppLocalizations.of(context)!;
        
        if (provider.qrImageData == null) {
          return const SizedBox.shrink();
        }

        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final success = await provider.saveToGallery();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success ? l10n.savedToGallery : l10n.saveToGalleryFailed),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.save),
                label: Text(l10n.save),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => provider.share(),
                icon: const Icon(Icons.share),
                label: Text(l10n.share),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getTypeDisplayName(BuildContext context, QRType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case QRType.url:
        return l10n.url;
      case QRType.text:
        return l10n.text;
      case QRType.wifi:
        return l10n.wifi;
      case QRType.phone:
        return l10n.phone;
      case QRType.sms:
        return l10n.sms;
      case QRType.contact:
        return l10n.contact;
      case QRType.unknown:
        return l10n.unknown;
    }
  }

  String _getHintForType(QRType type, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case QRType.url:
        return l10n.hintUrl;
      case QRType.text:
        return l10n.hintText;
      case QRType.wifi:
        return l10n.hintWifi;
      case QRType.phone:
        return l10n.hintPhone;
      case QRType.sms:
        return l10n.hintSms;
      case QRType.contact:
        return l10n.hintContact;
      case QRType.unknown:
        return l10n.hintText;
    }
  }
}
