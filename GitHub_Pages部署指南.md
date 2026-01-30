# GitHub Pages 部署指南

**目标**: 将隐私政策托管到 GitHub Pages,获取公开访问 URL

---

## ✅ 已完成的准备工作

1. ✅ 创建了 `docs/index.html` - 应用首页
2. ✅ 创建了 `docs/privacy.html` - 隐私政策页面
3. ✅ 创建了 `docs/README.md` - 说明文档

---

## 🚀 部署步骤

### 步骤 1: 检查 Git 状态

```bash
cd /Users/fancw/StudioProjects/scan
git status
```

### 步骤 2: 添加文件到 Git

```bash
# 添加 docs 文件夹
git add docs/

# 提交
git commit -m "Add GitHub Pages website and privacy policy"
```

### 步骤 3: 创建 GitHub 仓库

1. 访问 https://github.com/new
2. 填写信息:
   - **Repository name**: `scan` 或 `smartscan`
   - **Description**: SmartScan - Fast, secure QR code scanner
   - **Public** (必须是公开仓库才能使用免费的 GitHub Pages)
   - **不要**勾选 "Initialize this repository with a README"
3. 点击 "Create repository"

### 步骤 4: 推送到 GitHub

```bash
# 添加远程仓库 (替换 [你的用户名] 为实际的 GitHub 用户名)
git remote add origin https://github.com/[你的用户名]/scan.git

# 推送到 main 分支
git branch -M main
git push -u origin main
```

**注意**: 如果需要登录,使用 GitHub 的 Personal Access Token,不要使用密码。

### 步骤 5: 启用 GitHub Pages

1. 访问仓库设置页面:
   ```
   https://github.com/[你的用户名]/scan/settings/pages
   ```

2. 在 "Build and deployment" 部分:
   - **Source**: 选择 "Deploy from a branch"
   - **Branch**: 选择 `main`
   - **Folder**: 选择 `/docs`

3. 点击 "Save"

4. 等待部署完成 (通常 1-5 分钟)

### 步骤 6: 验证部署

访问以下 URL 确认网站已上线:

- **首页**: `https://[你的用户名].github.io/scan/`
- **隐私政策**: `https://[你的用户名].github.io/scan/privacy.html`

---

## 📝 获取隐私政策 URL

部署成功后,你的隐私政策 URL 将是:

```
https://[你的用户名].github.io/scan/privacy.html
```

**这个 URL 需要填写到 Google Play Console 的以下位置**:
1. App content → Privacy policy
2. 粘贴完整的 URL
3. 点击 "Save"

---

## 🔧 如果遇到问题

### 问题 1: Git 未初始化

**错误**: `fatal: not a git repository`

**解决**:
```bash
cd /Users/fancw/StudioProjects/scan
git init
```

### 问题 2: 推送被拒绝

**错误**: `remote: Permission denied`

**解决**:
1. 确保你已登录 GitHub
2. 使用 Personal Access Token 而不是密码
3. 生成 Token: https://github.com/settings/tokens

### 问题 3: 404 错误

**原因**: GitHub Pages 还未部署完成

**解决**:
1. 等待 5-10 分钟
2. 检查 GitHub Actions 是否成功
3. 访问 `https://github.com/[你的用户名]/scan/actions` 查看部署状态

### 问题 4: 文件未找到

**原因**: 文件路径不正确

**解决**:
1. 确保文件在 `docs/` 文件夹中
2. 确保文件名正确: `privacy.html` (全小写)
3. 重新推送: `git add docs/ && git commit -m "Fix files" && git push`

---

## 🎨 网站特点

### 首页 (index.html)
- ✅ 响应式设计,支持手机和电脑
- ✅ 中英文切换
- ✅ 介绍应用核心功能
- ✅ 展示隐私保护承诺
- ✅ 提供联系方式

### 隐私政策页面 (privacy.html)
- ✅ 完整的隐私政策内容
- ✅ 中英文双语
- ✅ 清晰的排版和格式
- ✅ 符合 Google Play 要求
- ✅ 包含更新日期和生效日期

---

## 📊 Google Play 要求

### 隐私政策必须包含

- ✅ 收集哪些数据
- ✅ 如何使用数据
- ✅ 是否与第三方分享
- ✅ 数据存储位置
- ✅ 用户权利说明
- ✅ 联系方式

### 我们的隐私政策

**已包含所有必需内容**:
- ✅ 明确说明不收集个人信息
- ✅ 说明数据完全本地存储
- ✅ 说明不与第三方分享
- ✅ 列出所需权限及用途
- ✅ 提供联系邮箱

---

## 🔄 更新隐私政策

如果需要更新隐私政策:

1. 修改 `docs/privacy.html` 文件
2. 更新日期
3. 提交并推送:
   ```bash
   git add docs/privacy.html
   git commit -m "Update privacy policy"
   git push
   ```
4. 等待 GitHub Pages 自动部署 (1-5分钟)

---

## 💡 最佳实践

### 1. 保持简洁
- 使用简单明了的语言
- 避免法律术语
- 分段清晰

### 2. 保持透明
- 诚实说明数据使用
- 不隐瞒任何信息
- 及时更新

### 3. 保持可访问
- 确保 URL 始终可访问
- 不要删除或移动页面
- 保持网站在线

### 4. 保持更新
- 应用功能变更时更新
- 数据处理方式变更时更新
- 至少每年审查一次

---

## 🎯 下一步

完成 GitHub Pages 部署后:

1. ✅ 获取隐私政策 URL
2. ✅ 在 Google Play Console 中填写
3. ✅ 继续准备其他发布材料:
   - 应用截图
   - 数据安全表单
   - 内容分级问卷

---

## 📞 需要帮助?

如果在部署过程中遇到问题:

1. 查看 GitHub Pages 文档: https://pages.github.com/
2. 查看 GitHub Actions 日志
3. 检查文件路径和权限
4. 确保仓库是公开的

---

## ✅ 检查清单

部署前检查:
- [ ] Git 仓库已初始化
- [ ] docs 文件夹包含 index.html 和 privacy.html
- [ ] 文件已提交到 Git
- [ ] GitHub 仓库已创建
- [ ] 代码已推送到 GitHub

部署后检查:
- [ ] GitHub Pages 已启用
- [ ] 网站可以访问
- [ ] 隐私政策页面可以访问
- [ ] 中英文切换正常
- [ ] 移动端显示正常

---

**准备好开始部署了吗?** 按照上面的步骤操作,大约 10-15 分钟即可完成!🚀
