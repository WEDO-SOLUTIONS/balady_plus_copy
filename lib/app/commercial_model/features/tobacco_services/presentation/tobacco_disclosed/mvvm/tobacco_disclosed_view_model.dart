import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/data/models/disclosure_request.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/data/repositories/repository_implementation.dart';

class TobaccoDisclosedViewModel extends BaseViewModel {
  final TobaccoListRepositoryImplementation repository;
  final DisclosureRequest disclosureRequest;
  FileDataItem? fileUploaded;

  bool acknowledgePledge = false;

  TobaccoDisclosedViewModel({
    required this.repository,
    required this.disclosureRequest,
    this.fileUploaded,
  });

  Future uploadDisclosure() async {
    try {
      isLoading = true;
      notifyListeners();
      var response = await repository.uploadDisclosure(disclosureRequest);
      var data;
      response.fold(
        (failure) {
          errorMessage = failure.toString();
          showError(errorMessage!);
        },
        (success) {
          data = success;
        },
      );
      isLoading = false;
      notifyListeners();
      return data;
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

  void setAcknowledgePledge(bool acknowledgePledge) {
    this.acknowledgePledge = acknowledgePledge;
    notifyListeners();
  }
}
