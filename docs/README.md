# SmartScan 官方网站

这是 SmartScan 应用的官方网站,托管在 GitHub Pages 上。

## 📄 包含页面

- **index.html** - 首页,介绍应用功能
- **privacy.html** - 隐私政策页面 (Google Play 必需)

## 🌐 访问地址

网站将托管在: `https://[你的GitHub用户名].github.io/scan/`

隐私政策 URL: `https://[你的GitHub用户名].github.io/scan/privacy.html`

## 🚀 部署步骤

### 1. 初始化 Git 仓库 (如果还没有)

```bash
cd /Users/fancw/StudioProjects/scan
git init
```

### 2. 添加文件到 Git

```bash
git add docs/
git commit -m "Add GitHub Pages website and privacy policy"
```

### 3. 创建 GitHub 仓库

1. 访问 https://github.com/new
2. 创建一个新仓库,名称: `scan`
3. 不要初始化 README、.gitignore 或 license

### 4. 推送到 GitHub

```bash
git remote add origin https://github.com/[你的用户名]/scan.git
git branch -M main
git push -u origin main
```

### 5. 启用 GitHub Pages

1. 访问仓库设置: `https://github.com/[你的用户名]/scan/settings/pages`
2. 在 "Source" 下选择:
   - Branch: `main`
   - Folder: `/docs`
3. 点击 "Save"
4. 等待几分钟,网站将在 `https://[你的用户名].github.io/scan/` 上线

## 📝 注意事项

- 确保 `docs` 文件夹中的文件已提交到 Git
- GitHub Pages 可能需要几分钟才能生效
- 隐私政策 URL 需要在 Google Play Console 中填写

## 🔗 相关链接

- GitHub Pages 文档: https://pages.github.com/
- Google Play 隐私政策要求: https://support.google.com/googleplay/android-developer/answer/113469
