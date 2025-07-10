# Chitti Finserv - Complete Setup Instructions

## Overview
This project includes:
1. **Flutter Mobile App** - User-facing loan application
2. **Node.js Backend API** - RESTful API with MongoDB
3. **React Admin Panel** - Admin dashboard for managing the system

## Prerequisites
- Node.js (v16 or higher)
- MongoDB (local or Atlas)
- Flutter SDK
- Firebase Project
- Gmail account for SMTP

## Step 1: Backend Setup

### 1.1 Install Dependencies
```bash
cd backend
npm install
```

### 1.2 Environment Configuration
Copy `config.env.example` to `.env` and configure:

```env
# Server Configuration
PORT=5000
NODE_ENV=development

# MongoDB Configuration
MONGODB_URI=mongodb://localhost:27017/chitti_finserv

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRE=7d

# Firebase Configuration
FIREBASE_PROJECT_ID=your-firebase-project-id
FIREBASE_PRIVATE_KEY_ID=your-private-key-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYour Private Key Here\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@your-project.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=your-client-id
FIREBASE_AUTH_URI=https://accounts.google.com/o/oauth2/auth
FIREBASE_TOKEN_URI=https://oauth2.googleapis.com/token
FIREBASE_AUTH_PROVIDER_X509_CERT_URL=https://www.googleapis.com/oauth2/v1/certs
FIREBASE_CLIENT_X509_CERT_URL=https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xxxxx%40your-project.iam.gserviceaccount.com

# SMTP Configuration
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
SMTP_FROM=Chitti Finserv <noreply@chittifinserv.com>

# Admin Configuration
ADMIN_EMAIL=admin@chittifinserv.com
ADMIN_PASSWORD=admin123
```

### 1.3 Firebase Setup
1. Create a Firebase project
2. Enable Authentication and Cloud Messaging
3. Generate service account key
4. Add the configuration to your `.env` file

### 1.4 SMTP Setup
1. Enable 2-factor authentication on your Gmail
2. Generate an app password
3. Use the app password in SMTP_PASS

### 1.5 Start Backend
```bash
npm run dev
```

## Step 2: Admin Panel Setup

### 2.1 Install Dependencies
```bash
cd admin-panel
npm install
```

### 2.2 Start Admin Panel
```bash
npm start
```

The admin panel will be available at `http://localhost:3000`

## Step 3: Flutter App Setup

### 3.1 Update API Base URL
In your Flutter app, update the API base URL in your repository files:

```dart
// Example: lib/data/repository/auth_repository.dart
static const String baseUrl = 'http://localhost:5000/api';
```

### 3.2 Firebase Configuration
1. Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
2. Configure Firebase in your Flutter app

### 3.3 Run Flutter App
```bash
flutter run
```

## Step 4: Database Setup

### 4.1 MongoDB Setup
1. Install MongoDB locally or use MongoDB Atlas
2. Create a database named `chitti_finserv`
3. The collections will be created automatically when you first use the API

### 4.2 Initial Data Setup
The system will automatically create an admin user on first run. Default credentials:
- Email: `admin@chittifinserv.com`
- Password: `admin123`

## Step 5: File Upload Setup

### 5.1 Create Upload Directory
```bash
cd backend
mkdir uploads
```

### 5.2 Configure File Upload
The backend is configured to handle file uploads. Files will be stored in the `uploads` directory and served statically.

## Step 6: Testing the Setup

### 6.1 Test Backend API
```bash
curl http://localhost:5000/api/health
```

### 6.2 Test Admin Panel
1. Open `http://localhost:3000`
2. Login with admin credentials
3. Navigate through different sections

### 6.3 Test Flutter App
1. Run the Flutter app
2. Test registration and login
3. Test loan application submission

## API Endpoints Overview

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/send-otp` - Send OTP
- `POST /api/auth/verify-otp` - Verify OTP

### Categories
- `GET /api/categories` - Get all categories
- `POST /api/categories` - Create category (Admin)
- `PUT /api/categories/:id` - Update category (Admin)
- `DELETE /api/categories/:id` - Delete category (Admin)

### Loan Applications
- `GET /api/loan-applications` - Get all applications (Agent/Admin)
- `POST /api/loan-applications` - Create application
- `PUT /api/loan-applications/:id/status` - Update status (Agent/Admin)
- `GET /api/loan-applications/my-applications` - User's applications

## Admin Panel Features

### Dashboard
- Overview statistics
- Recent applications
- Monthly trends

### User Management
- View all users
- Update user status
- View user details

### Category Management
- Create/edit/delete categories
- Reorder categories
- Upload category icons

### Application Management
- View all loan applications
- Filter by status/category
- Update application status
- Add remarks
- View application details

### Configuration
- SMTP settings
- Firebase settings
- App settings
- Legal documents

## Security Features

### Backend Security
- JWT authentication
- Password hashing with bcrypt
- Rate limiting
- CORS protection
- Input validation
- SQL injection protection

### Admin Panel Security
- Protected routes
- Role-based access
- Session management
- Secure API calls

## Deployment

### Backend Deployment
1. Set `NODE_ENV=production`
2. Use MongoDB Atlas for database
3. Deploy to Heroku, Vercel, or AWS
4. Set up environment variables

### Admin Panel Deployment
1. Build the React app: `npm run build`
2. Deploy to Netlify, Vercel, or AWS
3. Update API base URL for production

### Flutter App Deployment
1. Update API base URL for production
2. Build for Android: `flutter build apk`
3. Build for iOS: `flutter build ios`
4. Submit to app stores

## Troubleshooting

### Common Issues

1. **MongoDB Connection Error**
   - Check MongoDB is running
   - Verify connection string
   - Check network connectivity

2. **Firebase Configuration Error**
   - Verify service account key
   - Check project ID
   - Ensure Firebase project is set up correctly

3. **SMTP Error**
   - Verify Gmail credentials
   - Check app password is correct
   - Ensure 2FA is enabled

4. **CORS Error**
   - Check CORS configuration in backend
   - Verify frontend URL is allowed

5. **JWT Token Error**
   - Check JWT_SECRET is set
   - Verify token expiration
   - Check token format

### Logs
- Backend logs are in console
- Check browser console for frontend errors
- Use Flutter debug console for app errors

## Support

For issues or questions:
1. Check the API documentation
2. Review error logs
3. Test individual components
4. Verify environment configuration

## Next Steps

1. **Customization**: Update branding, colors, and content
2. **Additional Features**: Add more loan types, payment integration
3. **Analytics**: Implement detailed analytics and reporting
4. **Mobile App**: Add more features to the Flutter app
5. **Testing**: Add comprehensive unit and integration tests
6. **Monitoring**: Set up application monitoring and logging 