import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath, RouteName;
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../objections_exports.dart'
    show ObjectableTransactionsEntity, RequestParameter;

class RequestsListItem extends StatelessWidget {
  final ObjectableTransactionsEntity request;
  final Function onApply;
  final Function onDetails;
  const RequestsListItem(
      {super.key,
      required this.request,
      required this.onApply,
      required this.onDetails});

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
              CustomTextWidget(
                "transaction_number".tr(),
                textStyle: AppStyle.cardTitleTextStle,
              ),
              const SizedBox(width: 4),
              CustomTextWidget(
                '#${request.transactionNumber}'.tr(),
                textStyle: AppStyle.requestNumberTextStle,
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
                  title: 'transaction_type'.tr(),
                  value: request.serviceName ?? "",
                ),
                RequestParameter(
                  title: 'transaction_last_objection_date'.tr(),
                  value: request.objectionLastApplyDateStr,
                ),
                RequestParameter(
                  title: 'municipality'.tr(),
                  value: request.municipalityName ?? "",
                ),
                RequestParameter(
                  title: 'sub_municipality'.tr(),
                  value: request.subMunicipalityName ?? "",
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                  flex: 10,
                  child: ElevatedButtonWidget.details(
                      onPressed: () => onDetails())),
              if (request.isAllowedForObjection?.toLowerCase() == "true") ...[
                const Expanded(flex: 1, child: CustomVerticalSpace(height: 16)),
                Expanded(
                    flex: 10,
                    child: ElevatedButtonWidget.applyObjection(
                        onPressed: () => onApply())),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
