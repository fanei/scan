import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/scan_provider.dart';
import '../../providers/batch_scan_provider.dart';
import '../../utils/formatters.dart';
import 'scan_result_screen.dart';
import '../batch_scan/batch_result_screen.dart';

/// 扫描页面
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  bool _isBatchMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScanProvider>().initialize();
    });
  }

  @override
  void dispose() {
    if (_isBatchMode) {
      context.read<BatchScanProvider>().reset();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final scanProvider = context.read<ScanProvider>();
    switch (state) {
      case AppLifecycleState.resumed:
        scanProvider.startScan();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        scanProvider.stopScan();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isBatchMode ? l10n.batchScan : l10n.scanScreen),
        centerTitle: true,
        actions: [
          // 批量模式切换按钮
          IconButton(
            onPressed: _toggleBatchMode,
            icon: Icon(_isBatchMode ? Icons.qr_code_scanner : Icons.qr_code_2),
            tooltip: _isBatchMode ? l10n.scanScreen : l10n.batchScan,
          ),
          // 手电筒按钮
          Consumer<ScanProvider>(
            builder: (context, provider, _) {
              return IconButton(
                icon: Icon(
                  provider.torchEnabled ? Icons.flash_on : Icons.flash_off,
                ),
                onPressed: () => provider.toggleTorch(),
                tooltip: l10n.torch,
              );
            },
          ),
        ],
      ),
      body: Consumer2<ScanProvider, BatchScanProvider>(
        builder: (context, scanProvider, batchProvider, _) {
          if (scanProvider.error != null) {
            return _buildErrorView(scanProvider.error!, () {
              scanProvider.clearError();
              scanProvider.initialize();
            }, l10n);
          }

          if (scanProvider.controller == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // 相机层始终保持，只切换上层UI
          return Stack(
            children: [
              // 底层：相机预览（始终存在，不重建）
              Positioned.fill(
                child: MobileScanner(
                  controller: scanProvider.controller!,
                  onDetect: (capture) => _isBatchMode
                      ? _handleBatchScan(capture, scanProvider, batchProvider, l10n)
                      : _handleNormalScan(capture, scanProvider),
                ),
              ),
              // 上层：根据模式显示不同UI
              if (_isBatchMode)
                _buildBatchModeOverlay(batchProvider, l10n)
              else
                _buildNormalModeOverlay(l10n),
            ],
          );
        },
      ),
    );
  }

  /// 普通模式覆盖层
  Widget _buildNormalModeOverlay(AppLocalizations l10n) {
    return Stack(
      children: [
        _buildScanOverlay(),
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                l10n.scanPrompt,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 批量模式覆盖层
  Widget _buildBatchModeOverlay(BatchScanProvider batchProvider, AppLocalizations l10n) {
    return Column(
      children: [
        // 统计栏
        _buildBatchStatsBar(batchProvider, l10n),
        // 扫描框
        Expanded(
          child: Stack(
            children: [
              _buildScanOverlay(),
            ],
          ),
        ),
        // 结果列表
        if (batchProvider.results.isNotEmpty)
          _buildBatchResultsList(batchProvider, l10n),
        // 操作按钮
        _buildBatchActions(batchProvider, l10n),
      ],
    );
  }

  /// 处理普通扫描
  void _handleNormalScan(BarcodeCapture capture, ScanProvider provider) {
    provider.handleScanResult(capture).then((_) {
      if (provider.lastResult != null && mounted) {
        // 暂停扫描
        provider.stopScan();
        
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScanResultScreen(
              result: provider.lastResult!,
            ),
          ),
        ).then((_) {
          // 返回时恢复扫描
          provider.clearLastResult();
          if (mounted) {
            provider.startScan();
          }
        });
      }
    });
  }

  /// 统计信息栏
  Widget _buildBatchStatsBar(BatchScanProvider provider, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Icon(Icons.qr_code_scanner, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            '${l10n.scanned}: ${provider.totalScans}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
          const Spacer(),
          IconButton(
            icon: Icon(provider.enableDeduplicate ? Icons.filter_alt : Icons.filter_alt_off, size: 20),
            onPressed: provider.toggleDeduplicate,
            tooltip: l10n.deduplicate,
          ),
        ],
      ),
    );
  }

  /// 结果列表
  Widget _buildBatchResultsList(BatchScanProvider provider, AppLocalizations l10n) {
    final recentResults = provider.results.reversed.take(5).toList();
    return Container(
      constraints: const BoxConstraints(maxHeight: 150),
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
              l10n.recentScans,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
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
                  leading: CircleAvatar(radius: 16, child: Text('$number')),
                  title: Text(
                    Formatters.truncateText(result.rawValue, 40),
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(result.type.displayName, style: const TextStyle(fontSize: 12)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 操作按钮
  Widget _buildBatchActions(BatchScanProvider provider, AppLocalizations l10n) {
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
              onPressed: provider.results.isEmpty ? null : () => _showClearConfirmDialog(provider, l10n),
              icon: const Icon(Icons.delete_outline),
              label: Text(l10n.clearList),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: provider.results.isEmpty ? null : () => _finishBatchScan(provider),
              icon: const Icon(Icons.check),
              label: Text(l10n.finish),
            ),
          ),
        ],
      ),
    );
  }

  /// 扫描框叠加层
  Widget _buildScanOverlay() {
    return Container(
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5)),
      child: CustomPaint(
        painter: ScanOverlayPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }

  /// 错误视图
  Widget _buildErrorView(String error, VoidCallback onRetry, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(error, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }

  /// 切换批量模式
  void _toggleBatchMode() {
    setState(() {
      if (_isBatchMode) {
        // 退出批量模式
        _finishBatchScan(context.read<BatchScanProvider>());
      } else {
        // 进入批量模式
        context.read<BatchScanProvider>().startBatchScan();
        _isBatchMode = true;
      }
    });
  }

  /// 完成批量扫描
  void _finishBatchScan(BatchScanProvider provider) {
    if (provider.results.isEmpty) {
      setState(() => _isBatchMode = false);
      provider.reset();
      return;
    }

    provider.stopBatchScan();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const BatchResultScreen()),
    ).then((_) {
      setState(() => _isBatchMode = false);
      provider.reset();
    });
  }

  /// 清空确认对话框
  void _showClearConfirmDialog(BatchScanProvider provider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearList),
        content: Text(l10n.clearListConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () {
              provider.clearResults();
              Navigator.pop(context);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  /// 处理批量扫描
  Future<void> _handleBatchScan(
    BarcodeCapture capture,
    ScanProvider scanProvider,
    BatchScanProvider batchProvider,
    AppLocalizations l10n,
  ) async {
    // 使用 ScanProvider 的 handleScanResult 来处理
    await scanProvider.handleScanResult(capture);
    final scanResult = scanProvider.lastResult;
    if (scanResult == null) return;
    
    // 清除 lastResult，避免影响普通模式
    scanProvider.clearLastResult();

    final added = await batchProvider.addResult(scanResult);

    if (mounted) {
      if (added) {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(scanResult.rawValue),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.duplicateScanned),
            duration: const Duration(milliseconds: 500),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    await Future.delayed(const Duration(milliseconds: 300));
  }
}

/// 扫描框绘制器
class ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cutOutSize = 250.0;
    final cutOutLeft = (size.width - cutOutSize) / 2;
    final cutOutTop = (size.height - cutOutSize) / 2;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cutOutLeft, cutOutTop, cutOutSize, cutOutSize),
          const Radius.circular(12),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, Paint()..color = Colors.black.withValues(alpha: 0.6));

    final cornerPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const cornerLength = 32.0;

    // 左上角
    canvas.drawLine(Offset(cutOutLeft, cutOutTop), Offset(cutOutLeft + cornerLength, cutOutTop), cornerPaint);
    canvas.drawLine(Offset(cutOutLeft, cutOutTop), Offset(cutOutLeft, cutOutTop + cornerLength), cornerPaint);

    // 右上角
    canvas.drawLine(Offset(cutOutLeft + cutOutSize, cutOutTop), Offset(cutOutLeft + cutOutSize - cornerLength, cutOutTop), cornerPaint);
    canvas.drawLine(Offset(cutOutLeft + cutOutSize, cutOutTop), Offset(cutOutLeft + cutOutSize, cutOutTop + cornerLength), cornerPaint);

    // 左下角
    canvas.drawLine(Offset(cutOutLeft, cutOutTop + cutOutSize), Offset(cutOutLeft + cornerLength, cutOutTop + cutOutSize), cornerPaint);
    canvas.drawLine(Offset(cutOutLeft, cutOutTop + cutOutSize), Offset(cutOutLeft, cutOutTop + cutOutSize - cornerLength), cornerPaint);

    // 右下角
    canvas.drawLine(Offset(cutOutLeft + cutOutSize, cutOutTop + cutOutSize), Offset(cutOutLeft + cutOutSize - cornerLength, cutOutTop + cutOutSize), cornerPaint);
    canvas.drawLine(Offset(cutOutLeft + cutOutSize, cutOutTop + cutOutSize), Offset(cutOutLeft + cutOutSize, cutOutTop + cutOutSize - cornerLength), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
