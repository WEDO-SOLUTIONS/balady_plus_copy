import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/request_details/request_replies_model.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/order_actions.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class RequestDetailsResponse extends Equatable {
  RequestDetailsResponse(
      {this.requestId,
      this.requestNumber,
      this.relationId,
      this.formId,
      this.requestStatusId,
      this.requestStatusName,
      this.closureFlag,
      this.allowedActions,
      this.createdOffersCount,
      this.submittedOffersCount,
      this.processedOffersCount,
      this.acceptedOffer,
      this.creationDate,
      this.subServiceId,
      this.subServiceName,
      this.mainServiceId,
      this.mainServiceName,
      this.cityId,
      this.cityName,
      this.services,
      this.allReplies,
      this.calculatedStatus});

  String? requestId;
  String? requestNumber;
  String? relationId;
  String? formId;
  String? requestStatusId;
  String? requestStatusName;
  bool? closureFlag;
  String? creationDate;
  List<Action>? allowedActions;
  int? createdOffersCount;
  int? submittedOffersCount;
  int? processedOffersCount;
  AcceptedOffer? acceptedOffer;
  String? subServiceId;
  String? subServiceName;
  String? mainServiceId;
  String? mainServiceName;
  String? cityId;
  String? cityName;
  List<Action>? actionsOnOrder;
  List<RequestRepliesModel>? allReplies;
  List<RequestService>? services;
  Status? calculatedStatus;

  Action? deleteAction() {
    return allowedActions
        ?.firstWhereOrNull((element) => element.id == "cancel");
  }

  Action? editAction() {
    return allowedActions?.firstWhereOrNull((element) => element.id == "edit");
  }

  Action? delegateAction() {
    return allowedActions
        ?.firstWhereOrNull((element) => element.id == "create-target-request");
  }

  String getCreatedDate() {
    try {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      DateTime? time = DateTime.tryParse(creationDate ?? "");

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

  List<RequestRepliesModel> getRequestReplies() {
    List<RequestRepliesModel> list = [];
    list.add(RequestRepliesModel(
        relationId: relationId,
        requestId: requestId,
        requestNumber: requestNumber,
        subServiceId: subServiceId,
        subServiceName: subServiceName,
        createdOffersCount: createdOffersCount,
        processedOffersCount: processedOffersCount,
        submittedOffersCount: submittedOffersCount,
        isAccepted: acceptedOffer?.id != null,
        financialAttachmentId: acceptedOffer?.financialAttachmentId,
        technicalAttachmentId: acceptedOffer?.technicalAttachmentId));

    services?.forEach((element) {
      list.add(RequestRepliesModel(
          relationId: element.relationId,
          requestId: element.requestId,
          requestNumber: element.requestNumber,
          subServiceId: element.subServiceId,
          subServiceName: element.subServiceName,
          createdOffersCount: element.createdOffersCount,
          processedOffersCount: element.processedOffersCount,
          submittedOffersCount: element.submittedOffersCount,
          isAccepted: element.acceptedOffer?.id != null,
          financialAttachmentId: acceptedOffer?.financialAttachmentId,
          technicalAttachmentId: acceptedOffer?.technicalAttachmentId));
    });

    return list;
  }

  @override
  List<Object?> get props => [];
}

class AcceptedOffer {
  AcceptedOffer(
      {this.id,
      this.number,
      this.providerId,
      this.value,
      this.notes,
      this.status,
      this.providerName,
      this.providerLogo,
      this.financialAttachmentId,
      this.technicalAttachmentId});

  String? id;
  String? number;
  String? providerId;
  int? value;
  String? notes;
  Status? status;
  String? providerName;
  String? providerLogo;
  String? financialAttachmentId;
  String? technicalAttachmentId;
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

class RequestService {
  RequestService(
      {this.relationId,
      this.targetRequestTypeId,
      this.cityId,
      this.createdOffersCount,
      this.submittedOffersCount,
      this.processedOffersCount,
      //  this.allowedActions,
      // this.subBiddings,
      this.subServiceId,
      this.subServiceName,
      this.mainServiceId,
      this.mainServiceName,
      this.requestId,
      this.requestNumber,
      this.requestStatusId,
      this.requestStatusName,
      this.closureFlag,
      this.acceptedOffer});

  final String? relationId;
  final String? targetRequestTypeId;
  final String? cityId;
  final int? createdOffersCount;
  final int? submittedOffersCount;
  final int? processedOffersCount;
  //final List<dynamic>? allowedActions;
//final List<dynamic>? subBiddings;
  final AcceptedOffer? acceptedOffer;

  final String? subServiceId;
  final String? subServiceName;
  final String? mainServiceId;
  final String? mainServiceName;
  final String? requestId;
  final String? requestNumber;
  final String? requestStatusId;
  final String? requestStatusName;
  final bool? closureFlag;
}
