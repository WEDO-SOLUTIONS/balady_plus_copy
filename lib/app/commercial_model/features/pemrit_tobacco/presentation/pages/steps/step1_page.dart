import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../../features/_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/undertaking_widget.dart';
import '../../../../commercial_license_cancel/presentation/commercial_license_cancel/widgets/widget_title_invoice.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/summery_widgets/field_data.dart';
import '../../../data/models/permit_request_details_model.dart';
import '../../widgets/hotel_selection.dart';
import '../../widgets/license_widgets/license_item_widget.dart';
import '../../widgets/previous_next_button.dart';
import 'package:collection/collection.dart';

import '../../../../../../features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../commercial_license/presentation/step3/widgets/map_widgets/cr_header_desc_widget.dart';
import '../../blocs/permit_tobacco_bloc.dart';

class PermitStep1Page extends StatefulWidget {
  const PermitStep1Page({super.key});

  @override
  State<PermitStep1Page> createState() => _PermitStep1PageState();
}

class _PermitStep1PageState extends State<PermitStep1Page> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermitTobaccoLicenseBloc, PermitTobaccoLicenseState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 24, left: 16, right: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.commercialLicenceDetails != null)
                      VdHeaderDesc(
                        header: ("permit_tobacco_license_details").tr(),
                      ),
                    //const Step1SummeryWidget(),
                    const CustomVerticalSpace(height: 16),
                    const Step2SummeryWidget(),
                    const CustomVerticalSpace(height: 16),

                    const CustomVerticalSpace(height: 250),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: AppColor.white,
                child: PostersPreviousNextButtons(
                  isBtnDisabled: !state.isStep1Valid(),
                ),
              ),
            ),
            if (state.status.isSubmissionLoading)
              const CustomCircularLoadingWidget(),
          ],
        );
      },
    );
  }
}

class Step2SummeryWidget extends StatelessWidget {
  const Step2SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermitTobaccoLicenseBloc, PermitTobaccoLicenseState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.commercialLicenceDetails != null) ...[
              FieldData(
                title: "license_no".tr(),
                subTitle: state.commercialLicenceDetails?.licenseInfo?.licenseId
                        .toString() ??
                    "",
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: "license_status".tr(),
                subTitle: state
                        .commercialLicenceDetails?.licenseInfo?.statusDesc
                        .toString() ??
                    "",
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: "license_end_date".tr(),
                subTitle: state
                        .commercialLicenceDetails?.licenseInfo?.licenseEndDate
                        .toString() ??
                    "",
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: "municipality".tr(),
                subTitle: state.commercialLicenceDetails?.locationInfo
                        ?.municipalityName
                        .toString() ??
                    "",
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: "sub_municipality".tr(),
                subTitle: state.commercialLicenceDetails?.locationInfo
                        ?.subMunicipalityName
                        .toString() ??
                    "",
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              /* FieldData(
              title: "license_health_end_date".tr(),
              subTitle: state
                      .commercialLicenceDetails?.licenseInfo?.licenseEndDate
                      .toString() ??
                  "",
            ),
            const CustomVerticalSpace(
              height: 16,
            ),*/
              FieldData(
                  title: "permit_need_baladiyah".tr(),
                  subTitle:
                      state.doesNotNeedsCredentials() ? "no".tr() : "yes".tr()),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                  title: "permit_needs_fees".tr(),
                  subTitle: state.needsFees() == true ? "yes".tr() : "no".tr()),
              const CustomVerticalSpace(
                height: 16,
              ),
            ],
            const CustomVerticalSpace(
              height: 16,
            ),
            const HotelSelectionWidget(),
            const CustomVerticalSpace(
              height: 16,
            ),
            if (state.isInsideHotel == true) ...[
              CustomTextFieldWidget(
                controller: context
                    .read<PermitTobaccoLicenseBloc>()
                    .hotelLicenseContrller,
                label: "hotel_license_number".tr(),
                onChanged: (String? val) {
                  context
                      .read<PermitTobaccoLicenseBloc>()
                      .add(ChangeHotelLicenseNumber(value: val));
                },
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              ElevatedButtonWidget.verify(
                  text:
                      (state.permitTobaccoValidateHotelLicenseResponse != null)
                          ? "done_check".tr()
                          : "verify".tr(),
                  onPressed: () {
                    context
                        .read<PermitTobaccoLicenseBloc>()
                        .add(ValidateTobaccoHotelEvent());
                  }),
              const CustomVerticalSpace(
                height: 16,
              ),
            ],
            if (state.permitTobaccoValidateHotelLicenseResponse != null) ...[
              FieldData(
                  title: "hotel_name".tr(),
                  subTitle: state
                      .permitTobaccoValidateHotelLicenseResponse?.hotelName),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                  title: "hotel_class".tr(),
                  subTitle: state.permitTobaccoValidateHotelLicenseResponse
                      ?.hotelClass?.name
                      .toString()),
            ]
          ],
        );
      },
    );
  }
}
