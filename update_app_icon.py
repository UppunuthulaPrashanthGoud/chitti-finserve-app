#!/usr/bin/env python3
"""
Script to update Flutter app icon using the new logo
"""

import os
import shutil
from PIL import Image
import subprocess

def create_icon_sizes():
    """Create different icon sizes for Android"""
    
    # Source logo path
    source_logo = "assets/images/logos/app-logo.png"
    
    if not os.path.exists(source_logo):
        print(f"❌ Source logo not found: {source_logo}")
        return False
    
    # Android icon sizes (in pixels)
    icon_sizes = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192
    }
    
    # iOS icon sizes (in pixels)
    ios_icon_sizes = {
        "Icon-App-20x20@1x.png": 20,
        "Icon-App-20x20@2x.png": 40,
        "Icon-App-20x20@3x.png": 60,
        "Icon-App-29x29@1x.png": 29,
        "Icon-App-29x29@2x.png": 58,
        "Icon-App-29x29@3x.png": 87,
        "Icon-App-40x40@1x.png": 40,
        "Icon-App-40x40@2x.png": 80,
        "Icon-App-40x40@3x.png": 120,
        "Icon-App-50x50@1x.png": 50,
        "Icon-App-50x50@2x.png": 100,
        "Icon-App-57x57@1x.png": 57,
        "Icon-App-57x57@2x.png": 114,
        "Icon-App-60x60@2x.png": 120,
        "Icon-App-60x60@3x.png": 180,
        "Icon-App-72x72@1x.png": 72,
        "Icon-App-72x72@2x.png": 144,
        "Icon-App-76x76@1x.png": 76,
        "Icon-App-76x76@2x.png": 152,
        "Icon-App-83.5x83.5@2x.png": 167,
        "Icon-App-1024x1024@1x.png": 1024
    }
    
    try:
        # Open the source logo
        with Image.open(source_logo) as img:
            # Convert to RGBA if needed
            if img.mode != 'RGBA':
                img = img.convert('RGBA')
            
            print("🔄 Creating Android icons...")
            
            # Create Android icons
            for directory, size in icon_sizes.items():
                android_path = f"android/app/src/main/res/{directory}"
                os.makedirs(android_path, exist_ok=True)
                
                # Resize image
                resized_img = img.resize((size, size), Image.Resampling.LANCZOS)
                
                # Save to Android directory
                output_path = f"{android_path}/ic_launcher.png"
                resized_img.save(output_path, "PNG")
                print(f"✅ Created {output_path} ({size}x{size})")
            
            print("🔄 Creating iOS icons...")
            
            # Create iOS icons
            ios_path = "ios/Runner/Assets.xcassets/AppIcon.appiconset"
            os.makedirs(ios_path, exist_ok=True)
            
            for filename, size in ios_icon_sizes.items():
                # Resize image
                resized_img = img.resize((size, size), Image.Resampling.LANCZOS)
                
                # Save to iOS directory
                output_path = f"{ios_path}/{filename}"
                resized_img.save(output_path, "PNG")
                print(f"✅ Created {output_path} ({size}x{size})")
            
            print("✅ App icon update completed successfully!")
            return True
            
    except Exception as e:
        print(f"❌ Error creating app icons: {e}")
        return False

def update_ios_contents_json():
    """Update iOS Contents.json file"""
    contents_json = '''{
  "images" : [
    {
      "filename" : "Icon-App-20x20@1x.png",
      "idiom" : "iphone",
      "scale" : "1x",
      "size" : "20x20"
    },
    {
      "filename" : "Icon-App-20x20@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "filename" : "Icon-App-20x20@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "20x20"
    },
    {
      "filename" : "Icon-App-29x29@1x.png",
      "idiom" : "iphone",
      "scale" : "1x",
      "size" : "29x29"
    },
    {
      "filename" : "Icon-App-29x29@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "filename" : "Icon-App-29x29@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "29x29"
    },
    {
      "filename" : "Icon-App-40x40@1x.png",
      "idiom" : "iphone",
      "scale" : "1x",
      "size" : "40x40"
    },
    {
      "filename" : "Icon-App-40x40@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "filename" : "Icon-App-40x40@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "40x40"
    },
    {
      "filename" : "Icon-App-50x50@1x.png",
      "idiom" : "iphone",
      "scale" : "1x",
      "size" : "50x50"
    },
    {
      "filename" : "Icon-App-50x50@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "50x50"
    },
    {
      "filename" : "Icon-App-57x57@1x.png",
      "idiom" : "iphone",
      "scale" : "1x",
      "size" : "57x57"
    },
    {
      "filename" : "Icon-App-57x57@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "57x57"
    },
    {
      "filename" : "Icon-App-60x60@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "60x60"
    },
    {
      "filename" : "Icon-App-60x60@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "60x60"
    },
    {
      "filename" : "Icon-App-72x72@1x.png",
      "idiom" : "iphone",
      "scale" : "1x",
      "size" : "72x72"
    },
    {
      "filename" : "Icon-App-72x72@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "72x72"
    },
    {
      "filename" : "Icon-App-76x76@1x.png",
      "idiom" : "iphone",
      "scale" : "1x",
      "size" : "76x76"
    },
    {
      "filename" : "Icon-App-76x76@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "76x76"
    },
    {
      "filename" : "Icon-App-83.5x83.5@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "83.5x83.5"
    },
    {
      "filename" : "Icon-App-1024x1024@1x.png",
      "idiom" : "ios-marketing",
      "scale" : "1x",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}'''
    
    ios_path = "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    os.makedirs(ios_path, exist_ok=True)
    
    with open(f"{ios_path}/Contents.json", "w") as f:
        f.write(contents_json)
    
    print("✅ Updated iOS Contents.json")

def main():
    print("🚀 Starting app icon update...")
    
    # Check if PIL is available
    try:
        from PIL import Image
    except ImportError:
        print("❌ PIL (Pillow) is required. Install it with: pip install Pillow")
        return False
    
    # Create icon sizes
    if create_icon_sizes():
        # Update iOS Contents.json
        update_ios_contents_json()
        
        print("\n🎉 App icon update completed!")
        print("📱 Android: Icons updated in android/app/src/main/res/mipmap-*/")
        print("🍎 iOS: Icons updated in ios/Runner/Assets.xcassets/AppIcon.appiconset/")
        print("\n🔄 Next steps:")
        print("1. Clean and rebuild your app:")
        print("   flutter clean")
        print("   flutter pub get")
        print("2. For Android: flutter build apk")
        print("3. For iOS: flutter build ios")
        
        return True
    else:
        print("❌ App icon update failed!")
        return False

if __name__ == "__main__":
    main() 