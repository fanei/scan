import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/history_provider.dart';
import '../../utils/formatters.dart';
import '../../models/qr_type.dart';
import '../../config/app_theme.dart';

/// 历史记录页面
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  QRType? _selectedType; // 筛选的类型
  
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

          // 筛选历史记录
          final filteredHistory = _selectedType == null
              ? provider.history
              : provider.history.where((item) => item.type == _selectedType).toList();
          
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

          return Column(
            children: [
              // 类型筛选标签
              _buildTypeFilter(provider.history),
              
              // 历史记录列表
              Expanded(
                child: filteredHistory.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.filter_list_off,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.noHistory,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: provider.refresh,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: filteredHistory.length,
                          itemBuilder: (context, index) {
                            final item = filteredHistory[index];
                            return Dismissible(
                              key: Key(item.id.toString()),
                              background: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingMedium,
                                  vertical: AppTheme.spacingSmall,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.errorColor,
                                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) => _confirmDelete(context),
                              onDismissed: (_) {
                                provider.deleteHistory(item.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.deleted)),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingMedium,
                                  vertical: AppTheme.spacingSmall,
                                ),
                                child: InkWell(
                                  onTap: () => _showHistoryDetail(item),
                                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppTheme.spacingMedium),
                                    child: Row(
                                      children: [
                                        // 图标
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: _getColorForType(item.type).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                                          ),
                                          child: Icon(
                                            _getIconForType(item.type),
                                            color: _getColorForType(item.type),
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: AppTheme.spacingMedium),
                                        // 内容
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.displaySummary,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    size: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    Formatters.formatDateTime(item.scanTime),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // 类型标签
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getColorForType(item.type).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                                          ),
                                          child: Text(
                                            _getTypeDisplayName(context, item.type),
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: _getColorForType(item.type),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 构建类型筛选器
  Widget _buildTypeFilter(List<dynamic> history) {
    if (history.isEmpty) return const SizedBox.shrink();
    
    // 获取所有存在的类型
    final existingTypes = history.map((item) => item.type).toSet().toList();
    existingTypes.sort((a, b) => a.toString().compareTo(b.toString()));
    
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMedium),
        children: [
          // "全部"筛选器
          _buildFilterChip(
            label: '全部',
            isSelected: _selectedType == null,
            onTap: () {
              setState(() {
                _selectedType = null;
              });
            },
          ),
          const SizedBox(width: 8),
          // 各类型筛选器
          ...existingTypes.map((type) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildFilterChip(
                  label: _getTypeDisplayName(context, type),
                  icon: _getIconForType(type),
                  color: _getColorForType(type),
                  isSelected: _selectedType == type,
                  onTap: () {
                    setState(() {
                      _selectedType = type;
                    });
                  },
                ),
              )),
        ],
      ),
    );
  }
  
  /// 构建筛选芯片
  Widget _buildFilterChip({
    required String label,
    IconData? icon,
    Color? color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final chipColor = color ?? AppTheme.primaryColor;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? chipColor.withOpacity(0.15) : AppTheme.grey100,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          border: Border.all(
            color: isSelected ? chipColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? chipColor : AppTheme.grey600,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? chipColor : AppTheme.grey700,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 确认删除对话框
  Future<bool?> _confirmDelete(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.delete),
          content: Text(l10n.deleteConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.errorColor,
              ),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }

  IconData _getIconForType(dynamic type) {
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
  
  Color _getColorForType(dynamic type) {
    switch (type) {
      case QRType.url:
        return AppTheme.primaryColor;
      case QRType.text:
        return AppTheme.grey700;
      case QRType.wifi:
        return const Color(0xFF9C27B0); // 紫色
      case QRType.phone:
        return AppTheme.secondaryColor;
      case QRType.sms:
        return const Color(0xFFFF9800); // 橙色
      case QRType.contact:
        return const Color(0xFF2196F3); // 蓝色
      default:
        return AppTheme.grey600;
    }
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
