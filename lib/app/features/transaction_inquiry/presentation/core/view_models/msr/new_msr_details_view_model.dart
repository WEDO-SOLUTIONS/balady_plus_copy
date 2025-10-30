import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:collection/collection.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../models/attachment_model.dart';
import '../../models/classification.dart';
import '../../models/gis_location_result.dart';
import '../../models/selected_location.dart';
import '../../services/customer_voice_repository.dart';
import 'new_msr_view_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class NewMSRDetailsViewModel extends BaseViewModel {
  final _repositry = locator<CustomerVoiceRepository>();
  final dataModel = locator<NewMSRViewModel>();

  FileDataItem? file;

  SpecializedClassification? get splClassifications =>
      dataModel.splClassifications;

  List<DropDownItem> get splTypeList => dataModel.splTypeList;

  DropDownItem? get splType => dataModel.splType;

  set splType(DropDownItem? data) {
    SpecializedClassificationItem? e = splClassifications?.splClassificationList
        ?.firstWhereOrNull((element) => element.id == data?.id);

    if (e != null) {
      dataModel.splType = data;
      dataModel.selectedSplItem = e;
    }
  }

  List<DropDownItem> get splBusinessTypeList => dataModel.splBusinessTypeList;

  DropDownItem? get splBusinessType => dataModel.splBusinessType;

  set splBusinessType(DropDownItem? data) {
    SplBusinessType? e = selectedSplDetails?.splBusinessType
        ?.firstWhereOrNull((element) => element.ID == data?.id);

    if (e != null) {
      dataModel.splBusinessType = data;
      dataModel.selectedSplBusinessItem = e;
    }
  }

  String? get splDescription => dataModel.splDescription;

  set splDescription(String? data) => dataModel.splDescription = data;

  bool get hideSplBuisnessField => dataModel.hideSplBuisnessField;

  set hideSplBuisnessField(bool data) => dataModel.hideSplBuisnessField = data;

  set selectedSplDetails(SubMainClassification? data) =>
      dataModel.selectedSplDetails = data;

  SubMainClassification? get selectedSplDetails => dataModel.selectedSplDetails;

  SpecializedClassificationItem? get selectedSplItem =>
      dataModel.selectedSplItem;

  SplBusinessType? get selectedSplBusinessItem =>
      dataModel.selectedSplBusinessItem;

  set selectedSplBusinessItem(SplBusinessType? data) =>
      dataModel.selectedSplBusinessItem = data;

  String? get desc => dataModel.desc;

  set desc(String? data) => dataModel.desc = data;

  List<AttachmentData> get attachments => dataModel.attachments;

  set attachments(List<AttachmentData> data) => dataModel.attachments = data;

  SelectedLocation get selectedLocation => dataModel.selectedLocation;

  GisLocationResult? get gisLocation => dataModel.gisLocation;

  bool get isFormValid => dataModel.isFormValid;

  set isFormValid(bool data) => dataModel.isFormValid = data;

// Form

  Future<bool> getSPLDetails(DropDownItem splType) async {
    showLoading();
    final SubMainClassification? response =
        await _repositry.getMSRSPlDetails(splType.id!);
    hideLoading();
    if (response != null &&
        response.MainClassificationID != null &&
        response.MainClassificationID!.isNotEmpty) {
      selectedSplBusinessItem = null;
      splDescription = null;
      selectedSplDetails = response;

      this.splType = splType;
      setSPLBusinessTypeIfOnlyOne();
      attachments = [];

      selectedSplDetails?.attachmentList?.forEach((element) {
        attachments.add(AttachmentData(
            isRequired: element.pyRequired ?? false,
            title: element.name ?? "",
            isUploaded: false,
            memo: "",
            id: element.ID ?? ""));
      });
      notifyListeners();
      validateForm();

      return true;
    } else {
      // show Error
      // showError("error3");
      showError(("server_error_1").tr());

      return false;
    }
  }

  void setFile(FileDataItem? file) {
    this.file = file;
    notifyListeners();
  }

  void submit() async {
    isLoading = true;
    notifyListeners();
    await dataModel.submitRequest(file);
    isLoading = false;
    notifyListeners();

  }

  validateForm() {
    try {
      bool isvalid = false;
      if (selectedSplItem != null &&
          selectedSplDetails != null &&
          desc != null &&
          desc!.isNotEmpty) {
        isvalid = true;
      } else {
        isvalid = false;
      }
      /* if (showSPLBuisinessTypeOption() && selectedSplBusinessItem == null) {
        isvalid = false;
      }*/

      if (selectedSplItem != null &&
          selectedSplItem?.name == "أخرى" &&
          (splDescription?.isEmpty ?? false)) {
        isvalid = false;
      }

      if (!CommonFunctions.doesContainsLettrs(desc ?? "")) {
        isvalid = false;
      }

      for (var item in attachments) {
        if (item.isRequired && item.filePath == null) {
          isvalid = false;
        }
      }

      if (isFormValid != isvalid) {
        isFormValid = isvalid;
        notifyListeners();
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
  }

  bool showSPLBuisinessTypeOption() {
    return (selectedSplDetails != null &&
            selectedSplDetails?.Specialclassflag != null &&
            (selectedSplDetails!.Specialclassflag == "B" ||
                selectedSplDetails!.Specialclassflag == "C"))
        ? true
        : false;
  }

  bool showSPLDescription() {
    return selectedSplItem != null &&
            selectedSplItem?.name != null &&
            selectedSplItem?.name == "أخرى"
        ? true
        : false;
  }

  void setSPLBusinessTypeIfOnlyOne() {
    try {
      if (showSPLBuisinessTypeOption() &&
          selectedSplDetails?.splBusinessType != null &&
          selectedSplDetails?.splBusinessType?.length == 1) {
        selectedSplBusinessItem = selectedSplDetails?.splBusinessType?[0];
        hideSplBuisnessField = true;
      } else {
        hideSplBuisnessField = false;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      hideSplBuisnessField = false;
    }
  }
}
