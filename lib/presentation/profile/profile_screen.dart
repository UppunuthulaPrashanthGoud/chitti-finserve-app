import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'profile_provider.dart';
import '../../data/model/profile_model.dart';
import '../legal/legal_menu_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _monthlyIncomeController = TextEditingController();
  final _occupationController = TextEditingController();
  final _aadharNumberController = TextEditingController();
  final _panNumberController = TextEditingController();
  
  String? _selectedPurpose;
  String? _selectedLoanAmount;
  String? _profilePicturePath;
  String? _aadharUploadPath;
  String? _panUploadPath;
  bool _isEditing = false;
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _loanPurposes = [
    'Personal',
    'Business',
    'OD',
    'Mortgage',
    'Home',
    'Car',
    'Insurance',
    'Credit Card',
    'Doctor',
    'Education',
    'Others'
  ];

  final List<String> _loanAmounts = [
    '₹50,000',
    '₹1,00,000',
    '₹2,00,000',
    '₹5,00,000',
    '₹10,00,000',
    '₹20,00,000',
    '₹50,00,000',
    '₹1,00,00,000',
    'Custom Amount'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _loadProfileData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _loanAmountController.dispose();
    _monthlyIncomeController.dispose();
    _occupationController.dispose();
    _aadharNumberController.dispose();
    _panNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final profileAsync = ref.read(profileProvider);
    profileAsync.whenData((profile) {
      if (profile != null) {
        setState(() {
          _nameController.text = profile.fullName;
          _mobileController.text = profile.mobileNumber;
          _emailController.text = profile.emailId ?? '';
          _loanAmountController.text = profile.loanAmount ?? '';
          _selectedPurpose = profile.purposeOfLoan;
          _monthlyIncomeController.text = profile.monthlyIncome ?? '';
          _occupationController.text = profile.occupation ?? '';
          _aadharNumberController.text = profile.aadharNumber ?? '';
          _panNumberController.text = profile.panNumber ?? '';
          _profilePicturePath = profile.profilePicture;
          _aadharUploadPath = profile.aadharUpload;
          _panUploadPath = profile.panUpload;
        });
      }
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(profileProvider.notifier).updateProfile(
        fullName: _nameController.text,
        mobileNumber: _mobileController.text,
        emailId: _emailController.text.isEmpty ? null : _emailController.text,
        loanAmount: _loanAmountController.text.isEmpty ? null : _loanAmountController.text,
        purposeOfLoan: _selectedPurpose,
        monthlyIncome: _monthlyIncomeController.text.isEmpty ? null : _monthlyIncomeController.text,
        occupation: _occupationController.text.isEmpty ? null : _occupationController.text,
        aadharNumber: _aadharNumberController.text.isEmpty ? null : _aadharNumberController.text,
        panNumber: _panNumberController.text.isEmpty ? null : _panNumberController.text,
        profilePicture: _profilePicturePath,
        aadharUpload: _aadharUploadPath,
        panUpload: _panUploadPath,
      );

      setState(() {
        _isEditing = false;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF005DFF), Color(0xFF5BB5FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Header
                  _buildHeader(),
                  
                  const SizedBox(height: 32),
                  
                  // Profile Form
                  _buildProfileForm(profileAsync),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(
            Icons.person_outline,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Profile Information',
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1,
        ),
        const SizedBox(height: 8),
        Text(
          'Your information will auto-fill loan applications',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  Widget _buildProfileForm(AsyncValue<ProfileModel?> profileAsync) {
    return profileAsync.when(
      data: (profile) {
        return Card(
          elevation: 16,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Personal Information',
                        style: TextStyle(
                          color: const Color(0xFF005DFF),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = !_isEditing;
                          });
                        },
                        icon: Icon(
                          _isEditing ? Icons.save : Icons.edit,
                          color: const Color(0xFF005DFF),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Full Name
                  _buildInputField(
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.person,
                    hint: 'Enter your full name',
                    enabled: _isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Mobile Number
                  _buildInputField(
                    controller: _mobileController,
                    label: 'Mobile Number',
                    icon: Icons.phone,
                    hint: 'Enter mobile number',
                    enabled: _isEditing,
                    keyboardType: TextInputType.phone,
                    formatter: FilteringTextInputFormatter.digitsOnly,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter mobile number';
                      }
                      if (value.length != 10) {
                        return 'Please enter a valid 10-digit mobile number';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Email ID (Optional)
                  _buildInputField(
                    controller: _emailController,
                    label: 'Email ID (Optional)',
                    icon: Icons.email,
                    hint: 'Enter email address',
                    enabled: _isEditing,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Loan Amount
                  _buildDropdownField(
                    label: 'Loan Amount',
                    icon: Icons.currency_rupee,
                    value: _selectedLoanAmount,
                    items: _loanAmounts.map((amount) => 
                      DropdownMenuItem(value: amount, child: Text(amount))
                    ).toList(),
                    onChanged: _isEditing ? (value) {
                      setState(() {
                        _selectedLoanAmount = value;
                        if (value == 'Custom Amount') {
                          _loanAmountController.clear();
                        } else {
                          _loanAmountController.text = value ?? '';
                        }
                      });
                    } : null,
                  ),
                  
                  if (_selectedLoanAmount == 'Custom Amount') ...[
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _loanAmountController,
                      label: 'Custom Amount',
                      icon: Icons.currency_rupee,
                      hint: 'Enter custom amount',
                      enabled: _isEditing,
                      keyboardType: TextInputType.number,
                      formatter: FilteringTextInputFormatter.digitsOnly,
                    ),
                  ],
                  
                  const SizedBox(height: 20),
                  
                  // Purpose of Loan
                  _buildDropdownField(
                    label: 'Purpose of Loan',
                    icon: Icons.category,
                    value: _selectedPurpose,
                    items: _loanPurposes.map((purpose) => 
                      DropdownMenuItem(value: purpose, child: Text(purpose))
                    ).toList(),
                    onChanged: _isEditing ? (value) {
                      setState(() {
                        _selectedPurpose = value;
                      });
                    } : null,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Monthly Income
                  _buildInputField(
                    controller: _monthlyIncomeController,
                    label: 'Monthly Income',
                    icon: Icons.account_balance_wallet,
                    hint: 'Enter monthly income',
                    enabled: _isEditing,
                    keyboardType: TextInputType.number,
                    formatter: FilteringTextInputFormatter.digitsOnly,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Occupation
                  _buildInputField(
                    controller: _occupationController,
                    label: 'Occupation',
                    icon: Icons.work,
                    hint: 'Enter your occupation',
                    enabled: _isEditing,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Profile Picture
                  _buildFileUploadField(
                    label: 'Profile Picture (Optional)',
                    icon: Icons.camera_alt,
                    filePath: _profilePicturePath,
                    onTap: _isEditing ? () => _selectProfilePicture() : null,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Aadhar Number (Optional)
                  _buildInputField(
                    controller: _aadharNumberController,
                    label: 'Aadhar Number (Optional)',
                    icon: Icons.credit_card,
                    hint: 'Enter Aadhar number',
                    enabled: _isEditing,
                    keyboardType: TextInputType.number,
                    formatter: FilteringTextInputFormatter.digitsOnly,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Aadhar Upload (Optional)
                  _buildFileUploadField(
                    label: 'Upload Aadhar (Optional)',
                    icon: Icons.upload_file,
                    filePath: _aadharUploadPath,
                    onTap: _isEditing ? () => _selectAadharFile() : null,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // PAN Number (Optional)
                  _buildInputField(
                    controller: _panNumberController,
                    label: 'PAN Number (Optional)',
                    icon: Icons.credit_card,
                    hint: 'Enter PAN number',
                    enabled: _isEditing,
                    keyboardType: TextInputType.text,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // PAN Upload (Optional)
                  _buildFileUploadField(
                    label: 'Upload PAN (Optional)',
                    icon: Icons.upload_file,
                    filePath: _panUploadPath,
                    onTap: _isEditing ? () => _selectPanFile() : null,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Save Button
                  if (_isEditing)
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF005DFF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Montserrat',
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                            ),
                            onPressed: _saveProfile,
                            child: const Text('Save Profile'),
                          ),
                  
                  const SizedBox(height: 24),
                  
                  // Legal Information Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.gavel, color: const Color(0xFF005DFF), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Legal Information',
                              style: TextStyle(
                                color: const Color(0xFF005DFF),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Review our terms, privacy policy, and data safety information.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LegalMenuScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('View Legal Documents'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005DFF),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Failed to load profile',
                  style: TextStyle(color: Colors.red[300], fontFamily: 'Montserrat'),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: TextStyle(color: Colors.red[200], fontSize: 12, fontFamily: 'Montserrat'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool enabled = true,
    TextInputType? keyboardType,
    TextInputFormatter? formatter,
    String? Function(String?)? validator,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: formatter != null ? [formatter] : null,
      style: TextStyle(
        fontFamily: 'Montserrat',
        color: enabled ? Colors.black87 : Colors.grey[600],
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: const Color(0xFF005DFF)),
        filled: true,
        fillColor: enabled ? Colors.grey[50] : Colors.grey[100],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF005DFF), width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    String? value,
    required List<DropdownMenuItem<String>> items,
    void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: const Color(0xFF005DFF)),
        filled: true,
        fillColor: onChanged != null ? Colors.grey[50] : Colors.grey[100],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF005DFF), width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      style: TextStyle(
        fontFamily: 'Montserrat',
        color: onChanged != null ? Colors.black87 : Colors.grey[600],
      ),
    );
  }

  Widget _buildFileUploadField({
    required String label,
    required IconData icon,
    String? filePath,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        color: onTap != null ? Colors.grey[50] : Colors.grey[100],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF005DFF)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: onTap != null ? Colors.black87 : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (filePath != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'File selected',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.green[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: onTap != null ? const Color(0xFF005DFF) : Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectProfilePicture() async {
    // TODO: Implement image picker
    setState(() {
      _profilePicturePath = 'profile_picture.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile picture selected')),
    );
  }

  Future<void> _selectAadharFile() async {
    // TODO: Implement file picker
    setState(() {
      _aadharUploadPath = 'aadhar_document.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Aadhar document selected')),
    );
  }

  Future<void> _selectPanFile() async {
    // TODO: Implement file picker
    setState(() {
      _panUploadPath = 'pan_document.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PAN document selected')),
    );
  }
} 