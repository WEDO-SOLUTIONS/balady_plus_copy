import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, DateTimeExtension;
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DropDownWithTitle;
import '../../../invoices_exports.dart'
    show InvoiceDateSelectedEvent, InvoicesBloc, InvoicesState;

class InvoicesDateFilter extends StatelessWidget {
  const InvoicesDateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicesBloc, InvoicesState>(
      buildWhen: (previous, current) =>
          previous.selectedInvoiceDate != current.selectedInvoiceDate,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            CustomTextWidget(
              "date_form".tr(),
              textStyle: AppStyle.dropDownTitleTextStle,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColor.primary50Light50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Radio(
                            value: 0,
                            groupValue: 1,
                            onChanged: (_) {},
                          ),
                          CustomTextWidget(
                            "hijri".tr(),
                            textStyle: AppStyle.dropDownValueTextStle,
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColor.primary50Light50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: 1,
                            activeColor: AppColor.primary700Light,
                            onChanged: (_) {},
                          ),
                          CustomTextWidget(
                            "gregorian".tr(),
                            textStyle: AppStyle.dropDownValueTextStle,
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            DropDownWithTitle(
              title: "invoice_date".tr(),
              selectedValue: state.selectedInvoiceDate?.toFormattedDate(),
              onTap: () async {
                //Show a date picker
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2021),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null && context.mounted) {
                  context.read<InvoicesBloc>().add(
                        InvoiceDateSelectedEvent(
                          date: selectedDate,
                        ),
                      );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
