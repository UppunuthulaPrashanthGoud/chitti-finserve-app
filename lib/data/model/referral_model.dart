class ReferralModel {
  final String id;
  final ReferredUserModel referredUser;
  final String status;
  final int bonusAmount;
  final String createdAt;
  final String? completedAt;

  ReferralModel({
    required this.id,
    required this.referredUser,
    required this.status,
    required this.bonusAmount,
    required this.createdAt,
    this.completedAt,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      id: json['id'] ?? '',
      referredUser: ReferredUserModel.fromJson(json['referredUser'] ?? {}),
      status: json['status'] ?? '',
      bonusAmount: json['bonusAmount'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      completedAt: json['completedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'referredUser': referredUser.toJson(),
      'status': status,
      'bonusAmount': bonusAmount,
      'createdAt': createdAt,
      'completedAt': completedAt,
    };
  }
}

class ReferredUserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String createdAt;

  ReferredUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
  });

  factory ReferredUserModel.fromJson(Map<String, dynamic> json) {
    return ReferredUserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': createdAt,
    };
  }
}

class WalletModel {
  final double balance;
  final double totalEarned;
  final double totalWithdrawn;

  WalletModel({
    required this.balance,
    required this.totalEarned,
    required this.totalWithdrawn,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: (json['balance'] ?? 0).toDouble(),
      totalEarned: (json['totalEarned'] ?? 0).toDouble(),
      totalWithdrawn: (json['totalWithdrawn'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'totalEarned': totalEarned,
      'totalWithdrawn': totalWithdrawn,
    };
  }
}

class ReferralStatisticsModel {
  final int totalReferrals;
  final int completedReferrals;
  final int pendingReferrals;
  final double totalEarned;

  ReferralStatisticsModel({
    required this.totalReferrals,
    required this.completedReferrals,
    required this.pendingReferrals,
    required this.totalEarned,
  });

  factory ReferralStatisticsModel.fromJson(Map<String, dynamic> json) {
    return ReferralStatisticsModel(
      totalReferrals: json['totalReferrals'] ?? 0,
      completedReferrals: json['completedReferrals'] ?? 0,
      pendingReferrals: json['pendingReferrals'] ?? 0,
      totalEarned: (json['totalEarned'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalReferrals': totalReferrals,
      'completedReferrals': completedReferrals,
      'pendingReferrals': pendingReferrals,
      'totalEarned': totalEarned,
    };
  }
}

class ReferralDataModel {
  final String referralCode;
  final ReferredByModel? referredBy;
  final WalletModel wallet;
  final ReferralStatisticsModel statistics;
  final List<ReferralModel> referrals;

  ReferralDataModel({
    required this.referralCode,
    this.referredBy,
    required this.wallet,
    required this.statistics,
    required this.referrals,
  });

  factory ReferralDataModel.fromJson(Map<String, dynamic> json) {
    return ReferralDataModel(
      referralCode: json['referralCode'] ?? '',
      referredBy: json['referredBy'] != null 
          ? ReferredByModel.fromJson(json['referredBy']) 
          : null,
      wallet: WalletModel.fromJson(json['wallet'] ?? {}),
      statistics: ReferralStatisticsModel.fromJson(json['statistics'] ?? {}),
      referrals: (json['referrals'] as List<dynamic>? ?? [])
          .map((e) => ReferralModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referralCode': referralCode,
      'referredBy': referredBy?.toJson(),
      'wallet': wallet.toJson(),
      'statistics': statistics.toJson(),
      'referrals': referrals.map((e) => e.toJson()).toList(),
    };
  }
}

class ReferredByModel {
  final String name;
  final String? referralCode;

  ReferredByModel({
    required this.name,
    this.referralCode,
  });

  factory ReferredByModel.fromJson(Map<String, dynamic> json) {
    return ReferredByModel(
      name: json['name'] ?? '',
      referralCode: json['referralCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'referralCode': referralCode,
    };
  }
}

class WalletTransactionModel {
  final String id;
  final String type;
  final double amount;
  final double balance;
  final String description;
  final String category;
  final String status;
  final String createdAt;

  WalletTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.balance,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'balance': balance,
      'description': description,
      'category': category,
      'status': status,
      'createdAt': createdAt,
    };
  }
}

class WalletTransactionsResponseModel {
  final List<WalletTransactionModel> transactions;
  final PaginationModel pagination;

  WalletTransactionsResponseModel({
    required this.transactions,
    required this.pagination,
  });

  factory WalletTransactionsResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionsResponseModel(
      transactions: (json['transactions'] as List<dynamic>? ?? [])
          .map((e) => WalletTransactionModel.fromJson(e))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactions': transactions.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class PaginationModel {
  final int page;
  final int limit;
  final int total;
  final int pages;

  PaginationModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'pages': pages,
    };
  }
}

class ShareReferralModel {
  final String referralCode;
  final String shareMessage;
  final String shareUrl;
  final String appName;

  ShareReferralModel({
    required this.referralCode,
    required this.shareMessage,
    required this.shareUrl,
    required this.appName,
  });

  factory ShareReferralModel.fromJson(Map<String, dynamic> json) {
    return ShareReferralModel(
      referralCode: json['referralCode'] ?? '',
      shareMessage: json['shareMessage'] ?? '',
      shareUrl: json['shareUrl'] ?? '',
      appName: json['appName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referralCode': referralCode,
      'shareMessage': shareMessage,
      'shareUrl': shareUrl,
      'appName': appName,
    };
  }
} 
 
 