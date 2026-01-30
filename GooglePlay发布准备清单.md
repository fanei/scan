# SmartScan - Google Play 发布准备清单

**创建日期**：2026年1月29日  
**应用名称**：SmartScan  
**目标平台**：Android（Google Play）

---

## ✅ 已完成的准备工作

### 1. 国际化支持 ✅
- [x] 支持英文
- [x] 支持中文
- [x] 所有界面文本已国际化
- [x] 自动适应系统语言

### 2. 权限配置 ✅
- [x] 相机权限
- [x] 存储权限
- [x] 网络权限
- [x] 权限说明文本

### 3. 应用基础信息 ✅
- [x] 应用包名：com.smartscan.smartscan
- [x] 版本号：1.0.0+1
- [x] 最低 SDK：Android 5.0 (API 21)
- [x] 目标 SDK：Android 14 (API 34)

---

## 📝 待完成事项

### A. 应用资源（必须）

#### 1. 应用图标（app icon）
- [ ] 设计应用图标
  - 尺寸：512x512 px（高分辨率）
  - 格式：PNG（透明背景或纯色背景）
  - 风格：简洁、易识别、代表 QR 扫描
- [ ] 生成不同尺寸
  - mdpi: 48x48 px
  - hdpi: 72x72 px
  - xhdpi: 96x96 px
  - xxhdpi: 144x144 px
  - xxxhdpi: 192x192 px
- [ ] 替换默认图标
  - Android: `android/app/src/main/res/mipmap-*/ic_launcher.png`

#### 2. Feature Graphic（特色图片）
- [ ] 设计特色图片
  - 尺寸：1024x500 px
  - 格式：PNG 或 JPG
  - 内容：展示应用核心功能
  - 无边框、无文字（Google Play 会添加）

#### 3. 应用截图（Screenshots）
至少需要 2 张，建议 4-8 张

- [ ] 扫描页面截图
- [ ] 扫描结果页面截图
- [ ] 生成页面截图
- [ ] 历史记录页面截图
- [ ] （可选）功能演示截图

**要求**：
- 尺寸：手机 16:9 或 9:16
- 格式：PNG 或 JPG
- 最小：320px
- 最大：3840px

#### 4. 宣传视频（可选）
- [ ] 录制应用演示视频
  - 时长：30秒 - 2分钟
  - 格式：YouTube 视频链接
  - 内容：核心功能演示

---

### B. 应用商店列表信息

#### 1. 应用标题
**英文**：
```
SmartScan - QR & Barcode Scanner
```

**中文**：
```
智能扫码 - 二维码扫描生成工具
```

**要求**：
- 最多 50 个字符
- 包含关键词（QR、Barcode、Scanner）

#### 2. 简短描述
**英文**：
```
Fast, secure, and smart QR code scanner with generator. Scan QR codes, barcodes, and generate custom QR codes instantly.
```

**中文**：
```
快速、安全、智能的二维码扫描和生成工具。扫描各种二维码、条码，并快速生成自定义二维码。
```

**要求**：
- 最多 80 个字符

#### 3. 完整描述
需要撰写详细的应用描述（最多 4000 个字符）

**建议结构**：
```
【核心功能】
✅ 快速扫描
✅ 智能生成
✅ 历史记录

【功能特色】
• 快速扫描：0.5秒内识别
• 多格式支持：QR、EAN、UPC、Code 128等
• 智能生成：支持网址、WiFi、联系人等
• 历史管理：自动保存，搜索方便

【为什么选择 SmartScan？】
• 界面简洁，操作直观
• 无广告干扰
• 注重隐私和安全
• 持续更新

【支持的QR码类型】
• 网址 URL
• 纯文本
• WiFi 网络
• 电话号码
• 短信
• 联系人

【即将推出】
• 批量扫描
• 云端同步
• 更多自定义选项

【联系我们】
如有问题或建议，请联系：support@smartscan.app
```

---

### C. 分类和标签

#### 1. 应用分类
**主分类**：工具（Tools）  
**次分类**：生产力（Productivity）

#### 2. 标签（Tags）
- QR Code
- Barcode
- Scanner
- QR Generator
- Productivity
- Utilities

---

### D. 隐私政策和用户协议

#### 1. 隐私政策（Privacy Policy）
**必须项**，需要创建隐私政策页面

**必须说明**：
- [ ] 收集哪些数据
  - 相机权限用途
  - 存储权限用途
  - 数据存储位置（本地）
- [ ] 如何使用数据
  - 仅本地存储
  - 不上传到服务器
- [ ] 数据分享
  - 不与第三方分享
- [ ] 用户权利
  - 删除数据
  - 导出数据

