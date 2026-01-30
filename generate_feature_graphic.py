#!/usr/bin/env python3
"""
SmartScan Feature Graphic Generator
生成 1024x500 的 Google Play 主题图片
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_feature_graphic():
    """创建主题图片"""
    
    # 图片尺寸
    width = 1024
    height = 500
    
    # 创建图片
    img = Image.new('RGB', (width, height), color='white')
    draw = ImageDraw.Draw(img)
    
    # 创建渐变背景 (蓝色到紫色)
    for y in range(height):
        # 从蓝色 #2196F3 到紫色 #9C27B0
        r = int(33 + (156 - 33) * y / height)
        g = int(150 + (39 - 150) * y / height)
        b = int(243 + (176 - 243) * y / height)
        draw.rectangle([(0, y), (width, y + 1)], fill=(r, g, b))
    
    # 尝试加载系统字体
    try:
        # macOS 系统字体
        title_font = ImageFont.truetype('/System/Library/Fonts/Supplemental/Arial Bold.ttf', 100)
        subtitle_font = ImageFont.truetype('/System/Library/Fonts/Supplemental/Arial.ttf', 42)
    except:
        try:
            # 备选字体
            title_font = ImageFont.truetype('/Library/Fonts/Arial Bold.ttf', 100)
            subtitle_font = ImageFont.truetype('/Library/Fonts/Arial.ttf', 42)
        except:
            # 使用默认字体
            print("警告: 无法加载系统字体,使用默认字体")
            title_font = ImageFont.load_default()
            subtitle_font = ImageFont.load_default()
    
    # 文字内容
    title = "SmartScan"
    subtitle_zh = "快速、安全、易用的二维码扫描工具"
    subtitle_en = "Fast, Secure, Easy-to-use QR Code Scanner"
    
    # 计算文字位置 (居中)
    # 标题
    title_bbox = draw.textbbox((0, 0), title, font=title_font)
    title_width = title_bbox[2] - title_bbox[0]
    title_height = title_bbox[3] - title_bbox[1]
    title_x = (width - title_width) // 2
    title_y = height // 2 - title_height - 30
    
    # 中文副标题
    subtitle_zh_bbox = draw.textbbox((0, 0), subtitle_zh, font=subtitle_font)
    subtitle_zh_width = subtitle_zh_bbox[2] - subtitle_zh_bbox[0]
    subtitle_zh_x = (width - subtitle_zh_width) // 2
    subtitle_zh_y = height // 2 + 10
    
    # 英文副标题
    subtitle_en_bbox = draw.textbbox((0, 0), subtitle_en, font=subtitle_font)
    subtitle_en_width = subtitle_en_bbox[2] - subtitle_en_bbox[0]
    subtitle_en_x = (width - subtitle_en_width) // 2
    subtitle_en_y = height // 2 + 60
    
    # 绘制文字 (白色)
    draw.text((title_x, title_y), title, fill='white', font=title_font)
    draw.text((subtitle_zh_x, subtitle_zh_y), subtitle_zh, fill='white', font=subtitle_font)
    draw.text((subtitle_en_x, subtitle_en_y), subtitle_en, fill=(255, 255, 255, 230), font=subtitle_font)
    
    # 绘制装饰性的二维码图案 (右侧)
    qr_size = 120
    qr_x = width - qr_size - 80
    qr_y = (height - qr_size) // 2
    
    # 简单的二维码样式装饰
    cell_size = 15
    for i in range(8):
        for j in range(8):
            if (i + j) % 2 == 0:
                x = qr_x + i * cell_size
                y = qr_y + j * cell_size
                draw.rectangle(
                    [(x, y), (x + cell_size - 2, y + cell_size - 2)],
                    fill=(255, 255, 255, 180)
                )
    
    # 绘制扫描图标 (左侧)
    icon_size = 120
    icon_x = 80
    icon_y = (height - icon_size) // 2
    
    # 简单的扫描框图标
    draw.rectangle(
        [(icon_x, icon_y), (icon_x + icon_size, icon_y + icon_size)],
        outline='white',
        width=4
    )
    # 扫描线
    scan_line_y = icon_y + icon_size // 2
    draw.line(
        [(icon_x + 10, scan_line_y), (icon_x + icon_size - 10, scan_line_y)],
        fill='white',
        width=3
    )
    
    # 保存图片
    output_path = 'smartscan-feature-graphic.png'
    img.save(output_path, 'PNG', quality=95)
    print(f"✅ 主题图片已生成: {output_path}")
    print(f"📐 尺寸: {width} x {height}")
    print(f"📁 文件大小: {os.path.getsize(output_path) / 1024:.1f} KB")
    
    return output_path

if __name__ == '__main__':
    print("🎨 开始生成 SmartScan 主题图片...")
    print("=" * 50)
    
    try:
        output_path = create_feature_graphic()
        print("=" * 50)
        print("✅ 完成!")
        print(f"\n图片位置: {os.path.abspath(output_path)}")
        print("\n现在可以上传到 Google Play Console 了!")
    except Exception as e:
        print(f"❌ 生成失败: {e}")
        print("\n请确保已安装 Pillow 库:")
        print("pip3 install Pillow")
