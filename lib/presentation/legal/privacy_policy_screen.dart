import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_config.dart';
import '../../data/repository/loan_form_repository.dart';
import 'package:chitti_finserve_lead_app/presentation/config/config_provider.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(appConfigProvider);
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
          child: configAsync.when(
            data: (config) {
              final contact = config.contactInfo;
              final companyName = contact?.companyName ?? 'Chitti Finserv';
              final email = contact?.email ?? 'support@chittifinserv.com';
              final phone = contact?.phone ?? '+91 9876543210';
              final address = contact?.address ?? '123 Financial District, Mumbai, Maharashtra, India';
              final website = contact?.website ?? 'https://chittifinserv.com';
              final today = DateTime.now();
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(24),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Privacy Policy',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Color(0xFF005DFF),
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'This app is provided by $companyName for the sole purpose of collecting user leads interested in financial products.\n\n'
                            'We do not provide, distribute, or process any loans, credit, or financial products directly through this app.\n\n'
                            'Information We Collect:\n'
                            '- Name, phone, email, and other contact details you provide in the application form.\n'
                            '- We do NOT collect or store any sensitive financial data.\n\n'
                            'How We Use Your Information:\n'
                            '- To contact you regarding your interest in financial products.\n'
                            '- To connect you with our team for further discussion.\n'
                            '- Your information will not be shared with third parties except as required to process your inquiry.\n\n'
                            'No financial transactions, approvals, or disbursements are performed within this app.\n\n'
                            'For any privacy concerns, contact us at:',
                            style: TextStyle(fontSize: 15, color: Colors.black87, fontFamily: 'Montserrat'),
                          ),
                          const SizedBox(height: 16),
                          _buildContactInfo(email, phone, address, website),
                          const SizedBox(height: 16),
                          Text(
                            'Last updated: ${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}',
                            style: TextStyle(color: Colors.grey[700], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Failed to load policy')),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          Icon(Icons.privacy_tip, color: Color(0xFF005DFF), size: 28),
          const SizedBox(width: 12),
          Text(
            'Privacy Policy',
            style: TextStyle(
              color: Color(0xFF005DFF),
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(String email, String phone, String address, String website) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email: $email', style: TextStyle(fontSize: 14, color: Colors.black87)),
        Text('Phone: $phone', style: TextStyle(fontSize: 14, color: Colors.black87)),
        Text('Address: $address', style: TextStyle(fontSize: 14, color: Colors.black87)),
        Text('Website: $website', style: TextStyle(fontSize: 14, color: Colors.black87)),
      ],
    );
  }
} 