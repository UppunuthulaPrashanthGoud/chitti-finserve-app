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
                            'We collect the following types of information:\n\n• Personal Information: Name, email, phone number, address, date of birth\n• Financial Information: Income, loan amount, purpose, employment details\n• Identity Documents: Aadhar, PAN, and other KYC documents\n• Device Information: Device type, operating system, app version, IP address\n• Usage Data: App interactions, features used, time spent, loan applications\n• Location Data: General location for loan processing (with consent)',
                          ),
                          
                          _buildSection(
                            '2. How We Use Your Information',
                            'We use your information to:\n\n• Process loan applications and connect you with lenders\n• Verify your identity and eligibility for loans\n• Provide customer support and improve our services\n• Send important updates and notifications\n• Comply with legal and regulatory requirements (RBI, KYC norms)\n• Prevent fraud and ensure security\n• Analyze app usage to improve user experience\n• Generate leads for financial institutions',
                          ),
                          
                          _buildSection(
                            '3. Information Sharing',
                            'We may share your information with:\n\n• Financial institutions and lenders for loan processing\n• KYC verification service providers\n• Payment gateways and banking partners\n• Legal authorities when required by law\n• Third-party verification services for identity verification\n• Analytics and security service providers\n\nWe do not sell your personal information to third parties. All sharing is done under strict confidentiality agreements.',
                          ),
                          
                          _buildSection(
                            '4. Data Security',
                            'We implement industry-standard security measures:\n\n• AES-256 encryption for data at rest\n• TLS 1.3 encryption for data in transit\n• Secure servers with 24/7 monitoring\n• Regular security audits and penetration testing\n• Access controls and multi-factor authentication\n• Employee training on data protection\n• Compliance with RBI security guidelines',
                          ),
                          
                          _buildSection(
                            '5. Data Retention',
                            'We retain your information for:\n\n• Active accounts: Duration of account plus 7 years (as per RBI guidelines)\n• Inactive accounts: 3 years after last activity\n• KYC documents: 7 years as per regulatory requirements\n• Legal requirements: As required by applicable laws\n• You may request deletion of your data (subject to legal requirements)',
                          ),
                          
                          _buildSection(
                            '6. Your Rights',
                            'You have the right to:\n\n• Access your personal information\n• Correct inaccurate information\n• Delete your account and data (subject to legal requirements)\n• Opt-out of marketing communications\n• Request data portability\n• Lodge complaints with authorities\n• Withdraw consent for data processing\n• Know what data we collect and how we use it',
                          ),
                          
                          _buildSection(
                            '7. Cookies and Tracking',
                            'We use cookies and similar technologies to:\n\n• Remember your preferences and login status\n• Analyze app usage and performance\n• Provide personalized experiences\n• Ensure security and prevent fraud\n• Improve app functionality\n\nYou can control cookie settings in your device. We do not use tracking for advertising purposes.',
                          ),
                          
                          _buildSection(
                            '8. Third-Party Services',
                            'Our app integrates with:\n\n• Payment gateways for loan processing\n• SMS services for OTP verification\n• Analytics services for app improvement\n• Cloud storage for secure data backup\n• KYC verification services\n• Banking and financial service APIs\n\nThese services have their own privacy policies and security measures.',
                          ),
                          
                          _buildSection(
                            '9. Children\'s Privacy',
                            'Our app is not intended for children under 18. We do not knowingly collect personal information from children under 18. If we become aware of such collection, we will delete the information immediately.',
                          ),
                          
                          _buildSection(
                            '10. International Transfers',
                            'Your information may be processed in India and other countries where our service providers are located. We ensure appropriate safeguards are in place to protect your data during international transfers, including:\n\n• Standard contractual clauses\n• Adequacy decisions\n• Other appropriate safeguards',
                          ),
                          
                          _buildSection(
                            '11. Changes to Privacy Policy',
                            'We may update this Privacy Policy from time to time. We will notify you of any material changes through:\n\n• In-app notifications\n• Email notifications\n• Updated policy in the app\n\nContinued use of the app after changes constitutes acceptance of the new policy.',
                          ),
                          
                          _buildSection(
                            '12. California Privacy Rights (CCPA)',
                            'California residents have additional rights:\n\n• Right to know what personal information is collected\n• Right to delete personal information\n• Right to opt-out of sale of personal information\n• Right to non-discrimination for exercising rights\n• Right to data portability\n\nWe do not sell personal information to third parties.',
                          ),
                          
                          _buildSection(
                            '13. European Privacy Rights (GDPR)',
                            'EU residents have additional rights:\n\n• Right to erasure ("right to be forgotten")\n• Right to data portability\n• Right to object to processing\n• Right to restrict processing\n• Right to lodge complaints with supervisory authorities\n• Right to withdraw consent',
                          ),
                          
                          _buildSection(
                            '14. Indian Privacy Rights (PDPB)',
                            'Indian residents have rights under the Personal Data Protection Bill:\n\n• Right to confirmation and access\n• Right to correction and completion\n• Right to erasure\n• Right to data portability\n• Right to restrict processing\n• Right to object to processing',
                          ),
                          
                          _buildSection(
                            '15. Contact Us',
                            'For privacy-related questions or requests:\n\nEmail: privacy@chittifinserve.com\nPhone: +91-XXXXXXXXXX\nAddress: [Your Company Address]\n\nData Protection Officer: dpo@chittifinserve.com\n\nResponse Time: We will respond to your requests within 30 days.',
                          ),
                          
                          const SizedBox(height: 32),
                          
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.security, color: Colors.green[600]),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Privacy Commitment',
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'We are committed to protecting your privacy and personal information. Your data is encrypted, secure, and never shared without your consent. We comply with all applicable privacy laws and regulations.',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
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