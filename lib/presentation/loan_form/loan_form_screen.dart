import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'loan_form_provider.dart';
import '../../data/model/loan_form_model.dart';
import '../../data/model/category_model.dart';
import '../profile/profile_provider.dart';
import '../user/user_provider.dart';
import '../legal/terms_conditions_screen.dart';
import '../legal/privacy_policy_screen.dart';
import '../applied_loans/applied_loans_screen.dart';
import 'dart:convert'; // Added for json.decode
import 'package:http/http.dart' as http; // Added for http.MultipartRequest
import '../../core/network_service.dart'; // Added for NetworkService
import '../../core/validation_helper.dart'; // Added for ValidationHelper
import 'success_screen.dart';
import '../../core/app_config.dart';

class LoanFormScreen extends ConsumerStatefulWidget {
  final String? prefillMobile;
  final String? prefillLoanType;
  final CategoryModel? selectedCategory;
  const LoanFormScreen({
    Key? key, 
    this.prefillMobile, 
    this.prefillLoanType,
    this.selectedCategory,
  }) : super(key: key);

  @override
  ConsumerState<LoanFormScreen> createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends ConsumerState<LoanFormScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _dropdownValues = {};
  final Map<String, String?> _filePaths = {};
  String? aadharDocPath;
  String? panDocPath;
  bool _loading = false;
  String? _error;
  bool _submitted = false;
  bool _acceptedTerms = false;
  bool _hasPrefilled = false; // Add flag to prevent multiple prefill calls

  @override
  void initState() {
    super.initState();
    _error = null;
    _loading = false;
    _submitted = false;
    _hasPrefilled = false;
  }

