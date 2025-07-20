import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'application_detail_provider.dart';
import '../../core/app_theme.dart';
import '../../core/app_config.dart';

class ApplicationDetailScreen extends ConsumerStatefulWidget {
  final String applicationId;

  ApplicationDetailScreen({
    Key? key,
    required this.applicationId,
  }) : super(key: key) {
    print('🔧 Debug: ApplicationDetailScreen created with ID: $applicationId');
  }

  @override
  ConsumerState<ApplicationDetailScreen> createState() => _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState extends ConsumerState<ApplicationDetailScreen> {
  @override
  void initState() {
    super.initState();
    print('🔧 Debug: ApplicationDetailScreen initState called');
    print('🔧 Debug: Application ID from widget: ${widget.applicationId}');
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🔧 Debug: Fetching application details for ID: ${widget.applicationId}');
      ref.read(applicationDetailProvider.notifier).fetchApplicationDetails(widget.applicationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final applicationState = ref.watch(applicationDetailProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Application Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(applicationDetailProvider.notifier).refreshApplicationDetails(widget.applicationId);
            },
          ),
        ],
      ),
      body: applicationState.when(
        data: (application) {
          if (application == null) {
            return const Center(
              child: Text('No application details found'),
            );
          }
          return _buildApplicationDetails(application);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading application details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(applicationDetailProvider.notifier).fetchApplicationDetails(widget.applicationId);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationDetails(Map<String, dynamic> application) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Application Header
          _buildApplicationHeader(application),
          const SizedBox(height: 24),
          
          // Status Card
          _buildStatusCard(application),
          const SizedBox(height: 16),
          
          // Personal Information
          _buildSectionCard(
            title: 'Personal Information',
            icon: Icons.person,
            child: _buildPersonalInfo(application['personalInfo'] ?? {}),
          ),
          const SizedBox(height: 16),
          
          // Address Information
          _buildSectionCard(
            title: 'Address Information',
            icon: Icons.location_on,
            child: _buildAddressInfo(application['address'] ?? {}),
          ),
          const SizedBox(height: 16),
          
          // Loan Details
          _buildSectionCard(
            title: 'Loan Details',
            icon: Icons.account_balance,
            child: _buildLoanDetails(application),
          ),
          const SizedBox(height: 16),
          
          // Documents
          _buildSectionCard(
            title: 'Documents',
            icon: Icons.description,
            child: _buildDocumentsSection(application['documents'] ?? {}),
          ),
          const SizedBox(height: 16),
          
          // Assignment Information
          if (application['assignedTo'] != null) ...[
            _buildSectionCard(
              title: 'Assigned To',
              icon: Icons.assignment_ind,
              child: _buildAssignedToInfo(application['assignedTo']),
            ),
            const SizedBox(height: 16),
          ],
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildApplicationHeader(Map<String, dynamic> application) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Application Number',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      application['applicationNumber'] ?? 'N/A',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
                child: _buildHeaderItem(
                  'Loan Type',
                  (application['loanType'] ?? 'N/A').toString().toUpperCase(),
                  Icons.category,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildHeaderItem(
                  'Amount',
                  '₹${NumberFormat('#,##,###').format(application['loanAmount'] ?? 0)}',
                  Icons.currency_rupee,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.8),
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(Map<String, dynamic> application) {
    final status = application['status'] ?? 'pending';
    final statusColors = {
      'pending': Colors.orange,
      'approved': Colors.green,
      'rejected': Colors.red,
      'processing': Colors.blue,
      'disbursed': Colors.green,
    };

    final statusIcons = {
      'pending': Icons.schedule,
      'approved': Icons.check_circle,
      'rejected': Icons.cancel,
      'processing': Icons.sync,
      'disbursed': Icons.account_balance_wallet,
    };

    final color = statusColors[status.toLowerCase()] ?? Colors.grey;
    final icon = statusIcons[status.toLowerCase()] ?? Icons.info;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
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
                  'Status',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  status.toString().toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(Map<String, dynamic> personalInfo) {
    return Column(
      children: [
        _buildInfoRow('Name', personalInfo['name'] ?? 'N/A'),
        _buildInfoRow('Email', personalInfo['email'] ?? 'N/A'),
        _buildInfoRow('Phone', personalInfo['phone'] ?? 'N/A'),
        if (personalInfo['aadharNumber'] != null)
          _buildInfoRow('Aadhar Number', personalInfo['aadharNumber']),
        if (personalInfo['panNumber'] != null)
          _buildInfoRow('PAN Number', personalInfo['panNumber']),
      ],
    );
  }

  Widget _buildAddressInfo(Map<String, dynamic> address) {
    return Column(
      children: [
        _buildInfoRow('Street', address['street'] ?? 'N/A'),
        _buildInfoRow('City', address['city'] ?? 'N/A'),
        _buildInfoRow('State', address['state'] ?? 'N/A'),
        _buildInfoRow('Pincode', address['pincode'] ?? 'N/A'),
      ],
    );
  }

  Widget _buildLoanDetails(Map<String, dynamic> application) {
    return Column(
      children: [
        _buildInfoRow('Loan Purpose', application['loanPurpose'] ?? 'N/A'),
        _buildInfoRow('Monthly Income', '₹${NumberFormat('#,##,###').format(application['monthlyIncome'] ?? 0)}'),
        _buildInfoRow('Employment Type', (application['employmentType'] ?? 'N/A').toString().replaceAll('_', ' ').toUpperCase()),
        _buildInfoRow('Category', application['category']?['name'] ?? 'N/A'),
        _buildInfoRow('Application Date', application['createdAt'] != null 
            ? DateFormat('dd MMM yyyy').format(DateTime.parse(application['createdAt']))
            : 'N/A'),
      ],
    );
  }

  Widget _buildDocumentsSection(Map<String, dynamic> documents) {
    final allDocuments = <Map<String, String>>[];
    
    if (documents['aadharCard'] != null) {
      allDocuments.add({'name': 'Aadhar Card', 'url': documents['aadharCard'], 'type': 'aadhar'});
    }
    if (documents['panCard'] != null) {
      allDocuments.add({'name': 'PAN Card', 'url': documents['panCard'], 'type': 'pan'});
    }
    if (documents['incomeProof'] != null) {
      allDocuments.add({'name': 'Income Proof', 'url': documents['incomeProof'], 'type': 'income'});
    }
    if (documents['bankStatement'] != null) {
      allDocuments.add({'name': 'Bank Statement', 'url': documents['bankStatement'], 'type': 'bank'});
    }
    if (documents['addressProof'] != null) {
      allDocuments.add({'name': 'Address Proof', 'url': documents['addressProof'], 'type': 'address'});
    }
    
    final otherDocs = documents['otherDocuments'] as List<dynamic>? ?? [];
    for (int i = 0; i < otherDocs.length; i++) {
      allDocuments.add({'name': 'Other Document ${i + 1}', 'url': otherDocs[i], 'type': 'other'});
    }

    if (allDocuments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'No documents uploaded',
            style: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return Column(
      children: allDocuments.map((doc) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              _getDocumentIcon(doc['type']!),
              color: AppColors.primary,
            ),
            title: Text(doc['name']!),
            subtitle: Text(doc['type']!.toUpperCase()),
            trailing: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _downloadDocument(doc['url']!, doc['name']!),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'aadhar':
        return Icons.credit_card;
      case 'pan':
        return Icons.badge;
      case 'income':
        return Icons.attach_money;
      case 'bank':
        return Icons.account_balance;
      case 'address':
        return Icons.location_on;
      default:
        return Icons.description;
    }
  }

  Future<void> _downloadDocument(String url, String fileName) async {
    // Always use AppConfig.assetsBaseUrl as the base for all document download URLs
    String fullUrl = url;
    final baseUrl = AppConfig.assetsBaseUrl.endsWith('/')
        ? AppConfig.assetsBaseUrl.substring(0, AppConfig.assetsBaseUrl.length - 1)
        : AppConfig.assetsBaseUrl;
    try {
      Uri uri = Uri.parse(url);
      String path = uri.path;
      if (!path.startsWith('/')) path = '/$path';
      fullUrl = '$baseUrl$path';
    } catch (e) {
      // fallback: if url is not parseable, just append as before
      String relativePath = url.startsWith('/') ? url.substring(1) : url;
      fullUrl = '$baseUrl/$relativePath';
    }
    print('🔧 Debug: Final document download URL: $fullUrl');

    try {
      // Show downloading message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening $fileName for download...'),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );

      // Try to open in browser for download (most reliable method)
      final uri = Uri.parse(fullUrl);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$fileName opened in browser. You can download it from there.'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        // If browser launch fails, show URL dialog for manual download
        _showUrlDialog(fullUrl, fileName);
        // Also show a snackbar for user feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open $fileName automatically. URL shown for manual download.'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Download error: $e');
      
      // Show error with URL for manual download
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open $fileName automatically.'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Show URL',
            onPressed: () => _showUrlDialog(fullUrl, fileName),
          ),
        ),
      );
    }
  }

  void _showUrlDialog(String url, String fileName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Download $fileName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Copy this URL and paste it in your browser to download:'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SelectableText(
                  url,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _copyUrlToClipboard(url);
              },
              child: const Text('Copy URL'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _copyUrlToClipboard(String url) async {
    // For now, just show the URL in a snackbar
    // In a real app, you'd use Clipboard.setData(ClipboardData(text: url))
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('URL copied: $url'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _openFile(String filePath) async {
    try {
      final uri = Uri.file(filePath);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open file'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildAssignedToInfo(Map<String, dynamic> assignedTo) {
    return Column(
      children: [
        _buildInfoRow('Name', assignedTo['name'] ?? 'N/A'),
        _buildInfoRow('Email', assignedTo['email'] ?? 'N/A'),
        _buildInfoRow('Phone', assignedTo['phone'] ?? 'N/A'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 