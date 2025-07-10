import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'loan_form_provider.dart';
import '../../data/model/loan_form_model.dart';
import '../profile/profile_provider.dart';
import '../legal/terms_conditions_screen.dart';
import '../legal/privacy_policy_screen.dart';

class LoanFormScreen extends ConsumerStatefulWidget {
  final String? prefillMobile;
  final String? prefillLoanType;
  const LoanFormScreen({Key? key, this.prefillMobile, this.prefillLoanType}) : super(key: key);

  @override
  ConsumerState<LoanFormScreen> createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends ConsumerState<LoanFormScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _dropdownValues = {};
  final Map<String, String?> _filePaths = {};
  bool _loading = false;
  String? _error;
  bool _submitted = false;
  bool _acceptedTerms = false;

  @override
  void initState() {
    super.initState();
    _error = null;
    _loading = false;
    _submitted = false;
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
        // Auto-fill from profile data
        if (_controllers.containsKey('full_name') && _controllers['full_name']!.text.isEmpty) {
          _controllers['full_name']!.text = profile.fullName;
        }
        if (_controllers.containsKey('mobile') && _controllers['mobile']!.text.isEmpty) {
          _controllers['mobile']!.text = profile.mobileNumber;
        }
        if (_controllers.containsKey('email') && _controllers['email']!.text.isEmpty) {
          _controllers['email']!.text = profile.emailId ?? '';
        }
        if (_controllers.containsKey('loan_amount') && _controllers['loan_amount']!.text.isEmpty) {
          _controllers['loan_amount']!.text = profile.loanAmount ?? '';
        }
        if (_controllers.containsKey('purpose') && _dropdownValues['purpose'] == null) {
          setState(() {
            _dropdownValues['purpose'] = profile.purposeOfLoan;
          });
        }
        if (_controllers.containsKey('income') && _controllers['income']!.text.isEmpty) {
          _controllers['income']!.text = profile.monthlyIncome ?? '';
        }
        if (_controllers.containsKey('occupation') && _controllers['occupation']!.text.isEmpty) {
          _controllers['occupation']!.text = profile.occupation ?? '';
        }
        if (_controllers.containsKey('aadhar') && _dropdownValues['aadhar'] == null) {
          setState(() {
            _dropdownValues['aadhar'] = profile.aadharUpload;
          });
        }
        if (_controllers.containsKey('pan') && _dropdownValues['pan'] == null) {
          setState(() {
            _dropdownValues['pan'] = profile.panUpload;
          });
        }
      }
    });
  }

  void _prefillFromWidget() {
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

  void _submit(LoanFormModel config) async {
    // Check if terms and conditions are accepted
    if (!_acceptedTerms) {
      setState(() {
        _error = 'Please accept the Terms & Conditions to continue';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    await Future.delayed(const Duration(seconds: 1));
    bool hasError = false;
    for (final field in config.fields) {
      if (field.required &&
          ((field.type == 'dropdown' && (_dropdownValues[field.id] == null || _dropdownValues[field.id]!.isEmpty)) ||
           (field.type != 'dropdown' && (_controllers[field.id]?.text.isEmpty ?? true)))) {
        hasError = true;
        break;
      }
    }
    setState(() {
      _loading = false;
      if (hasError) {
        _error = config.errorMessage;
      } else {
        _submitted = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loanFormAsync = ref.watch(loanFormConfigProvider);
    return Scaffold(
      body: loanFormAsync.when(
        data: (config) {
          // Prefill logic after config loads
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _prefillFromProfile();
            _prefillFromWidget();
          });
          if (_submitted) {
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
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Application Submitted!',
                        style: TextStyle(
                          color: const Color(0xFF005DFF),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                config.thankYouMessage,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                        ),
                textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
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
                  // Compact Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                    child: Column(
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
                        // Compact header content
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.rocket_launch,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.title,
                                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18,
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
                            ],
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
                  ..._buildFormFields(config.fields),
                              
                  if (_error != null)
                                Container(
                                  margin: const EdgeInsets.only(top: 16, bottom: 8),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.red[200]!),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _error!,
                                          style: TextStyle(color: Colors.red[700], fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              
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
                                                  config.submitButton,
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
    return fields.map((field) {
      if (!_controllers.containsKey(field.id)) {
        _controllers[field.id] = TextEditingController();
      }
      switch (field.type) {
        case 'dropdown':
          final currentValue = _dropdownValues[field.id];
          final options = field.options ?? [];
          // Ensure the current value exists in options, otherwise set to null
          final validValue = options.contains(currentValue) ? currentValue : null;
          if (validValue != currentValue) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _dropdownValues[field.id] = validValue;
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
              items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
              onChanged: (val) => setState(() => _dropdownValues[field.id] = val),
              decoration: InputDecoration(
                labelText: field.label,
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
              validator: (val) => field.required && (val == null || val.isEmpty)
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
                              field.label + (field.required ? ' *' : ''),
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
              controller: _controllers[field.id],
              keyboardType: field.type == 'number' ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                labelText: field.label + (field.required ? ' *' : ''),
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
