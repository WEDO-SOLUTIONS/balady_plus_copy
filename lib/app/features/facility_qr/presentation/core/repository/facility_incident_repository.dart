/*import 'dart:convert';

import 'package:balady_plus/app/core/remote_services/api_constants.dart';
import 'package:balady_plus/app/core/remote_services/pega_web_service.dart';
import 'package:balady_plus/app/core/shared_local_services/common.dart';
import 'package:balady_plus/app/core/shared_local_services/locator.dart';
import 'package:balady_plus/app/features/customer_voice/presentation/core/models/classification.dart';

class FacilityIncidentRepository {
  final webServices = locator<WebService>();

  Future<SpecializedClassification?> getSPlList(String municipality,
      {String? category}) async {
    Map<String, dynamic> queryParms = {};
    if (userInfo?.idNo != null) {
      queryParms = {
        if (userInfo!.idNo!.startsWith("1"))
          "NationalID": "${userInfo!.idNo}"
        else
          "IqamaID": "${userInfo!.idNo}",
        "ID": municipality,
        "action": "SplClsList",
        "ChannelType": "Mobile",
        "Type": "CRM",
        if (category != null && category.isNotEmpty)
          "SpecialClassificationType": category
      };
    }

    final body = await webServices.getPegaRequest(
        ApiConstants.IncidentRetrieveData,
        queryParams: queryParms);
    bool state = body['state'];
    dynamic data = body['data'];

    try {
      SpecializedClassification response =
          SpecializedClassification.fromMap(json.decode(data));
      return response;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
   

      return null;
    }
  }
}
*/
