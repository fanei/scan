import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/batch_scan_provider.dart';
import '../../utils/formatters.dart';
import 'batch_result_screen.dart';

/// 批量扫描页面
class BatchScanScreen extends StatefulWidget {
  const BatchScanScreen({super.key});

  @override
  State<BatchScanScreen> createState() => _BatchScanScreenState();
}

class _BatchScanScreenState extends State<BatchScanScreen> {
  @override
  void initState() {
    super.initState();
    // 启动批量扫描
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BatchScanProvider>().startBatchScan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.batchScan),
        actions: [
          Consumer<BatchScanProvider>(
            builder: (context, provider, _) {
              return IconButton(
                icon: Icon(
                  provider.enableDeduplicate 
                      ? Icons.filter_alt 
                      : Icons.filter_alt_off,
                ),
                onPressed: provider.toggleDeduplicate,
                tooltip: l10n.deduplicate,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () => _finishBatchScan(context),
            tooltip: l10n.finish,
          ),
        ],
      ),
      body: Consumer<BatchScanProvider>(
        builder: (context, provider, _) {
          if (provider.errorMessage != null) {
            return _buildErrorView(context, provider);
          }

          return Column(
            children: [
              _buildStatisticsBar(context, provider),
              Expanded(
                child: _buildCameraView(context, provider),
              ),
              _buildResultsList(context, provider),
              _buildBottomBar(context, provider),
            ],
          );
        },
      ),
    );
  }

  /// 统计信息栏
  Widget _buildStatisticsBar(BuildContext context, BatchScanProvider provider) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Icon(
            Icons.qr_code_scanner,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            '${l10n.scanned}: ${provider.totalScans}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (provider.enableDeduplicate && provider.totalScans != provider.uniqueScans) ...[
            const SizedBox(width: 16),
            Text(
              '${l10n.unique}: ${provider.uniqueScans}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  /// 相机预览
  Widget _buildCameraView(BuildContext context, BatchScanProvider provider) {
    final controller = provider.scannerService.controller;
    
    if (controller == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    return Stack(
      children: [
        MobileScanner(
          controller: controller,
          onDetect: (capture) => _handleScan(context, capture, provider),
        ),
        // 扫描框
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  /// 处理扫描
  Future<void> _handleScan(
    BuildContext context,
    BarcodeCapture capture,
    BatchScanProvider provider,
  ) async {
    final scanResult = provider.scannerService.parseBarcodeCapture(capture);
    if (scanResult == null) return;

    final added = await provider.addResult(scanResult);

    if (mounted) {
      if (added) {
        // 成功添加，震动反馈
        HapticFeedback.mediumImpact();
        
        // 显示提示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(scanResult.rawValue),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        // 重复，轻微震动
        HapticFeedback.lightImpact();
        
        // 显示重复提示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.duplicateScanned),
            duration: const Duration(milliseconds: 500),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    // 短暂延迟，避免重复扫描
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// 结果列表（最近5条）
  Widget _buildResultsList(BuildContext context, BatchScanProvider provider) {
    if (provider.results.isEmpty) {
      return const SizedBox.shrink();
    }

    final recentResults = provider.results.reversed.take(5).toList();

    return Container(
      height: 150,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              AppLocalizations.of(context)!.recentScans,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: recentResults.length,
              itemBuilder: (context, index) {
                final result = recentResults[index];
                final number = provider.totalScans - index;
                
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 16,
                    child: Text('$number'),
                  ),
                  title: Text(
                    Formatters.truncateText(result.rawValue, 40),
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    result.type.displayName,
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 底部操作栏
  Widget _buildBottomBar(BuildContext context, BatchScanProvider provider) {
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
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: provider.results.isEmpty
                  ? null
                  : () => _showClearConfirmDialog(context),
              icon: const Icon(Icons.delete_outline),
              label: Text(l10n.clearList),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: provider.results.isEmpty
                  ? null
                  : () => _finishBatchScan(context),
              icon: const Icon(Icons.check),
              label: Text(l10n.finish),
            ),
          ),
        ],
      ),
    );
  }

  /// 错误视图
  Widget _buildErrorView(BuildContext context, BatchScanProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            provider.errorMessage ?? 'Unknown error',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              provider.clearError();
              provider.startBatchScan();
            },
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  /// 完成批量扫描
  void _finishBatchScan(BuildContext context) {
    final provider = context.read<BatchScanProvider>();
    
    if (provider.results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.noScanResults),
        ),
      );
      return;
    }

    provider.stopBatchScan();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const BatchResultScreen(),
      ),
    );
  }

  /// 显示清空确认对话框
  void _showClearConfirmDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearList),
        content: Text(l10n.clearListConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<BatchScanProvider>().clearResults();
              Navigator.pop(context);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 停止扫描
    context.read<BatchScanProvider>().stopBatchScan();
    super.dispose();
  }
}
