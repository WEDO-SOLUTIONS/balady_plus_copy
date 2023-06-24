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
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => FacilityRatingViewModel(),
        builder: (context, child) {
          FacilityRatingViewModel model =
              Provider.of<FacilityRatingViewModel>(context);
          return Scaffold(
            backgroundColor: AppColor.white,
            appBar: DefaultAppBarWidget(
              title: ("review").tr() +
                  " " +
                  facilityDetailsViewModel.getFacilityName(),
            ),
            body: !CommonProperties.isLoggedIn
                ? NeedLoginWidget(
                    title: ('facility_evaluation').tr(),
                    desc: ('need_login_desc_evaluation').tr(),
                    onSuccessLogin: (isSuccess) {
                      if (isSuccess) {
                        model.getUserLatestRating();
                      }
                    },
                  )
                : Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
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
                            )),
                            Container(
                              color: AppColor.white,
                              child: SafeArea(
                                top: false,
                                child: EnhancedCustomElevatedButtonWidget(
                                  btnColor: !model.isFormValid
                                      ? AppColor.black200
                                      : AppColor.darkTurquoise,
                                  btnPressed: !model.isFormValid
                                      ? null
                                      : () {
                                          model.submitRating(
                                              facilityDetailsViewModel
                                                  .getLicenseUuid());
                                        },
                                  btnText: ("review").tr(),
                                  btnTextColor: !model.isFormValid
                                      ? AppColor.black
                                      : AppColor.white,
                                  btnTextSize: 16,
                                  btnTextWeight: AppFontWeight.regular,
                                  btnHeight: 56,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}
