import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/data/repositories/repository_implementation.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/commercial_license_attachments_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/commercial_license_permits_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/domain/use_cases/get_commercial_license_details.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/bloc/commercial_license_details_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/mvvm/commercial_license_action_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/commercial_license_action_sheet.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/commercial_license_details_body.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import '../../../commercial_license_ownership_transfer/old_owner_transfer/domain/use_cases/get_validate_license.dart';
import '../../../commercial_license_ownership_transfer/old_owner_transfer/persentation/bloc/license_tranfer_cubit.dart';

class CommercialLicenseDetailsPage extends StatefulWidget {
  const CommercialLicenseDetailsPage({super.key});

  @override
  State<CommercialLicenseDetailsPage> createState() =>
      _CommercialLicenseDetailsPageState();
}

class _CommercialLicenseDetailsPageState
    extends State<CommercialLicenseDetailsPage> {
  LicenseTransferCubit? bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.openLicensesDetails);
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    int commercialLicenseId = int.parse(data['licenseNumber']);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => CommercialLicenseDetailsCubit(
                  GetCommercialLicenseDetails(
                    repository:
                        CommercialLicenseDetailsRepositoryImplementation(
                      remoteDataSource:
                          CommercialLicenseDetailsRemoteDataSourceImplementation(
                        webService: sl(),
                      ),
                    ),
                  ),
                  commercialLicenseId,
                )),
        BlocProvider(
          create: (_) {
            bloc = LicenseTransferCubit(
                null, null, GetValidateLicense(repository: sl()), null);
            return bloc!;
          },
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.scaffoldBackground,
          elevation: 0,
          shadowColor: AppColor.primary100Light,
          centerTitle: false,
          // leadingWidth: showBack == true ? null : 8,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTextWidget(
                "businessLicense".tr(),
                fontSize: 20,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                fontWeight: AppFontWeight.bold,
                fontColor: AppColor.blackModern700Light,
              ),
              CustomTextWidget(
                "#${commercialLicenseId}",
                fontSize: 14,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                fontWeight: AppFontWeight.medium,
                fontColor: AppColor.blackModern700Light,
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColor.blackModern900Light,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            BlocBuilder<CommercialLicenseDetailsCubit,
                CommercialLicenseDetailsState>(
              builder: (_, state) {
                if (state.status == BlocRequestStatus.submissionGetLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                    child: ShimmerEffectWidget(
                      width: 40,
                      height: 30,
                      borderRadius: 25,
                    ),
                  );
                }
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: InkWell(
                    onTap: () {
                      if (state.commercialLicenceDetails!.submitterInfo !=
                              null &&
                          state.commercialLicenceDetails!.licenseInfo != null) {
                        BottomSheetDialog.showDraggableSheet(
                          context,
                          dialogKeyName:
                              DialogName.commercialLicenseActionSheetDialog,
                          currentRouteName: CommercialRouteName.commercialLicenseDetails,
                          child: ChangeNotifierProvider(
                            create: (BuildContext context) =>
                                CommercialLicenseActionViewModel(
                                    webService: sl(),
                                    licenseId: commercialLicenseId,
                                    submitterInfo: state
                                        .commercialLicenceDetails!
                                        .submitterInfo!,
                                    commercialLicenceDetails:
                                        state.commercialLicenceDetails!),
                            child: CommercialLicenseActionSheet(
                                licenseTransferCubit: bloc!),
                          ),
                          isFullHeight: false,
                          height: MediaQuery.of(context).size.height * 0.47,
                        );
                      }
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
        body: BlocConsumer<LicenseTransferCubit, LicenseTransferState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (_, state) async {
              if (state.status.isSubmissionGetFailure) {
                CommonFunctions.showError(state.error);
              } else if (state.status.isSubmissionGetSuccess) {
                Navigator.of(context).pushNamed(
                  CommercialRouteName.commercialLicenseTransferOverView,
                  arguments: "$commercialLicenseId",
                );
              }
            },
            builder: (context, state) {
              return Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: BlocBuilder<CommercialLicenseDetailsCubit,
                        CommercialLicenseDetailsState>(
                      builder: (context, state) {
                        CommercialLicenseDetailsCubit bloc =
                            context.watch<CommercialLicenseDetailsCubit>();
                        if (state.status ==
                            BlocRequestStatus.submissionGetLoading) {
                          return ListView.builder(
                            itemCount: 3,
                            itemBuilder: (_, __) => Container(
                              height: 200,
                              margin: const EdgeInsets.only(top: 16),
                              child: const ShimmerEffectWidget(),
                            ),
                          );
                        } else if (state.commercialLicenceDetails != null) {
                          final commercialLicenceDetails =
                              state.commercialLicenceDetails!;
                          return MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (BuildContext context) {
                                  return CommercialLicenseAttachmentsViewModel(
                                    webService: sl(),
                                    licenseId: bloc.commercialLicenseId,
                                  );
                                },
                              ),
                              ChangeNotifierProvider(
                                create: (BuildContext context) {
                                  return CommercialLicensePermitsViewModel(
                                    webService: sl(),
                                    requestId: commercialLicenceDetails
                                            .licenseInfo!.licenseId ??
                                        0,
                                  );
                                },
                              ),
                            ],
                            child: CommercialLicenseDetailsBody(
                              commercialLicenceDetails:
                                  commercialLicenceDetails,
                            ),
                          );
                        }

                        return Center(
                          child: ReloadWidget(
                            onTab: () {
                              bloc.getCommercialLicenseDetailsById(
                                  bloc.commercialLicenseId);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  state.status == BlocRequestStatus.submissionGetLoading
                      ? const CircularProgressIndicator()
                      : Container(),
                ],
              );
              //  }
            }),
      ),
    );
  }
}
