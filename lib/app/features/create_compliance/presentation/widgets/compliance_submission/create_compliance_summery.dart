import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_widget.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../bloc/compliance_bloc.dart';
import '../../bloc/compliance_state.dart';
import '../map_widgets/compliance_header_desc_widget.dart';
import '../summery_widgets/pledges_summury_widget.dart';
import '../summery_widgets/step1_summury_widget.dart';
import '../summery_widgets/step2_2_summury_widget.dart';
import '../summery_widgets/step2_summury_widget.dart';
import '../summery_widgets/step3_summury_widget.dart';
import '../summery_widgets/step4_summury_widget.dart';
import '../summery_widgets/step5_summury_widget.dart';
import '../summery_widgets/step6_1_summury_widget.dart';
import '../summery_widgets/step6_summury_widget.dart';
import 'previous_next_buttons.dart';

class CreateComplianceSummurySection extends StatefulWidget {
  const CreateComplianceSummurySection({Key? key}) : super(key: key);

  @override
  State<CreateComplianceSummurySection> createState() =>
      _CreateComplianceSummurySectionState();
}

class _CreateComplianceSummurySectionState
    extends State<CreateComplianceSummurySection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header: ("review_request").tr(),
                      ),
                      Step1SummeryWidget(),
                      CustomVerticalSpace(height: 16),
                      Step2SummeryWidget(),
                      CustomVerticalSpace(height: 16),
                      Step2_2SummeryWidget(),
                      CustomVerticalSpace(height: 16),
                      Step3SummeryWidget(),
                      CustomVerticalSpace(height: 16),
                      Step4SummeryWidget(),
                      CustomVerticalSpace(height: 16),
                      Step5SummeryWidget(),
                      CustomVerticalSpace(height: 16),
                      Step6SummeryWidget(),
                      CustomVerticalSpace(height: 16),
                      Step6_1SummeryWidget(),
                      CustomVerticalSpace(height: 16),
                      PledgesSummuryWidget()
                    ],
                  ),
                ),
              ),
            ),
            PreviousNextButtons()
          ],
        );
      },
    );
  }

  _scrollToEnd() async {
    _scrollController.animateTo(_scrollController!.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.ease);
  }
}
