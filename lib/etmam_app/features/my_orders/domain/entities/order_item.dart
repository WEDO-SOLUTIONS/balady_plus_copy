import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/order_actions.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/order_status.dart';
import 'package:intl/intl.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';


class OrderItem extends Equatable {
  String? id;
  String? number;
  String? relationId;
  String? subServiceId;
  String? subServiceName;
  String? mainServiceId;
  String? mainServiceName;
  Status? type;
  String? providerId;
  bool? mandatory;
  bool? independent;
  Status? status;
  List<Action>? allowedActions;
  String? createDate;
  bool? hasPendingCancelRequest;
  String? cityId;
  OrderStatus? orderStatus;
  List<Action>? actionsOnOrder;

  OrderItem(
      {this.id,
      this.number,
      this.relationId,
      this.subServiceId,
      this.subServiceName,
      this.mainServiceId,
      this.mainServiceName,
      this.type,
      this.providerId,
      this.mandatory,
      this.independent,
      this.status,
      this.allowedActions,
      this.createDate,
      this.hasPendingCancelRequest,
      this.cityId,
      this.orderStatus,
      this.actionsOnOrder});

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
        ? this
            .allowedActions!
            .where((element) => actions.contains(element.id))
            .toList()
        : [];
  }

  @override
  List<Object?> get props => [id];
}

class Status {
  Status({
    this.id,
    this.name,
  });

  String? id;
  String? name;
}

class Action {
  Action({this.id, this.name, this.action});

  OrderAction? action;

  String? id;
  String? name;
}
