import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class PrivacyPolicyScreen extends ConsumerStatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  ConsumerState<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends ConsumerState<PrivacyPolicyScreen> with TickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                // Header
                _buildHeader(),
                
                // Content
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection(
                            '1. Information We Collect',
                            'We collect the following types of information:\n\n• Personal Information: Name, email, phone number, address\n• Financial Information: Income, loan amount, purpose\n• Identity Documents: Aadhar, PAN, and other KYC documents\n• Device Information: Device type, operating system, app version\n• Usage Data: App interactions, features used, time spent',
                          ),
                          
                          _buildSection(
                            '2. How We Use Your Information',
                            'We use your information to:\n\n• Process loan applications and connect you with lenders\n• Verify your identity and eligibility\n• Provide customer support and improve our services\n• Send important updates and notifications\n• Comply with legal and regulatory requirements\n• Prevent fraud and ensure security',
                          ),
                          
                          _buildSection(
                            '3. Information Sharing',
                            'We may share your information with:\n\n• Financial institutions and lenders for loan processing\n• Service providers who assist in our operations\n• Legal authorities when required by law\n• Third-party verification services for KYC\n\nWe do not sell your personal information to third parties.',
                          ),
                          
                          _buildSection(
                            '4. Data Security',
                            'We implement industry-standard security measures:\n\n• Encryption of data in transit and at rest\n• Secure servers and data centers\n• Regular security audits and updates\n• Access controls and authentication\n• Employee training on data protection',
                          ),
                          
                          _buildSection(
                            '5. Data Retention',
                            'We retain your information for:\n\n• Active accounts: Duration of account plus 7 years\n• Inactive accounts: 3 years after last activity\n• Legal requirements: As required by applicable laws\n• You may request deletion of your data',
                          ),
                          
                          _buildSection(
                            '6. Your Rights',
                            'You have the right to:\n\n• Access your personal information\n• Correct inaccurate information\n• Delete your account and data\n• Opt-out of marketing communications\n• Request data portability\n• Lodge complaints with authorities',
                          ),
                          
                          _buildSection(
                            '7. Cookies and Tracking',
                            'We use cookies and similar technologies to:\n\n• Remember your preferences\n• Analyze app usage and performance\n• Provide personalized experiences\n• Ensure security and prevent fraud\n\nYou can control cookie settings in your device.',
                          ),
                          
                          _buildSection(
                            '8. Third-Party Services',
                            'Our app may integrate with:\n\n• Payment gateways for transactions\n• SMS services for verification\n• Analytics services for app improvement\n• Cloud storage for data backup\n\nThese services have their own privacy policies.',
                          ),
                          
                          _buildSection(
                            '9. Children\'s Privacy',
                            'Our app is not intended for children under 18. We do not knowingly collect personal information from children under 18. If we become aware of such collection, we will delete the information immediately.',
                          ),
                          
                          _buildSection(
                            '10. International Transfers',
                            'Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place to protect your data during international transfers.',
                          ),
                          
                          _buildSection(
                            '11. Changes to Privacy Policy',
                            'We may update this Privacy Policy from time to time. We will notify you of any material changes through the app or email. Continued use of the app after changes constitutes acceptance of the new policy.',
                          ),
                          
                          _buildSection(
                            '12. California Privacy Rights (CCPA)',
                            'California residents have additional rights:\n\n• Right to know what personal information is collected\n• Right to delete personal information\n• Right to opt-out of sale of personal information\n• Right to non-discrimination for exercising rights',
                          ),
                          
                          _buildSection(
                            '13. European Privacy Rights (GDPR)',
                            'EU residents have additional rights:\n\n• Right to erasure ("right to be forgotten")\n• Right to data portability\n• Right to object to processing\n• Right to restrict processing\n• Right to lodge complaints with supervisory authorities',
                          ),
                          
                          _buildSection(
                            '14. Contact Us',
                            'For privacy-related questions or requests:\n\nEmail: privacy@chittifinserve.com\nPhone: +91-XXXXXXXXXX\nAddress: [Your Company Address]\n\nData Protection Officer: dpo@chittifinserve.com',
                          ),
                          
                          const SizedBox(height: 32),
                          
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Last updated: ${DateTime.now().year}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Privacy Policy',
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'How we protect your information',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF005DFF),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              fontFamily: 'Montserrat',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
} 