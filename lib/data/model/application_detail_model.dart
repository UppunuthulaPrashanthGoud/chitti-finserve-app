class ApplicationDetailModel {
  final String id;
  final String loanType;
  final double loanAmount;
  final String loanPurpose;
  final double monthlyIncome;
  final String employmentType;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Personal Information
  final PersonalInfo personalInfo;
  
  // Address Information
  final Address address;
  
  // Category Information
  final CategoryInfo category;
  
  // Documents with full URLs
  final Documents documents;
  
  // Status History
  final List<StatusHistory> statusHistory;
  
  // Assignment Information
  final AssignedTo? assignedTo;
  
  // Additional Information
  final AdditionalInfo additionalInfo;

  ApplicationDetailModel({
    required this.id,
    required this.loanType,
    required this.loanAmount,
    required this.loanPurpose,
    required this.monthlyIncome,
    required this.employmentType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.personalInfo,
    required this.address,
    required this.category,
    required this.documents,
    required this.statusHistory,
    this.assignedTo,
    required this.additionalInfo,
  });

  factory ApplicationDetailModel.fromJson(Map<String, dynamic> json) {
    return ApplicationDetailModel(
      id: json['_id'] ?? '',
      loanType: json['loanType'] ?? '',
      loanAmount: (json['loanAmount'] ?? 0).toDouble(),
      loanPurpose: json['loanPurpose'] ?? '',
      monthlyIncome: (json['monthlyIncome'] ?? 0).toDouble(),
      employmentType: json['employmentType'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      personalInfo: PersonalInfo.fromJson(json['personalInfo'] ?? {}),
      address: Address.fromJson(json['address'] ?? {}),
      category: CategoryInfo.fromJson(json['category'] ?? {}),
      documents: Documents.fromJson(json['documents'] ?? {}),
      statusHistory: (json['statusHistory'] as List<dynamic>?)
          ?.map((e) => StatusHistory.fromJson(e))
          .toList() ?? [],
      assignedTo: json['assignedTo'] != null 
          ? AssignedTo.fromJson(json['assignedTo']) 
          : null,
      additionalInfo: AdditionalInfo.fromJson(json['additionalInfo'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'loanType': loanType,
      'loanAmount': loanAmount,
      'loanPurpose': loanPurpose,
      'monthlyIncome': monthlyIncome,
      'employmentType': employmentType,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'personalInfo': personalInfo.toJson(),
      'address': address.toJson(),
      'category': category.toJson(),
      'documents': documents.toJson(),
      'statusHistory': statusHistory.map((e) => e.toJson()).toList(),
      'assignedTo': assignedTo?.toJson(),
      'additionalInfo': additionalInfo.toJson(),
    };
  }
}

class PersonalInfo {
  final String name;
  final String email;
  final String phone;
  final String? aadharNumber;
  final String? panNumber;

  PersonalInfo({
    required this.name,
    required this.email,
    required this.phone,
    this.aadharNumber,
    this.panNumber,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      aadharNumber: json['aadharNumber'],
      panNumber: json['panNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'aadharNumber': aadharNumber,
      'panNumber': panNumber,
    };
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String pincode;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'pincode': pincode,
    };
  }

  String get fullAddress => '$street, $city, $state - $pincode';
}

class CategoryInfo {
  final String id;
  final String name;
  final String? description;

  CategoryInfo({
    required this.id,
    required this.name,
    this.description,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
    };
  }
}

class Documents {
  final String? aadharCard;
  final String? panCard;
  final String? incomeProof;
  final String? bankStatement;
  final String? addressProof;
  final List<String> otherDocuments;

  Documents({
    this.aadharCard,
    this.panCard,
    this.incomeProof,
    this.bankStatement,
    this.addressProof,
    required this.otherDocuments,
  });

  factory Documents.fromJson(Map<String, dynamic> json) {
    return Documents(
      aadharCard: json['aadharCard'],
      panCard: json['panCard'],
      incomeProof: json['incomeProof'],
      bankStatement: json['bankStatement'],
      addressProof: json['addressProof'],
      otherDocuments: List<String>.from(json['otherDocuments'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aadharCard': aadharCard,
      'panCard': panCard,
      'incomeProof': incomeProof,
      'bankStatement': bankStatement,
      'addressProof': addressProof,
      'otherDocuments': otherDocuments,
    };
  }

  List<DocumentItem> get allDocuments {
    final documents = <DocumentItem>[];
    
    if (aadharCard != null) {
      documents.add(DocumentItem(
        name: 'Aadhar Card',
        url: aadharCard!,
        type: 'aadhar',
      ));
    }
    
    if (panCard != null) {
      documents.add(DocumentItem(
        name: 'PAN Card',
        url: panCard!,
        type: 'pan',
      ));
    }
    
    if (incomeProof != null) {
      documents.add(DocumentItem(
        name: 'Income Proof',
        url: incomeProof!,
        type: 'income',
      ));
    }
    
    if (bankStatement != null) {
      documents.add(DocumentItem(
        name: 'Bank Statement',
        url: bankStatement!,
        type: 'bank',
      ));
    }
    
    if (addressProof != null) {
      documents.add(DocumentItem(
        name: 'Address Proof',
        url: addressProof!,
        type: 'address',
      ));
    }
    
    for (int i = 0; i < otherDocuments.length; i++) {
      documents.add(DocumentItem(
        name: 'Other Document ${i + 1}',
        url: otherDocuments[i],
        type: 'other',
      ));
    }
    
    return documents;
  }
}

class DocumentItem {
  final String name;
  final String url;
  final String type;

  DocumentItem({
    required this.name,
    required this.url,
    required this.type,
  });
}

class StatusHistory {
  final String status;
  final String comment;
  final String updatedBy;
  final DateTime updatedAt;

  StatusHistory({
    required this.status,
    required this.comment,
    required this.updatedBy,
    required this.updatedAt,
  });

  factory StatusHistory.fromJson(Map<String, dynamic> json) {
    return StatusHistory(
      status: json['status'] ?? '',
      comment: json['comment'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'comment': comment,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get formattedDate {
    return '${updatedAt.day}/${updatedAt.month}/${updatedAt.year}';
  }

  String get formattedTime {
    return '${updatedAt.hour.toString().padLeft(2, '0')}:${updatedAt.minute.toString().padLeft(2, '0')}';
  }
}

class AssignedTo {
  final String id;
  final String name;
  final String email;
  final String phone;

  AssignedTo({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory AssignedTo.fromJson(Map<String, dynamic> json) {
    return AssignedTo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}

class AdditionalInfo {
  final bool isActive;
  final bool isVerified;
  final DateTime? verificationDate;
  final DateTime? approvalDate;
  final DateTime? disbursementDate;

  AdditionalInfo({
    required this.isActive,
    required this.isVerified,
    this.verificationDate,
    this.approvalDate,
    this.disbursementDate,
  });

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalInfo(
      isActive: json['isActive'] ?? false,
      isVerified: json['isVerified'] ?? false,
      verificationDate: json['verificationDate'] != null 
          ? DateTime.parse(json['verificationDate']) 
          : null,
      approvalDate: json['approvalDate'] != null 
          ? DateTime.parse(json['approvalDate']) 
          : null,
      disbursementDate: json['disbursementDate'] != null 
          ? DateTime.parse(json['disbursementDate']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isActive': isActive,
      'isVerified': isVerified,
      'verificationDate': verificationDate?.toIso8601String(),
      'approvalDate': approvalDate?.toIso8601String(),
      'disbursementDate': disbursementDate?.toIso8601String(),
    };
  }
} 