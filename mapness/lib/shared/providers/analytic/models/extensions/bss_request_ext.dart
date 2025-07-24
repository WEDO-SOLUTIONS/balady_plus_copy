import 'package:mapness/shared/providers/analytic/models/bss_request.dart';

extension BssRequestExt on BssRequest {
  Map<String, dynamic> toJson() => {
        'eventType': eventType.name,
        'actionType': actionType?.name,
        'timestamp': timestamp,
        'query': query,
        'uiElement': uiElement.toJson(),
        'map': map.toJson(),
        'common': common.toJson(),
        'payload': payload?.toJson(),
      };
}
