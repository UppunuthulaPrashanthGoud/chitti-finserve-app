import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'lead_provider.dart';
import '../../main.dart';

class AppliedLoansScreen extends ConsumerStatefulWidget {
  const AppliedLoansScreen({super.key});

  @override
  ConsumerState<AppliedLoansScreen> createState() => _AppliedLoansScreenState();
}

class _AppliedLoansScreenState extends ConsumerState<AppliedLoansScreen> with TickerProviderStateMixin {
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
    final leadsAsync = ref.watch(leadListProvider);
    
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
                  child: leadsAsync.when(
                    data: (leads) => _buildLeadsList(leads),
                    loading: () => _buildLoadingState(),
                    error: (e, _) => _buildErrorState(e),
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
          // Top row with menu button
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    // Navigate to main navigation with applications tab selected
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const MainNavScreen(initialIndex: 1),
                      ),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.menu, color: Colors.white),
                  iconSize: 20,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    // Refresh applications
                    ref.invalidate(leadListProvider);
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  iconSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Icon(
              Icons.assignment_outlined,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'My Applications',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track your loan applications',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadsList(List<Application> applications) {
    if (applications.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final application = applications[index];
        return _buildLeadCard(application, index);
      },
    );
  }

  Widget _buildLeadCard(Application application, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getStatusColor(application.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getStatusIcon(application.status),
                      color: _getStatusColor(application.status),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.loanType,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'Montserrat',
                            color: Color(0xFF005DFF),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${application.loanAmount.toStringAsFixed(0)} • ${application.category}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Applied on ${application.appliedDate}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Category icon on the right
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF005DFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.category,
                      color: const Color(0xFF005DFF),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(application.status),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Progress Steps
              _buildProgressSteps(application.status),
              
              if (application.status == 'approved' || application.status == 'rejected')
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getStatusColor(application.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getStatusColor(application.status).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        application.status == 'approved' ? Icons.check_circle : Icons.cancel,
                        color: _getStatusColor(application.status),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          application.status == 'approved' 
                              ? 'Congratulations! Your loan has been approved.'
                              : 'Your loan application has been rejected.',
                          style: TextStyle(
                            color: _getStatusColor(application.status),
                            fontSize: 14,
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
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }

  Widget _buildProgressSteps(String currentStatus) {
    final steps = ['pending', 'under_review', 'approved'];
    final currentIndex = steps.indexOf(currentStatus.toLowerCase());
    
    return Column(
      children: [
        Row(
          children: steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isCompleted = index <= currentIndex;
            final isCurrent = index == currentIndex;
            
            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: isCompleted 
                            ? _getStatusColor(currentStatus)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (index < steps.length - 1)
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isCompleted 
                            ? _getStatusColor(currentStatus)
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isCompleted = index <= currentIndex;
            final isCurrent = index == currentIndex;
            
            return Expanded(
              child: Text(
                step.replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(
                  color: isCompleted 
                      ? _getStatusColor(currentStatus)
                      : Colors.grey[400],
                  fontSize: 10,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'under_review':
        return Colors.blue;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'disbursed':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'under_review':
        return Icons.visibility;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'disbursed':
        return Icons.payment;
      default:
        return Icons.assignment;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.folder_open,
              size: 64,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No applications yet',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your loan applications will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/loan-form');
            },
            icon: const Icon(Icons.add),
            label: const Text('Apply for Loan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF005DFF),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 16),
          Text(
            'Loading applications...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.white70,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load applications',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
