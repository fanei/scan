# SmartScan 图标生成器

这个文件夹包含了 SmartScan 应用图标的设计和生成工具。

---

## 📁 文件说明

- **icon.svg** - SVG 格式的图标源文件
- **icon_generator.dart** - Dart 代码生成器（高级）
- **generate_icon.html** - HTML/Canvas 图标生成器（推荐）⭐
- **README.md** - 本说明文件

---

## 🎨 图标设计

### 设计元素
- **渐变绿色背景**：从 #4CAF50 到 #2E7D32
- **白色扫描框**：四个角的扫描框轮廓
- **QR 点阵**：中心的白色点阵图案
- **圆角矩形**：符合 Material Design 3 和 iOS 风格

### 设计理念
- 简洁现代
- 高识别度
- 符合 Material Design 规范
- 在所有尺寸下都清晰

---

## 🚀 使用方法

### 方法 1：使用 HTML 生成器（最简单）⭐

1. **打开生成器**
   ```bash
   open generate_icon.html
   ```
   或直接在浏览器中打开该文件

2. **下载图标**
   - 页面会自动生成预览
   - 点击"下载图标"按钮
   - 保存为 `smartscan_icon_1024.png`

3. **移动到项目**
   ```bash
   mv smartscan_icon_1024.png ../smartscan_app/assets/icon/icon.png
   ```

### 方法 2：使用 SVG（需要转换工具）

**在线转换**：
1. 上传 `icon.svg` 到以下网站：
   - https://cloudconvert.com/svg-to-png
   - https://www.adobe.com/express/feature/image/convert/svg-to-png
   
2. 设置尺寸为 1024x1024
3. 下载 PNG

**命令行转换**（需要安装 ImageMagick 或 Inkscape）：
```bash
# 使用 Inkscape
inkscape icon.svg -w 1024 -h 1024 -o icon.png

# 或使用 ImageMagick
convert -background none -size 1024x1024 icon.svg icon.png
```

### 方法 3：使用 Dart 生成器（开发者）

1. 创建临时 Flutter 项目
2. 复制 `icon_generator.dart`
3. 运行生成器

---

## 📱 配置应用图标

### 步骤 1：准备图标文件

确保你有一个 1024x1024 的 PNG 图标文件。

```bash
# 创建 assets/icon 目录
mkdir -p ../smartscan_app/assets/icon

# 复制图标到项目（假设你已生成 smartscan_icon_1024.png）
cp smartscan_icon_1024.png ../smartscan_app/assets/icon/icon.png
```

### 步骤 2：配置 pubspec.yaml

在 `smartscan_app/pubspec.yaml` 中添加：

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
  min_sdk_android: 21
  
  # Android Adaptive Icon (可选)
  adaptive_icon_background: "#4CAF50"
  adaptive_icon_foreground: "assets/icon/icon.png"
  
  # iOS (可选，移除 alpha 通道)
  remove_alpha_ios: true
```

### 步骤 3：生成所有尺寸

```bash
cd ../smartscan_app
flutter pub get
flutter pub run flutter_launcher_icons
```

### 步骤 4：重新构建应用

```bash
# 清理
flutter clean

# 重新构建
flutter build apk --release

# 或运行
flutter run
```

---

## 📏 所需尺寸

### Android
- **xxxhdpi**: 192x192 px
- **xxhdpi**: 144x144 px
- **xhdpi**: 96x96 px
- **hdpi**: 72x72 px
- **mdpi**: 48x48 px

### iOS
- **App Store**: 1024x1024 px
- **iPhone (@3x)**: 180x180 px
- **iPhone (@2x)**: 120x120 px
- **iPad Pro**: 167x167 px
- **iPad**: 152x152 px

### Google Play
- **Feature Graphic**: 512x512 px

---

## 🎯 快速开始

最快的方法：

```bash
# 1. 在浏览器打开生成器
open generate_icon.html

# 2. 下载图标并重命名
# (在浏览器中点击"下载图标"按钮)

# 3. 移动到项目
mkdir -p ../smartscan_app/assets/icon
mv ~/Downloads/smartscan_icon_1024.png ../smartscan_app/assets/icon/icon.png

# 4. 配置 flutter_launcher_icons（已完成）
# 查看 ../smartscan_app/pubspec.yaml

# 5. 生成所有尺寸
cd ../smartscan_app
flutter pub run flutter_launcher_icons

# 6. 重新构建
flutter clean
flutter build apk --release
```

---

## 🔧 高级选项

### Android Adaptive Icon

如果你想为 Android 8.0+ 创建 Adaptive Icon：

1. **分离前景和背景**
   - 前景：扫描框 + QR 点（透明背景）
   - 背景：纯色或渐变

2. **修改配置**
   ```yaml
   flutter_launcher_icons:
     android: true
     adaptive_icon_background: "#4CAF50"
     adaptive_icon_foreground: "assets/icon/foreground.png"
   ```

### iOS 自定义

iOS 会自动添加圆角，确保：
- 使用方形图标
- 重要内容远离边缘
- 不要预先添加圆角

---

## 🎨 自定义图标

### 修改颜色

在 `generate_icon.html` 中找到这些行：

```javascript
// 修改渐变颜色
gradient.addColorStop(0, '#4CAF50');  // 起始颜色
gradient.addColorStop(1, '#2E7D32');  // 结束颜色

// 修改前景色
ctx.strokeStyle = '#FFFFFF';  // 扫描框颜色
ctx.fillStyle = '#FFFFFF';    // 点阵颜色
```

### 修改图案

调整这些参数：

```javascript
const cornerSize = size * 0.18;   // 角的大小
const margin = size * 0.22;       // 边距
const dotRadius = size * 0.028;   // 点的大小
const spacing = size * 0.08;      // 点的间距
```

---

## ✅ 检查清单

生成图标后，检查：

- [ ] 图标在白色背景下清晰
- [ ] 图标在深色背景下清晰
- [ ] 在小尺寸（48x48）下依然可辨识
- [ ] 在大尺寸（1024x1024）下清晰
- [ ] 符合 Material Design 规范
- [ ] 符合 iOS 设计规范
- [ ] 在真机上测试显示效果

---

## 🐛 常见问题

### Q: 图标生成后不显示？
**A**: 
1. 确保路径正确
2. 运行 `flutter clean`
3. 重新构建应用
4. 卸载旧版本应用再安装

### Q: 图标质量不好？
**A**: 
1. 确保源图标是 1024x1024
2. 使用 PNG 格式
3. 避免有损压缩

### Q: Android/iOS 显示不一致？
**A**: 
- Android: 会显示圆角矩形
- iOS: 系统自动添加圆角
- 这是正常的，两个平台风格不同

---

## 📚 参考资源

- [Material Design Icons](https://material.io/design/iconography)
- [iOS Icon Guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons)
- [Android Adaptive Icons](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive)

---

**创建日期**: 2026年1月29日  
**版本**: 1.0.0  
**状态**: ✅ 准备就绪
