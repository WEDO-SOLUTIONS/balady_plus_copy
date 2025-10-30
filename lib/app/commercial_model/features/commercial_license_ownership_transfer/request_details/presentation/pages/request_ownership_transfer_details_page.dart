import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/pages/check_debts/commercial_debts_screen.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/presentation/bloc/request_ownership_transfer_details_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/presentation/widgets/request_ownership_transfer_details_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';

class RequestOwnershipTransferDetailsPage extends StatefulWidget {
  const RequestOwnershipTransferDetailsPage({super.key});

  @override
  State<RequestOwnershipTransferDetailsPage> createState() =>
      _RequestOwnershipTransferDetailsPageState();
}

class _RequestOwnershipTransferDetailsPageState
    extends State<RequestOwnershipTransferDetailsPage> {
  RequestOwnershipTransferDetailsCubit? bloc;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      bloc!.getCommercialLicenseDetailsById(bloc!.requestID!);
    });
    CommonFunctions.sendUXCamEvent(UXCamEvents.openLicensesDetails);
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    String requestNumber = data['requestNumber'];
    bool isReadonly = data['isReadonly'] ?? false;
    return BlocProvider(
      create: (context) {
        bloc = RequestOwnershipTransferDetailsCubit(
          requestOwnershipTransferDetailsRepository: sl(),
          acceptOrRejectRequestOwnershipTransferRepository: sl(),
        );

        bloc?.requestID = requestNumber;

        return bloc!;
      },
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
                "request".tr(),
                fontSize: 20,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                fontWeight: AppFontWeight.bold,
                fontColor: AppColor.blackModern700Light,
              ),
              const SizedBox(
                width: 10,
              ),
              CustomTextWidget(
                "#$requestNumber",
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
          actions: [],
        ),
        body: BlocConsumer<RequestOwnershipTransferDetailsCubit,
            RequestOwnershipTransferDetailsState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (_, state) async {
            if (state.status == BlocRequestStatus.submissionGetFailure) {
              MessageDialog.showErrorNotification(msg: state.error);
            }
          },
          builder: (context, state) {
            if (state.status == BlocRequestStatus.submissionGetLoading) {
              return ListView.builder(
                itemCount: 3,
                itemBuilder: (_, __) => Container(
                  height: 200,
                  margin: const EdgeInsets.only(top: 16),
                  child: const ShimmerEffectWidget(),
                ),
              );
            } else if (state.commercialLicenceDetails != null) {
              if (!isReadonly && (state.commercialLicenceDetails!.statusId == 10 || state.commercialLicenceDetails!.statusId == 37)) {
                return CommercialDebtsScreen(
                  transactionType: TransactionType.REQUEST,
                  transactionId: int.parse(requestNumber),
                  steps: const [
                    OwnershipTransferSteps.acceptOrRejectRequestByNewOwner
                  ],
                  serviceId: CommercialLicenseServiceId.ownershipTransferCommercialLicense,
                  child: RequestOwnershipTransferDetailsBody(
                    isReadonly: isReadonly ?? false,
                    commercialRequestDetails: state.commercialLicenceDetails!,
                  ),
                );
              } else {
                return RequestOwnershipTransferDetailsBody(
                  isReadonly: isReadonly ?? false,
                  commercialRequestDetails: state.commercialLicenceDetails!,
                );
              }
            }
            return Center(
              child: ReloadWidget(
                onTab: () {
                  bloc?.getCommercialLicenseDetailsById(requestNumber);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
