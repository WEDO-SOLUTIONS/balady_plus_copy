import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/widgets/debts_parameter.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';

class DebtsListItem extends StatelessWidget {
  final Debt debt;

  const DebtsListItem({super.key, required this.debt});

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
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 3.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 40),
              children: [
                DebtsParameter(
                  title: "invoice_no".tr(),
                  value: debt.number,
                ),
                DebtsParameter(
                  title: 'invoice_date'.tr(),
                  value: DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(debt.creationDate)),
                ),
                DebtsParameter(
                  title: 'invoice_amount'.tr(),
                  value: '${debt.amount} ${'sar'.tr()}',
                ),
                DebtsParameter(
                  title: 'invoice_service'.tr(),
                  value: debt.service?.name ?? "",
                ),
                DebtsParameter(
                  title: 'debt_origin'.tr(),
                  value: debt.source,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
