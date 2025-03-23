import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/request_details/presentation/pages/replyWithNotes.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/request_details/presentation/widgets/RequestDetailsBody.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/objectable_transactions_params.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/use_cases/get_objection_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../../core/utils/EncryptionHelper.dart';
import '../../../../../../../core/utils/common_functions.dart';
import '../../../../../../../core/utils/constants/app_style.dart';
import '../../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../../core/utils/constants/remote_config.dart';
import '../../../../../../../core/utils/constants/route_names.dart';
import '../../../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../../../../../features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../../../../features/objectable_transactions/domain/entities/create_objection_page_params.dart';
import '../../../../../../commercial_routes/commercial_route_names.dart';
import '../../../../domain/use_cases/step1_License_export_apply.dart';
import '../../../export_commercial_license/license_export_intiation/blocs/commercial_license_export_bloc.dart';
import '../../bloc/commercial_license_details_bloc.dart';

class RequestDetailsPage extends StatelessWidget {
  RequestDetailsPage({super.key});

  CommercialLicenseDetailsBloc? bloc;
  String? hashingRequestNumber;

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    hashingRequestNumber = data["hashingRequestNumber"];
    return BlocProvider(
      create: (context) {

        bloc = CommercialLicenseDetailsBloc(int.parse(data['requestNumber']));
        return bloc!;
      },
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: '${"request".tr()} #${data['requestNumber']}',
          actions: [
            BlocBuilder<CommercialLicenseDetailsBloc,
                CommercialLicenseDetailsState>(
              builder: (_, state) {
                // if (state.status == BlocStatus.loading) {
                //   return Center(child: CustomCircularLoadingWidget());
                //   // return const Padding(
                //   //   padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                //   //   child: ShimmerEffectWidget(
                //   //     width: 40,
                //   //     height: 30,
                //   //     borderRadius: 25,
                //   //   ),
                //   // );
                // }
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: InkWell(
                    onTap: () {
                      BottomSheetDialog.showDraggableSheet(
                        context,
                        dialogKeyName: DialogName
                            .requestCommercialLicenseActionSheetDialog,
                        currentRouteName:
                            CommercialRouteName.requestCommercialLicenseDetails,
                        child: BottomSheetWithActions(
                          title: "procedures".tr(),
                          body: state.requestDetails?.allowedActions != null &&
                                  state.requestDetails?.allowedActions!
                                          .isNotEmpty ==
                                      true
                              ? Column(
                                  children: state
                                      .requestDetails!.allowedActions!
                                      .map(
                                        (action) => InkWell(
                                          onTap: () {
                                            switch (action.id) {
                                              case "complete-request" || "edit":
                                                Navigator.of(context).pushNamed(
                                                  CommercialRouteName
                                                      .CommercialLicenseInitialApprovelScreen,
                                                  arguments: state.requestId,
                                                );
                                                break;
                                              case "apply-commercial-issuing-request":
                                                {


                                                  LicenseExportApply  _LicenseExportApply = LicenseExportApply(repository: sl());
                                                  _LicenseExportApply(state.requestId!).then((response){

                                                    response.fold(
                                                            (failure) {

                                                          CommonFunctions.showError(failure.toString());

                                                        }

                                                        , (res) {


                                                      Navigator.of(context)
                                                          .pushNamed(
                                                        CommercialRouteName.LicenseExportStartServicePage, arguments: {"initialApprovalRequestId":state.requestId,"issuingRequestId":res},
                                                      );

                                                    });
                                                  });
                                               ;




                                                }

                                                break;

                                              case "apply-objection":
                                                {

                                                  final GetObjectionRequests
                                                      getRequests =
                                                      GetObjectionRequests(
                                                          repository: sl());

                                                  getRequests(
                                                    TransactionsRequestsPrams(
                                                      unifiedNationalNumber: CommonProperties.userInfo?.idNo,
                                                      identityNumber: CommonProperties.selectedDelegator?.crNumber,
                                                      page: 0,
                                                      size: 1,
                                                      requestNo: state.requestId.toString(),
                                                    ),
                                                  ).then((failureOrSuccess) {
                                                    failureOrSuccess.fold(
                                                      (failure) {},
                                                      (requests) {
                                                        NavigationService
                                                            .navigatorKey
                                                            .currentState!
                                                            .pushNamed(
                                                          RouteName
                                                              .createObjectionDetails,
                                                          arguments:
                                                              CreateObjectionPageParams(
                                                            // details: state.details,
                                                            item:
                                                                requests.first,
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  });
                                                }

                                                break;
                                              case "cancel":
                                                CustomPopUpsWidgets
                                                    .showConfirmAppMessageDialog(
                                                        context,
                                                        ("do_you_want_to_cancel")
                                                            .tr(),
                                                        primaryBtn: () {
                                                  Navigator.of(context).pop(true);
                                                  bloc?.cancelIntialApproval();
                                                });

                                                break;
                                              case "print":
                                                {
                                                  CommonFunctions.openBaldyWithRefreshCookie("${RemoteConfig.baladyCommercialUrl}/InitialApproval/Issuing/Edit/details/$hashingRequestNumber?isPrintAllowed=true");
                                                }

                                                break;
                                              case "reply-on-notes":
                                                if (state.requestDetails!
                                                            .notes !=
                                                        null &&
                                                    state.requestDetails!.notes!
                                                        .isNotEmpty) {
                                                  BottomSheetDialog.showDraggableSheet(
                                                      NavigationService
                                                          .navigatorKey
                                                          .currentContext!,
                                                      backgroundColor:
                                                          AppColor.black,
                                                      child: BottomSheetWithActions(
                                                          title:
                                                              "replyWithNotes"
                                                                  .tr(),
                                                          body: ReplyWithNotes(
                                                              bloc: bloc!,
                                                              noteId:
                                                                  "${state.requestDetails!.notes?[0].id}")));
                                                }
                                                break;
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  action.id == 'cancel'
                                                      ? IconPath.cancelOrder
                                                      : IconPath.editIcon,
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                const SizedBox(width: 8),
                                                CustomAutoSizeTextWidget(
                                                  action.name ?? "",
                                                  textStyle: AppStyle
                                                      .profileNameTextStyle
                                                      .copyWith(
                                                    color: AppColor
                                                        .blackModern600Light,
                                                  ),
                                                  maxLines: 2,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                )
                              : Center(
                                  child: CustomTextWidget(
                                    ('data_not_have_actions').tr(),
                                    fontSize: 14,
                                    fontColor: AppColor.primary900Light,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                        ),
                        isFullHeight: false,
                        height: MediaQuery.of(context).size.height * 0.47,
                      );
                    },
                    child: const CircleIcon(
                      backgroundColor: AppColor.primary50Light,
                      icon: IconPath.settings,
                      circleSize: 48.0,
                      iconSize: 30.0,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: RequestDetailsBody(),
        ),
      ),
    );
  }
}
