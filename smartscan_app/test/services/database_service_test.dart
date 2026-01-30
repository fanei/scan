import 'package:flutter_test/flutter_test.dart';
import 'package:smartscan/services/database_service.dart';
import 'package:smartscan/models/history_item.dart';
import 'package:smartscan/models/qr_type.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // 初始化 sqflite_ffi 用于测试
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseService service;

  setUp(() async {
    service = DatabaseService();
    // 清空之前的数据
    await service.clearAllHistory();
  });

  tearDown(() async {
    await service.clearAllHistory();
  });

  group('DatabaseService - 基本操作', () {
    test('数据库实例是单例', () {
      final service1 = DatabaseService();
      final service2 = DatabaseService();
      
      expect(service1, same(service2));
    });

    test('数据库可以正常初始化', () async {
      final db = await service.database;
      expect(db, isNotNull);
      expect(db.isOpen, true);
    });
  });

  group('DatabaseService - 插入记录', () {
    test('插入单条记录成功', () async {
      final item = HistoryItem(
        id: 0, // id 会被忽略
        type: QRType.url,
        content: 'https://example.com',
        scanTime: DateTime(2026, 1, 30),
      );

      final id = await service.insertScanHistory(item);
      
      expect(id, greaterThan(0));
    });

    test('插入多条记录', () async {
      final items = [
        HistoryItem(
          id: 0,
          type: QRType.url,
          content: 'https://example1.com',
          scanTime: DateTime(2026, 1, 30, 10, 0),
        ),
        HistoryItem(
          id: 0,
          type: QRType.phone,
          content: 'tel:13800138000',
          scanTime: DateTime(2026, 1, 30, 11, 0),
        ),
        HistoryItem(
          id: 0,
          type: QRType.text,
          content: 'Some text',
          scanTime: DateTime(2026, 1, 30, 12, 0),
        ),
      ];

      for (var item in items) {
        await service.insertScanHistory(item);
      }

      final count = await service.getHistoryCount();
      expect(count, 3);
    });

    test('插入完整记录（包含 formattedContent）', () async {
      final item = HistoryItem(
        id: 0,
        type: QRType.wifi,
        content: 'WIFI:T:WPA;S:MyWiFi;P:password;;',
        formattedContent: {
          'ssid': 'MyWiFi',
          'password': 'password',
          'encryption': 'WPA',
        },
        scanTime: DateTime(2026, 1, 30),
        previewImagePath: '/path/to/image.png',
      );

      final id = await service.insertScanHistory(item);
      expect(id, greaterThan(0));

      final retrieved = await service.getHistoryById(id);
      expect(retrieved, isNotNull);
      expect(retrieved!.formattedContent, isNotNull);
      expect(retrieved.formattedContent!['ssid'], 'MyWiFi');
      expect(retrieved.previewImagePath, '/path/to/image.png');
    });
  });

  group('DatabaseService - 查询记录', () {
    test('查询所有记录', () async {
      // 插入测试数据
      await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.url,
        content: 'https://example1.com',
        scanTime: DateTime(2026, 1, 30, 10, 0),
      ));
      await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.text,
        content: 'Text 2',
        scanTime: DateTime(2026, 1, 30, 11, 0),
      ));
      await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.phone,
        content: 'tel:13800138000',
        scanTime: DateTime(2026, 1, 30, 12, 0),
      ));

      final history = await service.getAllHistory();

      expect(history.length, 3);
      // 检查排序（最新的在前）
      expect(history[0].content, 'tel:13800138000');
      expect(history[1].content, 'Text 2');
      expect(history[2].content, 'https://example1.com');
    });

    test('分页查询记录', () async {
      // 插入 10 条记录
      for (int i = 0; i < 10; i++) {
        await service.insertScanHistory(HistoryItem(
          id: 0,
          type: QRType.text,
          content: 'Text $i',
          scanTime: DateTime(2026, 1, 30, 10, i),
        ));
      }

      // 第一页（前 5 条）
      final page1 = await service.getAllHistory(limit: 5, offset: 0);
      expect(page1.length, 5);
      expect(page1[0].content, 'Text 9'); // 最新的

      // 第二页（后 5 条）
      final page2 = await service.getAllHistory(limit: 5, offset: 5);
      expect(page2.length, 5);
      expect(page2[0].content, 'Text 4');
    });

    test('查询空数据库', () async {
      final history = await service.getAllHistory();
      expect(history, isEmpty);
    });

    test('根据 ID 查询记录', () async {
      final id = await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.url,
        content: 'https://example.com',
        scanTime: DateTime(2026, 1, 30),
      ));

      final item = await service.getHistoryById(id);
      
      expect(item, isNotNull);
      expect(item!.id, id);
      expect(item.content, 'https://example.com');
    });

    test('查询不存在的 ID 返回 null', () async {
      final item = await service.getHistoryById(99999);
      expect(item, isNull);
    });
  });

  group('DatabaseService - 搜索记录', () {
    setUp(() async {
      // 插入测试数据
      await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.url,
        content: 'https://google.com',
        scanTime: DateTime(2026, 1, 30, 10, 0),
      ));
      await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.url,
        content: 'https://github.com',
        scanTime: DateTime(2026, 1, 30, 11, 0),
      ));
      await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.text,
        content: 'Hello Google',
        scanTime: DateTime(2026, 1, 30, 12, 0),
      ));
      await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.phone,
        content: 'tel:13800138000',
        scanTime: DateTime(2026, 1, 30, 13, 0),
      ));
    });

    test('搜索匹配的记录', () async {
      final results = await service.searchHistory('google');
      
      expect(results.length, 2);
      expect(results.any((item) => item.content.contains('google.com')), true);
      expect(results.any((item) => item.content.contains('Google')), true);
    });

    test('搜索大小写不敏感（部分匹配）', () async {
      final results1 = await service.searchHistory('GOOGLE');
      final results2 = await service.searchHistory('google');
      final results3 = await service.searchHistory('Google');
      
      // SQLite LIKE 是大小写不敏感的
      expect(results1.length, results2.length);
      expect(results2.length, results3.length);
    });

    test('搜索无结果', () async {
      final results = await service.searchHistory('notfound');
      expect(results, isEmpty);
    });

    test('搜索空字符串返回所有记录', () async {
      final results = await service.searchHistory('');
      expect(results.length, 4);
    });

    test('搜索数字', () async {
      final results = await service.searchHistory('138');
      
      expect(results.length, 1);
      expect(results[0].content, 'tel:13800138000');
    });
  });

  group('DatabaseService - 按类型查询', () {
    setUp(() async {
      // 插入不同类型的记录
      await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.url,
        content: 'https://example1.com',
        scanTime: DateTime(2026, 1, 30, 10, 0),
      ));
      await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.url,
        content: 'https://example2.com',
        scanTime: DateTime(2026, 1, 30, 11, 0),
      ));
      await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.phone,
        content: 'tel:13800138000',
        scanTime: DateTime(2026, 1, 30, 12, 0),
      ));
      await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.text,
        content: 'Some text',
        scanTime: DateTime(2026, 1, 30, 13, 0),
      ));
    });

    test('查询 URL 类型', () async {
      final results = await service.getHistoryByType(QRType.url);
      
      expect(results.length, 2);
      expect(results.every((item) => item.type == QRType.url), true);
    });

    test('查询电话类型', () async {
      final results = await service.getHistoryByType(QRType.phone);
      
      expect(results.length, 1);
      expect(results[0].type, QRType.phone);
    });

    test('查询不存在的类型', () async {
      final results = await service.getHistoryByType(QRType.wifi);
      expect(results, isEmpty);
    });

    test('按类型查询结果按时间排序', () async {
      final results = await service.getHistoryByType(QRType.url);
      
      expect(results.length, 2);
      // 最新的在前
      expect(results[0].content, 'https://example2.com');
      expect(results[1].content, 'https://example1.com');
    });
  });

  group('DatabaseService - 删除记录', () {
    test('删除单条记录', () async {
      final id = await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.url,
        content: 'https://example.com',
        scanTime: DateTime(2026, 1, 30),
      ));

      final count1 = await service.getHistoryCount();
      expect(count1, 1);

      final deleted = await service.deleteHistory(id);
      expect(deleted, 1);

      final count2 = await service.getHistoryCount();
      expect(count2, 0);

      final item = await service.getHistoryById(id);
      expect(item, isNull);
    });

    test('删除不存在的记录', () async {
      final deleted = await service.deleteHistory(99999);
      expect(deleted, 0);
    });

    test('清空所有记录', () async {
      // 插入多条记录
      for (int i = 0; i < 5; i++) {
        await service.insertScanHistory(HistoryItem(
          id: 0,
          type: QRType.text,
          content: 'Text $i',
          scanTime: DateTime(2026, 1, 30, 10, i),
        ));
      }

      final count1 = await service.getHistoryCount();
      expect(count1, 5);

      final deleted = await service.clearAllHistory();
      expect(deleted, 5);

      final count2 = await service.getHistoryCount();
      expect(count2, 0);

      final history = await service.getAllHistory();
      expect(history, isEmpty);
    });

    test('清空已空的数据库', () async {
      final deleted = await service.clearAllHistory();
      expect(deleted, 0);
    });
  });

  group('DatabaseService - 记录数量统计', () {
    test('空数据库计数为 0', () async {
      final count = await service.getHistoryCount();
      expect(count, 0);
    });

    test('插入记录后计数增加', () async {
      for (int i = 0; i < 10; i++) {
        await service.insertScanHistory(HistoryItem(
          id: 0,
          type: QRType.text,
          content: 'Text $i',
          scanTime: DateTime(2026, 1, 30),
        ));
      }

      final count = await service.getHistoryCount();
      expect(count, 10);
    });

    test('删除记录后计数减少', () async {
      final id1 = await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.text,
        content: 'Text 1',
        scanTime: DateTime(2026, 1, 30),
      ));
      final id2 = await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.text,
        content: 'Text 2',
        scanTime: DateTime(2026, 1, 30),
      ));

      final count1 = await service.getHistoryCount();
      expect(count1, 2);

      await service.deleteHistory(id1);

      final count2 = await service.getHistoryCount();
      expect(count2, 1);
    });

    test('检查历史记录是否已满', () async {
      final isFull1 = await service.isHistoryFull();
      expect(isFull1, false);

      // 插入大量记录（假设最大限制是 1000）
      for (int i = 0; i < 1001; i++) {
        await service.insertScanHistory(HistoryItem(
          id: 0,
          type: QRType.text,
          content: 'Text $i',
          scanTime: DateTime(2026, 1, 30),
        ));
      }

      final isFull2 = await service.isHistoryFull();
      expect(isFull2, true);
    });
  });

  group('DatabaseService - 删除最旧记录', () {
    test('删除最旧的记录', () async {
      // 插入 3 条记录，时间递增
      await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.text,
        content: 'Oldest',
        scanTime: DateTime(2026, 1, 30, 10, 0),
      ));
      await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.text,
        content: 'Middle',
        scanTime: DateTime(2026, 1, 30, 11, 0),
      ));
      await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.text,
        content: 'Newest',
        scanTime: DateTime(2026, 1, 30, 12, 0),
      ));

      final count1 = await service.getHistoryCount();
      expect(count1, 3);

      await service.deleteOldestHistory();

      final count2 = await service.getHistoryCount();
      expect(count2, 2);

      final remaining = await service.getAllHistory();
      expect(remaining.length, 2);
      expect(remaining.any((item) => item.content == 'Oldest'), false);
      expect(remaining.any((item) => item.content == 'Middle'), true);
      expect(remaining.any((item) => item.content == 'Newest'), true);
    });

    test('从空数据库删除最旧记录不报错', () async {
      await service.deleteOldestHistory();
      final count = await service.getHistoryCount();
      expect(count, 0);
    });
  });

  group('DatabaseService - 边界情况', () {
    test('插入空内容', () async {
      final id = await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.text,
        content: '',
        scanTime: DateTime(2026, 1, 30),
      ));

      expect(id, greaterThan(0));
      
      final item = await service.getHistoryById(id);
      expect(item, isNotNull);
      expect(item!.content, '');
    });

    test('插入非常长的内容', () async {
      final longContent = 'a' * 10000;
      final id = await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.text,
        content: longContent,
        scanTime: DateTime(2026, 1, 30),
      ));

      expect(id, greaterThan(0));
      
      final item = await service.getHistoryById(id);
      expect(item, isNotNull);
      expect(item!.content, longContent);
    });

    test('插入特殊字符', () async {
      final specialContent = '特殊字符: \n\t\r"\'\$';
      final id = await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.text,
        content: specialContent,
        scanTime: DateTime(2026, 1, 30),
      ));

      expect(id, greaterThan(0));
      
      final item = await service.getHistoryById(id);
      expect(item, isNotNull);
      expect(item!.content, specialContent);
    });

    test('插入 SQL 注入攻击字符', () async {
      final sqlInjection = "'; DROP TABLE history; --";
      final id = await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.text,
        content: sqlInjection,
        scanTime: DateTime(2026, 1, 30),
      ));

      expect(id, greaterThan(0));
      
      // 确保表还存在
      final count = await service.getHistoryCount();
      expect(count, 1);

      final item = await service.getHistoryById(id);
      expect(item, isNotNull);
      expect(item!.content, sqlInjection);
    });

    test('极端时间戳', () async {
      final pastTime = DateTime(1970, 1, 1);
      final futureTime = DateTime(2099, 12, 31);

      final id1 = await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.text,
        content: 'past',
        scanTime: pastTime,
      ));

      final id2 = await service.insertScanHistory(HistoryItem(
        id: 0,
        type: QRType.text,
        content: 'future',
        scanTime: futureTime,
      ));

      final item1 = await service.getHistoryById(id1);
      final item2 = await service.getHistoryById(id2);

      expect(item1!.scanTime, pastTime);
      expect(item2!.scanTime, futureTime);
    });
  });

  group('DatabaseService - 性能测试', () {
    test('批量插入 100 条记录', () async {
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 100; i++) {
        await service.insertScanHistory(HistoryItem(
          id: 0,
          type: QRType.text,
          content: 'Text $i',
          scanTime: DateTime(2026, 1, 30, 10, i % 60),
        ));
      }

      stopwatch.stop();

      final count = await service.getHistoryCount();
      expect(count, 100);

      // 100 条插入应该在 5 秒内完成
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });

    test('查询大量记录性能', () async {
      // 先插入 500 条记录
      for (int i = 0; i < 500; i++) {
        await service.insertScanHistory(HistoryItem(
          id: 0,
          type: QRType.text,
          content: 'Text $i',
          scanTime: DateTime(2026, 1, 30, 10, i % 60),
        ));
      }

      final stopwatch = Stopwatch()..start();
      final history = await service.getAllHistory();
      stopwatch.stop();

      expect(history.length, 500);
      
      // 查询 500 条应该在 1 秒内完成
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    test('搜索大量记录性能', () async {
      // 插入 200 条记录
      for (int i = 0; i < 200; i++) {
        await service.insertScanHistory(HistoryItem(
          id: 0,
          type: QRType.text,
          content: 'Test item number $i',
          scanTime: DateTime(2026, 1, 30),
        ));
      }

      final stopwatch = Stopwatch()..start();
      final results = await service.searchHistory('number');
      stopwatch.stop();

      expect(results.length, 200);
      
      // 搜索应该在 500ms 内完成
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });
  });
}
