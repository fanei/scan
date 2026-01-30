import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/history_provider.dart';
import '../../utils/formatters.dart';
import '../../models/qr_type.dart';

/// 历史记录页面
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // 加载历史记录
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyScreen),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
            tooltip: l10n.search,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear',
                child: Text(l10n.clearAll),
              ),
            ],
            onSelected: (value) {
              if (value == 'clear') {
                _showClearConfirmDialog();
              }
            },
          ),
        ],
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadHistory(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          if (provider.history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noHistory,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: ListView.builder(
              itemCount: provider.history.length,
              itemBuilder: (context, index) {
                final item = provider.history[index];
                return Dismissible(
                  key: Key(item.id.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    provider.deleteHistory(item.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.deleted)),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(_getIconForType(item.type)),
                    ),
                    title: Text(
                      item.displaySummary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      Formatters.formatDateTime(item.scanTime),
                    ),
                    trailing: Text(_getTypeDisplayName(context, item.type)),
                    onTap: () => _showHistoryDetail(item),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForType(dynamic type) {
    // 简化版，使用默认图标
    return Icons.qr_code;
  }

  String _getTypeDisplayName(BuildContext context, dynamic type) {
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
      default:
        return l10n.unknown;
    }
  }

  void _showSearchDialog() {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.search),
          content: TextField(
            decoration: InputDecoration(
              hintText: l10n.inputContent,
            ),
            onSubmitted: (query) {
              context.read<HistoryProvider>().search(query);
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }

  void _showClearConfirmDialog() {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.clearAll),
          content: Text(l10n.clearAllConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () async {
                await context.read<HistoryProvider>().clearAll();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.cleared)),
                  );
                }
              },
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    );
  }

  void _showHistoryDetail(dynamic item) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_getTypeDisplayName(context, item.type)),
          content: SingleChildScrollView(
            child: SelectableText(item.content),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }
}
