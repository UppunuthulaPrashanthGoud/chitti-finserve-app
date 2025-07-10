# API Integration Documentation

## Overview

The Chitti Finserv Flutter app has been fully integrated with the backend APIs. All static JSON files have been replaced with dynamic API calls to the Node.js backend.

## Architecture

### Network Layer
- **NetworkService**: Centralized HTTP client with retry logic, timeout handling, and error management
- **ApiException**: Custom exception class for API errors
- **Base URL**: Configurable for development and production environments

### Repository Pattern
Each feature has its own repository that handles API calls:
- `LoginRepository` - Authentication and user management
- `CategoryRepository` - Loan categories
- `LoanFormRepository` - Loan applications
- `ContactRepository` - Contact information
- `SplashRepository` - App splash screen content
- `LeadStatusRepository` - Lead status management
- `ConfigRepository` - App-wide configuration
- `UserRepository` - User data and authentication state

### State Management
Using Riverpod for state management with providers:
- Repository providers for dependency injection
- State providers for UI state management
- Future providers for async data loading

## API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/send-otp` - Send OTP via SMS
- `POST /api/auth/verify-otp` - Verify OTP
- `GET /api/auth/me` - Get current user
- `PUT /api/auth/profile` - Update user profile
- `PUT /api/auth/change-password` - Change password

### Categories
- `GET /api/categories` - Get all categories
- `GET /api/categories/:id` - Get category by ID

### Loan Applications
- `POST /api/loan-applications` - Submit loan application
- `GET /api/loan-applications/user/:userId` - Get user applications
- `GET /api/loan-applications/:id` - Get application by ID

### Configuration
- `GET /api/configuration/public` - Get public app configuration

### Contact
- `POST /api/contact` - Submit contact form

## Key Features

### 1. Authentication Integration
- JWT token management
- Automatic token storage and retrieval
- Session persistence
- Secure logout functionality

### 2. Error Handling
- Centralized error handling in NetworkService
- Retry logic for network failures
- Timeout handling
- User-friendly error messages

### 3. State Management
- Loading states for all API calls
- Error states with user feedback
- Success states with data updates
- Automatic state cleanup

### 4. Offline Support
- Local storage for user data
- Token persistence
- Graceful degradation when offline

## Configuration

### Development
```dart
static const String baseUrl = 'http://localhost:5000/api';
```

### Production
```dart
static const String baseUrl = 'https://your-domain.com/api';
```

## Usage Examples

### Login
```dart
final loginState = ref.read(loginStateProvider.notifier);
await loginState.login(email, password);
```

### Get Categories
```dart
final categories = await ref.read(categoryListProvider.future);
```

### Submit Loan Application
```dart
final formState = ref.read(loanFormStateProvider.notifier);
await formState.submitApplication(formData);
```

### Check Authentication
```dart
final authState = ref.read(authStateProvider);
if (authState.isAuthenticated) {
  // User is logged in
}
```

## Error Handling

The app handles various types of errors:

1. **Network Errors**: Retry logic with exponential backoff
2. **Authentication Errors**: Automatic logout and redirect
3. **Validation Errors**: User-friendly error messages
4. **Server Errors**: Graceful degradation

## Security Features

1. **JWT Token Management**: Secure token storage and automatic refresh
2. **HTTPS**: All production API calls use HTTPS
3. **Input Validation**: Client-side validation before API calls
4. **Error Sanitization**: Sensitive data not exposed in error messages

## Performance Optimizations

1. **Request Caching**: Smart caching for frequently accessed data
2. **Lazy Loading**: Data loaded only when needed
3. **Connection Pooling**: Efficient HTTP connection management
4. **Compression**: Gzip compression for API responses

## Testing

### Unit Tests
- Repository tests with mocked API responses
- Provider tests for state management
- NetworkService tests for error handling

### Integration Tests
- End-to-end API integration tests
- Authentication flow tests
- Form submission tests

## Migration from Static JSON

The app has been migrated from static JSON files to dynamic APIs:

### Before
```dart
final data = await rootBundle.loadString('assets/json/categories.json');
```

### After
```dart
final response = await NetworkService.get('/categories');
final categories = NetworkService.parseResponse(response);
```

## Backend Requirements

The backend must provide:

1. **CORS Support**: For web platform
2. **JWT Authentication**: Secure token-based auth
3. **Rate Limiting**: Prevent abuse
4. **Input Validation**: Server-side validation
5. **Error Handling**: Consistent error responses
6. **Logging**: Request/response logging
7. **Monitoring**: Health checks and metrics

## Deployment Checklist

- [ ] Update base URL for production
- [ ] Configure SSL certificates
- [ ] Set up monitoring and logging
- [ ] Test all API endpoints
- [ ] Verify authentication flow
- [ ] Check error handling
- [ ] Test offline scenarios
- [ ] Performance testing
- [ ] Security audit

## Troubleshooting

### Common Issues

1. **Network Timeout**: Check server connectivity and timeout settings
2. **Authentication Errors**: Verify JWT token format and expiration
3. **CORS Errors**: Ensure backend CORS configuration
4. **Data Format Errors**: Verify API response structure matches models

### Debug Tools

- Network tab in browser dev tools
- Flutter inspector for state debugging
- Logging for API calls and errors
- Error reporting integration

## Future Enhancements

1. **Real-time Updates**: WebSocket integration for live data
2. **Push Notifications**: Firebase integration for notifications
3. **Offline Sync**: Local database with sync capabilities
4. **Analytics**: User behavior tracking
5. **A/B Testing**: Feature flag integration
6. **Performance Monitoring**: APM integration

## Support

For API integration issues:
1. Check network connectivity
2. Verify backend server status
3. Review API documentation
4. Check error logs
5. Test with Postman/curl 