import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../invoices_exports.dart' show InvoiceEntity, InvoiceParameter;

class InvoicesListItem extends StatelessWidget {
  final InvoiceEntity request;

  const InvoicesListItem({
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
              const DrawIconBasedTypeWidget(icon: IconPath.invoices),
              const SizedBox(width: 4),
              CustomTextWidget(
                'invoice'.tr(),
                textStyle: AppStyle.cardTitleTextStle,
              ),
              const SizedBox(width: 4),
              // Expanded(
              //   child: CustomTextWidget(
              //     '#${request.requestNumber}'.tr(),
              //     textStyle: AppStyle.requestNumberTextStle,
              //   ),
              // ),
              const Spacer(),
              HomeTag(
                title: request.invoiceStatusName,
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
                  title: 'invoice_type'.tr(),
                  value: request.invoiceTypeName,
                ),
                InvoiceParameter(
                  title: 'request_type'.tr(),
                  value: request.requestTypeName,
                ),
                InvoiceParameter(
                  title: 'munipality'.tr(),
                  value: request.municipalityName,
                ),
                InvoiceParameter(
                  title: 'invoice_amount'.tr(),
                  value: '${request.amount} ${"sar".tr()}',
                ),
                InvoiceParameter(
                  title: 'request_no'.tr(),
                  value: '${request.requestNumber}',
                ),
                InvoiceParameter(
                  title: 'creation_date'.tr(),
                  value: DateFormat.yMd().format(request.creationDate),
                ),
                InvoiceParameter(
                  title: 'last_update'.tr(),
                  value: DateFormat.yMd().format(request.updatedDate),
                ),
              ],
            ),
          ),
          ElevatedButtonWidget.details(onPressed: () {}),
        ],
      ),
    );
  }
}
