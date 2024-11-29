import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/features/poi_card/domain/model/organization_item.dart';

part 'organizations_response.g.dart';

@JsonSerializable()
class OrganizationsMessage {
  final List<OrganizationItem> items;
  final int total;
  final int page;

  OrganizationsMessage({
    required this.items,
    required this.total,
    this.page = 1,
  });

  factory OrganizationsMessage.fromJson(Map<String, dynamic> json) => _$OrganizationsMessageFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationsMessageToJson(this);
}
