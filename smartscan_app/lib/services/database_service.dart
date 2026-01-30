import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/history_item.dart';
import '../models/qr_type.dart';
import '../utils/constants.dart';

/// 数据库服务类
/// 
/// 负责管理 SQLite 数据库操作
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  /// 获取数据库实例
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// 初始化数据库
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// 创建表
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.tableHistory} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        content TEXT NOT NULL,
        formatted_content TEXT,
        scan_time INTEGER NOT NULL,
        preview_image_path TEXT,
        created_at INTEGER DEFAULT (strftime('%s', 'now'))
      )
    ''');

    // 创建索引
    await db.execute('''
      CREATE INDEX idx_scan_time ON ${AppConstants.tableHistory}(scan_time DESC)
    ''');

    await db.execute('''
      CREATE INDEX idx_type ON ${AppConstants.tableHistory}(type)
    ''');
  }

  /// 数据库升级
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 未来版本升级时的处理逻辑
    if (oldVersion < 2) {
      // 例如：添加新字段
    }
  }

  /// 插入扫描记录
  Future<int> insertScanHistory(HistoryItem item) async {
    final db = await database;
    final map = item.toMap();
    map.remove('id'); // 移除 id，让数据库自动生成
    return await db.insert(AppConstants.tableHistory, map);
  }

  /// 查询所有历史记录
  Future<List<HistoryItem>> getAllHistory({
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.tableHistory,
      orderBy: 'scan_time DESC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => HistoryItem.fromMap(map)).toList();
  }

  /// 根据 ID 查询记录
  Future<HistoryItem?> getHistoryById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.tableHistory,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return HistoryItem.fromMap(maps.first);
  }

  /// 搜索历史记录
  Future<List<HistoryItem>> searchHistory(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.tableHistory,
      where: 'content LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'scan_time DESC',
    );

    return maps.map((map) => HistoryItem.fromMap(map)).toList();
  }

  /// 按类型查询记录
  Future<List<HistoryItem>> getHistoryByType(QRType type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.tableHistory,
      where: 'type = ?',
      whereArgs: [type.toString().split('.').last],
      orderBy: 'scan_time DESC',
    );

    return maps.map((map) => HistoryItem.fromMap(map)).toList();
  }

  /// 删除记录
  Future<int> deleteHistory(int id) async {
    final db = await database;
    return await db.delete(
      AppConstants.tableHistory,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 清空所有记录
  Future<int> clearAllHistory() async {
    final db = await database;
    return await db.delete(AppConstants.tableHistory);
  }

  /// 获取记录数量
  Future<int> getHistoryCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${AppConstants.tableHistory}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// 检查是否超过最大记录数
  Future<bool> isHistoryFull() async {
    final count = await getHistoryCount();
    return count >= AppConstants.maxHistoryItems;
  }

  /// 删除最旧的记录（当超过限制时）
  Future<void> deleteOldestHistory() async {
    final db = await database;
    await db.delete(
      AppConstants.tableHistory,
      where: 'id = (SELECT id FROM ${AppConstants.tableHistory} ORDER BY scan_time ASC LIMIT 1)',
    );
  }

  /// 关闭数据库
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
