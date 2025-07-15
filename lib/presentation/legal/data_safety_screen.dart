import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class DataSafetyScreen extends ConsumerStatefulWidget {
  const DataSafetyScreen({super.key});

  @override
  ConsumerState<DataSafetyScreen> createState() => _DataSafetyScreenState();
}

class _DataSafetyScreenState extends ConsumerState<DataSafetyScreen> with TickerProviderStateMixin {
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
                            '1. Data Encryption',
                            'We use industry-standard encryption to protect your data:\n\n• AES-256 encryption for data at rest\n• TLS 1.3 encryption for data in transit\n• End-to-end encryption for sensitive communications\n• Secure key management and rotation\n• Hardware security modules (HSM) for key storage\n• Certificate pinning for API communications',
                          ),
                          
                          _buildSection(
                            '2. Secure Infrastructure',
                            'Our infrastructure is built with security in mind:\n\n• AWS/GCP cloud infrastructure with security certifications\n• Multi-factor authentication for all access\n• Regular security audits and penetration testing\n• 24/7 security monitoring and incident response\n• SOC 2 Type II compliance\n• ISO 27001 certification',
                          ),
                          
                          _buildSection(
                            '3. Financial Data Protection',
                            'Your financial information is protected by:\n\n• PCI DSS compliance for payment processing\n• Tokenization of sensitive financial data\n• Secure APIs with rate limiting and monitoring\n• Regular vulnerability assessments\n• RBI guidelines compliance\n• Secure document storage for KYC',
                          ),
                          
                          _buildSection(
                            '4. Identity Document Security',
                            'KYC documents are secured through:\n\n• Encrypted storage with access controls\n• Automatic document verification systems\n• Secure sharing with authorized lenders only\n• Regular audit trails for document access\n• Watermarking and digital signatures\n• Automatic deletion after verification',
                          ),
                          
                          _buildSection(
                            '5. Access Controls',
                            'We implement strict access controls:\n\n• Role-based access control (RBAC)\n• Principle of least privilege\n• Regular access reviews and updates\n• Multi-factor authentication for all users\n• Session management and timeout\n• IP whitelisting for admin access',
                          ),
                          
                          _buildSection(
                            '6. Data Backup and Recovery',
                            'Your data is protected through:\n\n• Automated daily backups with encryption\n• Geographic redundancy across multiple locations\n• Regular disaster recovery testing\n• 99.9% uptime guarantee\n• Point-in-time recovery capabilities\n• Secure backup verification',
                          ),
                          
                          _buildSection(
                            '7. Third-Party Security',
                            'We ensure our partners maintain high security:\n\n• Security assessments of all third-party vendors\n• Data processing agreements with security requirements\n• Regular audits of third-party security practices\n• Incident response coordination\n• Vendor risk management program\n• Secure API integrations',
                          ),
                          
                          _buildSection(
                            '8. Mobile App Security',
                            'Our mobile app includes:\n\n• Secure code signing and integrity checks\n• Jailbreak/root detection\n• Secure local storage with encryption\n• Certificate pinning for API communications\n• Biometric authentication support\n• Secure key storage using Keychain/Keystore',
                          ),
                          
                          _buildSection(
                            '9. Network Security',
                            'Network-level protection includes:\n\n• DDoS protection and mitigation\n• Web application firewall (WAF)\n• Intrusion detection and prevention systems\n• Regular network security assessments\n• SSL/TLS encryption for all communications\n• Rate limiting and traffic monitoring',
                          ),
                          
                          _buildSection(
                            '10. Incident Response',
                            'We have a comprehensive incident response plan:\n\n• 24/7 security monitoring and alerting\n• Automated threat detection and response\n• Customer notification within 72 hours of breach\n• Regular incident response drills and training\n• Forensic analysis capabilities\n• Legal and regulatory reporting',
                          ),
                          
                          _buildSection(
                            '11. Compliance and Certifications',
                            'We maintain various security certifications:\n\n• ISO 27001 Information Security Management\n• SOC 2 Type II compliance\n• GDPR compliance for EU users\n• RBI guidelines compliance for financial services\n• PCI DSS compliance for payment processing\n• Regular compliance audits',
                          ),
                          
                          _buildSection(
                            '12. Employee Security',
                            'Our team follows strict security practices:\n\n• Background checks for all employees\n• Security training and awareness programs\n• Non-disclosure agreements (NDAs)\n• Regular security policy reviews\n• Security incident reporting procedures\n• Employee access monitoring',
                          ),
                          
                          _buildSection(
                            '13. Data Minimization',
                            'We follow data minimization principles:\n\n• Collect only necessary information\n• Automatic data retention and deletion\n• Anonymization of data for analytics\n• User control over data sharing\n• Purpose limitation for data usage\n• Regular data inventory and cleanup',
                          ),
                          
                          _buildSection(
                            '14. Security Monitoring',
                            'Continuous monitoring includes:\n\n• Real-time security event monitoring\n• Automated threat detection\n• Regular security assessments\n• Vulnerability scanning and patching\n• Security metrics and reporting\n• Threat intelligence integration',
                          ),
                          
                          _buildSection(
                            '15. User Security Features',
                            'Users can enhance their security:\n\n• Enable two-factor authentication\n• Set up biometric authentication\n• Monitor account activity\n• Report suspicious activity\n• Control data sharing preferences\n• Request data deletion',
                          ),
                          
                          _buildSection(
                            '16. Loan Application Security',
                            'Loan applications are secured through:\n\n• Encrypted form submissions\n• Secure document upload\n• Real-time fraud detection\n• Identity verification systems\n• Secure communication with lenders\n• Audit trails for all transactions',
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
                                      'Security Commitment',
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
                                  'We are committed to protecting your data with the highest security standards. Our security practices are regularly audited and updated to meet evolving threats. Your financial and personal information is our top priority.',
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
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.blue[600]),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Security Tips',
                                      style: TextStyle(
                                        color: Colors.blue[700],
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '• Never share your OTP or login credentials\n• Enable two-factor authentication\n• Keep your app updated\n• Report suspicious activity immediately\n• Use strong passwords\n• Log out when not using the app',
                                  style: TextStyle(
                                    color: Colors.blue[700],
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
                      'Data Safety',
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