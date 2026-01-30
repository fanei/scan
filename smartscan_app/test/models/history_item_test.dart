import 'package:flutter_test/flutter_test.dart';
import 'package:smartscan/models/history_item.dart';
import 'package:smartscan/models/qr_type.dart';

void main() {
  group('HistoryItem - 构造和属性', () {
    test('创建基本 HistoryItem', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.url,
        content: 'https://example.com',
        scanTime: DateTime(2026, 1, 30, 12, 0),
      );

      expect(item.id, 1);
      expect(item.type, QRType.url);
      expect(item.content, 'https://example.com');
      expect(item.scanTime, DateTime(2026, 1, 30, 12, 0));
      expect(item.formattedContent, null);
      expect(item.previewImagePath, null);
    });

    test('创建完整 HistoryItem', () {
      final item = HistoryItem(
        id: 2,
        type: QRType.wifi,
        content: 'WIFI:T:WPA;S:MyWiFi;P:password;;',
        formattedContent: {
          'ssid': 'MyWiFi',
          'password': 'password',
          'encryption': 'WPA',
        },
        scanTime: DateTime(2026, 1, 30, 12, 30),
        previewImagePath: '/path/to/image.png',
      );

      expect(item.id, 2);
      expect(item.formattedContent, isNotNull);
      expect(item.formattedContent!['ssid'], 'MyWiFi');
      expect(item.previewImagePath, '/path/to/image.png');
    });
  });

  group('HistoryItem - displaySummary', () {
    test('短内容直接返回', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.text,
        content: 'Short text',
        scanTime: DateTime.now(),
      );

      expect(item.displaySummary, 'Short text');
    });

    test('长内容截断为 50 字符', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.text,
        content: 'This is a very long text that exceeds fifty characters in length',
        scanTime: DateTime.now(),
      );

      expect(item.displaySummary, 'This is a very long text that exceeds fifty charac...');
      expect(item.displaySummary.length, 53); // 50 + '...'
    });

    test('正好 50 字符不截断', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.text,
        content: '12345678901234567890123456789012345678901234567890', // 正好 50
        scanTime: DateTime.now(),
      );

      expect(item.displaySummary, '12345678901234567890123456789012345678901234567890');
      expect(item.displaySummary.length, 50);
    });
  });

  group('HistoryItem - toMap/fromMap 序列化', () {
    test('基本序列化和反序列化', () {
      final original = HistoryItem(
        id: 1,
        type: QRType.url,
        content: 'https://example.com',
        scanTime: DateTime(2026, 1, 30, 12, 0),
      );

      final map = original.toMap();
      final restored = HistoryItem.fromMap(map);

      expect(restored.id, original.id);
      expect(restored.type, original.type);
      expect(restored.content, original.content);
      expect(restored.scanTime, original.scanTime);
      expect(restored.formattedContent, null);
      expect(restored.previewImagePath, null);
    });

    test('完整序列化和反序列化', () {
      final original = HistoryItem(
        id: 2,
        type: QRType.contact,
        content: 'BEGIN:VCARD\nFN:John Doe\nEND:VCARD',
        formattedContent: {
          'name': 'John Doe',
          'phone': '+1234567890',
        },
        scanTime: DateTime(2026, 1, 30, 15, 30),
        previewImagePath: '/path/to/image.png',
      );

      final map = original.toMap();
      final restored = HistoryItem.fromMap(map);

      expect(restored.id, original.id);
      expect(restored.type, original.type);
      expect(restored.content, original.content);
      expect(restored.scanTime, original.scanTime);
      expect(restored.formattedContent, isNotNull);
      expect(restored.formattedContent!['name'], 'John Doe');
      expect(restored.formattedContent!['phone'], '+1234567890');
      expect(restored.previewImagePath, '/path/to/image.png');
    });

    test('toMap 格式正确', () {
      final item = HistoryItem(
        id: 3,
        type: QRType.phone,
        content: 'tel:+8613800138000',
        scanTime: DateTime(2026, 1, 30, 12, 0),
      );

      final map = item.toMap();

      expect(map['id'], 3);
      expect(map['type'], 'phone');
      expect(map['content'], 'tel:+8613800138000');
      expect(map['scan_time'], isA<int>());
      expect(map['formatted_content'], null);
      expect(map['preview_image_path'], null);
    });

    test('时间戳转换正确（秒级）', () {
      final scanTime = DateTime(2026, 1, 30, 12, 0, 0);
      final item = HistoryItem(
        id: 1,
        type: QRType.text,
        content: 'test',
        scanTime: scanTime,
      );

      final map = item.toMap();
      final timestamp = map['scan_time'] as int;

      // 检查是秒级时间戳
      expect(timestamp, scanTime.millisecondsSinceEpoch ~/ 1000);

      // 反序列化后时间应该一致
      final restored = HistoryItem.fromMap(map);
      expect(restored.scanTime, scanTime);
    });
  });

  group('HistoryItem - copyWith', () {
    test('复制所有属性', () {
      final original = HistoryItem(
        id: 1,
        type: QRType.url,
        content: 'https://example.com',
        scanTime: DateTime(2026, 1, 30),
      );

      final copied = original.copyWith(
        id: 2,
        type: QRType.text,
        content: 'new content',
        scanTime: DateTime(2026, 2, 1),
      );

      expect(copied.id, 2);
      expect(copied.type, QRType.text);
      expect(copied.content, 'new content');
      expect(copied.scanTime, DateTime(2026, 2, 1));
    });

    test('部分复制', () {
      final original = HistoryItem(
        id: 1,
        type: QRType.url,
        content: 'https://example.com',
        scanTime: DateTime(2026, 1, 30),
      );

      final copied = original.copyWith(content: 'new content');

      expect(copied.id, original.id);
      expect(copied.type, original.type);
      expect(copied.content, 'new content');
      expect(copied.scanTime, original.scanTime);
    });

    test('不传参数返回相同值', () {
      final original = HistoryItem(
        id: 1,
        type: QRType.url,
        content: 'https://example.com',
        scanTime: DateTime(2026, 1, 30),
      );

      final copied = original.copyWith();

      expect(copied.id, original.id);
      expect(copied.type, original.type);
      expect(copied.content, original.content);
      expect(copied.scanTime, original.scanTime);
    });
  });

  group('HistoryItem - 相等性和哈希码', () {
    test('相同 ID 的 HistoryItem 相等', () {
      final item1 = HistoryItem(
        id: 1,
        type: QRType.url,
        content: 'https://example.com',
        scanTime: DateTime.now(),
      );

      final item2 = HistoryItem(
        id: 1,
        type: QRType.text,
        content: 'different content',
        scanTime: DateTime.now(),
      );

      expect(item1, equals(item2));
      expect(item1.hashCode, equals(item2.hashCode));
    });

    test('不同 ID 的 HistoryItem 不相等', () {
      final item1 = HistoryItem(
        id: 1,
        type: QRType.url,
        content: 'https://example.com',
        scanTime: DateTime.now(),
      );

      final item2 = HistoryItem(
        id: 2,
        type: QRType.url,
        content: 'https://example.com',
        scanTime: DateTime.now(),
      );

      expect(item1, isNot(equals(item2)));
    });

    test('自身相等', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.url,
        content: 'https://example.com',
        scanTime: DateTime.now(),
      );

      expect(item, equals(item));
    });
  });

  group('HistoryItem - toString', () {
    test('短内容完整显示', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.text,
        content: 'Short',
        scanTime: DateTime.now(),
      );

      final str = item.toString();
      expect(str, contains('id: 1'));
      expect(str, contains('type: QRType.text'));
      expect(str, contains('Short'));
    });

    test('长内容截断显示', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.text,
        content: 'This is a very long content that should be truncated',
        scanTime: DateTime.now(),
      );

      final str = item.toString();
      expect(str, contains('id: 1'));
      expect(str, contains('This is a very long '));
      expect(str, contains('...'));
    });
  });

  group('HistoryItem - 边界情况', () {
    test('空内容', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.text,
        content: '',
        scanTime: DateTime.now(),
      );

      expect(item.displaySummary, '');
      
      final map = item.toMap();
      final restored = HistoryItem.fromMap(map);
      expect(restored.content, '');
    });

    test('非常长的内容', () {
      final longContent = 'a' * 1000;
      final item = HistoryItem(
        id: 1,
        type: QRType.text,
        content: longContent,
        scanTime: DateTime.now(),
      );

      expect(item.displaySummary.length, 53); // 50 + '...'
      
      final map = item.toMap();
      final restored = HistoryItem.fromMap(map);
      expect(restored.content, longContent);
    });

    test('包含特殊字符的内容', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.text,
        content: '特殊字符: \n\t\r"\'\$',
        scanTime: DateTime.now(),
      );

      final map = item.toMap();
      final restored = HistoryItem.fromMap(map);
      expect(restored.content, '特殊字符: \n\t\r"\'\$');
    });

    test('复杂的 formattedContent', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.contact,
        content: 'vCard data',
        formattedContent: {
          'name': 'John Doe',
          'phones': ['+1234567890', '+0987654321'],
          'emails': ['john@example.com', 'doe@example.com'],
          'nested': {
            'key1': 'value1',
            'key2': 'value2',
          },
        },
        scanTime: DateTime.now(),
      );

      final map = item.toMap();
      final restored = HistoryItem.fromMap(map);

      expect(restored.formattedContent, isNotNull);
      expect(restored.formattedContent!['name'], 'John Doe');
      expect(restored.formattedContent!['phones'], isA<List>());
      expect(restored.formattedContent!['nested'], isA<Map>());
    });

    test('极端时间戳', () {
      // 测试过去和未来的时间
      final pastTime = DateTime(1970, 1, 1);
      final futureTime = DateTime(2099, 12, 31);

      final item1 = HistoryItem(
        id: 1,
        type: QRType.text,
        content: 'past',
        scanTime: pastTime,
      );

      final item2 = HistoryItem(
        id: 2,
        type: QRType.text,
        content: 'future',
        scanTime: futureTime,
      );

      final map1 = item1.toMap();
      final map2 = item2.toMap();

      final restored1 = HistoryItem.fromMap(map1);
      final restored2 = HistoryItem.fromMap(map2);

      expect(restored1.scanTime, pastTime);
      expect(restored2.scanTime, futureTime);
    });
  });

  group('HistoryItem - 不同类型测试', () {
    final testTime = DateTime(2026, 1, 30);

    test('URL 类型', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.url,
        content: 'https://github.com/fanei/scan',
        scanTime: testTime,
      );

      final map = item.toMap();
      expect(map['type'], 'url');

      final restored = HistoryItem.fromMap(map);
      expect(restored.type, QRType.url);
    });

    test('电话类型', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.phone,
        content: 'tel:+8613800138000',
        scanTime: testTime,
      );

      final map = item.toMap();
      expect(map['type'], 'phone');

      final restored = HistoryItem.fromMap(map);
      expect(restored.type, QRType.phone);
    });

    test('WiFi 类型', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.wifi,
        content: 'WIFI:T:WPA;S:MyWiFi;P:password;;',
        scanTime: testTime,
      );

      final map = item.toMap();
      expect(map['type'], 'wifi');

      final restored = HistoryItem.fromMap(map);
      expect(restored.type, QRType.wifi);
    });

    test('联系人类型', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.contact,
        content: 'BEGIN:VCARD\nVERSION:3.0\nFN:John Doe\nEND:VCARD',
        scanTime: testTime,
      );

      final map = item.toMap();
      expect(map['type'], 'contact');

      final restored = HistoryItem.fromMap(map);
      expect(restored.type, QRType.contact);
    });

    test('短信类型', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.sms,
        content: 'smsto:13800138000:Hello',
        scanTime: testTime,
      );

      final map = item.toMap();
      expect(map['type'], 'sms');

      final restored = HistoryItem.fromMap(map);
      expect(restored.type, QRType.sms);
    });

    test('文本类型', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.text,
        content: 'Just some plain text',
        scanTime: testTime,
      );

      final map = item.toMap();
      expect(map['type'], 'text');

      final restored = HistoryItem.fromMap(map);
      expect(restored.type, QRType.text);
    });

    test('未知类型', () {
      final item = HistoryItem(
        id: 1,
        type: QRType.unknown,
        content: 'Unknown data',
        scanTime: testTime,
      );

      final map = item.toMap();
      expect(map['type'], 'unknown');

      final restored = HistoryItem.fromMap(map);
      expect(restored.type, QRType.unknown);
    });
  });
}
