# Mobile App Troubleshooting Guide

## "Failed to load login config" Error

This error occurs when the mobile app cannot connect to the backend API. Here's how to fix it:

## 🔍 Quick Diagnosis

### 1. Check Backend Server
First, ensure your backend server is running:

```bash
# Navigate to backend directory
cd backend

# Start the server
npm run dev
```

### 2. Test Backend API
Test if the backend is accessible:

```bash
# Test health endpoint
curl http://localhost:5000/health

# Test configuration endpoint
curl http://localhost:5000/api/configuration/public
```

## 🛠️ Platform-Specific Solutions

### Android Emulator
If you're using Android emulator, the app is configured to use `10.0.2.2:5000` which is the correct IP to access your host machine's localhost.

**Check if this is working:**
1. Open Android Studio
2. Go to AVD Manager
3. Start your emulator
4. Run the Flutter app
5. Check the console logs for connection messages

### Physical Android Device
If you're using a physical Android device, you need to:

1. **Find your computer's IP address:**
   ```bash
   # On Windows
   ipconfig
   
   # On macOS/Linux
   ifconfig
   ```

2. **Update the API URL:**
   Edit `lib/core/app_config.dart` and change:
   ```dart
   // Comment out the dynamic URL
   // static String get apiBaseUrl { ... }
   
   // Use your computer's IP address
   static const String apiBaseUrl = 'http://YOUR_COMPUTER_IP:5000/api';
   ```

### iOS Simulator
For iOS simulator, the app uses `localhost:5000` which should work correctly.

### Web Platform
For web platform, the app uses `localhost:5000` which should work correctly.

## 🔧 Configuration Options

### Option 1: Dynamic Configuration (Recommended)
The app currently uses dynamic configuration based on platform:

```dart
// lib/core/app_config.dart
static String get apiBaseUrl {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:5000/api'; // Android emulator
  } else if (Platform.isIOS) {
    return 'http://localhost:5000/api'; // iOS simulator
  } else {
    return 'http://localhost:5000/api'; // Web
  }
}
```

### Option 2: Manual Configuration
For physical device testing, manually set your computer's IP:

```dart
// lib/core/app_config.dart
static const String apiBaseUrl = 'http://192.168.1.100:5000/api';
```

### Option 3: Environment-Based Configuration
For production, use environment variables:

```dart
// lib/core/app_config.dart
static String get apiBaseUrl {
  if (isProduction) {
    return 'https://your-domain.com/api';
  } else {
    // Development configuration
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api';
    } else {
      return 'http://localhost:5000/api';
    }
  }
}
```

## 🚨 Common Issues and Solutions

### Issue 1: "SocketException: Connection refused"
**Cause:** Backend server is not running or wrong port
**Solution:**
1. Start the backend server: `cd backend && npm run dev`
2. Verify it's running on port 5000
3. Check if port 5000 is not used by another application

### Issue 2: "TimeoutException"
**Cause:** Network timeout or slow connection
**Solution:**
1. Check your internet connection
2. Increase timeout in `lib/core/app_config.dart`
3. Ensure both devices are on the same network

### Issue 3: "HttpException: 404 Not Found"
**Cause:** Wrong API endpoint or backend route not configured
**Solution:**
1. Check if the backend route exists
2. Verify the API endpoint path
3. Check backend logs for errors

### Issue 4: "CORS Error" (Web Platform)
**Cause:** Backend CORS configuration
**Solution:**
1. Check backend CORS settings in `server.js`
2. Ensure frontend URL is allowed
3. Update CORS configuration if needed

## 🔍 Debugging Steps

### Step 1: Enable Debug Logging
The app has built-in logging. Check the console for:
- 🌐 NetworkService: Making request
- ✅ NetworkService: Response received
- ❌ NetworkService: Error occurred

### Step 2: Test Connection
Add this to your app temporarily:

```dart
import 'test_connection.dart';

// In your widget
await ConnectionTester.testApiConnection();
```

### Step 3: Check Network Configuration
Verify your network setup:

1. **Same Network:** Ensure both devices are on the same WiFi network
2. **Firewall:** Check if Windows Firewall is blocking the connection
3. **Antivirus:** Some antivirus software may block connections
4. **Router:** Some routers block local network connections

### Step 4: Alternative Testing
Test with a simple HTTP client:

```bash
# Test from your computer
curl http://localhost:5000/api/configuration/public

# Test from another device on the same network
curl http://YOUR_COMPUTER_IP:5000/api/configuration/public
```

## 📱 Platform-Specific Notes

### Android
- **Emulator:** Uses `10.0.2.2` to access host machine
- **Physical Device:** Needs your computer's IP address
- **Permissions:** Ensure `INTERNET` permission is in `AndroidManifest.xml`

### iOS
- **Simulator:** Uses `localhost`
- **Physical Device:** Needs your computer's IP address
- **Network Security:** iOS may require HTTPS in production

### Web
- **Development:** Uses `localhost`
- **Production:** Needs HTTPS and proper CORS configuration

## 🚀 Quick Fix Checklist

- [ ] Backend server is running on port 5000
- [ ] Backend health endpoint responds: `http://localhost:5000/health`
- [ ] Configuration endpoint responds: `http://localhost:5000/api/configuration/public`
- [ ] Mobile app is using correct API URL for your platform
- [ ] Both devices are on the same network (for physical device testing)
- [ ] Firewall is not blocking the connection
- [ ] Check console logs for detailed error messages

## 📞 Getting Help

If you're still having issues:

1. **Check the console logs** for detailed error messages
2. **Test the API endpoints** manually using curl or Postman
3. **Verify network connectivity** between devices
4. **Check backend logs** for any server-side errors
5. **Try different network configurations** (different WiFi, mobile hotspot, etc.)

## 🔄 Testing the Fix

After making changes:

1. **Hot reload** the Flutter app: `r` in the terminal
2. **Check console logs** for connection messages
3. **Test the login screen** to see if the error is resolved
4. **Verify other API calls** work correctly

The app should now successfully connect to your backend API and load the login configuration! 