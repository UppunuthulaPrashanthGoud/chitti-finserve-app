import 'package:json_annotation/json_annotation.dart';

part 'bank_model.g.dart';

@JsonSerializable()
class BankModel {
  @JsonKey(name: '_id')
  final String? id;
  
  final String? name;
  final String? code;
  final String? ifscCode;
  final String? branch;
  final String? address;
  final bool? isActive;
  
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  
  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  BankModel({
    this.id,
    this.name,
    this.code,
    this.ifscCode,
    this.branch,
    this.address,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) => _$BankModelFromJson(json);
  Map<String, dynamic> toJson() => _$BankModelToJson(this);

  @override
  String toString() {
    return 'BankModel(id: $id, name: $name, code: $code, ifscCode: $ifscCode, branch: $branch, address: $address, isActive: $isActive)';
  }
} 