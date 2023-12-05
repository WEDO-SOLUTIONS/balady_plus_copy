import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../objectable_transactions/presentation/widgets/request_parameter.dart';
import '../../../data/models/find_cemetry_response_model.dart';
import '../../../data/models/orgnization_charity_list.dart';

class OrgnizationDetailsItemWidget extends StatelessWidget {
  final EkramCharityOrgnizationItem item;
  const OrgnizationDetailsItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
        bottom: 8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
      ),
      child: Column(
        children: [
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
                  title: 'city'.tr(),
                  value: item.cityName ?? "",
                ),
                RequestParameter(
                  title: 'ekram_transportation_name'.tr(),
                  value: item.orgName ?? "",
                ),
                RequestParameter(
                  title: 'district'.tr(),
                  value: item.districtName ?? "",
                ),
                RequestParameter(
                  title: 'street'.tr(),
                  value: item.streetName ?? "",
                ),
              ],
            ),
          ),
          ElevatedButtonWidget.primaryCustom(
              onPressed: () {
                NavigationService.navigatorKey.currentState!.pushNamed(
                    RouteName.EkramInquiryOrgnizationsResultsDetailsPage,
                    arguments: item);
              },
              text: "details".tr())
        ],
      ),
    );
  }
}
