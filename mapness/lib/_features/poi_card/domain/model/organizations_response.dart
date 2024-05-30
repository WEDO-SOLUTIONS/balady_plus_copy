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
}
