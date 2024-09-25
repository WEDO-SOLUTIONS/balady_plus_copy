import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/pages/check_debts/commercial_debts_screen.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import '../../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../commercial_license/presentation/step4/widgets/yes_no_radio_group_widget.dart';
import '../../../old_owner_transfer/persentation/interface/step_interface.dart';
import '../../domain/entities/save_shop_info_request.dart';
import '../blocs/request_approval_sequence_cubit.dart';

class ApprovalSequenceShopInfoScreen extends StatefulWidget {
  StepInterface stepInterface;

  ApprovalSequenceShopInfoScreen({Key? key, required this.stepInterface})
      : super(key: key);

  @override
  State<ApprovalSequenceShopInfoScreen> createState() =>
      _ApprovalSequenceShopInfoScreenState();
}

class _ApprovalSequenceShopInfoScreenState
    extends State<ApprovalSequenceShopInfoScreen> {
  final TextEditingController _crNumberController = TextEditingController();
  final FocusNode _crNumberDescFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  RequestApprovalSequenceCubit? bloc;
  bool brandChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = context.read<RequestApprovalSequenceCubit>();
    return CommercialDebtsScreen(
      transactionType: TransactionType.REQUEST,
      transactionId: bloc!.requestNumber!,
      steps: const [OwnershipTransferSteps.saveShopInfo],
      serviceId: CommercialLicenseServiceId.ownershipTransferCommercialLicense,
      child: BlocBuilder<RequestApprovalSequenceCubit,
          RequestApprovalSequenceState>(builder: (blocContext, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: 30, right: 30, left: 30, top: 0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              "issue_commercial_shop_info".tr(),
                              textStyle: AppStyle.complianceTitleStyle,
                              maxLines: 4,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFieldWidget(
                              label: "${"shopName".tr()} *",
                              controller: _crNumberController,
                              focusNode: _crNumberDescFocusNode,
                              keyboardType: TextInputType.text,
                              fillColor: Colors.transparent,
                              onValidate: (text) {
                                RegExp regex = RegExp(r"^[a-zء-ي ]+$");
                                if (text.toString().isEmpty) {
                                  return ("shop_name_error").tr();
                                } else if (!regex.hasMatch(text!)) {
                                  return ("validate_shop_name".tr());
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.done,
                              spacerSize: 10,
                            ),
                            YesNoRadioGroupWidget(
                              groupName: "step4GroupName".tr(),
                              currentValue: brandChecked,
                              onChanged: (value) {
                                setState(() {
                                  brandChecked = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
              child: state is LoadingState
                  ? const CustomCircularLoadingWidget()
                  : ElevatedButtonWidget.next(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          bloc?.saveShopInfo(
                              bloc!.requestNumber!,
                              SaveShopInfoRequest(
                                  shopName: _crNumberController.text,
                                  hasBrand: brandChecked),
                              widget.stepInterface);
                        }
                      },
                    ),
            )
          ],
        );
      }),
    );
  }
}
