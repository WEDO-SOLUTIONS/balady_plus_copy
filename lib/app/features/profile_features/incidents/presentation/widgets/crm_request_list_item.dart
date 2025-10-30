import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/features/profile_features/requests/domain/entities/crm_request_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:dartz/dartz.dart' show Either, Right, Left;
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, CommonFunctions, IconPath, RouteName;
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../requests/presentation/widgets/request_parameter.dart';
import '../../domain/entities/request_details_page_params.dart';

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  CustomTextWidget(
                    '#${request.getId()}',
                    textStyle: AppStyle.requestNumberTextStle,
                  ),
                ],
              ),
              StatusTag(
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
                (request.getRequestType() != RequestsType.TSR &&
                        request.getRequestType() != RequestsType.REQ)
                    ? RequestParameter(
                        title: 'municipality'.tr(),
                        value: request.municipalityName ?? "",
                      )
                    : Container(),
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
            onPressed: () async {
              final RequestDetailsPageParams params = RequestDetailsPageParams(
                  details: request, type: request.getRequestType());
              switch (request.getRequestType()) {
                case RequestsType.INC:
                  NavigationService.navigatorKey.currentState!
                      .pushNamed(RouteName.IncidentDetails, arguments: params);
                  break;
                case RequestsType.DC:
                  NavigationService.navigatorKey.currentState!
                      .pushNamed(RouteName.DCDetails, arguments: params);
                  break;
                case RequestsType.VHR:
                  NavigationService.navigatorKey.currentState!
                      .pushNamed(RouteName.VHRDetails, arguments: params);
                  break;
                case RequestsType.INQ:
                  NavigationService.navigatorKey.currentState!
                      .pushNamed(RouteName.InqDetails, arguments: params);
                  break;
                case RequestsType.REQ:
                  NavigationService.navigatorKey.currentState!
                      .pushNamed(RouteName.ReqDetails, arguments: params);
                  break;
                case RequestsType.TSR:
                  NavigationService.navigatorKey.currentState!
                      .pushNamed(RouteName.DaemDetails, arguments: params);
                  break;
                case RequestsType.MUN:
                  NavigationService.navigatorKey.currentState!
                      .pushNamed(RouteName.DCDetails, arguments: params);
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}

class StatusTag extends StatelessWidget {
  final String title;
  final Color? color;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final double? height;
  final bool selected;

  const StatusTag({
    super.key,
    required this.title,
    this.color,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.height,
    this.selected = false,
  }) : assert(
            (color == null && backgroundColor != null) ||
                (color != null && backgroundColor == null),
            "can't choose color and backgroundColor at the same time");
  @override
  Widget build(BuildContext context) {
    final backgroundColor = this.backgroundColor ??
        (selected ? color : AppColor.blackModern50Light);
    final textColor = this.textColor ??
        (selected ? AppColor.blackModern50Light : AppColor.blackModern600Light);

    return Flexible(
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 4.0,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomTextWidget(
          title,
          maxLines: 3,
          textStyle: AppStyle.tagStyle.copyWith(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
