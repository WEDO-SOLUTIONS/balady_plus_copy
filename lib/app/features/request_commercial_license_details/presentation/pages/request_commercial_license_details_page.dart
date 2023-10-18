import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/bloc/commercial_license_details_cubit.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/commercial_license_action_sheet.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import 'package:balady_plus/app/features/request_commercial_license_details/presentation/bloc/request_commercial_license_details_cubit.dart';
import 'package:balady_plus/app/features/request_commercial_license_details/presentation/mvvm/commercial_license_request_action_view_model.dart';
import 'package:balady_plus/app/features/request_commercial_license_details/presentation/widgets/request_commercial_license_details_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';



class RequestCommercialLicenseDetailsPage extends StatelessWidget {
  const RequestCommercialLicenseDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    RequestCommercialLicenseDetailsCubit  bloc = ModalRoute.of(context)!.settings.arguments as RequestCommercialLicenseDetailsCubit;

    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: '${"request".tr()} #${bloc.requestId}',
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
                        dialogKeyName: DialogName.requestCommercialLicenseActionSheetDialog,
                        currentRouteName: RouteName.requestCommercialLicenseDetails,
                        child: ChangeNotifierProvider(
                          create: (BuildContext context) =>
                              RequestCommercialLicenseActionViewModel(
                                webService: sl(),
                                requestId: bloc.requestId,
                              ),
                          child: const CommercialLicenseActionSheet(),
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
          padding:  EdgeInsets.all(16),
          child:  RequestCommercialLicenseDetailsBody(),
        ),
      ),
    );
  }
}
