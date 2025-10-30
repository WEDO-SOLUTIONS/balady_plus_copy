import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:balady_plus/app/features/profile_features/requests/domain/entities/crm_request_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:dartz/dartz.dart' show Either, Right, Left;

import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/services/local/use_case.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, CommonFunctions, IconPath, RouteName;
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../entry_point/domain/use_cases/get_cookie.dart';
import '../../../../health_certificate/presentation/core/models/health_request_details.dart';
import '../../../../health_certificate/presentation/core/models/health_request_details_screen_args.dart';
import '../../../../health_certificate/presentation/core/services/view_models/main_health_license_view_model.dart';
import '../../../../objectable_transactions/domain/use_cases/get_objection_details.dart';
import '../../requests_exports.dart' show RequestEntity, RequestParameter;

class CRMRequestsListItem extends StatelessWidget {
  final CRMRequestItem request;

  const CRMRequestsListItem({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
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
              /* CustomTextWidget(
                'request'.tr(),
                textStyle: AppStyle.cardTitleTextStle,
              ),
              const SizedBox(width: 4),*/
              Expanded(
                child: CustomTextWidget(
                  '#${request.getId()}',
                  textStyle: AppStyle.requestNumberTextStle,
                ),
              ),
              HomeTag(
                title: request.getStatusSTR(),
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
                  title: 'crm_request_classification'.tr(),
                  value: request.getSplClassificationName(),
                ),
                RequestParameter(
                  title: 'municipality'.tr(),
                  value: request.municipalityName ?? "",
                ),
                /*RequestParameter(
                  title: 'sub_municipality'.tr(),
                  value: request.municipalityName ?? "",
                ),*/
                RequestParameter(
                  title: 'request_date'.tr(),
                  value: request.getCreateDate(),
                ),
              ],
            ),
          ),
          ElevatedButtonWidget.details(
            onPressed: () async {},
          ),
        ],
      ),
    );
  }
}
