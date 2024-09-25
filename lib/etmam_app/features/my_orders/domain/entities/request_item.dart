import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/order_actions.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/order_status.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class RequestItem extends Equatable {
  String? requestId;
  String? internalId;
  String? requestNumber;
  String? cityId;
  String? cityName;
  String? orderStatus;
  String? statusName;
  bool? closureFlag;
  String? requestTypeId;
  String? requestTypeName;
  String? createDate;
  String? subServiceId;
  String? subServiceName;
  String? mainServiceId;
  String? mainServiceName;
  String? providerId;
  String? providerName;
  List<Tag>? tags;
  RequestItem(
      {this.requestId,
      this.requestNumber,
      this.closureFlag,
      this.subServiceId,
      this.subServiceName,
      this.mainServiceId,
      this.mainServiceName,
      this.cityName,
      this.providerId,
      this.providerName,
      this.requestTypeId,
      this.requestTypeName,
      this.createDate,
      this.cityId,
      this.orderStatus,
      this.internalId,
      this.statusName,
      this.tags});

  String getCreatedDate() {
    try {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      DateTime? time = DateTime.tryParse(createDate ?? "");

      if (time != null) {
        return dateFormat.format(time);
      }
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
    return "";
  }

  Tag? getPendingRequsetTag() {
    return tags?.firstWhereOrNull(
        (element) => element.id == "bidding.tags.pending-offers");
  }

  @override
  List<Object?> get props => [requestId];
}

class Tag {
  String? id;
  String? value;

  Tag({this.id, this.value});
}
