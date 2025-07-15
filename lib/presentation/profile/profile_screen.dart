import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile_provider.dart';
import '../../data/model/profile_model.dart';
import '../../core/validation_helper.dart';
import '../legal/legal_menu_screen.dart';
import '../referral/referral_screen.dart';
import '../login/login_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _aadharNumberController = TextEditingController();
  final _panNumberController = TextEditingController();
  String? _profilePicturePath;
  String? _aadharUploadPath;
  String? _panUploadPath;
  bool _isEditing = false;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
    _emailController.dispose();
    _mobileController.dispose();
    _aadharNumberController.dispose();
    _panNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final profileAsync = ref.read(profileProvider);
    profileAsync.whenData((profile) {
      if (profile != null) {
        setState(() {
          _nameController.text = profile.name ?? '';
          _emailController.text = profile.email ?? '';
          _mobileController.text = profile.phone ?? '';
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
        name: _nameController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        aadharNumber: _aadharNumberController.text.trim().isEmpty ? null : _aadharNumberController.text.trim(),
        panNumber: _panNumberController.text.trim().isEmpty ? null : _panNumberController.text.trim(),
        profilePicture: _profilePicturePath,
        aadharUpload: _aadharUploadPath,
        panUpload: _panUploadPath,
      );

      setState(() {
        _isEditing = false;
        _isLoading = false;
      });

      ValidationHelper.showSuccessMessage(context, 'Profile updated successfully!');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // Handle different types of errors
      if (e.toString().contains('Validation error') || e.toString().contains('400')) {
        ValidationHelper.showValidationError(context, e.toString());
      } else {
        ValidationHelper.showErrorMessage(context, 'Failed to update profile: ${e.toString()}');
      }
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
                  _buildHeader(),
                  const SizedBox(height: 32),
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
                  
                  // Name
                  TextFormField(
                    controller: _nameController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person, color: Color(0xFF005DFF)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    validator: ValidationHelper.validateName,
                  ),
                  const SizedBox(height: 16),
                  // Email
                  TextFormField(
                    controller: _emailController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Color(0xFF005DFF)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    validator: ValidationHelper.validateEmail,
                  ),
                    const SizedBox(height: 16),
                  // Phone (read-only)
                  TextFormField(
                    controller: _mobileController,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone, color: Color(0xFF005DFF)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Aadhar Number
                  TextFormField(
                    controller: _aadharNumberController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'Aadhar Number (Optional)',
                      prefixIcon: Icon(Icons.credit_card, color: Color(0xFF005DFF)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      hintText: 'Enter 12-digit Aadhar number',
                    ),
                    validator: ValidationHelper.validateAadharNumber,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // PAN Number
                  TextFormField(
                    controller: _panNumberController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'PAN Number (Optional)',
                      prefixIcon: Icon(Icons.credit_card, color: Color(0xFF005DFF)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      hintText: 'e.g., ABCDE1234F',
                    ),
                    validator: ValidationHelper.validatePanNumber,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                      LengthLimitingTextInputFormatter(10),
                    ],
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
                  
                  // Aadhar Upload (Optional)
                  _buildFileUploadField(
                    label: 'Upload Aadhar (Optional)',
                    icon: Icons.upload_file,
                    filePath: _aadharUploadPath,
                    onTap: _isEditing ? () => _selectAadharFile() : null,
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
                  
                  // Referral Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.card_giftcard, color: const Color(0xFF005DFF), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Refer & Earn',
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
                          'Share your referral code and earn ₹100 for each friend who joins!',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReferralScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('View Referrals'),
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
                  
                  const SizedBox(height: 24),
                  
                  // Legal Information Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
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
                            color: Colors.grey.shade600,
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
                  
                  const SizedBox(height: 24),
                  
                  // Delete Account Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.delete_forever, color: Colors.red[600], size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Delete Account',
                              style: TextStyle(
                                color: Colors.red[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Permanently delete your account and all associated data. This action cannot be undone.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _openDeleteAccountPage(),
                          icon: const Icon(Icons.open_in_browser),
                          label: const Text('Delete Account'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[600],
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
                  
                  const SizedBox(height: 24),
                  
                  // Logout Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
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
                    onPressed: () => _showLogoutDialog(),
                    child: const Text('Logout'),
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

  Widget _buildFileUploadField({
    required String label,
    required IconData icon,
    String? filePath,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: onTap != null ? Colors.grey.shade50 : Colors.grey.shade100,
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
                        color: onTap != null ? Colors.black87 : Colors.grey.shade600,
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
                color: onTap != null ? const Color(0xFF005DFF) : Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectProfilePicture() async {
    try {
      // TODO: Implement actual image picker with file upload
      // For now, simulate file upload
      setState(() {
        _profilePicturePath = 'profile_picture.jpg';
      });
      
      // Upload to backend
      await ref.read(profileProvider.notifier).uploadDocument('profilePicture', _profilePicturePath!);
      
      ValidationHelper.showSuccessMessage(context, 'Profile picture uploaded successfully');
    } catch (e) {
      ValidationHelper.showErrorMessage(context, 'Failed to upload profile picture: ${e.toString()}');
    }
  }

  Future<void> _selectAadharFile() async {
    try {
      // TODO: Implement actual file picker with file upload
      // For now, simulate file upload
      setState(() {
        _aadharUploadPath = 'aadhar_document.pdf';
      });
      
      // Upload to backend
      await ref.read(profileProvider.notifier).uploadDocument('aadharUpload', _aadharUploadPath!);
      
      ValidationHelper.showSuccessMessage(context, 'Aadhar document uploaded successfully');
    } catch (e) {
      ValidationHelper.showErrorMessage(context, 'Failed to upload Aadhar document: ${e.toString()}');
    }
  }

  Future<void> _selectPanFile() async {
    try {
      // TODO: Implement actual file picker with file upload
      // For now, simulate file upload
      setState(() {
        _panUploadPath = 'pan_document.pdf';
      });
      
      // Upload to backend
      await ref.read(profileProvider.notifier).uploadDocument('panUpload', _panUploadPath!);
      
      ValidationHelper.showSuccessMessage(context, 'PAN document uploaded successfully');
    } catch (e) {
      ValidationHelper.showErrorMessage(context, 'Failed to upload PAN document: ${e.toString()}');
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () async {
                try {
                  // Clear all user data
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear(); // Clear all stored data
                  
                  // Close the dialog
                  Navigator.of(dialogContext).pop();
                  
                  // Navigate to login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                } catch (e) {
                  print('❌ Error during logout: $e');
                  // Still navigate to login even if there's an error
                  Navigator.of(dialogContext).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openDeleteAccountPage() async {
    const url = 'http://chittifinserv.com/delete-account';
    
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ValidationHelper.showErrorMessage(context, 'Could not open delete account page');
      }
    } catch (e) {
      ValidationHelper.showErrorMessage(context, 'Failed to open delete account page: ${e.toString()}');
    }
  }
} 