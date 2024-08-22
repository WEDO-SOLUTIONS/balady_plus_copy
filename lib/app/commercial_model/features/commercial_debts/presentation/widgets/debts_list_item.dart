import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/widgets/debts_parameter.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, ContextConversion, IconPath, RouteName;
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';

class DebtsListItem extends StatelessWidget {

  const DebtsListItem({
    super.key,
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
              const DrawIconBasedTypeWidget(icon: IconPath.invoices),
              const SizedBox(width: 4),
              CustomTextWidget(
                'debt'.tr(),
                textStyle: AppStyle.cardTitleTextStle,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CustomTextWidget(
                  '#',
                  textStyle: AppStyle.requestNumberTextStle,
                ),
              ),
              HomeTag(
                title: 'invoice.invoiceStatusName',
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
                DebtsParameter(
                  title: "invoice_no".tr(),
                  value: '',
                ),
                DebtsParameter(
                  title: 'invoice_date'.tr(),
                  value: '',
                ),
                DebtsParameter(
                  title: 'invoice_amount'.tr(),
                  value: '',
                ),
                DebtsParameter(
                  title: 'invoice_service'.tr(),
                  value: '',
                ),
                DebtsParameter(
                  title: 'debt_origin'.tr(),
                  value: '',
                ),
         
              ],
            ),
          ),
          ElevatedButtonWidget.details(
            onPressed: (){},
          ),
        ],
      ),
    );
  }
}
