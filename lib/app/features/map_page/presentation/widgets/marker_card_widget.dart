import 'dart:math';

import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../mvvm/point_view_model.dart';
import 'package:collection/collection.dart';

class MarkerMapWidget extends StatelessWidget {
  final PointViewModel pointViewModel;

  const MarkerMapWidget({super.key, required this.pointViewModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(RouteName.MapDetailsPage, arguments: pointViewModel);
      },
      child: Container(
        height: 300,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Image.network(
                    'https://1000logos.net/wp-content/uploads/2020/10/Costa-Coffee-Logo.png',
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 6,
                child: ValueListenableBuilder<DirectoryObjectMessage?>(
                  valueListenable: pointViewModel.dataPoint,
                  builder: (_, dataPoint, __) {
                    return dataPoint == null
                        ? const SizedBox()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dataPoint?.title ?? "",
                                style: AppStyle.mainTextStyle,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                dataPoint.address?.components
                                        ?.firstWhereOrNull(
                                          (element) =>
                                              element?.streetAddress != null,
                                        )
                                        ?.streetAddress
                                        ?.street ??
                                    'Address',
                                style: AppStyle.serviceDescriptionStyle,
                              ),
                              const CustomVerticalSpace(height: 8),
                              Row(
                                children: [
                                  CustomTextWidget(
                                    "",
                                    textStyle: AppStyle.serviceDescriptionStyle,
                                  ),
                                  CustomTextWidget(
                                    dataPoint?.workStatus?.isOpen == true
                                        ? "open".tr()
                                        : "",
                                    textStyle: AppStyle.serviceDescriptionStyle,
                                  ),
                                ],
                              ),
                              const CustomVerticalSpace(height: 16),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      CustomTextWidget(
                                        "License type",
                                        textStyle: AppStyle
                                            .serviceDescriptionStyle
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      CustomTextWidget(
                                        dataPoint?.tradeLicense?.type ?? "No",
                                        textStyle:
                                            AppStyle.serviceDescriptionStyle,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      CustomTextWidget(
                                        "License",
                                        textStyle: AppStyle
                                            .serviceDescriptionStyle
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      CustomTextWidget(
                                        dataPoint?.tradeLicense?.license ??
                                            "No",
                                        textStyle:
                                            AppStyle.serviceDescriptionStyle,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      CustomTextWidget(
                                        "Legal form",
                                        textStyle: AppStyle
                                            .serviceDescriptionStyle
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      CustomTextWidget(
                                        dataPoint?.tradeLicense?.legalForm ??
                                            "No",
                                        textStyle:
                                            AppStyle.serviceDescriptionStyle,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      CustomTextWidget(
                                        "End date",
                                        textStyle: AppStyle
                                            .serviceDescriptionStyle
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      CustomTextWidget(
                                        dataPoint?.tradeLicense?.endDate ??
                                            "No",
                                        textStyle:
                                            AppStyle.serviceDescriptionStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const CustomVerticalSpace(height: 16),
                              Row(
                                children: [
                                  CustomTextWidget(
                                    "externalIds",
                                    textStyle: AppStyle.serviceDescriptionStyle
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  /* const SizedBox(width: 4),
                                  CustomTextWidget(
                                    dataPoint?.externalIds?.join(" ") ?? "[]",
                                    textStyle: AppStyle.serviceDescriptionStyle,
                                  ),*/
                                ],
                              )
                              /* const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.phone, size: 15),
                                  const SizedBox(width: 6),
                                  Text(
                                    '+9550029202',
                                    style: AppStyle
                                        .personalInfoParameterTitleTextStyle
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )*/
                            ],
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
