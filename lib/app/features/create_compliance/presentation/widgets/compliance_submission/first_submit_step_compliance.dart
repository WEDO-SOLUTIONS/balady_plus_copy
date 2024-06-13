import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_bloc.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/previous_next_buttons.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_title_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/custom_radio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class FirstComplianceSubmissionWidget extends StatelessWidget {
  const FirstComplianceSubmissionWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ComplianceSubmitTitle(
                  title: 'representation_title'.tr(),
                  subtitle: "",
                ),
                const SizedBox(height: 10),
                RadioCustomWidget(
                  value: 1,
                  title: 'representation_radio_option1'.tr(),
                  subtitle: 'representation_option1_subtitle'.tr(),
                  feesStatus: 'free'.tr(),
                ),
                const SizedBox(height: 10),
                RadioCustomWidget(
                  value: 2,
                  title: 'representation_radio_option2'.tr(),
                  subtitle: 'representation_option2_subtitle'.tr(),
                  feesStatus: 'office_fees'.tr(),
                ),
                const SizedBox(height: 32),
                const PreviousNextButtons()
              ],
            ),
          ),
        );
      },
    );
  }
}
