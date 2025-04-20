import 'package:balady_plus/app/core/utils/routes_type.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, CommonFunctions, IconPath, RouteName;
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../requests_exports.dart' show RequestEntity, RequestParameter;

class RequestsListItem extends StatelessWidget {
  final RequestEntity request;

  const RequestsListItem({super.key, required this.request});

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
                'request'.tr(),
                textStyle: AppStyle.cardTitleTextStle,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CustomTextWidget(
                  '#${request.requestNumberAsText}',
                  textStyle: AppStyle.requestNumberTextStle,
                ),
              ),
              HomeTag(
                title: request.requestStatusName,
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
                  title: 'request_type'.tr(),
                  value: request.requestTypeName,
                ),
                RequestParameter(
                  title: 'license_type'.tr(),
                  value: request.licenseTypeName,
                ),
                RequestParameter(
                  title: 'municipality'.tr(),
                  value: request.municipalityName,
                ),
                RequestParameter(
                  title: 'sub_municipality'.tr(),
                  value: request.subMunicipalityName,
                ),
                RequestParameter(
                  title: 'request_date'.tr(),
                  value: DateFormat.yMd().format(request.creationDate),
                ),
                RequestParameter(
                  title: 'last_update'.tr(),
                  value: DateFormat.yMd().format(request.lastUpdateDate),
                ),
              ],
            ),
          ),
          ElevatedButtonWidget.details(
            onPressed: () async {
              String routeName = getScreenName(
                ScreenTage.request.name,
                // all request of health license open in one screen this reason
                // to send requestMainTypeId if 1300 -> health license
                typeId: request.requestTypeId,
              );
              if (RouteName.inappWebview == routeName) {
                CommonFunctions.openBaldyWithRefreshCookie(
                  request.redirectUrl,
                );
              } else {

                NavigationService.navigatorKey.currentState!.pushNamed(
                  routeName,
                  arguments: {
                    "requestNumber": request.requestNumber.toString(),
                    "objectionRequestNumber":
                        request.requestNumberAsText.toString(),
                    "redirectUrl": request.redirectUrl,
                    "hashingRequestNumber":request.hashingRequestNumber
                  },
                );
              }
              ///////////////////////////////////////////////
              if (request.requestMainTypeId == "1300") {
                CommonFunctions.sendUXCamEvent(
                  UXCamEvents.detailsServiceHealthCertificate,
                );
              } else if (request.requestTypeId == 1130) {
                CommonFunctions.sendUXCamEvent(
                  UXCamEvents.detailsServiceComplianceCertificate,
                );
              }

              // else if (request.requestTypeId == 1008 ||
              //     request.requestTypeId == 1005 ||
              //     request.requestTypeId == 1004) {
              // } else if (request.requestTypeId == 1042 ||
              //     request.requestTypeId == 1043) {
              // } else if (request.requestTypeId == 1028) {
              // } else if (request.requestTypeId == 1026) {
              // } else {}
            },
          ),
        ],
      ),
    );
  }
}
