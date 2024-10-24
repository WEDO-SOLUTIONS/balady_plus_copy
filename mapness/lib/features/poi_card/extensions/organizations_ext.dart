import 'package:mapness/features/poi_card/domain/model/organization_item.dart';
import 'package:mapness/features/poi_card/domain/model/organizations_response.dart';

extension RealCountOfOrganizations on OrganizationsMessage {
  int get count => items.where(_filter).length;
  List<OrganizationItem> get itemsFiltered => items.where(_filter).toList();

  /// This is not the best way to filter organizations, but it works
  /// Here we don't want to show items without name and address. Mainly the first organzation in the list
  /// is the building itself, so we don't want to show it
  ///
  /// Also if @backend will change the logic and will return items without building itself, this filter will not break
  /// the logic.
  bool _filter(OrganizationItem item) => item.nameEx?.primary != null || (item.name?.isNotEmpty ?? false);
}

extension RubricsOfOrganization on OrganizationItem {
  String? get title => nameEx?.primary ?? name;
  String? get rubricsNames => rubrics?.nonNulls.map((e) => e.name).join(', ');
}