  @override
  void dispose() {
    for (final ctrl in _controllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _prefillFromProfile() {
    final profileAsync = ref.read(profileProvider);
    profileAsync.whenData((profile) {
      if (profile != null) {
        // Auto-fill from profile data using correct field names
        if (_controllers.containsKey('full_name') && _controllers['full_name']!.text.isEmpty) {
          _controllers['full_name']!.text = profile.name ?? '';
        }
        if (_controllers.containsKey('mobile') && _controllers['mobile']!.text.isEmpty) {
          _controllers['mobile']!.text = profile.phone ?? '';
        }
        if (_controllers.containsKey('email') && _controllers['email']!.text.isEmpty) {
          _controllers['email']!.text = profile.email ?? '';
        }
        if (_controllers.containsKey('aadhar_number') && _controllers['aadhar_number']!.text.isEmpty) {
          _controllers['aadhar_number']!.text = profile.aadharNumber ?? '';
        }
        if (_controllers.containsKey('pan_number') && _controllers['pan_number']!.text.isEmpty) {
          _controllers['pan_number']!.text = profile.panNumber ?? '';
        }
        if (_controllers.containsKey('aadhar_upload') && _dropdownValues['aadhar_upload'] == null) {
          setState(() {
            _dropdownValues['aadhar_upload'] = profile.aadharUpload;
          });
        }
        if (_controllers.containsKey('pan_upload') && _dropdownValues['pan_upload'] == null) {
          setState(() {
            _dropdownValues['pan_upload'] = profile.panUpload;
          });
        }
      }
    });
  }

  void _prefillFromBackendUser() async {
    if (_hasPrefilled) return; // Prevent multiple calls
    
    try {
      final userData = await ref.read(loanFormRepositoryProvider).getCurrentUser();
      if (userData != null) {
        // Auto-fill from backend user data
        if (_controllers.containsKey('full_name') && _controllers['full_name']!.text.isEmpty) {
          _controllers['full_name']!.text = userData['name'] ?? '';
        }
        if (_controllers.containsKey('mobile') && _controllers['mobile']!.text.isEmpty) {
          _controllers['mobile']!.text = userData['phone'] ?? '';
        }
        if (_controllers.containsKey('email') && _controllers['email']!.text.isEmpty) {
          _controllers['email']!.text = userData['email'] ?? '';
        }
        if (_controllers.containsKey('aadhar_number') && _controllers['aadhar_number']!.text.isEmpty) {
          _controllers['aadhar_number']!.text = userData['aadharNumber'] ?? '';
        }
        if (_controllers.containsKey('pan_number') && _controllers['pan_number']!.text.isEmpty) {
          _controllers['pan_number']!.text = userData['panNumber'] ?? '';
        }
        if (_controllers.containsKey('aadhar_upload') && _dropdownValues['aadhar_upload'] == null) {
          setState(() {
            _dropdownValues['aadhar_upload'] = userData['aadharUpload'];
          });
        }
        if (_controllers.containsKey('pan_upload') && _dropdownValues['pan_upload'] == null) {
          setState(() {
            _dropdownValues['pan_upload'] = userData['panUpload'];
          });
        }
        _hasPrefilled = true; // Mark as prefilled
      }
    } catch (e) {
      // If backend fails, fall back to profile data
      _prefillFromProfile();
    }
  }

  void _prefillFromWidget() {
    if (_hasPrefilled) return; // Prevent multiple calls
    
    final mobile = widget.prefillMobile;
    final loanType = widget.prefillLoanType;
    
    if (mobile != null && _controllers.containsKey('mobile')) {
      if (_controllers['mobile']!.text.isEmpty) {
        _controllers['mobile']!.text = mobile;
      }
    }
    if (loanType != null) {
      // Ensure the dropdown value is set after the form is loaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_dropdownValues['purpose'] == null) {
          setState(() {
            _dropdownValues['purpose'] = loanType;
          });
        }
      });
    }
  }

  Future<String?> _uploadDocument(String fieldId, String? filePath) async {
    if (filePath == null || filePath.isEmpty) return null;
    final uri = Uri.parse('${NetworkService.baseUrl}/upload/document');
    final request = http.MultipartRequest('POST', uri);
    
    // Determine the correct field name based on fieldId
    String fieldName = 'document';
    if (fieldId == 'aadharUpload') {
      fieldName = 'aadharCard';
    } else if (fieldId == 'panUpload') {
      fieldName = 'panCard';
    }
    
    request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));
    // Add auth token if needed
    final token = await ref.read(userRepositoryProvider).getAuthToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final respJson = json.decode(respStr);
      return respJson['data']?['path'];
    }
    return null;
  }

  void _submit(LoanFormModel config) async {
    // Check if terms and conditions are accepted
    if (!_acceptedTerms) {
      ValidationHelper.showValidationError(context, 'Please accept the Terms & Conditions to continue');
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      // Build form data based on actual field IDs from configuration
      final Map<String, dynamic> formData = {};
      
      // Handle selected category first
      if (widget.selectedCategory != null) {
        formData['category'] = widget.selectedCategory!.name;
        formData['loanType'] = widget.selectedCategory!.name.toLowerCase().replaceAll(' ', '-');
      }
      
      // Map fields based on their IDs from the configuration
      for (final field in config.fields ?? []) {
        final fieldId = field.id ?? '';
        
        // Skip category field if we have a selected category
        if (fieldId == 'category' && widget.selectedCategory != null) {
          continue;
        }
        
        if (field.type == 'dropdown') {
          final value = _dropdownValues[fieldId];
          if (value != null && value.isNotEmpty) {
            // Map dropdown values to backend field names
            switch (fieldId) {
              case 'category':
                // Use the category name directly - the repository will map it to ID
                formData['category'] = value;
                // Also set loanType based on category name
                formData['loanType'] = value.toLowerCase().replaceAll(' ', '-');
                break;
              case 'purpose':
                formData['loanPurpose'] = value;
                break;
              case 'employmentType':
                formData['employmentType'] = value;
                break;
              default:
                formData[fieldId] = value;
            }
          }
        } else {
          final controller = _controllers[fieldId];
          if (controller != null && controller.text.isNotEmpty) {
            // Map text field values to backend field names
            switch (fieldId) {
              case 'loanAmount':
                formData['loanAmount'] = double.tryParse(controller.text) ?? 0;
                break;
              case 'monthlyIncome':
                formData['monthlyIncome'] = double.tryParse(controller.text) ?? 0;
                break;
              case 'aadharNumber':
                formData['aadharNumber'] = controller.text;
                break;
              case 'panNumber':
                formData['panNumber'] = controller.text;
                break;
              case 'street':
                if (!formData.containsKey('address')) formData['address'] = {};
                (formData['address'] as Map)['street'] = controller.text;
                break;
              case 'city':
                if (!formData.containsKey('address')) formData['address'] = {};
                (formData['address'] as Map)['city'] = controller.text;
                break;
              case 'state':
                if (!formData.containsKey('address')) formData['address'] = {};
                (formData['address'] as Map)['state'] = controller.text;
                break;
              case 'pincode':
                if (!formData.containsKey('address')) formData['address'] = {};
                (formData['address'] as Map)['pincode'] = controller.text;
                break;
              default:
                formData[fieldId] = controller.text;
            }
          }
        }
      }
      
      // Add documents if uploaded
      if (aadharDocPath != null || panDocPath != null) {
        formData['documents'] = {};
        if (aadharDocPath != null) {
          (formData['documents'] as Map)['aadharCard'] = aadharDocPath;
        }
        if (panDocPath != null) {
          (formData['documents'] as Map)['panCard'] = panDocPath;
        }
      }
      
      // Debug: Print final form data
      print('🔧 Mobile App Debug: Final form data:');
      print('${JsonEncoder.withIndent('  ').convert(formData)}');
      
      // Validate required fields for backend
      final List<String> missingFields = [];
      
      if (!formData.containsKey('category') || formData['category'] == null) {
        missingFields.add('category');
      }
      // loanType is automatically generated from category, so no need to validate separately
      if (!formData.containsKey('loanAmount') || formData['loanAmount'] == 0) {
        missingFields.add('loanAmount');
      }
      if (!formData.containsKey('loanPurpose') || formData['loanPurpose'] == null) {
        missingFields.add('loanPurpose');
      }
      if (!formData.containsKey('monthlyIncome') || formData['monthlyIncome'] == 0) {
        missingFields.add('monthlyIncome');
      }
      if (!formData.containsKey('employmentType') || formData['employmentType'] == null) {
        missingFields.add('employmentType');
      }
      
      // Check address fields
      final address = formData['address'] as Map?;
      if (address == null || address.isEmpty) {
        missingFields.add('address');
      } else {
        if (!address.containsKey('street') || address['street'] == null) {
          missingFields.add('address.street');
        }
        if (!address.containsKey('city') || address['city'] == null) {
          missingFields.add('address.city');
        }
        if (!address.containsKey('state') || address['state'] == null) {
          missingFields.add('address.state');
        }
        if (!address.containsKey('pincode') || address['pincode'] == null) {
          missingFields.add('address.pincode');
        }
      }
      
      if (missingFields.isNotEmpty) {
        print('❌ Mobile App Debug: Missing required fields: $missingFields');
        setState(() {
          _loading = false;
        });
        ValidationHelper.showValidationError(context, 'Please fill in all required fields: ${missingFields.join(', ')}');
        return;
      }

      // Check authentication first
      final token = await ref.read(userRepositoryProvider).getAuthToken();
      if (token == null) {
        setState(() {
          _loading = false;
        });
        ValidationHelper.showValidationError(context, 'Please login to submit an application');
        return;
      }
      
      print('🔧 Mobile App Debug: User is authenticated, proceeding with submission');
      
      // Submit the application
      await ref.read(loanFormRepositoryProvider).submitLoanApplication(formData);
      
      setState(() {
        _loading = false;
        _submitted = true;
      });
      
    } catch (e) {
      String errorMessage = e.toString();
      
      // Parse validation errors from backend
      if (errorMessage.contains('Validation error') || errorMessage.contains('400') || errorMessage.contains('Validation failed')) {
        try {
          // Check if the error message contains JSON data
          if (errorMessage.contains('{"success":false}') || errorMessage.contains('"errors"')) {
            // Extract JSON from the error message
            final jsonStart = errorMessage.indexOf('{');
            final jsonEnd = errorMessage.lastIndexOf('}') + 1;
            if (jsonStart != -1 && jsonEnd > jsonStart) {
              final jsonString = errorMessage.substring(jsonStart, jsonEnd);
              final errorData = json.decode(jsonString);
              
              if (errorData is Map && errorData['errors'] != null) {
                final errors = errorData['errors'] as List;
                final errorMsgs = errors.map((error) => error['msg'] ?? 'Validation error').toList();
                if (errorMsgs.isNotEmpty) {
                  errorMessage = errorMsgs.join('\n');
                }
              }
            }
          }
        } catch (_) {
          // If JSON parsing fails, use a generic message
          errorMessage = 'Please check all required fields and try again.';
        }
      } else if (errorMessage.contains('already have') && errorMessage.contains('loan application')) {
        errorMessage = 'You already have an application for this loan type. You can only apply for one loan of each type at a time.';
      } else if (errorMessage.contains('Network error')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (errorMessage.contains('timeout')) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (errorMessage.contains('Authentication failed')) {
        errorMessage = 'Please login again to submit your application.';
      } else if (errorMessage.contains('Server error')) {
        errorMessage = 'Server error. Please try again later.';
      }
      
      setState(() {
        _loading = false;
      });
      
      // Show error using ValidationHelper
      ValidationHelper.showValidationError(context, errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loanFormAsync = ref.watch(loanFormConfigProvider);
    return Scaffold(
      body: loanFormAsync.when(
        data: (config) {
          // Prefill logic after config loads - only once
          if (!_hasPrefilled) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_hasPrefilled) {
                _prefillFromBackendUser();
                _prefillFromWidget();
              }
            });
          }
          if (_submitted) {
            return SuccessScreen(
              thankYouMessage: config.thankYouMessage ?? 'Thank you for your application!',
            );
          }
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF005DFF),
                  const Color(0xFF5BB5FF),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header with selected category
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back button
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                iconSize: 20,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Category icon and name in header
                        if (widget.selectedCategory != null)
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: widget.selectedCategory!.icon != null && widget.selectedCategory!.icon!.isNotEmpty
                                    ? Image.network(
                                        widget.selectedCategory!.icon!.startsWith('http')
                                            ? widget.selectedCategory!.icon!
                                            : widget.selectedCategory!.icon!.startsWith('uploads/')
                                                ? AppConfig.apiBaseUrl.replaceFirst('/api', '') + '/' + widget.selectedCategory!.icon!
                                                : AppConfig.apiBaseUrl.replaceFirst('/api', '') + '/uploads/' + widget.selectedCategory!.icon!,
                                        width: 36,
                                        height: 36,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Icon(Icons.category, size: 36, color: const Color(0xFF005DFF)),
                                      )
                                    : Icon(Icons.category, size: 36, color: const Color(0xFF005DFF)),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                widget.selectedCategory!.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                        if (widget.selectedCategory == null)
                          Text(
                            config.title ?? 'Loan Application',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          'Complete your application',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Form Content
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                          child: Column(
                            children: [
                              // Form fields with minimal spacing
                              ..._buildFormFields(config.fields ?? []),
                              
                              const SizedBox(height: 24),
                              
                              // Terms and Conditions Consent
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF005DFF).withOpacity(0.05),
                                      const Color(0xFF5BB5FF).withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFF005DFF).withOpacity(0.2)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: _acceptedTerms ? const Color(0xFF005DFF) : Colors.grey[300],
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Checkbox(
                                            value: _acceptedTerms,
                                            onChanged: (value) {
                                              setState(() {
                                                _acceptedTerms = value ?? false;
                                              });
                                            },
                                            activeColor: Colors.white,
                                            checkColor: const Color(0xFF005DFF),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'I accept the Terms & Conditions',
                                                style: TextStyle(
                                                  color: const Color(0xFF005DFF),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  fontFamily: 'Montserrat',
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'By checking this box, you agree to our Terms & Conditions and Privacy Policy.',
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 13,
                                                  fontFamily: 'Montserrat',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: const Color(0xFF005DFF).withOpacity(0.3)),
                                            ),
                                            child: TextButton.icon(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const TermsConditionsScreen(),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.description, size: 16),
                                              label: const Text('View Terms'),
                                              style: TextButton.styleFrom(
                                                foregroundColor: const Color(0xFF005DFF),
                                                textStyle: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Montserrat',
                                                ),
                                                padding: EdgeInsets.zero,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: const Color(0xFF005DFF).withOpacity(0.3)),
                                            ),
                                            child: TextButton.icon(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const PrivacyPolicyScreen(),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.privacy_tip, size: 16),
                                              label: const Text('View Privacy'),
                                              style: TextButton.styleFrom(
                                                foregroundColor: const Color(0xFF005DFF),
                                                textStyle: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Montserrat',
                                                ),
                                                padding: EdgeInsets.zero,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                  const SizedBox(height: 24),
                              
                              // Submit Button
                  _loading
                                  ? Container(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          const CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF005DFF)),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Processing your application...',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16,
                                              fontFamily: 'Montserrat',
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                          width: double.infinity,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: _acceptedTerms 
                                            ? [const Color(0xFF005DFF), const Color(0xFF5BB5FF)]
                                            : [Colors.grey[400]!, Colors.grey[400]!],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: _acceptedTerms ? [
                                          BoxShadow(
                                            color: const Color(0xFF005DFF).withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ] : null,
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: _acceptedTerms ? () => _submit(config) : null,
                                          borderRadius: BorderRadius.circular(16),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 18),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.send,
                                                  color: Colors.white,
                                                  size: 22,
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  config.submitButton ?? 'Submit Application',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
        loading: () => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF005DFF),
                const Color(0xFF5BB5FF),
              ],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        error: (e, _) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF005DFF),
                const Color(0xFF5BB5FF),
              ],
            ),
          ),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Failed to load form!',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Montserrat'),
                  ),
                  const SizedBox(height: 12),
                  Text(e.toString(), style: const TextStyle(color: Colors.redAccent, fontFamily: 'Montserrat')),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    onPressed: () => setState(() {}),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005DFF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields(List<LoanFormField> fields) {
    return fields.where((field) {
      // If a category is selected, skip the category field entirely
      if (field.id == 'category' && widget.selectedCategory != null) {
        return false;
      }
      return true;
    }).map((field) {
      final fieldId = field.id ?? 'unknown_field';
      if (!_controllers.containsKey(fieldId)) {
        _controllers[fieldId] = TextEditingController();
      }
      
      switch (field.type) {
        case 'dropdown':
          final currentValue = _dropdownValues[fieldId];
          final options = field.options ?? [];
          // Ensure the current value exists in options, otherwise set to null
          final validValue = options.any((opt) {
            final optionValue = opt is String ? opt : opt.toString();
            return optionValue == currentValue;
          }) ? currentValue : null;
          if (validValue != currentValue) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _dropdownValues[fieldId] = validValue;
              });
            });
          }
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              value: validValue,
              items: options.map((opt) {
                // Handle both string and dynamic options
                final optionValue = opt is String ? opt : opt.toString();
                return DropdownMenuItem<String>(
                  value: optionValue,
                  child: Text(optionValue),
                );
              }).toList(),
              onChanged: (val) => setState(() => _dropdownValues[fieldId] = val),
              decoration: InputDecoration(
                labelText: field.label ?? 'Field',
                labelStyle: TextStyle(
                  color: const Color(0xFF005DFF),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF005DFF), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              validator: (val) => field.required == true && (val == null || val.isEmpty)
                  ? 'Required'
                  : null,
            ),
          );
        case 'file':
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                // TODO: File picker integration
              },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF005DFF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.upload_file,
                          color: const Color(0xFF005DFF),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (field.label ?? 'Field') + (field.required == true ? ' *' : ''),
                              style: TextStyle(
                                color: const Color(0xFF005DFF),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Tap to upload file',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        default:
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _controllers[fieldId],
              keyboardType: field.type == 'number' ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                labelText: (field.label ?? 'Field') + (field.required == true ? ' *' : ''),
                labelStyle: TextStyle(
                  color: const Color(0xFF005DFF),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF005DFF), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          );
      }
    }).toList();
  }
}

