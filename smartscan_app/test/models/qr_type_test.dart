import 'package:flutter_test/flutter_test.dart';
import 'package:smartscan/models/qr_type.dart';

void main() {
  group('QRType - fromString', () {
    test('解析 URL 类型', () {
      expect(QRType.fromString('url'), QRType.url);
      expect(QRType.fromString('URL'), QRType.url);
      expect(QRType.fromString('Url'), QRType.url);
    });

    test('解析文本类型', () {
      expect(QRType.fromString('text'), QRType.text);
      expect(QRType.fromString('TEXT'), QRType.text);
    });

    test('解析联系人类型', () {
      expect(QRType.fromString('contact'), QRType.contact);
      expect(QRType.fromString('CONTACT'), QRType.contact);
    });

    test('解析 WiFi 类型', () {
      expect(QRType.fromString('wifi'), QRType.wifi);
      expect(QRType.fromString('WIFI'), QRType.wifi);
      expect(QRType.fromString('WiFi'), QRType.wifi);
    });

    test('解析电话类型', () {
      expect(QRType.fromString('phone'), QRType.phone);
      expect(QRType.fromString('PHONE'), QRType.phone);
    });

    test('解析短信类型', () {
      expect(QRType.fromString('sms'), QRType.sms);
      expect(QRType.fromString('SMS'), QRType.sms);
    });

    test('未知字符串返回 unknown', () {
      expect(QRType.fromString('invalid'), QRType.unknown);
      expect(QRType.fromString(''), QRType.unknown);
      expect(QRType.fromString('random'), QRType.unknown);
    });
  });

  group('QRType - detectFromContent', () {
    group('检测 URL', () {
      test('HTTP URL', () {
        expect(QRType.detectFromContent('http://example.com'), QRType.url);
        expect(QRType.detectFromContent('http://www.google.com'), QRType.url);
        expect(QRType.detectFromContent('http://github.com/user/repo'), QRType.url);
      });

      test('HTTPS URL', () {
        expect(QRType.detectFromContent('https://example.com'), QRType.url);
        expect(QRType.detectFromContent('https://www.google.com'), QRType.url);
        expect(QRType.detectFromContent('https://github.com/fanei/scan'), QRType.url);
      });

      test('带参数的 URL', () {
        expect(QRType.detectFromContent('https://example.com?param=value'), QRType.url);
        expect(QRType.detectFromContent('https://example.com/path?a=1&b=2'), QRType.url);
      });

      test('URL 片段', () {
        expect(QRType.detectFromContent('https://example.com#section'), QRType.url);
      });
    });

    group('检测电话', () {
      test('标准 tel: 格式', () {
        expect(QRType.detectFromContent('tel:+8613800138000'), QRType.phone);
        expect(QRType.detectFromContent('tel:13800138000'), QRType.phone);
        expect(QRType.detectFromContent('tel:+1234567890'), QRType.phone);
      });

      test('tel: 大小写', () {
        expect(QRType.detectFromContent('tel:123456789'), QRType.phone);
        expect(QRType.detectFromContent('TEL:123456789'), QRType.text); // 区分大小写
      });
    });

    group('检测短信', () {
      test('sms: 格式', () {
        expect(QRType.detectFromContent('sms:13800138000'), QRType.sms);
        expect(QRType.detectFromContent('sms:+8613800138000'), QRType.sms);
      });

      test('smsto: 格式', () {
        expect(QRType.detectFromContent('smsto:13800138000'), QRType.sms);
        expect(QRType.detectFromContent('smsto:13800138000:Hello'), QRType.sms);
      });

      test('带消息内容', () {
        expect(QRType.detectFromContent('smsto:13800138000:Hello World'), QRType.sms);
      });
    });

    group('检测 WiFi', () {
      test('标准 WIFI: 格式', () {
        expect(QRType.detectFromContent('WIFI:T:WPA;S:MyWiFi;P:password;;'), QRType.wifi);
        expect(QRType.detectFromContent('WIFI:T:WPA2;S:Network;P:pass123;;'), QRType.wifi);
      });

      test('简化 WIFI: 格式', () {
        expect(QRType.detectFromContent('WIFI:S:MyWiFi;P:pass;;'), QRType.wifi);
      });

      test('开放网络', () {
        expect(QRType.detectFromContent('WIFI:T:nopass;S:OpenWiFi;;'), QRType.wifi);
      });
    });

    group('检测联系人', () {
      test('标准 vCard', () {
        const vcard = 'BEGIN:VCARD\nVERSION:3.0\nFN:John Doe\nEND:VCARD';
        expect(QRType.detectFromContent(vcard), QRType.contact);
      });

      test('完整 vCard', () {
        const vcard = '''BEGIN:VCARD
VERSION:3.0
FN:John Doe
TEL:+1234567890
EMAIL:john@example.com
END:VCARD''';
        expect(QRType.detectFromContent(vcard), QRType.contact);
      });

      test('vCard 2.1 版本', () {
        const vcard = 'BEGIN:VCARD\nVERSION:2.1\nFN:John Doe\nEND:VCARD';
        expect(QRType.detectFromContent(vcard), QRType.contact);
      });
    });

    group('检测文本', () {
      test('普通文本', () {
        expect(QRType.detectFromContent('Just some text'), QRType.text);
        expect(QRType.detectFromContent('Hello World'), QRType.text);
      });

      test('数字文本', () {
        expect(QRType.detectFromContent('12345'), QRType.text);
        expect(QRType.detectFromContent('123.456'), QRType.text);
      });

      test('中文文本', () {
        expect(QRType.detectFromContent('你好世界'), QRType.text);
        expect(QRType.detectFromContent('这是一段中文'), QRType.text);
      });

      test('特殊字符', () {
        expect(QRType.detectFromContent('!@#\$%^&*()'), QRType.text);
      });

      test('空字符串', () {
        expect(QRType.detectFromContent(''), QRType.text);
      });

      test('无协议的域名', () {
        expect(QRType.detectFromContent('example.com'), QRType.text);
        expect(QRType.detectFromContent('www.google.com'), QRType.text);
      });
    });

    group('边界情况', () {
      test('协议在中间的内容', () {
        expect(QRType.detectFromContent('This is http://example.com'), QRType.text);
        expect(QRType.detectFromContent('Call tel:123456789'), QRType.text);
      });

      test('包含多个协议', () {
        expect(QRType.detectFromContent('http://example.com and tel:123'), QRType.url);
      });

      test('大小写敏感', () {
        expect(QRType.detectFromContent('HTTP://example.com'), QRType.text); // 区分大小写
        expect(QRType.detectFromContent('http://example.com'), QRType.url);
      });

      test('不完整的格式', () {
        expect(QRType.detectFromContent('http://'), QRType.url);
        expect(QRType.detectFromContent('tel:'), QRType.phone);
        expect(QRType.detectFromContent('WIFI:'), QRType.wifi);
      });
    });
  });

  group('QRType - displayName', () {
    test('获取所有类型的显示名称', () {
      expect(QRType.url.displayName, '网址');
      expect(QRType.text.displayName, '文本');
      expect(QRType.contact.displayName, '联系人');
      expect(QRType.wifi.displayName, 'WiFi');
      expect(QRType.phone.displayName, '电话');
      expect(QRType.sms.displayName, '短信');
      expect(QRType.unknown.displayName, '未知');
    });
  });

  group('QRType - iconName', () {
    test('获取所有类型的图标名称', () {
      expect(QRType.url.iconName, 'link');
      expect(QRType.text.iconName, 'text_fields');
      expect(QRType.contact.iconName, 'person');
      expect(QRType.wifi.iconName, 'wifi');
      expect(QRType.phone.iconName, 'phone');
      expect(QRType.sms.iconName, 'message');
      expect(QRType.unknown.iconName, 'help_outline');
    });
  });

  group('QRType - 枚举属性', () {
    test('所有枚举值存在', () {
      expect(QRType.values, contains(QRType.url));
      expect(QRType.values, contains(QRType.text));
      expect(QRType.values, contains(QRType.contact));
      expect(QRType.values, contains(QRType.wifi));
      expect(QRType.values, contains(QRType.phone));
      expect(QRType.values, contains(QRType.sms));
      expect(QRType.values, contains(QRType.unknown));
    });

    test('枚举数量正确', () {
      expect(QRType.values.length, 7);
    });

    test('toString 格式正确', () {
      expect(QRType.url.toString(), 'QRType.url');
      expect(QRType.text.toString(), 'QRType.text');
      expect(QRType.contact.toString(), 'QRType.contact');
    });
  });

  group('QRType - 实际扫描场景测试', () {
    test('Google 搜索 URL', () {
      expect(
        QRType.detectFromContent('https://www.google.com/search?q=flutter'),
        QRType.url,
      );
    });

    test('GitHub 项目链接', () {
      expect(
        QRType.detectFromContent('https://github.com/flutter/flutter'),
        QRType.url,
      );
    });

    test('中国手机号', () {
      expect(QRType.detectFromContent('tel:13800138000'), QRType.phone);
      expect(QRType.detectFromContent('tel:+8613800138000'), QRType.phone);
    });

    test('美国手机号', () {
      expect(QRType.detectFromContent('tel:+1234567890'), QRType.phone);
    });

    test('家庭 WiFi', () {
      expect(
        QRType.detectFromContent('WIFI:T:WPA2;S:HomeNetwork;P:mypassword123;;'),
        QRType.wifi,
      );
    });

    test('办公室 WiFi', () {
      expect(
        QRType.detectFromContent('WIFI:T:WPA;S:OfficeWiFi;P:securepass;;'),
        QRType.wifi,
      );
    });

    test('名片 vCard', () {
      const businessCard = '''BEGIN:VCARD
VERSION:3.0
FN:张三
ORG:科技公司
TEL:+8613800138000
EMAIL:zhangsan@example.com
END:VCARD''';
      expect(QRType.detectFromContent(businessCard), QRType.contact);
    });

    test('短信邀请', () {
      expect(
        QRType.detectFromContent('smsto:13800138000:您好，我是张三'),
        QRType.sms,
      );
    });

    test('产品序列号', () {
      expect(QRType.detectFromContent('SN:ABC123456789'), QRType.text);
    });

    test('票务代码', () {
      expect(QRType.detectFromContent('TICKET-2026-001'), QRType.text);
    });
  });

  group('QRType - fromString 和 detectFromContent 一致性', () {
    test('所有类型都能正确往返', () {
      for (var type in QRType.values) {
        if (type == QRType.unknown) continue;
        
        final typeString = type.toString().split('.').last;
        final parsedType = QRType.fromString(typeString);
        
        expect(parsedType, type);
      }
    });
  });

  group('QRType - 性能测试', () {
    test('detectFromContent 快速检测', () {
      final stopwatch = Stopwatch()..start();
      
      for (int i = 0; i < 1000; i++) {
        QRType.detectFromContent('https://example.com');
        QRType.detectFromContent('tel:13800138000');
        QRType.detectFromContent('WIFI:T:WPA;S:Test;P:pass;;');
        QRType.detectFromContent('Just text');
      }
      
      stopwatch.stop();
      
      // 4000 次检测应该在 100ms 内完成
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });
}
