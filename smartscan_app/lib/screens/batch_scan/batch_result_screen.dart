import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/batch_scan_provider.dart';
import '../../utils/formatters.dart';

/// 批量扫描结果页面
class BatchResultScreen extends StatelessWidget {
  const BatchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.batchScanResults),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _exitBatchScan(context),
        ),
      ),
      body: Consumer<BatchScanProvider>(
        builder: (context, provider, _) {
          final results = provider.enableDeduplicate
              ? provider.deduplicatedResults
              : provider.results;

          if (results.isEmpty) {
            return _buildEmptyView(context);
          }

          return Column(
            children: [
              _buildSummaryCard(context, provider),
              _buildFilterBar(context, provider),
              Expanded(
                child: _buildResultsList(context, provider, results),
              ),
              _buildActionBar(context, provider),
            ],
          );
        },
      ),
    );
  }

  /// 摘要卡片
  Widget _buildSummaryCard(BuildContext context, BatchScanProvider provider) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  context,
                  l10n.totalScans,
                  '${provider.totalScans}',
                  Icons.qr_code_scanner,
                ),
                if (provider.enableDeduplicate)
                  _buildStatItem(
                    context,
                    l10n.uniqueScans,
                    '${provider.uniqueScans}',
                    Icons.filter_alt,
                  ),
              ],
            ),
            if (provider.currentSession?.durationInSeconds != null) ...[
              const SizedBox(height: 12),
              Text(
                '${l10n.duration}: ${provider.currentSession!.durationInSeconds}${l10n.seconds}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  /// 筛选栏
  Widget _buildFilterBar(BuildContext context, BatchScanProvider provider) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            label: Text(l10n.deduplicate),
            selected: provider.enableDeduplicate,
            onSelected: (_) => provider.toggleDeduplicate(),
            avatar: Icon(
              provider.enableDeduplicate ? Icons.check : Icons.filter_alt_off,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  /// 结果列表
  Widget _buildResultsList(
    BuildContext context,
    BatchScanProvider provider,
    List results,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(
              result.rawValue,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${result.type.displayName} • ${Formatters.formatTime(result.timestamp)}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => _copyToClipboard(context, result.rawValue),
            ),
            onTap: () => _showDetailDialog(context, result),
          ),
        );
      },
    );
  }

  /// 操作栏
  Widget _buildActionBar(BuildContext context, BatchScanProvider provider) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _exportToCSV(context, provider),
                  icon: const Icon(Icons.table_chart),
                  label: Text(l10n.exportCSV),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _exportToTXT(context, provider),
                  icon: const Icon(Icons.description),
                  label: Text(l10n.exportTXT),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _shareResults(context, provider),
              icon: const Icon(Icons.share),
              label: Text(l10n.share),
            ),
          ),
        ],
      ),
    );
  }

  /// 空视图
  Widget _buildEmptyView(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_2,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noScanResults,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// 复制到剪贴板
  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copiedToClipboard)),
    );
  }

  /// 显示详情对话框
  void _showDetailDialog(BuildContext context, dynamic result) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(result.type.displayName),
        content: SingleChildScrollView(
          child: SelectableText(result.rawValue),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
          TextButton(
            onPressed: () {
              _copyToClipboard(context, result.rawValue);
              Navigator.pop(context);
            },
            child: Text(l10n.copy),
          ),
        ],
      ),
    );
  }

  /// 导出为 CSV
  Future<void> _exportToCSV(
    BuildContext context,
    BatchScanProvider provider,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final filePath = await provider.exportToCSV();
      if (filePath != null && context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.exportSuccess),
            content: Text('${l10n.savedTo}:\n$filePath'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.close),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  provider.shareFile(filePath);
                },
                child: Text(l10n.share),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.exportFailed}: $e')),
        );
      }
    }
  }

  /// 导出为 TXT
  Future<void> _exportToTXT(
    BuildContext context,
    BatchScanProvider provider,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final filePath = await provider.exportToTXT();
      if (filePath != null && context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.exportSuccess),
            content: Text('${l10n.savedTo}:\n$filePath'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.close),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  provider.shareFile(filePath);
                },
                child: Text(l10n.share),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.exportFailed}: $e')),
        );
      }
    }
  }

  /// 分享结果
  Future<void> _shareResults(
    BuildContext context,
    BatchScanProvider provider,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      await provider.shareResults();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.shareFailed}: $e')),
        );
      }
    }
  }

  /// 退出批量扫描
  void _exitBatchScan(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        
        return AlertDialog(
          title: Text(l10n.exitBatchScan),
          content: Text(l10n.exitBatchScanConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 关闭对话框
                context.read<BatchScanProvider>().reset();
                Navigator.pop(context); // 返回主页
              },
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    );
  }
}
