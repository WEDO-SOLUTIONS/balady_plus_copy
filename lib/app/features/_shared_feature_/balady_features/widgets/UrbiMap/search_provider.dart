import 'dart:async';

import 'package:balady_plus/app/features/_shared_feature_/balady_features/widgets/UrbiMap/urbi_location_model.dart';
import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/services/global/web_service.dart';

class UrbiSearchProvider extends ChangeNotifier {
  ValueNotifier<UrbiLocationModel>? lstSuggestedLocation;

  UrbiSearchProvider();

  Future<List<UrbiLocationModel>> search(String query, LatLng location) async {
    Response? response;
    try {
      String url = "https://urbi-lifestyle.momah.gov.sa/3.0/suggests";

      WebService webService = sl();
      Map<String, dynamic> formMap = {
        "key": "0dc4aaea-82ac-416a-b807-f99c33b835b6",
        "locale": "ar_SA",
        "fields": "items.full_address_name,items.point,items.adm_div",
        "q": query,
        "location": "${location.longitude},${location.latitude}",
      };
      response = await webService.dio.get(url, queryParameters: formMap);

      final data = response.data["result"]["items"];

      List<UrbiLocationModel> parsedResult = data != null
          ? List<UrbiLocationModel>.from(data.map((x) => UrbiLocationModel.fromJson(x)))
          : [];

      parsedResult = parsedResult.where((item) => (item.fullName != null && item.fullName!.isNotEmpty)).toList();
      return parsedResult;
    } on DioException catch (_) {
      return [];
    } catch (_) {
      return [];
    }
  }
}
