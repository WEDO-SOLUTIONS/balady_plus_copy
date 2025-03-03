import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/facility_qr/facility_qr_exports.dart'
    show RatingCard;
import 'package:balady_plus/app/features/facility_qr/presentation/core/view_models/facility_rating_viewModel.dart';
import 'package:balady_plus/app/features/facility_qr/presentation/core/view_models/facility_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/need_login_widget.dart';

class FacilityRatingScreen extends StatefulWidget {
  FacilityRatingScreen();

  @override
  _FacilityRatingScreenState createState() => _FacilityRatingScreenState();
}

class _FacilityRatingScreenState extends State<FacilityRatingScreen> {
  final facilityDetailsViewModel = locator<FacilityQRDetailsViewModel>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //MM  Helpers.sendEventToAnalytics(AppEvents.QR_Rating);

    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceYourFeedbackRating);

    CommonFunctions.sendUXCamEvent(UXCamEvents.YourFeedback_Open_Rating_Event);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => FacilityRatingViewModel(),
        builder: (context, child) {
          FacilityRatingViewModel model =
              Provider.of<FacilityRatingViewModel>(context);
          return !CommonProperties.isLoggedInMunicipality
              ? NeedLoginWidget(
                  title: ('facility_evaluation').tr(),
                  desc: ('need_login_desc_evaluation').tr(),
                  onSuccessLogin: (isSuccess) {
                    if (isSuccess) {}
                  },
                )
              : Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.ratingItems.length,
                      physics: const ScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return RatingCard(
                            item: model.ratingItems[index],
                            onChanged: (int rating) {
                              model.ratingItems[index].value = rating;
                              model.validateForm();
                            });
                      },
                    ),
                    EnhancedCustomElevatedButtonWidget(
                      btnColor: !model.isFormValid
                          ? AppColor.black200
                          : AppColor.primary900Light,
                      btnPressed: !model.isFormValid
                          ? null
                          : () {
                              model.submitRating(
                                  facilityDetailsViewModel.getLicenseUuid());
                            },
                      btnText: ("review").tr(),
                      btnTextColor:
                          !model.isFormValid ? AppColor.black : AppColor.white,
                      btnTextSize: 16,
                      btnTextWeight: AppFontWeight.regular,
                      btnHeight: 56,
                    ),
                  ],
                );
        });
  }
}
