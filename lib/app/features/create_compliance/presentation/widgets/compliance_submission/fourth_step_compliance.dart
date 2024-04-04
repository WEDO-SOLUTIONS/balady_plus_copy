import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_bloc.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_image_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/previous_next_buttons.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../domain/entities/comliance_request_details.dart';
import '../compliance_clauses_submit_item_widget.dart';
import '../compliance_consetnt.dart';

class FourthStepCompliance extends StatelessWidget {
  FourthStepCompliance({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ComplianceSubmitTitle(
                  title: 'compliance_clauses_title'.tr(),
                  subtitle: "",
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.requestDetails?.emtithalItems?.length ?? 0,
                  itemBuilder: (ctx, index) {
                    return ComplianceClauseSubmitItem(
                      isReturned: state.requestDetails
                              ?.isRequestReturnedFromMunicipality ??
                          false,
                      item: state.requestDetails!.emtithalItems![index],
                      index: index,
                      onSubmit: (EmtithalItem item) {
                        context.read<ComplianceBloc>().add(
                            SaveImtethalItemEvent(item: item, index: index));
                      },
                      onChange: (EmtithalItem val) {
                        context.read<ComplianceBloc>().add(
                            ChangeImtethalItemEvent(index: index, item: val));
                      },
                    );
                    return ComplianceImageWidget(
                      item: state.requestDetails?.emtithalItems?[index],
                      onChange: (EmtithalItem val) {
                        context.read<ComplianceBloc>().add(
                            ChangeImtethalItemEvent(index: index, item: val));
                      },
                    );
                  },
                ),
                /* ComplianceConsent(
                  body: "compliance_emtethal_body".tr(),
                  agreement: state.emtethalAgreement ?? false,
                  onChanged: (val) {
                    context.read<ComplianceBloc>().add(
                        UpdateFieldsEvent(emtethalAgreeemnt: val ?? false));
                  },
                ),*/
                SizedBox(
                  height: 32,
                ),
                PreviousNextButtons()
              ],
            ),
          ),
        );
      },
    );
  }
}
