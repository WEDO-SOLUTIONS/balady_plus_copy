import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/pages/check_debts/commercial_debts_screen.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import '../../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../bloc/license_tranfer_cubit.dart';
import '../interface/step_interface.dart';

class RequestSequencePledgesScreen extends StatefulWidget {
  StepInterface stepInterface;

  RequestSequencePledgesScreen({Key? key, required this.stepInterface})
      : super(key: key);

  @override
  State<RequestSequencePledgesScreen> createState() =>
      _RequestSequencePledgesScreenState();
}

class _RequestSequencePledgesScreenState
    extends State<RequestSequencePledgesScreen> {
  LicenseTransferCubit? bloc;

  bool isAgree = false;
  List<int> lstPermits = [];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      bloc = context.read<LicenseTransferCubit>();
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = context.read<LicenseTransferCubit>();
    return CommercialDebtsScreen(
      transactionType: TransactionType.LICENSE,
      transactionId: int.parse(bloc!.licenseNumber ?? "0"),
      steps: const [
        OwnershipTransferSteps.sendRequestToNewOwner
      ],
      serviceId: CommercialLicenseServiceId.ownershipTransferCommercialLicense,
      child: BlocConsumer<LicenseTransferCubit, LicenseTransferState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (_, state) async {
          if (state.status.isSubmissionGetFailure) {
            CommonFunctions.showError(state.error);
          } else if (state.status.isSubmissionGetSuccess &&
              state.applyRequestDataModel != null) {
            Navigator.of(context).pop(true);
            Navigator.of(context).pushNamed(CommercialRouteName.SucessfullScreen,
                arguments: {
                  "requestId": "${state.applyRequestDataModel?.result}",
                  "isFromRequest": true
                });
          }
        },
        builder: (context, state) {
          return Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: getCardView(
                      Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const DrawIconBasedTypeWidget(
                                icon: IconPath.saveIcon,
                                iconSize: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Pledges".tr(),
                                style: AppStyle
                                    .personalInfoParameterValueTextStyle
                                    .copyWith(fontSize: 15, height: 1.5),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "pledges_condtions".tr(),
                            style: AppStyle.personalInfoParameterValueTextStyle
                                .copyWith(fontSize: 12, height: 1.5),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          getCardView(
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                //  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                      value: isAgree,
                                      checkColor: AppColor.blueSkyLight800,
                                      activeColor: AppColor.white,
                                      onChanged: (value) {
                                        setState(() {
                                          isAgree = !isAgree;
                                        });
                                      }),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "cr_consent_conditions_check".tr(),
                                        style: AppStyle
                                            .personalInfoParameterValueTextStyle
                                            .copyWith(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              AppColor.grayLight,
                              const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 5, top: 5)),
                        ],
                      ),
                      AppColor.white,
                      null),
                ),
                const Spacer(),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                      color: Colors.white),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
                  child: Column(
                    children: [
                      getCardView(
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const DrawIconBasedTypeWidget(
                                icon: IconPath.infoCircle,
                                iconSize: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "exclude".tr(),
                                  style: AppStyle
                                      .personalInfoParameterValueTextStyle
                                      .copyWith(fontSize: 12, height: 1.5),
                                ),
                              ),
                            ],
                          ),
                          AppColor.grayLight,
                          null),
                      const SizedBox(height: 20),
                      state.status == BlocRequestStatus.submissionGetLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButtonWidget.applyRequest(
                        onPressed: () {
                          if (isAgree) {
                            bloc?.sendToNewOwner(
                                bloc!.licenseNumber!, bloc!.request);
                          } else {
                            CommonFunctions.showError("terms_error".tr());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            state.status == BlocRequestStatus.submissionGetLoading
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox(),
          ]);
        },
      ),
    );
  }


  Widget getCardView(Widget child, Color bgcolor, EdgeInsetsGeometry? padding) {
    return Container(
      padding: padding ??
          const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 20),
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: bgcolor,
      ),
      child: child,
    );
  }
}
