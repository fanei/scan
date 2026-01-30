# 验证 GitHub Pages 部署

## 🔍 快速验证

### 方法 1: 浏览器访问 (推荐)

**隐私政策页面** (最重要):
```
https://fanei.github.io/scan/privacy.html
```

**应用首页**:
```
https://fanei.github.io/scan/
```

---

### 方法 2: 命令行验证

在终端执行以下命令:

```bash
# 检查隐私政策页面
curl -I https://fanei.github.io/scan/privacy.html

# 检查首页
curl -I https://fanei.github.io/scan/
```

**预期结果**: 
- 返回 `HTTP/2 200` 表示成功
- 返回 `404` 表示页面未找到,需要等待或检查配置

---

### 方法 3: 查看部署状态

访问 GitHub Actions 页面:
```
https://github.com/fanei/scan/actions
```

**查看内容**:
- ✅ 绿色勾号: 部署成功
- 🟡 黄色圆圈: 正在部署
- ❌ 红色叉号: 部署失败

---

## ✅ 验证清单

部署成功后,请逐项检查:

### 隐私政策页面

- [ ] 页面能打开 (不是 404)
- [ ] 显示 "SmartScan Privacy Policy" 标题
- [ ] 有中英文切换按钮
- [ ] 点击"简体中文"显示中文内容
- [ ] 点击"English"显示英文内容
- [ ] 联系邮箱显示: faneizn@gmail.com
- [ ] 更新日期: 2026年1月29日
- [ ] 底部显示: © 2026 fanei. All rights reserved.

### 应用首页

- [ ] 页面能打开 (不是 404)
- [ ] 显示 "SmartScan" 标题
- [ ] 有中英文切换按钮
- [ ] 有"隐私政策"导航链接
- [ ] 点击"隐私政策"能跳转到 privacy.html
- [ ] 联系邮箱显示: faneizn@gmail.com
- [ ] 开发者名称显示: fanei

---

## 🐛 常见问题

### Q1: 页面显示 404

**原因**: 
- GitHub Pages 还在部署中 (首次部署需要 5-10 分钟)
- 配置错误

**解决方法**:
1. **等待 5-10 分钟**,然后刷新页面
2. **检查 GitHub Pages 配置**:
   - 访问: https://github.com/fanei/scan/settings/pages
   - 确认 Source 是 "Deploy from a branch"
   - 确认 Branch 是 "main"
   - 确认 Folder 是 "/docs"
3. **查看部署日志**:
   - 访问: https://github.com/fanei/scan/actions
   - 点击最新的 workflow run
   - 查看错误信息

### Q2: 页面内容不对

**原因**: 
- 浏览器缓存

**解决方法**:
- 按 `Ctrl + Shift + R` (Windows/Linux) 或 `Cmd + Shift + R` (Mac) 强制刷新
- 或者使用隐私/无痕模式打开

### Q3: 中英文切换不工作

**原因**: 
- JavaScript 未加载

**解决方法**:
- 打开浏览器开发者工具 (F12)
- 查看 Console 是否有错误
- 确保浏览器启用了 JavaScript

---

## 📱 在手机上测试

### Android

1. 打开 Chrome 浏览器
2. 访问: https://fanei.github.io/scan/privacy.html
3. 测试中英文切换
4. 测试页面滚动和显示

### iOS

1. 打开 Safari 浏览器
2. 访问: https://fanei.github.io/scan/privacy.html
3. 测试中英文切换
4. 测试页面滚动和显示

**重要**: 确保在移动设备上显示正常,因为很多用户会在手机上查看隐私政策!

---

## 🎯 Google Play Console 测试

在提交 Google Play 之前,测试 URL 是否符合要求:

1. **打开 Google Play Console**
2. **进入应用详情**
3. **Store presence → Store listing → Privacy policy**
4. **输入 URL**: `https://fanei.github.io/scan/privacy.html`
5. **点击"预览"按钮** (如果有)
6. **确认页面能正常打开**

---

## ✅ 验证通过标准

所有以下条件都满足,才算验证通过:

- ✅ 隐私政策页面返回 200 状态码
- ✅ 页面内容完整,包含所有必要信息
- ✅ 中英文切换功能正常
- ✅ 联系邮箱和开发者信息正确
- ✅ 在桌面和移动设备上都能正常访问
- ✅ HTTPS 证书有效 (浏览器地址栏显示锁图标)

---

## 📞 需要帮助?

如果遇到问题:

1. **查看部署日志**: https://github.com/fanei/scan/actions
2. **检查文件是否存在**: https://github.com/fanei/scan/tree/main/docs
3. **重新推送代码**:
   ```bash
   cd /Users/fancw/StudioProjects/scan
   git add docs/
   git commit -m "Update GitHub Pages"
   git push
   ```

---

**验证完成后,请告诉我结果!** ✅
