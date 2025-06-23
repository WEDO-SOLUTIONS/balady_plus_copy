import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/conclusion_widget/conclusion_additional_info_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/conclusion_widget/conclusion_bank_info_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/conclusion_widget/conclusion_location_info_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/conclusion_widget/conclusion_personal_info_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/conclusion_widget/conclusion_user_data_applicant_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import '../../blocs/choose_muncipality_bloc.dart';

class ConclusionScreen extends StatefulWidget {
  const ConclusionScreen({Key? key}) : super(key: key);

  @override
  State<ConclusionScreen> createState() => _ConclusionScreenState();
}

class _ConclusionScreenState extends State<ConclusionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChooseMuncipalityBloc, CertifiedObserverState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ChooseMuncipalityState) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        UserDataApplicantConclusionWidget(state: state),
                        PersonalInfoConclusionWidget(state: state),
                        LocationInfoConclusionWidget(state: state),
                        BankInfoConclusionWidget(state: state),
                        AdditionalInfoConclusionWidget(state: state),
                      ],
                    ),
                  ),
                ),
              ),
              //// Button Action
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 26,
                ),
                child: state.status == BlocStatus.loading
                    ? const CustomLoadingWidget()
                    : CustomElevatedButtonWidget(
                        btnColor: AppColor.primary800Light,
                        textStyle: AppStyle.elevatedButtonStyle.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        btnHeight: 56,
                        text: "submit_order".tr(),
                        onPressed: () {
                          if (state.requestData?.pledgeQuestion ?? false) {
                            context.read<ChooseMuncipalityBloc>().add(
                                  SubmitCertifiedObserverRequestEvent(
                                    dataModel: state.requestData!,
                                  ),
                                );
                          }
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
}
