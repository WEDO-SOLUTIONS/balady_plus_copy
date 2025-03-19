import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/fill_info_widgets/additional_info_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/fill_info_widgets/bank_info_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/fill_info_widgets/location_info_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/fill_info_widgets/personal_info_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/fill_info_widgets/user_data_applicant_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class FillInfoScreen extends StatefulWidget {
  const FillInfoScreen({Key? key}) : super(key: key);

  @override
  State<FillInfoScreen> createState() => _FillInfoScreenState();
}

class _FillInfoScreenState extends State<FillInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseMuncipalityBloc, CertifiedObserverState>(
      builder: (context, state) {
        if (state is ChooseMuncipalityState) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // User Data applicant
                      UserDataApplicantWidget(state: state),
                      // Location Info
                      LocationInfoWidget(state: state),
                      // Personal Info
                      PersonalInfoWidget(state: state),
                      // Bank Info
                      BankInfoWidget(state: state),
                      // Additional Info
                      AdditionalInfoWidget(state: state),
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
                    if (state.requestData?.municipality != null) {
                      context
                          .read<ChooseMuncipalityBloc>()
                          .checkMuncipalityAcceptance();
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
