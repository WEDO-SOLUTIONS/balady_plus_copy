import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/widgets/request_parameter.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/data/models/facility.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_details/mvvm/tobacco_details_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_list/mvvm/tobacco_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class TobaccoListItem extends StatelessWidget {
  final Facility facility;

  const TobaccoListItem({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    TobaccoListViewModel provider = context.watch<TobaccoListViewModel>();
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const DrawIconBasedTypeWidget(icon: IconPath.requests),
              const SizedBox(width: 4),
              CustomTextWidget(
                'authenticationـnumber'.tr(),
                textStyle: AppStyle.cardTitleTextStle,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CustomTextWidget(
                  '#${facility.authenticationNumber ?? ''}',
                  textStyle: AppStyle.requestNumberTextStle,
                ),
              ),
              // HomeTag(
              //   title:
              //       (facility.isApproved ? 'disclosed' : 'not_disclosed').tr(),
              //   backgroundColor: facility.isApproved
              //       ? AppColor.success
              //       : AppColor.orange,
              // ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              children: [
                RequestParameter(
                  title: 'certificate_number'.tr(),
                  value: facility.registrationNumber ?? '',
                ),
                RequestParameter(
                  title: 'establsihment_name'.tr(),
                  value: facility.facilityName ?? '',
                ),
                RequestParameter(
                  title: 'license_number'.tr(),
                  value: facility.baladyLicenseNo ?? '',
                ),
                RequestParameter(
                  title: 'health_trining_expiryDate'.tr(),
                  value: facility.createdDate != null
                      ? DateFormat.yMd().format(facility.createdDate!)
                      : '',
                ),
              ],
            ),
          ),
          ElevatedButtonWidget.choose(
            onPressed: () async {
              if (facility.registrationNumber != null &&
                  (CommonProperties.selectedDelegator?.crNumber != null ||
                      CommonProperties.userInfo!.idNo != null)) {
                Navigator.pushNamed(
                  context,
                  CommercialRouteName.tobaccoDetails,
                  arguments: TobaccoDetailsViewModel(
                    provider.repository,
                    CommonProperties.selectedDelegator?.crNumber ??
                        CommonProperties.userInfo!.idNo!,
                    facility.registrationNumber!,
                  ),
                );
              } else {
                CommonFunctions.showError('error_please_try_again_later');
              }
            },
          ),
        ],
      ),
    );
  }
}
