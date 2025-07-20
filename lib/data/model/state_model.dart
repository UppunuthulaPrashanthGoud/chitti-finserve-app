import 'package:json_annotation/json_annotation.dart';

part 'state_model.g.dart';

@JsonSerializable()
class StateModel {
  @JsonKey(name: '_id')
  final String? id;
  
  final String? name;
  final String? code;
  final String? country;
  final bool? isActive;
  
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  
  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  StateModel({
    this.id,
    this.name,
    this.code,
    this.country,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => _$StateModelFromJson(json);
  Map<String, dynamic> toJson() => _$StateModelToJson(this);

  @override
  String toString() {
    return 'StateModel(id: $id, name: $name, code: $code, country: $country, isActive: $isActive)';
  }
} 