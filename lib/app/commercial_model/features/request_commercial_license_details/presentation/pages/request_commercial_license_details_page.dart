import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/reason_cancel.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/data/repositories/repository_implementation.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/domain/use_cases/get_request_commercial_license_details.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/presentation/bloc/request_commercial_license_details_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/presentation/mvvm/commercial_license_request_action_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/presentation/widgets/request_commercial_license_action_sheet.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/presentation/widgets/request_commercial_license_details_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class RequestCommercialLicenseDetailsPage extends StatelessWidget {
  const RequestCommercialLicenseDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;

    return BlocProvider(
      create: (context) => RequestCommercialLicenseDetailsCubit(
        GetRequestCommercialLicenseDetails(
          repository: RequestCommercialLicenseDetailsRepositoryImplementation(
            remoteDataSource:
                RequestCommercialLicenseDetailsRemoteDataSourceImplementation(
              webService: sl(),
            ),
          ),
        ),
        int.parse(data['requestNumber']),
      ),
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: '${"request".tr()} #${data['requestNumber']}',
          actions: [
            BlocBuilder<RequestCommercialLicenseDetailsCubit,
                RequestCommercialLicenseDetailsState>(
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
                      BottomSheetDialog.showDraggableSheet(
                        context,
                        dialogKeyName: DialogName
                            .requestCommercialLicenseActionSheetDialog,
                        currentRouteName:
                            CommercialRouteName.requestCommercialLicenseDetails,
                        child: ChangeNotifierProvider(
                          create: (BuildContext context) =>
                              RequestCommercialLicenseActionViewModel(
                            webService: sl(),
                            requestId: int.parse(data['requestNumber']),
                          isFromInitialApproval:  state.requestCommercialLicenseDetails!.isFromInitialApproval,
                            requestTypeId:
                                state.requestCommercialLicenseDetails!.typeId,
                            reasonCancel: state.requestCommercialLicenseDetails!
                                        .cancellationReasonId !=
                                    null
                                ? ReasonCancel(
                                    id: state.requestCommercialLicenseDetails!
                                        .cancellationReasonId!,
                                    text: state.requestCommercialLicenseDetails!
                                        .cancellationReasonName!,
                                  )
                                : null,
                            availableCloseDate: state
                                .requestCommercialLicenseDetails!
                                .availableCloseDate,
                          ),
                          child: const RequestCommercialLicenseActionSheet(),
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
          child: RequestCommercialLicenseDetailsBody(),
        ),
      ),
    );
  }
}
