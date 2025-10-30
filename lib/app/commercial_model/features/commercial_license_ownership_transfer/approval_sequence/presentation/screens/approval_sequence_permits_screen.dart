import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/pages/check_debts/commercial_debts_screen.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../old_owner_transfer/persentation/interface/step_interface.dart';
import '../blocs/request_approval_sequence_cubit.dart';

class ApprovalSequencePermitsScreen extends StatefulWidget {
  StepInterface stepInterface;

  ApprovalSequencePermitsScreen({Key? key, required this.stepInterface})
      : super(key: key);

  @override
  State<ApprovalSequencePermitsScreen> createState() =>
      _ApprovalSequencePermitsScreenState();
}

class _ApprovalSequencePermitsScreenState
    extends State<ApprovalSequencePermitsScreen> {
  RequestApprovalSequenceCubit? bloc;

  bool isAgree = false;
  List<int> lstPermits = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      bloc = context.read<RequestApprovalSequenceCubit>();
      bloc!.getRequestPermits(bloc!.requestNumber!);
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = context.read<RequestApprovalSequenceCubit>();
    return CommercialDebtsScreen(
      transactionType: TransactionType.REQUEST,
      transactionId: bloc!.requestNumber!,
      steps: const [
        OwnershipTransferSteps.permitsNewOwner,
      ],
      serviceId: CommercialLicenseServiceId.ownershipTransferCommercialLicense,
      child: getBody(),
    );
  }

  Widget getBody() {
    return BlocConsumer<RequestApprovalSequenceCubit,
        RequestApprovalSequenceState>(
      listener: (bC, states) {
        if (states is GetPermitsSucceedState) {
          final permitsList = states.permitsList;
          for (var index = 0; index < permitsList.permits!.length; index++) {
            permitsList.permits![index].selected = true;
            if (lstPermits.contains(permitsList.permits![index].requestId!) ==
                false) {
              lstPermits.add(permitsList.permits![index].requestId!);
            }
          }
          setState(() {});
        }
      },
      builder: (blocContext, state) {
        if (state is LoadingState) {
          return ListView.builder(
            itemCount: 3,
            itemBuilder: (_, __) => Container(
              height: 200,
              margin: const EdgeInsets.only(top: 16),
              child: const ShimmerEffectWidget(),
            ),
          );
        } else if (state is GetPermitsSucceedState) {
          final permitsList = state.permitsList;
          return Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  "permit_info".tr(),
                  textStyle: AppStyle.complianceTitleStyle,
                  maxLines: 4,
                ),
                permitsList.permits!.isNotEmpty
                    ? getCardView(
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
                                "permit_warn".tr(),
                                style: AppStyle
                                    .personalInfoParameterValueTextStyle
                                    .copyWith(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        AppColor.grayLight)
                    : Container(),
                permitsList.permits!.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomElevatedButtonWidget(
                            btnColor: Colors.transparent,
                            textStyle: AppStyle.elevatedButtonStyle.copyWith(
                              color: AppColor.blueSkyLight800,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            btnPadding: EdgeInsets.all(8.0),
                            btnHeight: 30,
                            btnWidth: 20,
                            text: "transfer_all".tr(),
                            onPressed: () {
                              for (var index = 0;
                                  index < permitsList.permits!.length;
                                  index++) {
                                permitsList.permits![index].selected = true;
                                if (lstPermits.contains(permitsList
                                        .permits![index].requestId!) ==
                                    false) {
                                  lstPermits.add(
                                      permitsList.permits![index].requestId!);
                                }
                              }
                              setState(() {});
                            },
                          ),
                        ],
                      )
                    : Container(),
                permitsList.permits!.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: permitsList.permits!.length,
                          itemBuilder: (_, index) {
                            final permit = permitsList.permits![index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const DrawIconBasedTypeWidget(
                                          icon: IconPath.documentCopy,
                                          iconSize: 24,
                                        ),
                                        CustomTextWidget(
                                          '${permit.permitName}',
                                          textStyle: AppStyle.dateTextStyle,
                                        ),
                                        const Spacer(),
                                        CustomElevatedButtonWidget(
                                          btnBorderColor:
                                              permit.selected == false ||
                                                      permit.selected == null
                                                  ? AppColor.white
                                                  : AppColor.blueSkyLight800,
                                          btnColor: permit.selected == false ||
                                                  permit.selected == null
                                              ? AppColor.blueSkyLight800
                                              : AppColor.white,
                                          textStyle: AppStyle
                                              .elevatedButtonStyle
                                              .copyWith(
                                            color: permit.selected == false ||
                                                    permit.selected == null
                                                ? AppColor.white
                                                : AppColor.blueSkyLight800,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                          btnPadding: EdgeInsets.all(8.0),
                                          btnHeight: 30,
                                          btnWidth: 20,
                                          text: permit.selected == false ||
                                                  permit.selected == null
                                              ? "tranfer_permit".tr()
                                              : "dont_tranfer_permit".tr(),
                                          onPressed: () {
                                            if (lstPermits
                                                .contains(permit.requestId!)) {
                                              lstPermits
                                                  .remove(permit.requestId!);
                                              setState(() {
                                                permit.selected = false;
                                              });
                                            } else {
                                              lstPermits.add(permit.requestId!);
                                              setState(() {
                                                permit.selected = true;
                                              });
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomTextWidget(
                                                "permit_24_permit_no".tr(),
                                                textStyle:
                                                    AppStyle.tagTextStyle,
                                              ),
                                              const SizedBox(height: 4),
                                              CustomTextWidget(
                                                "${permit.permitNumber}",
                                                textStyle:
                                                    AppStyle.costTitleTextStyle,
                                                maxLines: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomTextWidget(
                                                "expirationDate".tr(),
                                                textStyle:
                                                    AppStyle.tagTextStyle,
                                              ),
                                              const SizedBox(height: 4),
                                              CustomTextWidget(
                                                permit.permitEndDate!,
                                                textStyle:
                                                    AppStyle.costTitleTextStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: CustomTextWidget(
                                ('data_not_have_permits').tr(),
                                fontSize: 14,
                                fontColor: AppColor.primary900Light,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                permitsList.term != null
                    ? getCardView(
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
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
                              child: Text(
                                permitsList.term ?? "",
                                style: AppStyle
                                    .personalInfoParameterValueTextStyle
                                    .copyWith(
                                  fontSize: 12,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppColor.grayLight)
                    : Container(),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                      color: Colors.white),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
                  child: state is LoadingState
                      ? const CustomCircularLoadingWidget()
                      : ElevatedButtonWidget.next(
                          onPressed: () {
                            if (isAgree || permitsList.term == null) {
                              bloc?.saveSelectedRequestsPermitsRequest
                                  .selectedPermits = lstPermits;

                              bloc?.saveSelectedRequestPermits(
                                  bloc!.requestNumber!,
                                  bloc!.saveSelectedRequestsPermitsRequest,
                                  widget.stepInterface);
                            } else {
                              CommonFunctions.showError("terms_error".tr());
                            }
                          },
                        ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: ReloadWidget(
            errorMessage: "no_data_found".tr(),
            onTab: () {
              bloc!.getRequestPermits(bloc!.requestNumber!);
            },
          ),
        );
      },
    );
  }

  Widget getCardView(Widget child, Color bgcolor) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 20),
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: bgcolor,
      ),
      child: child,
    );
  }
}