**托管选项**：
- GitHub Pages（免费）
- Google Sites（免费）
- 自己的网站

#### 2. 用户协议（Terms of Service）
建议创建，虽然不是必须

**包含内容**：
- 使用条款
- 免责声明
- 知识产权
- 服务变更

---

### E. 内容分级（Content Rating）

需要完成 Google Play 的内容分级问卷

**我们的应用**：
- [ ] 无暴力内容
- [ ] 无成人内容
- [ ] 无赌博内容
- [ ] 工具类应用

**预计分级**：适合所有人（Everyone）

---

### F. 应用签名和安全

#### 1. 生成签名密钥
```bash
keytool -genkey -v -keystore ~/smartscan-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias smartscan
```

**重要**：妥善保管密钥！

#### 2. 配置签名
创建 `android/key.properties`：
```properties
storePassword=<密码>
keyPassword=<密码>
keyAlias=smartscan
storeFile=<密钥文件路径>
```

#### 3. 修改 build.gradle
配置 release 签名

#### 4. 构建 Release APK
```bash
flutter build appbundle --release
```

生成的文件：`build/app/outputs/bundle/release/app-release.aab`

---

### G. 测试

#### 1. Alpha/Beta 测试
- [ ] 创建封闭测试轨道
- [ ] 邀请 20-50 个测试用户
- [ ] 收集反馈
- [ ] 修复问题

#### 2. 设备测试
- [ ] 测试不同品牌（小米、华为、三星等）
- [ ] 测试不同 Android 版本（5.0 - 14）
- [ ] 测试不同屏幕尺寸

#### 3. 功能测试
- [ ] 所有功能正常
- [ ] 权限申请正常
- [ ] 无崩溃
- [ ] 性能良好

---

### H. Google Play Console 设置

#### 1. 创建应用
- [ ] 登录 Google Play Console
- [ ] 创建新应用
- [ ] 选择语言和国家

#### 2. 应用设置
- [ ] 上传应用图标
- [ ] 上传 Feature Graphic
- [ ] 上传截图（中英文各一套）
- [ ] 填写应用描述（中英文）

#### 3. 发布设置
- [ ] 选择国家/地区
- [ ] 设置定价（免费/付费）
- [ ] 配置应用内购买（如果有）

#### 4. 审核准备
- [ ] 完成内容分级
- [ ] 提供隐私政策 URL
- [ ] 填写目标受众
- [ ] 声明广告（我们没有广告）

---

## 📊 发布时间线

### Week 1 ✅（已完成）
- [x] 项目搭建
- [x] 核心功能开发
- [x] 国际化配置
- [x] 基础测试

### Week 2-3（当前）
- [ ] UI/UX 优化
- [ ] 功能完善
- [ ] 准备发布资源
  - [ ] 应用图标设计
  - [ ] 截图制作
  - [ ] 描述撰写
  - [ ] 隐私政策

### Week 4-5
- [ ] 内部测试
- [ ] Alpha 测试
- [ ] Bug 修复
- [ ] 性能优化

### Week 6
- [ ] Beta 测试
- [ ] 最终优化
- [ ] 提交审核
- [ ] 正式发布

---

## ⚠️ 重要提醒

### 发布前必须完成
1. ✅ **国际化**（已完成）
2. ⏳ **隐私政策**（必须）
3. ⏳ **应用图标**（必须）
4. ⏳ **截图**（至少 2 张）
5. ⏳ **应用描述**（必须）
6. ⏳ **内容分级**（必须）

### Google Play 审核注意事项
- 通常需要 3-7 天审核
- 首次发布可能更久
- 确保符合 Google Play 政策
- 准备好回应审核意见

---

## 📞 资源和帮助

### Google Play 官方资源
- [Google Play Console](https://play.google.com/console)
- [发布指南](https://support.google.com/googleplay/android-developer)
- [政策中心](https://play.google.com/about/developer-content-policy/)

### 设计资源
- [Material Design](https://material.io/)
- [Android Icon Design](https://developer.android.com/distribute/google-play/resources/icon-design-specifications)
- [Screenshot Guidelines](https://support.google.com/googleplay/android-developer/answer/9866151)

---

## 🎯 总结

**国际化已完成，随时可以开始准备 Google Play 发布！**

**优先级行动**：
1. 🔴 **高优先级**：隐私政策（必须有）
2. 🔴 **高优先级**：应用图标（视觉第一印象）
3. 🟡 **中优先级**：截图（展示功能）
4. 🟡 **中优先级**：应用描述（吸引用户）
5. 🟢 **低优先级**：宣传视频（加分项）

---

**当前状态**：✅ 技术准备完成，营销资源待准备  
**预计发布**：4-6周后
