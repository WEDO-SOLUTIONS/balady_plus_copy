import 'package:mapness/_features/poi_card/domain/model/organization_item.dart';

class OrganizationsMessage {
  final List<OrganizationItem> items;
  final int total;
  final int page;

  OrganizationsMessage({
    required this.items,
    required this.total,
    this.page = 1,
  });

  factory OrganizationsMessage.fromJson(Map<String, dynamic>? json) {
    final itemsList = <OrganizationItem>[];
    json?['items']?.forEach((v) => itemsList.add(OrganizationItem.fromJson(v)));
    final totalJson = json?['total'] ?? 0;
    final pageJson = json?['page'] ?? 0;
    return OrganizationsMessage(
      items: itemsList,
      total: totalJson,
      page: pageJson,
    );
  }

  Map<String, dynamic> toJson() => {
      'items': items.map((v) => v.toJson()).toList(),
      'total': total,
      'page': page,
    };
}
