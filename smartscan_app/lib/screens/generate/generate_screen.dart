import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/generate_provider.dart';
import '../../models/qr_type.dart';
import '../../config/app_theme.dart';
import '../../utils/validators.dart';

/// 生成页面
class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _validationError;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateInput(String value, QRType type) {
    setState(() {
      if (value.isEmpty) {
        _validationError = null;
        return;
      }

      switch (type) {
        case QRType.url:
          _validationError = Validators.isValidUrl(value) 
              ? null 
              : '无效的 URL';
          break;
        case QRType.phone:
          final phone = value.startsWith('tel:') ? value.substring(4) : value;
          _validationError = Validators.isValidPhone(phone)
              ? null
              : '无效的电话号码';
          break;
        case QRType.wifi:
          _validationError = value.startsWith('WIFI:')
              ? null
              : '无效的 WiFi 格式';
          break;
        case QRType.contact:
          _validationError = Validators.isValidVCard(value)
              ? null
              : '无效的联系人格式';
          break;
        default:
          _validationError = Validators.isNotEmpty(value) ? null : '内容不能为空';
      }
    });
  }

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
          elevation: AppTheme.elevationSmall,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.inputContent,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.grey700,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: _getHintForType(provider.selectedType, context),
                    errorText: _validationError,
                    prefixIcon: Icon(
                      _getIconForType(provider.selectedType),
                      color: _validationError != null 
                          ? AppTheme.errorColor 
                          : AppTheme.primaryColor,
                    ),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _controller.clear();
                              provider.setInputData('');
                              setState(() {
                                _validationError = null;
                              });
                            },
                          )
                        : null,
                  ),
                  maxLines: provider.selectedType == QRType.contact ? 8 : 3,
                  onChanged: (value) {
                    provider.setInputData(value);
                    _validateInput(value, provider.selectedType);
                  },
                ),
                if (_validationError == null && _controller.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppTheme.secondaryColor,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '输入格式正确',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
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
        final isDisabled = provider.inputData.isEmpty || _validationError != null;
        
        return ElevatedButton.icon(
          onPressed: (provider.isGenerating || isDisabled) 
              ? null 
              : provider.generateQRCode,
          icon: provider.isGenerating
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.qr_code_2),
          label: Text(
            provider.isGenerating ? '生成中...' : l10n.generateQRCode,
          ),
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

        return AnimatedOpacity(
          opacity: provider.qrImageData != null ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Card(
            elevation: AppTheme.elevationMedium,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              child: Column(
                children: [
                  // QR码预览
                  Hero(
                    tag: 'qr_preview',
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.spacingMedium),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Image.memory(
                        provider.qrImageData!,
                        width: 280,
                        height: 280,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMedium),
                  // 内容预览
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMedium,
                      vertical: AppTheme.spacingSmall,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.grey100,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIconForType(provider.selectedType),
                          size: 16,
                          color: AppTheme.grey600,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            provider.inputData.length > 50
                                ? '${provider.inputData.substring(0, 50)}...'
                                : provider.inputData,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.grey700,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
  
  IconData _getIconForType(QRType type) {
    switch (type) {
      case QRType.url:
        return Icons.link;
      case QRType.text:
        return Icons.text_fields;
      case QRType.wifi:
        return Icons.wifi;
      case QRType.phone:
        return Icons.phone;
      case QRType.sms:
        return Icons.message;
      case QRType.contact:
        return Icons.person;
      default:
        return Icons.qr_code;
    }
  }
}
