import 'package:flutter_test/flutter_test.dart';
import 'package:smartscan/services/qr_generator_service.dart';
import 'package:smartscan/models/qr_type.dart';

void main() {
  late QRGeneratorService service;

  setUp(() {
    service = QRGeneratorService();
  });

  group('QRGeneratorService - validateData', () {
    group('URL 验证', () {
      test('验证完整的 HTTP(S) URL', () {
        expect(service.validateData('http://example.com', QRType.url), true);
        expect(service.validateData('https://www.google.com', QRType.url), true);
      });

      test('验证无协议的域名', () {
        expect(service.validateData('example.com', QRType.url), true);
        expect(service.validateData('www.google.com', QRType.url), true);
      });

      test('拒绝无效的 URL', () {
        expect(service.validateData('not a url', QRType.url), false);
        expect(service.validateData('ab', QRType.url), false);
      });

      test('拒绝空字符串', () {
        expect(service.validateData('', QRType.url), false);
      });
    });

    group('电话号码验证', () {
      test('验证标准号码', () {
        expect(service.validateData('13800138000', QRType.phone), true);
        expect(service.validateData('+8613800138000', QRType.phone), true);
      });

      test('验证带 tel: 前缀的号码', () {
        expect(service.validateData('tel:13800138000', QRType.phone), true);
        expect(service.validateData('tel:+8613800138000', QRType.phone), true);
      });

      test('拒绝无效号码', () {
        expect(service.validateData('123', QRType.phone), false);
        expect(service.validateData('abc123', QRType.phone), false);
      });
    });

    group('短信验证', () {
      test('验证标准短信格式', () {
        expect(service.validateData('smsto:13800138000:Hello', QRType.sms), true);
        expect(service.validateData('sms:13800138000', QRType.sms), true);
      });

      test('拒绝无效短信格式', () {
        expect(service.validateData('123:message', QRType.sms), false);
        expect(service.validateData('', QRType.sms), false);
      });
    });

    group('WiFi 验证', () {
      test('验证标准 WiFi 格式', () {
        expect(service.validateData('WIFI:T:WPA;S:MyWiFi;P:password;;', QRType.wifi), true);
        expect(service.validateData('S:Network;P:12345678', QRType.wifi), true);
      });

      test('拒绝不完整的 WiFi 格式', () {
        expect(service.validateData('S:MyWiFi', QRType.wifi), false);
        expect(service.validateData('P:password', QRType.wifi), false);
      });
    });

    group('联系人验证', () {
      test('验证标准 vCard', () {
        const vcard = '''BEGIN:VCARD
VERSION:3.0
FN:John Doe
END:VCARD''';
        expect(service.validateData(vcard, QRType.contact), true);
      });

      test('拒绝不完整的 vCard', () {
        expect(service.validateData('BEGIN:VCARD', QRType.contact), false);
        expect(service.validateData('VERSION:3.0', QRType.contact), false);
      });
    });

    group('文本验证', () {
      test('接受任何非空文本', () {
        expect(service.validateData('任何文本', QRType.text), true);
        expect(service.validateData('123', QRType.text), true);
        expect(service.validateData('!@#\$%', QRType.text), true);
      });

      test('拒绝空文本', () {
        expect(service.validateData('', QRType.text), false);
      });
    });
  });

  group('QRGeneratorService - formatData', () {
    group('URL 格式化', () {
      test('为无协议 URL 添加 https://', () {
        expect(service.formatData('example.com', QRType.url), 'https://example.com');
        expect(service.formatData('www.google.com', QRType.url), 'https://www.google.com');
      });

      test('保留已有协议的 URL', () {
        expect(service.formatData('http://example.com', QRType.url), 'http://example.com');
        expect(service.formatData('https://example.com', QRType.url), 'https://example.com');
      });
    });

    group('电话号码格式化', () {
      test('为电话号码添加 tel: 前缀', () {
        expect(service.formatData('13800138000', QRType.phone), 'tel:13800138000');
        expect(service.formatData('+8613800138000', QRType.phone), 'tel:+8613800138000');
      });

      test('保留已有 tel: 前缀', () {
        expect(service.formatData('tel:13800138000', QRType.phone), 'tel:13800138000');
      });
    });

    group('短信格式化', () {
      test('为短信添加 smsto: 前缀', () {
        expect(service.formatData('13800138000', QRType.sms), 'smsto:13800138000');
        expect(service.formatData('13800138000:Hello', QRType.sms), 'smsto:13800138000:Hello');
      });

      test('保留已有 sms/smsto 前缀', () {
        expect(service.formatData('sms:13800138000', QRType.sms), 'sms:13800138000');
        expect(service.formatData('smsto:13800138000:Hi', QRType.sms), 'smsto:13800138000:Hi');
      });
    });

    group('WiFi 格式化', () {
      test('为 WiFi 数据添加 WIFI: 前缀和结尾', () {
        expect(
          service.formatData('T:WPA;S:MyWiFi;P:password', QRType.wifi),
          'WIFI:T:WPA;S:MyWiFi;P:password;;'
        );
      });

      test('保留已有 WIFI: 前缀', () {
        expect(
          service.formatData('WIFI:T:WPA;S:MyWiFi;P:password;;', QRType.wifi),
          'WIFI:T:WPA;S:MyWiFi;P:password;;'
        );
      });
    });

    group('联系人格式化', () {
      test('保持 vCard 格式不变', () {
        const vcard = '''BEGIN:VCARD
VERSION:3.0
FN:John Doe
END:VCARD''';
        expect(service.formatData(vcard, QRType.contact), vcard);
      });
    });

    group('文本格式化', () {
      test('保持文本不变', () {
        expect(service.formatData('Hello World', QRType.text), 'Hello World');
        expect(service.formatData('任意文本', QRType.text), '任意文本');
      });
    });
  });

  group('QRGeneratorService - createWifiData', () {
    test('创建标准 WPA WiFi QR 数据', () {
      final result = service.createWifiData(
        ssid: 'MyWiFi',
        password: 'password123',
      );
      expect(result, 'WIFI:T:WPA;S:MyWiFi;P:password123;H:false;;');
    });

    test('创建 WPA2 WiFi QR 数据', () {
      final result = service.createWifiData(
        ssid: 'SecureNetwork',
        password: 'strongpassword',
        encryption: 'WPA2',
      );
      expect(result, 'WIFI:T:WPA2;S:SecureNetwork;P:strongpassword;H:false;;');
    });

    test('创建隐藏网络 WiFi QR 数据', () {
      final result = service.createWifiData(
        ssid: 'HiddenNet',
        password: 'secret',
        isHidden: true,
      );
      expect(result, 'WIFI:T:WPA;S:HiddenNet;P:secret;H:true;;');
    });

    test('创建开放网络 WiFi QR 数据', () {
      final result = service.createWifiData(
        ssid: 'OpenWiFi',
        password: '',
        encryption: 'nopass',
      );
      expect(result, 'WIFI:T:nopass;S:OpenWiFi;P:;H:false;;');
    });
  });

  group('QRGeneratorService - createContactData', () {
    test('创建基本联系人数据（仅姓名）', () {
      final result = service.createContactData(name: 'John Doe');
      expect(result, contains('BEGIN:VCARD'));
      expect(result, contains('VERSION:3.0'));
      expect(result, contains('FN:John Doe'));
      expect(result, contains('END:VCARD'));
    });

    test('创建完整联系人数据', () {
      final result = service.createContactData(
        name: 'John Doe',
        phone: '+1234567890',
        email: 'john@example.com',
        organization: 'Acme Inc',
        url: 'https://example.com',
      );
      
      expect(result, contains('FN:John Doe'));
      expect(result, contains('TEL:+1234567890'));
      expect(result, contains('EMAIL:john@example.com'));
      expect(result, contains('ORG:Acme Inc'));
      expect(result, contains('URL:https://example.com'));
    });

    test('创建部分信息的联系人数据', () {
      final result = service.createContactData(
        name: 'Jane Smith',
        phone: '13800138000',
      );
      
      expect(result, contains('FN:Jane Smith'));
      expect(result, contains('TEL:13800138000'));
      expect(result, isNot(contains('EMAIL:')));
      expect(result, isNot(contains('ORG:')));
    });
  });

  group('QRGeneratorService - 边界情况', () {
    test('处理空字符串验证', () {
      for (var type in QRType.values) {
        if (type == QRType.text || type == QRType.unknown) {
          expect(service.validateData('', type), false);
        }
      }
    });

    test('处理特殊字符', () {
      expect(service.validateData('https://example.com?param=value&test=1', QRType.url), true);
      expect(service.formatData('https://example.com?param=value', QRType.url), 
             'https://example.com?param=value');
    });

    test('处理中文字符', () {
      expect(service.validateData('你好世界', QRType.text), true);
      expect(service.formatData('你好世界', QRType.text), '你好世界');
      
      final wifiData = service.createWifiData(
        ssid: '我的WiFi',
        password: '密码123',
      );
      expect(wifiData, contains('我的WiFi'));
      expect(wifiData, contains('密码123'));
    });

    test('处理极长的输入', () {
      final longText = 'a' * 1000;
      expect(service.validateData(longText, QRType.text), true);
      expect(service.formatData(longText, QRType.text), longText);
    });
  });
}
