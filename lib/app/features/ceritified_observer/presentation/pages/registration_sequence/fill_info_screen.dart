import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/fill_info_widgets/additional_info_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/fill_info_widgets/bank_info_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/fill_info_widgets/location_info_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/fill_info_widgets/personal_info_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/fill_info_widgets/user_data_applicant_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class FillInfoScreen extends StatefulWidget {
  const FillInfoScreen({Key? key}) : super(key: key);

  @override
  State<FillInfoScreen> createState() => _FillInfoScreenState();
}

class _FillInfoScreenState extends State<FillInfoScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final GlobalKey locationSection = GlobalKey();
  final ExpandableController locationExpandableController =
      ExpandableController();
  final GlobalKey personalSection = GlobalKey();
  final ExpandableController personalExpandableController =
      ExpandableController();
  final GlobalKey bankSection = GlobalKey();
  final ExpandableController bankExpandableController = ExpandableController();
  final GlobalKey additionalInfoSection = GlobalKey();
  final ExpandableController additionalInfoExpandableController =
      ExpandableController();

  bool isCompleted = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseMuncipalityBloc, CertifiedObserverState>(
      builder: (context, state) {
        if (state is ChooseMuncipalityState) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        // User Data applicant
                        UserDataApplicantWidget(
                          state: state,
                        ),
                        // Location Info
                        LocationInfoWidget(
                          key: locationSection,
                          state: state,
                          expandableController: locationExpandableController,
                        ),
                        // Personal Info
                        PersonalInfoWidget(
                          key: personalSection,
                          state: state,
                          expandableController: personalExpandableController,
                        ),
                        // Bank Info
                        BankInfoWidget(
                          key: bankSection,
                          state: state,
                          expandableController: bankExpandableController,
                        ),
                        // Additional Info
                        AdditionalInfoWidget(
                          key: additionalInfoSection,
                          state: state,
                          expandableController:
                              additionalInfoExpandableController,
                        ),
                      ],
                    ),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
                child: CustomElevatedButtonWidget(
                  btnColor: AppColor.primary800Light,
                  textStyle: AppStyle.elevatedButtonStyle.copyWith(
                    color: AppColor.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  btnHeight: 56,
                  text: "next".tr(),
                  onPressed: () {
                    ///// First check if the Location Info is filled

                    bool isFormValid=formKey.currentState!.validate();
                    if (state.requestData?.municipality == null ||
                          state.requestData?.city == null ||
                          state.requestData?.district == null) {
                        moveToTheNotCompletedSection(locationSection);
                        if (!locationExpandableController.expanded) {
                          locationExpandableController.toggle();
                        }
                        isCompleted = false;
                      } else {
                        if (locationExpandableController.expanded) {
                          locationExpandableController.toggle();
                        }
                      }

                      ///// Second check if the Personal Info is filled
                      if (state.requestData?.mobileNumber == null ||
                          state.requestData?.email == null ||
                          state.requestData?.academicQualification == null ||
                          state.requestData?.maritalStatus == null) {
                        moveToTheNotCompletedSection(personalSection);
                        if (!personalExpandableController.expanded) {
                          personalExpandableController.toggle();
                        }
                        isCompleted = false;
                      } else {
                        if (personalExpandableController.expanded&& isFormValid==true) {
                          personalExpandableController.toggle();
                        }
                      }

                      ///// Third check if the Bank Info is filled
                      if (state.requestData?.bankInfo == null ||
                          state.requestData?.iban == null) {
                        moveToTheNotCompletedSection(bankSection);
                        if (!bankExpandableController.expanded) {
                          bankExpandableController.toggle();
                        }
                        isCompleted = false;
                      } else {
                        if (bankExpandableController.expanded) {
                          bankExpandableController.toggle();
                        }
                      }

                      ///// Fourth check if the Additional Info is filled
                      if (state.requestData?.surveyQuestion1 == null ||
                          state.requestData?.surveyQuestion2 == null ||
                          state.requestData?.surveyQuestion3 == null ||
                          state.requestData?.surveyQuestion4 == null) {
                        moveToTheNotCompletedSection(additionalInfoSection);
                        if (!additionalInfoExpandableController.expanded) {
                          additionalInfoExpandableController.toggle();
                        }
                        isCompleted = false;
                      } else {
                        if (additionalInfoExpandableController.expanded) {
                          additionalInfoExpandableController.toggle();
                        }
                      }
                      if(isFormValid == false)
                        {
                          isCompleted = false;
                        }

                      if (isCompleted) {
                        context.read<ChooseMuncipalityBloc>().add(
                          const GoToNextPageEvent(),
                        );
                      } else {
                        CommonFunctions.showError(
                            "please_fill_all_required_fields".tr());
                        isCompleted = true;
                      }

                      oneMove = false;

                  },
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  bool oneMove = false;

  void moveToTheNotCompletedSection(GlobalKey key) {
    if (!oneMove) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
      oneMove = true;
    }
  }
}
