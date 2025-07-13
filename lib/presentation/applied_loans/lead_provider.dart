import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/loan_form_repository.dart';
import '../loan_form/loan_form_provider.dart';

class Application {
  final String id;
  final String loanType;
  final String status;
  final String appliedDate;
  final String? approvedDate;
  final String? rejectedDate;
  final String? remarks;
  final double loanAmount;
  final String category;

  Application({
    required this.id,
    required this.loanType,
    required this.status,
    required this.appliedDate,
    this.approvedDate,
    this.rejectedDate,
    this.remarks,
    required this.loanAmount,
    required this.category,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['_id'] ?? json['id'] ?? '',
      loanType: json['loanType'] ?? '',
      status: json['status'] ?? 'pending',
      appliedDate: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']).toLocal().toString().split(' ')[0]
          : '',
      approvedDate: json['approvedDate'],
      rejectedDate: json['rejectedDate'],
      remarks: json['remarks'],
      loanAmount: (json['loanAmount'] ?? 0).toDouble(),
      category: json['category']?['name'] ?? '',
    );
  }
}

final leadListProvider = FutureProvider<List<Application>>((ref) async {
  try {
    final repository = ref.read(loanFormRepositoryProvider);
    final applications = await repository.getUserApplications();
    
    return applications.map((app) => Application.fromJson(app)).toList();
  } catch (e) {
    // Return empty list if API fails
    return [];
  }
}); 