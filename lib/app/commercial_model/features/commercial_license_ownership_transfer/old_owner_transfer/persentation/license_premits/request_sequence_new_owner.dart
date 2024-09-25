import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/pages/check_debts/commercial_debts_screen.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import '../../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../bloc/license_tranfer_cubit.dart';
import '../interface/step_interface.dart';

class RquestSequenceNewOwnerInfoScreen extends StatefulWidget {
  StepInterface stepInterface;

  RquestSequenceNewOwnerInfoScreen({Key? key, required this.stepInterface})
      : super(key: key);

  @override
  State<RquestSequenceNewOwnerInfoScreen> createState() =>
      _RquestSequenceNewOwnerInfoScreenState();
}


class _RquestSequenceNewOwnerInfoScreenState
    extends State<RquestSequenceNewOwnerInfoScreen> {
  final TextEditingController _crNumberController = TextEditingController();
  final FocusNode _crNumberDescFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  LicenseTransferCubit? bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = context.read<LicenseTransferCubit>();
    return CommercialDebtsScreen(
      transactionType: TransactionType.LICENSE,
      transactionId: int.parse(bloc!.licenseNumber ?? "0"),
      steps: const [
        OwnershipTransferSteps.validateNewOwner
      ],
      serviceId: CommercialLicenseServiceId.ownershipTransferCommercialLicense,
      child: BlocConsumer<LicenseTransferCubit, LicenseTransferState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (_, state) async {
          if (state.status.isSubmissionGetFailure) {
            CommonFunctions.showError(state.error);
          } else if (state.status.isSubmissionGetSuccess &&
              state.validateOwnerDataModel != null) {
            bloc?.request.crNumber = _crNumberController.text;
            widget.stepInterface.nextPage();
          }
        },
        builder: (context, state) {
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
                                "new_owner".tr(),
                                textStyle: AppStyle.complianceTitleStyle,
                                maxLines: 4,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomTextFieldWidget(
                                label: "${"new_owner_cr_number".tr()} *",
                                controller: _crNumberController,
                                focusNode: _crNumberDescFocusNode,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                fillColor: Colors.transparent,
                                onValidate: (text) {
                                  if (text.toString().isEmpty) {
                                    return ("new_owner_cr_number_error").tr();
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.done,
                                spacerSize: 10,
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
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
                child: state.status == BlocRequestStatus.submissionGetLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButtonWidget.next(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            bloc?.validateNewOwner(
                                bloc!.licenseNumber!, _crNumberController.text);
                          }
                        },
                      ),
              )
            ],
          );
        },
      ),
    );
  }
}
