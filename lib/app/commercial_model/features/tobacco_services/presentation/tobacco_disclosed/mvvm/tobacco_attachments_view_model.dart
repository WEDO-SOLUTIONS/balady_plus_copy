import 'dart:async';
import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/reason_cancel.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/data/models/facility.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/data/models/tobacco_schedule.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/data/repositories/repository_implementation.dart';
import 'package:dio/dio.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';


class DisclosedMonthsViewModel extends BaseViewModel {
  final TobaccoListRepositoryImplementation repository;
  // final String identityNumber;
  final DisclosureSchedule disclosureSchedule;
  final Facility facility;
  double? amount;
  String? attachmentId;
  FileDataItem? fileUploaded;

  DisclosedMonthsViewModel({
    required this.facility,
    required this.disclosureSchedule,
    required this.repository,
    // required this.identityNumber,
  });

  Future<void> uploadTobaccoServicesAttachments(FileDataItem file) async {
    Response? response;
    try {
      isLoading = true;
      notifyListeners();
      var response = await repository.uploadFile(file);
      response.fold(
        (failure) {
          errorMessage = failure.toString();
        },
        (success) {
          attachmentId = success;
          fileUploaded = file;
        },
      );
    } on Exception catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      showError(error.toString());
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      showError(error.toString());
    }
    isLoading = false;
    notifyListeners();
  }

  //////////////////////////////////////////
  bool reason = false;

  // int? removeDisclosureReasonId;
  // String? removeDisclosureComments;
  String? removeDisclosureComments;
  void setReason(bool reason) {
    this.reason = reason;
    amount = null;
    notifyListeners();
  }

  List<ReasonCancel> reasonCancelList = [
    ReasonCancel(id: 101, text: 'المنشاة مغلق'),
    ReasonCancel(id: 102, text: 'لا يــوجد إيــرادات'),
    ReasonCancel(id: 103, text: 'أخــرى'),
  ];
  ReasonCancel? reasonCancel;

  void selectReasonCancel(ReasonCancel? selectReasonCancel) {
    reasonCancel = selectReasonCancel;
    notifyListeners();
  }

  // Future<void> getCommercialLicenseCancellationReasons() async {
  //   Response? response;
  //   try {
  //     isLoading = true;
  //     notifyListeners();
  //     final reasonCancelList = [
  //       ReasonCancel(id: 101, text: 'المحل مغلق'),
  //       ReasonCancel(id: 102, text: 'لا يــوجد إيــرادات'),
  //       ReasonCancel(id: 103, text: 'أخــرى'),
  //     ];
  //   } on Exception catch (exception) {
  //     CommonFunctions.sendEvent(
  //       dioError: exception is DioException ? exception : null,
  //       response: response,
  //       ex: exception,
  //     );
  //   } catch (exception) {
  //     CommonFunctions.sendEvent(
  //       dioError: null,
  //       response: response,
  //       ex: Exception(error.toString()),
  //     );
  //   }
  //   isLoading = false;
  //   notifyListeners();
  // }
}
