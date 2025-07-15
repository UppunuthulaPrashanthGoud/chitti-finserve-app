import 'dart:convert';
import '../../core/network_service.dart';
import '../../core/app_config.dart';
import '../model/loan_form_model.dart';
import '../model/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanFormRepository {
  // Dynamic category mapping - will be populated from API
  final Map<String, String> _categoryMapping = {};

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await NetworkService.get('/categories');
      final jsonMap = NetworkService.parseResponse(response);
      final categories = jsonMap['data'] as List<dynamic>;
      return categories.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<LoanFormModel> fetchLoanFormConfig() async {
    try {
      if (AppConfig.enableLogging) {
        print('🔧 LoanFormRepository Debug: Fetching loan form configuration...');
      }
      final response = await NetworkService.get('/configuration/public');
      final data = NetworkService.parseResponse(response);
      
      if (AppConfig.enableLogging) {
        print('🔧 LoanFormRepository Debug: Full response structure:');
        print('Available keys: ${data.keys.toList()}');
      }
      
      // Check if loanForm exists in the response
      if (data['data'] != null && data['data']['loanForm'] != null) {
        if (AppConfig.enableLogging) {
          print('✅ LoanFormRepository Debug: Found loanForm in data.loanForm');
        }
        final loanFormConfig = LoanFormModel.fromJson(data['data']['loanForm']);
        
        // Fetch categories and update the form configuration
        try {
          final categories = await fetchCategories();
          if (AppConfig.enableLogging) {
            print('🔧 LoanFormRepository Debug: Fetched ${categories.length} categories');
          }
          
          // Populate category mapping
          _categoryMapping.clear();
          for (final category in categories) {
            _categoryMapping[category.name] = category.id;
          }
          if (AppConfig.enableLogging) {
            print('🔧 LoanFormRepository Debug: Updated category mapping: $_categoryMapping');
          }
          
          // Update the category field options with dynamic categories
          final updatedFields = loanFormConfig.fields?.map((field) {
            if (field.id == 'category' && field.type == 'dropdown') {
              // Create new field with dynamic category options
              return LoanFormField(
                id: field.id,
                label: field.label,
                type: field.type,
                required: field.required,
                autofill: field.autofill,
                options: categories.map((cat) => cat.name).toList(),
              );
            }
            return field;
          }).toList();
          
          // Create updated loan form model
          return LoanFormModel(
            title: loanFormConfig.title,
            fields: updatedFields,
            submitButton: loanFormConfig.submitButton,
            thankYouMessage: loanFormConfig.thankYouMessage,
            errorMessage: loanFormConfig.errorMessage,
            formTitle: loanFormConfig.formTitle,
            formSubtitle: loanFormConfig.formSubtitle,
            enableDocuments: loanFormConfig.enableDocuments,
            enableTerms: loanFormConfig.enableTerms,
            requiredFields: loanFormConfig.requiredFields,
            categories: loanFormConfig.categories,
            isActive: loanFormConfig.isActive,
          );
        } catch (e) {
          if (AppConfig.enableLogging) {
            print('⚠️ LoanFormRepository Debug: Failed to fetch categories, using static options: $e');
          }
          return loanFormConfig;
        }
      } else if (data['loanForm'] != null) {
        if (AppConfig.enableLogging) {
          print('✅ LoanFormRepository Debug: Found loanForm in response');
        }
        return LoanFormModel.fromJson(data['loanForm']);
      } else {
        if (AppConfig.enableLogging) {
          print('❌ LoanFormRepository Debug: loanForm not found in response');
          print('Response structure: ${JsonEncoder.withIndent('  ').convert(data)}');
        }
        throw Exception('Loan form configuration not found');
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ LoanFormRepository Debug: Error fetching config: $e');
      }
      throw Exception('Failed to fetch loan form configuration: $e');
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await NetworkService.get('/auth/me', token: token);
      return NetworkService.parseResponse(response);
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  Future<Map<String, dynamic>> submitLoanApplication(Map<String, dynamic> formData) async {
    try {
      if (AppConfig.enableLogging) {
        print('🔧 LoanFormRepository Debug: Submitting loan application');
        print('Form data: ${JsonEncoder.withIndent('  ').convert(formData)}');
      }
      
      final token = await _getAuthToken();
      if (AppConfig.enableLogging) {
        print('🔧 LoanFormRepository Debug: Auth token: ${token != null ? 'Found' : 'Not found'}');
      }
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Map category name to category ID using dynamic mapping
      if (formData.containsKey('category') && formData['category'] is String) {
        final categoryName = formData['category'] as String;
        final categoryId = _categoryMapping[categoryName];
        if (categoryId != null) {
          formData['category'] = categoryId;
          if (AppConfig.enableLogging) {
            print('🔧 LoanFormRepository Debug: Mapped category "$categoryName" to ID "$categoryId"');
          }
        } else {
          if (AppConfig.enableLogging) {
            print('⚠️ LoanFormRepository Debug: Category "$categoryName" not found in mapping, using first available category');
          }
          // Use first available category ID if mapping not found
          if (_categoryMapping.isNotEmpty) {
            formData['category'] = _categoryMapping.values.first;
          } else {
            // Fallback to a default ID if no categories are available
            formData['category'] = '507f1f77bcf86cd799439011';
          }
        }
      }

      if (AppConfig.enableLogging) {
        print('🔧 LoanFormRepository Debug: Making API call to /loan-applications');
      }
      final response = await NetworkService.post(
        '/loan-applications',
        body: formData,
        token: token,
      );
      
      if (AppConfig.enableLogging) {
        print('🔧 LoanFormRepository Debug: Response status: ${response.statusCode}');
        print('🔧 LoanFormRepository Debug: Response body: ${response.body}');
      }
      
      final responseData = NetworkService.parseResponse(response);
      if (AppConfig.enableLogging) {
        print('🔧 LoanFormRepository Debug: Parsed response:');
        print('${JsonEncoder.withIndent('  ').convert(responseData)}');
      }
      
      return responseData;
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ LoanFormRepository Debug: Error submitting application: $e');
      }
      
      // If it's an ApiException with validation errors, extract the messages
      if (e is ApiException && e.data != null && e.data!['errors'] != null) {
        final errors = e.data!['errors'] as List;
        final errorMessages = errors.map((error) => error['msg'] ?? 'Validation error').toList();
        throw Exception(errorMessages.join('\n'));
      }
      
      // Try to extract more detailed error information
      String errorMessage = 'Failed to submit loan application';
      if (e.toString().contains('400')) {
        if (e.toString().contains('already have') && e.toString().contains('loan application')) {
          errorMessage = 'You already have an application for this loan type. You can only apply for one loan of each type at a time.';
        } else {
          errorMessage = 'Validation failed. Please check all required fields.';
        }
      } else if (e.toString().contains('401')) {
        errorMessage = 'Authentication failed. Please login again.';
      } else if (e.toString().contains('403')) {
        errorMessage = 'Access denied.';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Server error. Please try again later.';
      }
      throw Exception(errorMessage);
    }
  }

  Future<List<Map<String, dynamic>>> getUserApplications() async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await NetworkService.get('/loan-applications/user/my-applications', token: token);
      final data = NetworkService.parseResponse(response);
      return List<Map<String, dynamic>>.from(data['data'] ?? []);
    } catch (e) {
      throw Exception('Failed to get user applications: $e');
    }
  }

  Future<Map<String, dynamic>> getApplicationById(String applicationId) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await NetworkService.get('/loan-applications/$applicationId', token: token);
      return NetworkService.parseResponse(response);
    } catch (e) {
      throw Exception('Failed to get application: $e');
    }
  }

  Future<String?> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      return null;
    }
  }
}
