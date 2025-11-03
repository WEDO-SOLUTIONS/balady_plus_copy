import 'dart:async';
import 'package:dio/dio.dart';
import 'package:mapness/features/poi_card/domain/model/organization_item.dart';
import 'package:mapness/features/poi_card/domain/model/organizations_response.dart';

abstract class PoiDataService {
  factory PoiDataService(Dio dio) => _PoiDataService(dio: dio);

  Future<OrganizationsMessage?> inBuildingOrganizations({
    required String key,
    required String url,
    required String languageCode,
    int? objectId,
    int page = 1,
    CancelToken? cancelToken,
    int pageSize = 30,
  });
}

class _PoiDataService implements PoiDataService {
  final Dio dio;

  _PoiDataService({required this.dio});

  @override
  Future<OrganizationsMessage?> inBuildingOrganizations({
    required String url,
    required String languageCode,
    String? key,
    int? objectId,
    int page = 1,
    int pageSize = 30,
    CancelToken? cancelToken,
  }) async {
    Response response;
    try {
      final request = '$url/3.0/items';
      const _fields = 'context_rubrics,'
          'items.sources,'
          'items.floors,'
          'items.floor_id,'
          'items.links.database_entrances.apartments_info,'
          'items.locale,items.flags,search_attributes,items.adm_div,items.city_alias,items.region_id,'
          'items.segment_id,items.reviews,items.point,request_type,items.links,items.name_ex,items.name_back,items.org,'
          'items.group,items.external_content,items.comment,items.ads.options,items.stat,items.description,'
          'items.geometry.centroid,items.geometry.selection,items.geometry.style,items.timezone_offset,items.context,'
          'items.address,items.is_paid,items.access,items.access_comment,items.for_trucks,items.is_incentive,'
          'items.paving_type,items.capacity,items.schedule,items.floors,dym,ad,items.rubrics,items.routes,'
          'items.reply_rate,items.purpose,items.purpose_code,items.route_logo,items.has_goods,'
          'items.has_apartments_info,items.has_pinned_goods,items.has_realty,items.has_payments,items.is_promoted,'
          'items.delivery,items.order_with_cart,search_type,items.has_discount,items.metarubrics,items.detailed_subtype,'
          'items.temporary_unavailable_atm_services,items.poi_category,items.trade_license';
      response = await dio.get(
        request,
        queryParameters: {
          'key': '$key',
          'building_id': '$objectId',
          'fields': _fields,
          'locale': languageCode,
          'page_size': '$pageSize',
          'page': '$page',
        },
        cancelToken: cancelToken,
      );
      final data = response.data as Map<String, dynamic>;
      final result = data['result'] as Map<String, dynamic>;
      final organizationsResponse = OrganizationsMessage(
        items: (result['items'] as List<dynamic>?)?.map((e) => OrganizationItem.fromJson(e)).toList() ??
            <OrganizationItem>[],
        total: result['total'] ?? 0,
      );

      return organizationsResponse;
    } on DioException catch (_) {
      return null;
    }
  }
}
