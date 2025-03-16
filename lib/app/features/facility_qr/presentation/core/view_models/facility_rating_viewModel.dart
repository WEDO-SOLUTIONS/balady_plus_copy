import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_popups_widgets.dart';

import 'package:balady_plus/app/features/facility_qr/data/latest_user_rating_response.dart';
import 'package:balady_plus/app/features/facility_qr/data/license_ratings_items.dart';
import 'package:balady_plus/app/features/facility_qr/data/submit_rating_response.dart';
import 'package:balady_plus/app/features/facility_qr/presentation/core/repository/facility_qr_repository.dart';
import 'package:balady_plus/app/features/facility_qr/presentation/core/view_models/facility_details_view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:tuple/tuple.dart';

import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../dialogs/success_rating.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class FacilityRatingViewModel extends BaseViewModel {
  FacilityRatingViewModel() {
    getUserLatestRating();
  }
  bool isFormValid = false;
  final facilityDataModel = locator<FacilityQRDetailsViewModel>();

  List<RatingItem> get ratingItems => facilityDataModel.ratingItems;
  set ratingItems(List<RatingItem> items) =>
      facilityDataModel.ratingItems = items;

  final _repositry = FacilityQRRepository();

  // LatestUserRatingResponse prevoiusUserRating;
  //LicenseRatingItems? ratingsData;
  SubmitRatingResponse? submitRatingData;
  LatestUserRatingResponse? prevoiusUserRating;

  final facilityQRViewModel = locator<FacilityQRDetailsViewModel>();
  void getUserLatestRating() async {
    String licenseId = locator<FacilityQRDetailsViewModel>().getLicenseUuid();
    await getRatingsData();

    if (!CommonProperties.isLoggedInMunicipality) return;

    try {
      showLoading();
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

    try {
      final LatestUserRatingResponse? response =
          await _repositry.getUserLatestRating(licenseId);

      if (response != null) {
        prevoiusUserRating = response;
        setPreviousRatings();

        notifyListeners();
      } else {
        // show Error
        //showError("error3");
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
    hideLoading();
  }

  Future<bool> getRatingsData() async {
    if (ratingItems.isNotEmpty) return true;
    try {
      showLoading();

      final Tuple3<bool?, String?, LicenseRatingItems?> response =
          await _repositry.getLicenseRatingitems();

      hideLoading();

      if (response.item3 != null && response.item1 == true) {
        // ratingsData = response;
        ratingItems = response.item3?.data?.result ?? [];
        // setPreviousRatings();
        notifyListeners();
        return true;
      } else {
        // show Error
        showError(response.item2 ?? "");
        return false;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      hideLoading();
      return false;
    }
  }

  void submitRating(String licenseId) async {
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.YourFeedback_Submit_Rating_Event);
    showLoading();
    final Tuple3<bool?, String?, SubmitRatingResponse?> response =
        await _repositry.postLicenseRatingitems(licenseId, ratingItems);
    hideLoading();

    if (response.item3 != null && response.item1 == true) {
      submitRatingData = response.item3;
      // navigation.currentState!.pushReplacementNamed(RouteName.successRoute,
      //     arguments: SuccessScreenArgs(type: PAGE_TYPE.ratingScreen));
      navigation.currentState?.pop();
      BottomSheetDialog.showDraggableSheet(navigation.currentContext!,
          isFullHeight: false,
          dialogKeyName: DialogName.qrRatingSuccessDialog,
          currentRouteName: DialogName.qrRatingDialog,
          height: 400,
          child: SuccessRatingDialog(
            title: ("send_evaluation").tr(),
            desc: ("rating_success_message").tr(),
          ));
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.YourFeedback_Success_Rating_Event);
      facilityQRViewModel.getFacilityData(licenseId, showLoader: false); //MM

      CommonFunctions.sendUXCamEvent(
          UXCamEvents.finishServiceYourFeedbackRating);
    } else {
      showError(response.item2 ?? "");
    }
  }

  void validateForm() {
    bool isValid = true;

    ratingItems.forEach((element) {
      if (element.value == null || element.value == 0) {
        isValid = false;
      }
    });

    if (isValid != isFormValid) {
      isFormValid = isValid;
      notifyListeners();
    }
  }

  void setPreviousRatings() {
    if (prevoiusUserRating != null &&
        prevoiusUserRating!.data?.result?.ratingDetils != null &&
        ratingItems.isNotEmpty) {
      prevoiusUserRating!.data!.result!.ratingDetils!.forEach((element) {
        int index =
            ratingItems.indexWhere((rating) => rating.id == element.key);

        if (index != -1 && element.value != null) {
          ratingItems[index].value = element.value;
        }
      });
    }
    notifyListeners();
  }

  void reset() {
    ratingItems = ratingItems.map((e) {
      e.value = null;
      return e;
    }).toList();
    isFormValid = false;
    submitRatingData = null;
    prevoiusUserRating = null;
  }
}
