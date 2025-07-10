#!/usr/bin/env python3
import os
from PIL import Image
import shutil

def create_web_icons():
    """Generate web favicon and icons from app-logo.png"""
    
    # Source logo file
    source_logo = "assets/images/logos/app-logo.png"
    
    if not os.path.exists(source_logo):
        print(f"Error: {source_logo} not found!")
        return
    
    # Web icon sizes and their filenames
    icon_sizes = {
        # Favicon
        (32, 32): "favicon.png",
        
        # Web app icons
        (192, 192): "icons/Icon-192.png",
        (512, 512): "icons/Icon-512.png",
        (192, 192): "icons/Icon-maskable-192.png",  # Maskable icon
        (512, 512): "icons/Icon-maskable-512.png",  # Maskable icon
    }
    
    # Load the source image
    try:
        with Image.open(source_logo) as img:
            # Convert to RGBA if not already
            if img.mode != 'RGBA':
                img = img.convert('RGBA')
            
            print("Generating web icons...")
            
            for (width, height), filename in icon_sizes.items():
                # Resize the image
                resized_img = img.resize((width, height), Image.Resampling.LANCZOS)
                
                # Save the icon
                output_path = os.path.join("web", filename)
                os.makedirs(os.path.dirname(output_path), exist_ok=True)
                resized_img.save(output_path, 'PNG')
                
                print(f"Generated: {filename} ({width}x{height})")
            
            print(f"\n✅ Successfully generated web icons!")
            print(f"Icons saved to: web/ directory")
            
    except Exception as e:
        print(f"Error processing image: {e}")

if __name__ == "__main__":
    create_web_icons() 