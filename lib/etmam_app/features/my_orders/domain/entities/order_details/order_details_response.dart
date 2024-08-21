import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/order_actions.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_item.dart';
import 'package:intl/intl.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class OrderDetailsResponse extends Equatable {
  OrderDetailsResponse(
      {this.id,
      this.number,
      this.cityId,
      this.relationId,
      this.serviceId,
      this.type,
      this.providerId,
      this.mandatory,
      this.independent,
      this.status,
      this.allowedActions,
      this.createDate,
      this.subOrders,
      this.pendingCancelRequest,
      this.cityName,
      this.serviceDetails,
      this.providerName,
      this.parent,
      this.serviceName,
      this.providerLogoUrl,
      this.actionsOnOrder,
      this.platformReferenceNumber,
      this.formId});

  String? id;
  String? number;
  String? cityId;
  String? relationId;
  String? serviceId;
  Status? type;
  String? providerId;
  bool? mandatory;
  bool? independent;
  String? formId;
  Status? status;
  List<Action>? allowedActions;
  String? createDate;
  List<OrderDetailsResponse>? subOrders;
  PendingCancelRequest? pendingCancelRequest;
  String? cityName;
  ServiceDetails? serviceDetails;
  String? providerName;
  String? serviceName;
  String? providerLogoUrl;
  Parent? parent;
  List<Action>? actionsOnOrder;
  String? platformReferenceNumber;

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

  List<Action> getAllowedActions() {
    List<String> actions = OrderAction.values.map((e) => e.action).toList();
    return this.allowedActions != null
        ? this.allowedActions!.where((element) {
            return actions.contains(element.id);
          }).toList()
        : [];
  }

  @override
  List<Object?> get props => [];
}

class Status {
  Status({
    this.id,
    this.name,
    this.active,
  });

  String? id;
  String? name;
  bool? active;
}

class Parent {
  Parent({
    this.id,
    this.number,
    this.cityId,
    this.relationId,
    this.serviceId,
    this.type,
    this.providerId,
    this.mandatory,
    this.independent,
    this.status,
    this.createDate,
    this.pendingCancelRequest,
  });

  String? id;
  String? number;
  String? cityId;
  String? relationId;
  String? serviceId;
  Status? type;
  String? providerId;
  bool? mandatory;
  bool? independent;
  Status? status;
  String? createDate;
  PendingCancelRequest? pendingCancelRequest;
}

class PendingCancelRequest {
  PendingCancelRequest(
      {this.id,
      this.number,
      this.status,
      this.creationTime,
      this.requestReason});

  String? id;
  String? number;
  Status? status;
  String? creationTime;
  String? requestReason;
}

class ServiceDetails {
  ServiceDetails({
    this.id,
    this.name,
    this.logoUrl,
    this.independent,
    this.ordersCount,
    this.category,
    this.description,
    this.notAvailableInCity,
  });

  String? id;
  String? name;
  String? logoUrl;
  bool? independent;
  int? ordersCount;
  Status? category;
  String? description;
  bool? notAvailableInCity;
}
