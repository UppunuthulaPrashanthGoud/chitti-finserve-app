# Chitti Finserv Complete Setup Guide

This guide covers the complete setup of the Chitti Finserv loan application system including the Flutter app, Node.js backend, and React admin panel.

## 🏗️ System Architecture

```
Chitti Finserv System
├── Flutter Mobile App (Frontend)
├── Node.js Backend API
├── React Admin Panel
└── MongoDB Database
```

## 📋 Prerequisites

- Node.js (v16 or higher)
- MongoDB (v5 or higher)
- Flutter SDK (v3.0 or higher)
- Git
- Firebase Account
- SMTP Email Service

## 🚀 Quick Start

### 1. Backend Setup

```bash
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# Create environment file
cp config.env.example config.env

# Edit config.env with your credentials
nano config.env

# Start the server
npm start
```

### 2. Admin Panel Setup

```bash
# Navigate to admin panel directory
cd admin-panel

# Install dependencies
npm install

# Create environment file
cp .env.example .env

# Edit .env with your API URL
nano .env

# Start the development server
npm start
```

### 3. Flutter App Setup

```bash
# Navigate to Flutter app directory
cd lib

# Update API base URL in your Flutter app
# Edit lib/data/repository/*.dart files

# Run the app
flutter run
```

## 🔧 Detailed Configuration

### Backend Environment Variables

Create `backend/config.env`:

```env
# Server Configuration
NODE_ENV=development
PORT=5000
FRONTEND_URL=http://localhost:3000

# Database
MONGODB_URI=mongodb://localhost:27017/chitti_finserv

# JWT Secret
JWT_SECRET=your-super-secret-jwt-key-here

# Firebase Configuration
FIREBASE_PROJECT_ID=your-firebase-project-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYour Firebase Private Key\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk@your-project.iam.gserviceaccount.com

# SMTP Configuration
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password

# Email Configuration
FROM_EMAIL=noreply@chittifinserv.com
FROM_NAME=Chitti Finserv

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
```

### Admin Panel Environment Variables

Create `admin-panel/.env`:

```env
REACT_APP_API_URL=http://localhost:5000/api
```

### Firebase Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project
   - Enable Authentication and Cloud Messaging

2. **Generate Service Account Key**
   - Go to Project Settings > Service Accounts
   - Generate new private key
   - Download the JSON file
   - Copy the values to your backend config

3. **Configure FCM**
   - Enable Cloud Messaging API
   - Get the server key for push notifications

### SMTP Email Setup

1. **Gmail Setup**
   - Enable 2-factor authentication
   - Generate app password
   - Use app password in SMTP configuration

2. **Alternative Email Providers**
   - SendGrid
   - Mailgun
   - AWS SES

## 📱 Flutter App Configuration

### Update API Base URL

In your Flutter app, update the API base URL in all repository files:

```dart
// Example: lib/data/repository/login_repository.dart
class LoginRepository {
  static const String baseUrl = 'http://localhost:5000/api';
  // or for production: 'https://your-domain.com/api'
}
```

### Firebase Configuration

1. **Add Firebase to Flutter**
   ```bash
   flutter pub add firebase_core
   flutter pub add firebase_messaging
   ```

2. **Configure Firebase**
   - Download `google-services.json` (Android)
   - Download `GoogleService-Info.plist` (iOS)
   - Place in appropriate directories

## 🗄️ Database Setup

### MongoDB Installation

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install mongodb
sudo systemctl start mongodb
sudo systemctl enable mongodb
```

**macOS:**
```bash
brew install mongodb-community
brew services start mongodb-community
```

**Windows:**
- Download MongoDB from official website
- Install and start MongoDB service

### Create Database

```bash
# Connect to MongoDB
mongo

# Create database
use chitti_finserv

# Create admin user
db.createUser({
  user: "admin",
  pwd: "your-password",
  roles: ["readWrite", "dbAdmin"]
})
```

## 🔐 Security Configuration

### JWT Secret
Generate a strong JWT secret:
```bash
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

### CORS Configuration
Update CORS settings in `backend/server.js`:
```javascript
app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  credentials: true
}));
```

### Rate Limiting
Configure rate limiting in `backend/server.js`:
```javascript
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});
```

## 🚀 Deployment

### Backend Deployment

**Using PM2:**
```bash
# Install PM2
npm install -g pm2

# Start the application
pm2 start backend/server.js --name "chitti-finserv-api"

# Save PM2 configuration
pm2 save

# Setup PM2 to start on boot
pm2 startup
```

**Using Docker:**
```dockerfile
# Dockerfile
FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 5000
CMD ["npm", "start"]
```

### Admin Panel Deployment

**Using Netlify:**
1. Connect your GitHub repository
2. Set build command: `npm run build`
3. Set publish directory: `build`
4. Add environment variables in Netlify dashboard

**Using Vercel:**
1. Connect your GitHub repository
2. Set build command: `npm run build`
3. Set output directory: `build`
4. Add environment variables in Vercel dashboard

### Flutter App Deployment

**Android:**
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

**iOS:**
```bash
# Build for iOS
flutter build ios --release
```

## 📊 Monitoring and Logging

### Backend Logging
```javascript
// Add to backend/server.js
const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});
```

### Error Tracking
Consider integrating:
- Sentry for error tracking
- LogRocket for session replay
- Google Analytics for user analytics

## 🔧 Maintenance

### Database Backups
```bash
# Create backup
mongodump --db chitti_finserv --out ./backups/$(date +%Y%m%d)

# Restore backup
mongorestore --db chitti_finserv ./backups/20231201/chitti_finserv/
```

### Log Rotation
```bash
# Install logrotate
sudo apt install logrotate

# Configure log rotation
sudo nano /etc/logrotate.d/chitti-finserv
```

### SSL Certificate
```bash
# Install Certbot
sudo apt install certbot

# Generate SSL certificate
sudo certbot certonly --standalone -d your-domain.com
```

## 🧪 Testing

### Backend Testing
```bash
# Install testing dependencies
npm install --save-dev jest supertest

# Run tests
npm test
```

### Admin Panel Testing
```bash
# Run tests
npm test

# Run with coverage
npm test -- --coverage
```

### Flutter Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

## 📞 Support

### Default Admin Credentials
- **Email**: admin@chittifinserv.com
- **Password**: admin123

### Common Issues

1. **CORS Errors**
   - Check CORS configuration in backend
   - Verify frontend URL in environment variables

2. **Database Connection Issues**
   - Verify MongoDB is running
   - Check connection string in config.env

3. **Firebase Configuration**
   - Verify service account credentials
   - Check FCM configuration

4. **Email Not Sending**
   - Verify SMTP credentials
   - Check email service configuration

### Contact Information
- **Email**: support@chittifinserv.com
- **Phone**: +91 9876543210
- **Documentation**: [Link to documentation]

## 📈 Performance Optimization

### Backend Optimization
- Enable compression
- Implement caching (Redis)
- Database indexing
- Connection pooling

### Frontend Optimization
- Code splitting
- Lazy loading
- Image optimization
- Bundle size optimization

### Database Optimization
- Create indexes for frequently queried fields
- Implement database connection pooling
- Regular database maintenance

## 🔄 Updates and Maintenance

### Regular Tasks
- Database backups (daily)
- Log rotation (weekly)
- Security updates (monthly)
- Performance monitoring (continuous)

### Update Process
1. Backup database
2. Update code
3. Run migrations
4. Test thoroughly
5. Deploy to production

---

This setup guide covers all aspects of the Chitti Finserv system. For additional support or questions, please refer to the documentation or contact the development team. 