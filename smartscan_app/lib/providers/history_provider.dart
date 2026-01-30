import 'package:flutter/foundation.dart';
import '../models/history_item.dart';
import '../models/qr_type.dart';
import '../services/database_service.dart';

/// 历史记录状态管理
class HistoryProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<HistoryItem> _history = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  QRType? _filterType;

  List<HistoryItem> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  QRType? get filterType => _filterType;

  /// 加载历史记录
  Future<void> loadHistory() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (_searchQuery.isNotEmpty) {
        _history = await _databaseService.searchHistory(_searchQuery);
      } else if (_filterType != null) {
        _history = await _databaseService.getHistoryByType(_filterType!);
      } else {
        _history = await _databaseService.getAllHistory();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 搜索历史记录
  Future<void> search(String query) async {
    _searchQuery = query;
    await loadHistory();
  }

  /// 按类型筛选
  Future<void> filterByType(QRType? type) async {
    _filterType = type;
    await loadHistory();
  }

  /// 清除筛选
  Future<void> clearFilter() async {
    _searchQuery = '';
    _filterType = null;
    await loadHistory();
  }

  /// 删除记录
  Future<bool> deleteHistory(int id) async {
    try {
      final result = await _databaseService.deleteHistory(id);
      if (result > 0) {
        _history.removeWhere((item) => item.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// 清空所有记录
  Future<bool> clearAll() async {
    try {
      final result = await _databaseService.clearAllHistory();
      if (result > 0 || _history.isEmpty) {
        _history.clear();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// 获取记录数量
  Future<int> getCount() async {
    try {
      return await _databaseService.getHistoryCount();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 0;
    }
  }

  /// 获取单条记录详情
  Future<HistoryItem?> getHistoryDetail(int id) async {
    try {
      return await _databaseService.getHistoryById(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// 刷新列表
  Future<void> refresh() async {
    await loadHistory();
  }

  /// 清除错误
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
