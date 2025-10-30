import '../../../../../core/utils/enums/enums.dart';
import '../../../requests/domain/entities/crm_request_item.dart';

class RequestDetailsPageParams {
  RequestsType type;
  CRMRequestItem details;

  RequestDetailsPageParams({required this.details, required this.type});
}
