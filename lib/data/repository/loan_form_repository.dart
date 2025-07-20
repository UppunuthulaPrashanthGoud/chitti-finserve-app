import 'dart:convert';
import '../../core/network_service.dart';
import '../../core/app_config.dart';
import '../model/loan_form_model.dart';
import '../model/category_model.dart';
import '../model/bank_model.dart';
import '../model/state_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

// Import ApiException from network_service
import '../../core/network_service.dart' show ApiException;

class LoanFormRepository {
  // Dynamic category mapping - will be populated from API
  final Map<String, String> _categoryMapping = {};
  
  // Cache for banks and states
  List<BankModel>? _cachedBanks;
  List<StateModel>? _cachedStates;

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

  Future<List<BankModel>> fetchBanks() async {
    try {
      if (_cachedBanks != null) {
        return _cachedBanks!;
      }
      final response = await NetworkService.get('/banks');
      final jsonMap = NetworkService.parseResponse(response);
      List<dynamic> banksData;
      if (jsonMap['data'] != null) {
        banksData = jsonMap['data'] as List<dynamic>;
      } else if (jsonMap is List) {
        banksData = jsonMap as List<dynamic>;
      } else {
        throw Exception('Invalid response format for banks');
      }
      _cachedBanks = banksData.map((e) => BankModel.fromJson(e)).toList();
      return _cachedBanks!;
    } catch (e) {
      throw Exception('Failed to load banks: $e');
    }
  }

  Future<List<StateModel>> fetchStates() async {
    try {
      if (_cachedStates != null) {
        return _cachedStates!;
      }
      final response = await NetworkService.get('/states');
      final jsonMap = NetworkService.parseResponse(response);
      List<dynamic> statesData;
      if (jsonMap['data'] != null) {
        statesData = jsonMap['data'] as List<dynamic>;
      } else if (jsonMap is List) {
        statesData = jsonMap as List<dynamic>;
      } else {
        throw Exception('Invalid response format for states');
      }
      _cachedStates = statesData.map((e) => StateModel.fromJson(e)).toList();
      return _cachedStates!;
    } catch (e) {
      throw Exception('Failed to load states: $e');
    }
  }

  Future<LoanFormModel> fetchLoanFormConfig() async {
    try {
      final response = await NetworkService.get('/configuration/public');
      final data = NetworkService.parseResponse(response);
      
      // Check if loanForm exists in the response
      if (data['data'] != null && data['data']['loanForm'] != null) {
        final loanFormConfig = LoanFormModel.fromJson(data['data']['loanForm']);
        
        // Fetch categories, banks, and states and update the form configuration
        try {
          final categories = await fetchCategories();
          final banks = await fetchBanks();
          final states = await fetchStates();
          
          // Populate category mapping
          _categoryMapping.clear();
          for (final category in categories) {
            _categoryMapping[category.name] = category.id;
          }
          
          // Update the form fields with dynamic options
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
            } else if (field.id == 'preferredBank') {
              // Always convert preferredBank to dropdown with bank options
              final bankOptions = banks.map((bank) => bank.name ?? '').where((name) => name.isNotEmpty).toList();
              return LoanFormField(
                id: field.id,
                label: field.label ?? 'Preferred Bank',
                type: 'dropdown',
                required: field.required ?? true,
                autofill: field.autofill,
                options: bankOptions,
              );
            } else if (field.id == 'state') {
              // Always convert state to dropdown with state options
              final stateOptions = states.map((state) => state.name ?? '').where((name) => name.isNotEmpty).toList();
              return LoanFormField(
                id: field.id,
                label: field.label ?? 'State',
                type: 'dropdown',
                required: field.required ?? true,
                autofill: field.autofill,
                options: stateOptions,
              );
            }
            return field;
          }).toList();
          
          // Add preferredBank field if it doesn't exist
          bool hasPreferredBank = updatedFields?.any((field) => field.id == 'preferredBank') ?? false;
          if (!hasPreferredBank) {
            final bankOptions = banks.map((bank) => bank.name ?? '').where((name) => name.isNotEmpty).toList();
            updatedFields?.add(LoanFormField(
              id: 'preferredBank',
              label: 'Preferred Bank',
              type: 'dropdown',
              required: true,
              autofill: false,
              options: bankOptions,
            ));
          }
          
          // Add state field if it doesn't exist
          bool hasState = updatedFields?.any((field) => field.id == 'state') ?? false;
          if (!hasState) {
            final stateOptions = states.map((state) => state.name ?? '').where((name) => name.isNotEmpty).toList();
            updatedFields?.add(LoanFormField(
              id: 'state',
              label: 'State',
              type: 'dropdown',
              required: true,
              autofill: false,
              options: stateOptions,
            ));
          }
          
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
          return loanFormConfig;
        }
      } else if (data['loanForm'] != null) {
        return LoanFormModel.fromJson(data['loanForm']);
      } else {
        throw Exception('Loan form configuration not found');
      }
    } catch (e) {
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
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Map category name to category ID using dynamic mapping
      if (formData.containsKey('category') && formData['category'] is String) {
        final categoryName = formData['category'] as String;
        final categoryId = _categoryMapping[categoryName];
        if (categoryId != null) {
          formData['category'] = categoryId;
        } else {
          // Use first available category ID if mapping not found
          if (_categoryMapping.isNotEmpty) {
            formData['category'] = _categoryMapping.values.first;
          } else {
            // Fallback to a default ID if no categories are available
            formData['category'] = '507f1f77bcf86cd799439011';
          }
        }
      }

      final response = await NetworkService.post(
        '/loan-applications',
        body: formData,
        token: token,
      );
      
      final responseData = NetworkService.parseResponse(response);
      
      return responseData;
    } catch (e) {
      
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

  /// Uploads Aadhar and/or PAN file to backend and returns uploaded file paths
  Future<Map<String, String>> uploadApplicationDocuments({File? aadharFile, File? panFile}) async {
    final token = await _getAuthToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }
    
    final uri = Uri.parse('${NetworkService.baseUrl}/upload/application-documents');
    
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    
    if (aadharFile != null) {
      try {
        final multipartFile = await http.MultipartFile.fromPath('aadharCard', aadharFile.path);
        request.files.add(multipartFile);
      } catch (e) {
        throw Exception('Failed to attach Aadhar file: $e');
      }
    }
    if (panFile != null) {
      try {
        final multipartFile = await http.MultipartFile.fromPath('panCard', panFile.path);
        request.files.add(multipartFile);
      } catch (e) {
        throw Exception('Failed to attach PAN file: $e');
      }
    }
    
    try {
      final streamedResponse = await request.send();
      
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to upload documents: ${response.body}');
      }
      
      final data = NetworkService.parseResponse(response);
      
      final result = <String, String>{};
      if (data['data'] != null) {
        if (data['data']['aadharCard'] != null) {
          result['aadharCard'] = data['data']['aadharCard']['path'];
        }
        if (data['data']['panCard'] != null) {
          result['panCard'] = data['data']['panCard']['path'];
        }
      }
      return result;
    } catch (e) {
      rethrow;
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

      final response = await NetworkService.get('/loan-applications/user/application/$applicationId', token: token);
      return NetworkService.parseResponse(response);
    } catch (e) {
      String errorMessage = 'Failed to fetch application details';
      if (e.toString().contains('404')) {
        errorMessage = 'Application not found';
      } else if (e.toString().contains('403')) {
        errorMessage = 'Access denied. This application does not belong to you.';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Authentication failed. Please login again.';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Server error. Please try again later.';
      }
      throw Exception(errorMessage);
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
