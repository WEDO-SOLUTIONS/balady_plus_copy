import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_check_box_widget.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';

class AgreementSection extends StatelessWidget {
  const AgreementSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header: Helpers.translatingWord("ekramAgreement"),
                      ),
                      CustomCheckBoxTopStartWidget(
                          onSelected: (value) {
                            context
                                .read<EkramRequestTransportationBloc>()
                                .add(ChangeAgreementEvent(isagree: value));
                          },
                          backgroundColor: Colors.white,
                          checkboxValue: state.agreement ?? false,
                          containerBackgroundColor: Colors.transparent,
                          borderSelectedColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          checkBoxAlignment: AlignmentDirectional.topStart,
                          titleSize: 14,
                          checkboxSize: 1,
                          verticalPadding: 5,
                          title: ("agreement_text").tr().replaceAll(
                              "{}", CommonProperties.userInfo?.arName ?? ""))
                    ],
                  ),
                ),
              ),
            ),
            EkramPreviousNextButtons()
          ],
        );
      },
    );
  }
}
