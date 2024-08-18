import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_details/mvvm/tobacco_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class DisclosedListWidget extends StatelessWidget {
  const DisclosedListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TobaccoDetailsViewModel provider = context.watch<TobaccoDetailsViewModel>();
    return ExpandableCard(
      title: 'monthsـhaveـbeen_disclosed'.tr(),
      icon: null,
      children: [
        ValueListenableBuilder(
          valueListenable: provider.year,
          builder: (BuildContext context, int? value, Widget? child) {
            return value != null
                ? Column(
                    children: provider.tobaccoSchedule!.disclosures[value]
                            ?.map(
                              (e) => Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                color: AppColor.white2,
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        fit: FlexFit.tight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${'month'.tr()} ${e.month.toString()}',
                                              style: AppStyle.listTitleTextStyle
                                                  .copyWith(),
                                            ),
                                            const SizedBox(height: 16),
                                            e.createdDate != null
                                                ? Text(
                                                    '${'dateـcreated'.tr()} ${DateFormat.yMd().format(e.createdDate!)}',
                                                    style: AppStyle
                                                        .requestNumberTextStle,
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${'sar'.tr()} ${e.totalAmount}',
                                        style: AppStyle.requestNumberTextStle
                                            .copyWith(
                                          color: AppColor.primary800Light,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList() ??
                        [],
                  )
                : const SizedBox();
          },
        ),
      ],
    );
  }
}
