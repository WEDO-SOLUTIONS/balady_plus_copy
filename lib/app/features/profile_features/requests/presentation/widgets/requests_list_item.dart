import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:balady_plus/app/features/request_commercial_license_details/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/features/request_commercial_license_details/data/repositories/repository_implementation.dart';
import 'package:balady_plus/app/features/request_commercial_license_details/domain/use_cases/get_request_commercial_license_details.dart';
import 'package:balady_plus/app/features/request_commercial_license_details/presentation/bloc/request_commercial_license_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:dartz/dartz.dart' show Either, Right, Left;

import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/services/local/use_case.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, CommonFunctions, IconPath, RouteName;
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../create_compliance/domain/use_cases/get_compliance_details.dart';
import '../../../../entry_point/domain/use_cases/get_cookie.dart';
import '../../../../health_certificate/presentation/core/models/health_request_details.dart';
import '../../../../health_certificate/presentation/core/models/health_request_details_screen_args.dart';
import '../../../../health_certificate/presentation/core/services/view_models/main_health_license_view_model.dart';
import '../../../../objectable_transactions/domain/use_cases/get_objection_details.dart';
import '../../requests_exports.dart' show RequestEntity, RequestParameter;

class RequestsListItem extends StatelessWidget {
  final RequestEntity request;

  const RequestsListItem({
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
              if (request.requestMainTypeId == "1300") {
                final model = locator<MainHealthLicenseViewModel>();

                HealthRequestDetails? details =
                    await model.getHealthRequestDetails(request.requestNumber);
                if (details != null) {
                  NavigationService.navigatorKey.currentState!.pushNamed(
                      RouteName.healthRequestDetailsScreen,
                      arguments: HealthRequestDetailsScreenArgs(
                          healthRequestDetails: details,
                          isDeletable: false,
                          isPrintable: false));
                }
              } else if (request.requestTypeId == 1130) {
                /*  Navigator.pushNamed(context, RouteName.complianceDetailsPage,
                    arguments: (
                      request.requestNumber.toString(),
                      request.redirectUrl
                    ));*/
                EasyLoading.show();
                final getComplicanceDetails =
                    GetComplianceByRequestId(repository: sl());

                final details = await getComplicanceDetails(
                    request.requestNumber.toString());
                EasyLoading.dismiss();

                details.fold((l) {
                  CommonFunctions.showError((l as ServerFailure).errorMessage);
                }, (r) {
                  if (r.submitterThrough == "BENEFICARY") {
                    Navigator.pushNamed(
                        context, RouteName.complianceDetailsPage, arguments: (
                      request.requestNumber.toString(),
                      request.redirectUrl
                    ));
                  } else {
                    CommonFunctions.openBaldyWithRefreshCookie(
                        request.redirectUrl);
                  }
                });
              } else if (request.requestTypeId == 1003) {
                Navigator.pushNamed(
                  context,
                  RouteName.commercialLicenseDetails,
                  arguments: RequestCommercialLicenseDetailsCubit(
                    GetRequestCommercialLicenseDetails(
                      repository:
                          RequestCommercialLicenseDetailsRepositoryImplementation(
                        remoteDataSource:
                            RequestCommercialLicenseDetailsRemoteDataSourceImplementation(
                          webService: sl(),
                        ),
                      ),
                    ),
                    request.requestNumber,
                  ),
                );
              } else {
                if (request.redirectUrl == null) {
                  if (request.requestTypeId == 50001) {
                    EasyLoading.show();
                    GetObjectionDetails getObjectionDetails =
                        GetObjectionDetails(repository: sl());
                    var failureOrSuccess =
                        await getObjectionDetails(request.requestNumberAsText);

                    await failureOrSuccess.fold((failure) {
                      EasyLoading.dismiss();
                    }, (success) async {
                      EasyLoading.dismiss();
                      NavigationService.navigatorKey.currentState!.pushNamed(
                          RouteName.objectionsDetailsPage,
                          arguments: success);
                    });
                    return;
                  }
                } else {
                  CommonFunctions.openBaldyWithRefreshCookie(
                      request.redirectUrl);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
