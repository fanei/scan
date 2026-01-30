#!/usr/bin/env python3
"""
处理截图,使其符合 Google Play 要求
- 宽高比: 9:16
- 尺寸: 320-3840 像素
- 格式: PNG 或 JPEG
- 文件大小: < 8 MB
"""

from PIL import Image
import os
import shutil

def process_screenshot(input_path, output_path):
    """处理单张截图"""
    img = Image.open(input_path)
    width, height = img.size
    
    # 目标宽高比 9:16
    target_ratio = 9 / 16
    current_ratio = width / height
    
    print(f"\n处理: {os.path.basename(input_path)}")
    print(f"  原始尺寸: {width} x {height}")
    print(f"  原始宽高比: {current_ratio:.4f}")
    
    # 如果宽高比不符合,需要裁剪
    if abs(current_ratio - target_ratio) > 0.01:
        # 计算目标尺寸
        if current_ratio < target_ratio:
            # 图片太窄,需要裁剪高度
            new_height = int(width / target_ratio)
            new_width = width
            
            # 从中间裁剪
            top = (height - new_height) // 2
            bottom = top + new_height
            left = 0
            right = width
        else:
            # 图片太宽,需要裁剪宽度
            new_width = int(height * target_ratio)
            new_height = height
            
            # 从中间裁剪
            left = (width - new_width) // 2
            right = left + new_width
            top = 0
            bottom = height
        
        # 裁剪
        img_cropped = img.crop((left, top, right, bottom))
        print(f"  裁剪后尺寸: {img_cropped.size[0]} x {img_cropped.size[1]}")
        print(f"  裁剪后宽高比: {img_cropped.size[0] / img_cropped.size[1]:.4f}")
        
        # 保存
        img_cropped.save(output_path, 'PNG', quality=95, optimize=True)
    else:
        # 宽高比已经符合,直接转换为 PNG
        print(f"  宽高比已符合,转换为 PNG")
        img.save(output_path, 'PNG', quality=95, optimize=True)
    
    # 检查文件大小
    size_mb = os.path.getsize(output_path) / (1024 * 1024)
    print(f"  输出文件大小: {size_mb:.2f} MB")
    
    if size_mb > 8:
        print(f"  ⚠️  文件大小超过 8 MB,压缩中...")
        # 降低质量重新保存
        img_cropped = Image.open(output_path)
        img_cropped.save(output_path, 'PNG', quality=85, optimize=True)
        size_mb = os.path.getsize(output_path) / (1024 * 1024)
        print(f"  压缩后文件大小: {size_mb:.2f} MB")
    
    print(f"  ✅ 完成")
    
    return output_path

def main():
    """主函数"""
    input_dir = '/Users/fancw/StudioProjects/scan/icon_generator/screenpicture'
    output_dir = '/Users/fancw/StudioProjects/scan/screenshots_processed'
    
    # 创建输出目录
    os.makedirs(output_dir, exist_ok=True)
    
    print("📱 开始处理截图")
    print("=" * 80)
    print(f"输入目录: {input_dir}")
    print(f"输出目录: {output_dir}")
    print("=" * 80)
    
    # 获取所有截图文件
    files = sorted([f for f in os.listdir(input_dir) if f.endswith(('.jpg', '.jpeg', '.png'))])
    
    if not files:
        print("❌ 未找到截图文件")
        return
    
    print(f"\n找到 {len(files)} 张截图")
    
    # 处理每张截图
    processed_count = 0
    for i, filename in enumerate(files, 1):
        input_path = os.path.join(input_dir, filename)
        output_filename = f"screenshot_{i:02d}.png"
        output_path = os.path.join(output_dir, output_filename)
        
        try:
            process_screenshot(input_path, output_path)
            processed_count += 1
        except Exception as e:
            print(f"  ❌ 处理失败: {e}")
    
    print("\n" + "=" * 80)
    print(f"✅ 处理完成!")
    print(f"成功处理: {processed_count}/{len(files)} 张")
    print(f"\n处理后的截图位置:")
    print(f"  {output_dir}")
    print("\n文件列表:")
    
    # 显示处理后的文件
    for filename in sorted(os.listdir(output_dir)):
        if filename.endswith('.png'):
            filepath = os.path.join(output_dir, filename)
            img = Image.open(filepath)
            size_kb = os.path.getsize(filepath) / 1024
            print(f"  - {filename}: {img.size[0]}x{img.size[1]}, {size_kb:.1f} KB")
    
    print("\n" + "=" * 80)
    print("📤 现在可以上传到 Google Play Console 了!")
    print("\n上传步骤:")
    print("1. 登录 Google Play Console")
    print("2. Store presence → Main store listing → Phone screenshots")
    print("3. 上传 screenshots_processed 文件夹中的 PNG 文件")
    print("4. 调整顺序 (拖动)")
    print("5. 保存")

if __name__ == '__main__':
    main()
