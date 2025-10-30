import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, ContextConversion, IconPath, RouteName;
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../invoices_exports.dart' show InvoiceEntity, InvoiceParameter;

class InvoicesListItem extends StatelessWidget {
  final InvoiceEntity invoice;

  const InvoicesListItem({
    super.key,
    required this.invoice,
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
                'invoice'.tr(),
                textStyle: AppStyle.cardTitleTextStle,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CustomTextWidget(
                  '#${invoice.accountNumber}',
                  textStyle: AppStyle.requestNumberTextStle,
                ),
              ),
              HomeTag(
                title: invoice.invoiceStatusName,
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
                InvoiceParameter(
                  title: "license_type".tr(),
                  value: invoice.invoiceTypeName,
                ),
                InvoiceParameter(
                  title: 'invoice_type'.tr(),
                  value: invoice.requestTypeName,
                ),
                InvoiceParameter(
                  title: 'invoice_amount'.tr(),
                  value: '${invoice.amount} ${"sar".tr()}',
                ),
                InvoiceParameter(
                  title: 'request_no'.tr(),
                  value: invoice.requestNumber,
                ),
                InvoiceParameter(
                  title: 'invoice_issue_date'.tr(),
                  value: DateFormat.yMd().format(invoice.creationDate),
                ),
                InvoiceParameter(
                  title: 'invoice_due_date'.tr(),
                  value: DateFormat.yMd().format(invoice.dueDate),
                ),
              ],
            ),
          ),
          ElevatedButtonWidget.details(
            onPressed: () {
              if (invoice.id != null) {
                context.pushNamedRoute(
                  RouteName.invoiceDetails,
                  arguments: {
                    "invoiceId": invoice.id,
                  },
                );
                return;
              } else if (invoice.redirectUrl != null) {
                context.pushNamedRoute(
                  RouteName.inappWebview,
                  arguments: (
                    requestNum: 'invoice'.tr(),
                    url: invoice.redirectUrl,
                    isObjections: false
                  ),
                );
                return;
              }
            },
          ),
        ],
      ),
    );
  }
}
