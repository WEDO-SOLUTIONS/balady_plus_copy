import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath, RouteName;
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../objections_exports.dart' show ObjectionEntity, RequestParameter;

class RequestsListItem extends StatelessWidget {
  final ObjectionEntity request;
  final Function onPress;

  const RequestsListItem(
      {super.key, required this.request, required this.onPress});

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
              CustomHorizontalSpace(
                width: 4,
              ),
              Expanded(
                child: CustomTextWidget(
                  '#${request.objectionRequestNumber}'.tr(),
                  textStyle: AppStyle.requestNumberTextStle,
                  textAlign: TextAlign.start,
                ),
              ),
              HomeTag(
                title: request.requestStatusName ?? "",
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
                  title: 'objection_transaction'.tr(),
                  value: request.objectionTypeName ?? "",
                ),
                Container(),
                RequestParameter(
                  title: 'municipality'.tr(),
                  value: request.municipalityName ?? "",
                ),
                RequestParameter(
                  title: 'sub_municipality'.tr(),
                  value: request.subMunicipalityName ?? "",
                ),
                RequestParameter(
                  title: 'request_date'.tr(),
                  value: request.createDateStr,
                ),
                RequestParameter(
                  title: 'last_update'.tr(),
                  value: request.lastUpdateStr,
                ),
              ],
            ),
          ),
          ElevatedButtonWidget.details(onPressed: () => onPress()),
        ],
      ),
    );
  }
}
