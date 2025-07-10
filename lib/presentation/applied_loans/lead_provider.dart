import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockLead {
  final String id;
  final String loanType;
  final String status;
  final String appliedDate;
  final String? approvedDate;
  final String? rejectedDate;
  final String? remarks;

  MockLead({
    required this.id,
    required this.loanType,
    required this.status,
    required this.appliedDate,
    this.approvedDate,
    this.rejectedDate,
    this.remarks,
  });
}

final leadListProvider = FutureProvider<List<MockLead>>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(seconds: 1));
  
  return [
    MockLead(
      id: 'personal_1',
      loanType: 'Personal Loan',
      status: 'Under Review',
      appliedDate: '2024-01-15',
    ),
    MockLead(
      id: 'business_1',
      loanType: 'Business Loan',
      status: 'In Process',
      appliedDate: '2024-01-10',
    ),
    MockLead(
      id: 'home_1',
      loanType: 'Home Loan',
      status: 'Approved',
      appliedDate: '2024-01-05',
      approvedDate: '2024-01-20',
      remarks: 'Congratulations! Your loan has been approved successfully.',
    ),
    MockLead(
      id: 'car_1',
      loanType: 'Car Loan',
      status: 'Rejected',
      appliedDate: '2024-01-01',
      rejectedDate: '2024-01-08',
      remarks: 'Your loan application has been rejected. Please contact us for more details.',
    ),
  ];
}); 