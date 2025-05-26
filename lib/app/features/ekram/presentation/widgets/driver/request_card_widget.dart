import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/driver_identical_bloc/identical_list_bloc.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_buttons_widgets.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/services/local/location_service.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../home_page/presentation/widgets/home_tag.dart';
import '../../../../objectable_transactions/presentation/widgets/request_parameter.dart';
import '../../../data/model/driver/transport_request_item_model.dart';
import '../../../domain/entities/deceased_transport_requests/transport_request_item.dart';
import '../ekram_status_widget.dart';

class RequestCardWidget extends StatelessWidget {
  final TransportRequestItemModel requestItemModel;

  const RequestCardWidget({
    Key? key,
    required this.requestItemModel,
  }) : super(key: key);

  @override
  void dispose() {
  //  sl<EkramLocationService>().stop();

  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigatorState navigator = Navigator.of(context);

        navigator.pushNamed(RouteName.IdenticalListPage,
            arguments: requestItemModel);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
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
                CustomHorizontalSpace(
                  width: 4,
                ),
                Expanded(
                  child: CustomTextWidget(
                    '#${requestItemModel.requestId.toString()}',
                    textStyle: AppStyle.requestNumberTextStle,
                    textAlign: TextAlign.start,
                  ),
                ),
                HomeTag(
                  title: requestItemModel.requestStatusName ?? "",
                  backgroundColor: AppColor.secondary100Light,
                ),
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
                    title: 'deceasedName'.tr(),
                    value: requestItemModel.deceasedName ?? "",
                  ),
                  // RequestParameter(
                  //   title: 'transportationType'.tr(),
                  //   value: ekramTransportationItem.getCityType() ?? "",
                  // ),
                  RequestParameter(
                    title: 'burialCity'.tr(),
                    value: requestItemModel.deathCityName ?? "",
                  ),

                  RequestParameter(
                    title: 'driver_card_applicant_date'.tr(),
                    value: CommonFunctions.getFormattedDateEkramCard(
                        requestItemModel.requestDate ?? ""),
                  ),
                  RequestParameter(
                    title: 'ekram_assign_Date'.tr(),
                    value: CommonFunctions.getFormattedDateEkramCard(
                        requestItemModel.assignDriverDate ?? ""),
                  ),
                  // RequestParameter(
                  //   title: 'transportationDestination'.tr(),
                  //   value: ekramTransportationItem.currentStationName ?? "",
                  // ),

                  RequestParameter(
                    title: 'transportationStatus'.tr(),
                    value: requestItemModel.transportCaseName ?? "",
                  ),
                ],
              ),
            ),
            ElevatedButtonWidget.primaryCustom(
                height: 40,
                onPressed: () {


                  sl<EkramLocationService>().start(requestItemModel.requestId!);
                  NavigationService.navigatorKey.currentState!.pushNamed(
                    RouteName.IdenticalListPage,
                    arguments: requestItemModel,
                  );

                  sl<IdenticalListBloc>().add(
                    GetIdenticalListRequestEvent(
                      requestId: requestItemModel.requestId!,
                    ),
                  );

                },
                text: "register_trip_details".tr())
          ],
        ),
      ),
    );
  }
}


