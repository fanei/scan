#!/usr/bin/env python3
"""
SmartScan 图标生成器
使用 PIL/Pillow 生成应用图标

安装依赖：
pip install Pillow

使用方法：
python generate_icon.py
"""

from PIL import Image, ImageDraw
import math

def create_rounded_rectangle_mask(size, radius):
    """创建圆角矩形遮罩"""
    mask = Image.new('L', (size, size), 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle([(0, 0), (size-1, size-1)], radius=radius, fill=255)
    return mask

def create_gradient_background(size):
    """创建渐变背景"""
    # 创建渐变背景（从左上到右下）
    image = Image.new('RGB', (size, size))
    draw = ImageDraw.Draw(image)
    
    # Material Green 颜色
    color1 = (76, 175, 80)    # #4CAF50
    color2 = (46, 125, 50)    # #2E7D32
    
    # 绘制渐变
    for y in range(size):
        for x in range(size):
            # 计算当前位置的渐变比例（从左上到右下）
            ratio = (x + y) / (2 * size)
            
            # 插值计算颜色
            r = int(color1[0] + (color2[0] - color1[0]) * ratio)
            g = int(color1[1] + (color2[1] - color1[1]) * ratio)
            b = int(color1[2] + (color2[2] - color1[2]) * ratio)
            
            image.putpixel((x, y), (r, g, b))
    
    return image

def draw_scan_corners(draw, size):
    """绘制扫描框四角"""
    white = (255, 255, 255)
    line_width = int(size * 0.04)
    corner_size = int(size * 0.18)
    margin = int(size * 0.22)
    
    # 左上角
    draw.line([(margin, margin), (margin + corner_size, margin)], 
              fill=white, width=line_width)
    draw.line([(margin, margin), (margin, margin + corner_size)], 
              fill=white, width=line_width)
    
    # 右上角
    draw.line([(size - margin, margin), (size - margin - corner_size, margin)], 
              fill=white, width=line_width)
    draw.line([(size - margin, margin), (size - margin, margin + corner_size)], 
              fill=white, width=line_width)
    
    # 左下角
    draw.line([(margin, size - margin), (margin + corner_size, size - margin)], 
              fill=white, width=line_width)
    draw.line([(margin, size - margin), (margin, size - margin - corner_size)], 
              fill=white, width=line_width)
    
    # 右下角
    draw.line([(size - margin, size - margin), (size - margin - corner_size, size - margin)], 
              fill=white, width=line_width)
    draw.line([(size - margin, size - margin), (size - margin, size - margin - corner_size)], 
              fill=white, width=line_width)

def draw_qr_dots(draw, size):
    """绘制 QR 点阵"""
    white = (255, 255, 255)
    dot_radius = int(size * 0.028)
    spacing = int(size * 0.08)
    center_x = size // 2
    center_y = size // 2
    
    # 定义点的位置（相对于中心）
    dots = [
        (-1, 0), (0, -1), (1, 0), (0, 1),  # 十字形
        (-1, 1), (1, -1)  # 两个对角
    ]
    
    # 绘制普通点
    for row, col in dots:
        x = center_x + col * spacing
        y = center_y + row * spacing
        bbox = [x - dot_radius, y - dot_radius, x + dot_radius, y + dot_radius]
        draw.ellipse(bbox, fill=white)
    
    # 绘制中心大点
    center_radius = int(dot_radius * 1.5)
    bbox = [
        center_x - center_radius, center_y - center_radius,
        center_x + center_radius, center_y + center_radius
    ]
    draw.ellipse(bbox, fill=white)

def generate_icon(size=1024, output_file='smartscan_icon.png'):
    """生成图标"""
    print(f"🎨 开始生成 {size}x{size} 图标...")
    
    # 1. 创建渐变背景
    print("  ✓ 创建渐变背景")
    image = create_gradient_background(size)
    
    # 2. 应用圆角
    radius = int(size * 0.22)
    mask = create_rounded_rectangle_mask(size, radius)
    
    # 创建 RGBA 图像
    rgba_image = Image.new('RGBA', (size, size))
    rgba_image.paste(image, (0, 0))
    rgba_image.putalpha(mask)
    
    # 3. 绘制扫描框和点阵
    draw = ImageDraw.Draw(rgba_image)
    
    print("  ✓ 绘制扫描框")
    draw_scan_corners(draw, size)
    
    print("  ✓ 绘制 QR 点阵")
    draw_qr_dots(draw, size)
    
    # 4. 保存
    rgba_image.save(output_file, 'PNG')
    print(f"✅ 图标已保存: {output_file}")
    
    return rgba_image

def generate_all_sizes():
    """生成所有需要的尺寸"""
    sizes = [
        (1024, "icon_1024.png"),      # iOS App Store, 源文件
        (512, "icon_512.png"),        # Google Play
        (192, "icon_192.png"),        # Android xxxhdpi
        (144, "icon_144.png"),        # Android xxhdpi
        (96, "icon_96.png"),          # Android xhdpi
        (72, "icon_72.png"),          # Android hdpi
        (48, "icon_48.png"),          # Android mdpi
    ]
    
    print("=" * 50)
    print("SmartScan 图标生成器")
    print("=" * 50)
    
    for size, filename in sizes:
        generate_icon(size, filename)
        print()
    
    print("=" * 50)
    print("🎉 所有图标生成完成！")
    print("=" * 50)
    print("\n下一步：")
    print("1. 将 icon_1024.png 复制到 ../smartscan_app/assets/icon/icon.png")
    print("2. 运行: cd ../smartscan_app && flutter pub run flutter_launcher_icons")
    print("3. 重新构建应用: flutter clean && flutter build apk --release")

if __name__ == '__main__':
    try:
        generate_all_sizes()
    except ImportError:
        print("❌ 错误: 需要安装 Pillow 库")
        print("运行: pip install Pillow")
    except Exception as e:
        print(f"❌ 错误: {e}")
