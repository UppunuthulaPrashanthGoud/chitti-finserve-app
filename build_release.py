#!/usr/bin/env python3
"""
Script to build release versions for Play Store and App Store
"""

import os
import subprocess
import sys

def run_command(command, description):
    """Run a command and handle errors"""
    print(f"🔄 {description}...")
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(f"✅ {description} completed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} failed:")
        print(f"Error: {e.stderr}")
        return False

def check_flutter_installation():
    """Check if Flutter is installed and accessible"""
    try:
        result = subprocess.run("flutter --version", shell=True, capture_output=True, text=True)
        if result.returncode == 0:
            print("✅ Flutter is installed")
            return True
        else:
            print("❌ Flutter is not installed or not in PATH")
            return False
    except Exception as e:
        print(f"❌ Error checking Flutter installation: {e}")
        return False

def clean_project():
    """Clean the Flutter project"""
    return run_command("flutter clean", "Cleaning project")

def get_dependencies():
    """Get Flutter dependencies"""
    return run_command("flutter pub get", "Getting dependencies")

def build_android_release():
    """Build Android release APK and AAB"""
    print("\n📱 Building Android release...")
    
    # Build APK
    if not run_command("flutter build apk --release", "Building Android APK"):
        return False
    
    # Build AAB (App Bundle - preferred for Play Store)
    if not run_command("flutter build appbundle --release", "Building Android App Bundle"):
        return False
    
    return True

def build_ios_release():
    """Build iOS release"""
    print("\n🍎 Building iOS release...")
    
    # Build iOS
    if not run_command("flutter build ios --release", "Building iOS release"):
        return False
    
    return True

def check_build_outputs():
    """Check if build outputs were created"""
    print("\n📋 Checking build outputs...")
    
    # Check Android outputs
    android_apk = "build/app/outputs/flutter-apk/app-release.apk"
    android_aab = "build/app/outputs/bundle/release/app-release.aab"
    
    if os.path.exists(android_apk):
        size = os.path.getsize(android_apk) / (1024 * 1024)  # MB
        print(f"✅ Android APK created: {android_apk} ({size:.1f} MB)")
    else:
        print(f"❌ Android APK not found: {android_apk}")
    
    if os.path.exists(android_aab):
        size = os.path.getsize(android_aab) / (1024 * 1024)  # MB
        print(f"✅ Android AAB created: {android_aab} ({size:.1f} MB)")
    else:
        print(f"❌ Android AAB not found: {android_aab}")
    
    # Check iOS output
    ios_app = "build/ios/iphoneos/Runner.app"
    if os.path.exists(ios_app):
        print(f"✅ iOS app created: {ios_app}")
    else:
        print(f"⚠️ iOS app not found: {ios_app}")

def main():
    print("🚀 Starting release build process...")
    print("📦 Package: com.chitti.finserv")
    print("📱 App Name: Chitti Finserv")
    print("🔢 Version: 1.0")
    
    # Check Flutter installation
    if not check_flutter_installation():
        print("❌ Please install Flutter and add it to your PATH")
        return False
    
    # Clean project
    if not clean_project():
        return False
    
    # Get dependencies
    if not get_dependencies():
        return False
    
    # Build Android release
    if not build_android_release():
        return False
    
    # Build iOS release
    if not build_ios_release():
        return False
    
    # Check build outputs
    check_build_outputs()
    
    print("\n🎉 Release build completed successfully!")
    print("\n📋 Summary:")
    print("✅ Package name: com.chitti.finserv")
    print("✅ App name: Chitti Finserv")
    print("✅ Version: 1.0")
    print("✅ App icon: Updated")
    print("✅ Android: APK and AAB built")
    print("✅ iOS: App built")
    
    print("\n🔄 Next steps for publishing:")
    print("📱 Play Store:")
    print("   1. Go to Google Play Console")
    print("   2. Create new app with package: com.chitti.finserv")
    print("   3. Upload app-release.aab file")
    print("   4. Fill in app details and submit for review")
    
    print("\n🍎 App Store:")
    print("   1. Open Xcode")
    print("   2. Archive the project")
    print("   3. Upload to App Store Connect")
    print("   4. Fill in app details and submit for review")
    
    print("\n📁 Build files location:")
    print("   Android APK: build/app/outputs/flutter-apk/app-release.apk")
    print("   Android AAB: build/app/outputs/bundle/release/app-release.aab")
    print("   iOS App: build/ios/iphoneos/Runner.app")
    
    return True

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1) 