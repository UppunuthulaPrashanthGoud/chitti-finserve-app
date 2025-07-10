import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class TermsConditionsScreen extends ConsumerStatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  ConsumerState<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends ConsumerState<TermsConditionsScreen> with TickerProviderStateMixin {
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
                            '1. Acceptance of Terms',
                            'By downloading, installing, or using the Chitti Finserve Loan Lead Generation App ("App"), you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the App.',
                          ),
                          
                          _buildSection(
                            '2. App Description',
                            'The App is a loan lead generation platform that connects users with financial institutions and lenders. We facilitate the process of loan applications but do not directly provide loans.',
                          ),
                          
                          _buildSection(
                            '3. User Eligibility',
                            'You must be at least 18 years old and legally competent to use this App. You must provide accurate and complete information when using our services.',
                          ),
                          
                          _buildSection(
                            '4. User Responsibilities',
                            '• Provide accurate and truthful information\n• Maintain the security of your account\n• Comply with all applicable laws\n• Not use the App for illegal purposes\n• Not attempt to gain unauthorized access',
                          ),
                          
                          _buildSection(
                            '5. Privacy and Data Protection',
                            'Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and protect your personal information.',
                          ),
                          
                          _buildSection(
                            '6. Financial Information',
                            'The App may collect financial information for loan processing. We implement industry-standard security measures to protect your financial data.',
                          ),
                          
                          _buildSection(
                            '7. Third-Party Services',
                            'The App may integrate with third-party services for loan processing, verification, and other services. We are not responsible for the privacy practices of third-party services.',
                          ),
                          
                          _buildSection(
                            '8. Intellectual Property',
                            'All content, features, and functionality of the App are owned by Chitti Finserve and are protected by copyright, trademark, and other intellectual property laws.',
                          ),
                          
                          _buildSection(
                            '9. Limitation of Liability',
                            'Chitti Finserve shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising from your use of the App.',
                          ),
                          
                          _buildSection(
                            '10. Disclaimers',
                            '• The App is provided "as is" without warranties\n• We do not guarantee loan approval\n• Loan terms are subject to lender discretion\n• Interest rates and fees vary by lender',
                          ),
                          
                          _buildSection(
                            '11. Termination',
                            'We may terminate or suspend your access to the App at any time, with or without cause, with or without notice.',
                          ),
                          
                          _buildSection(
                            '12. Governing Law',
                            'These Terms and Conditions are governed by the laws of India. Any disputes shall be resolved in the courts of India.',
                          ),
                          
                          _buildSection(
                            '13. Changes to Terms',
                            'We reserve the right to modify these terms at any time. Continued use of the App after changes constitutes acceptance of the new terms.',
                          ),
                          
                          _buildSection(
                            '14. Contact Information',
                            'For questions about these Terms and Conditions, please contact us at:\nEmail: support@chittifinserve.com\nPhone: +91-XXXXXXXXXX',
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
                      'Terms & Conditions',
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
            'Please read these terms carefully',
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