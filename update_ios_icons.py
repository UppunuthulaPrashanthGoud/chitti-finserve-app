#!/usr/bin/env python3
import os
from PIL import Image
import shutil

def create_ios_icons():
    """Generate iOS app icons from app-logo.png"""
    
    # Source logo file
    source_logo = "app-logo.png"
    
    if not os.path.exists(source_logo):
        print(f"Error: {source_logo} not found!")
        return
    
    # iOS icon sizes and their filenames
    icon_sizes = {
        # iPhone icons
        (20, 20, 1): "Icon-App-20x20@1x.png",
        (20, 20, 2): "Icon-App-20x20@2x.png", 
        (20, 20, 3): "Icon-App-20x20@3x.png",
        (29, 29, 1): "Icon-App-29x29@1x.png",
        (29, 29, 2): "Icon-App-29x29@2x.png",
        (29, 29, 3): "Icon-App-29x29@3x.png",
        (40, 40, 1): "Icon-App-40x40@1x.png",
        (40, 40, 2): "Icon-App-40x40@2x.png",
        (40, 40, 3): "Icon-App-40x40@3x.png",
        (60, 60, 2): "Icon-App-60x60@2x.png",
        (60, 60, 3): "Icon-App-60x60@3x.png",
        
        # iPad icons
        (76, 76, 1): "Icon-App-76x76@1x.png",
        (76, 76, 2): "Icon-App-76x76@2x.png",
        (83.5, 83.5, 2): "Icon-App-83.5x83.5@2x.png",
        
        # App Store icon
        (1024, 1024, 1): "Icon-App-1024x1024@1x.png"
    }
    
    # Load the source image
    try:
        with Image.open(source_logo) as img:
            # Convert to RGBA if not already
            if img.mode != 'RGBA':
                img = img.convert('RGBA')
            
            # iOS directory
            ios_icon_dir = "ios/Runner/Assets.xcassets/AppIcon.appiconset"
            
            # Create directory if it doesn't exist
            os.makedirs(ios_icon_dir, exist_ok=True)
            
            print("Generating iOS app icons...")
            
            for (width, height, scale), filename in icon_sizes.items():
                # Calculate actual pixel dimensions
                actual_width = int(width * scale)
                actual_height = int(height * scale)
                
                # Resize the image
                resized_img = img.resize((actual_width, actual_height), Image.Resampling.LANCZOS)
                
                # Save the icon
                output_path = os.path.join(ios_icon_dir, filename)
                resized_img.save(output_path, 'PNG')
                
                print(f"Generated: {filename} ({actual_width}x{actual_height})")
            
            print(f"\n✅ Successfully generated {len(icon_sizes)} iOS app icons!")
            print(f"Icons saved to: {ios_icon_dir}")
            
    except Exception as e:
        print(f"Error processing image: {e}")

if __name__ == "__main__":
    create_ios_icons() 