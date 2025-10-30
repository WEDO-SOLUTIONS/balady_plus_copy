import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class IncidentDescSection extends StatelessWidget {
  const IncidentDescSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVDBloc, CreateVDState>(
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
                        header: ("vd_incident_details").tr(),
                      ),
                      if (state.isRegaClass()) CRTextField(),
                      VdFieldsSection(initialDesc: state.issueDesc),
                      /* VdAgreementSection(
                          initalChecked: state.agreement,
                          onChecked: (bool? isAgreed) {
                            context
                                .read<CreateVDBloc>()
                                .add(ChangeAgreementEvent(isagree: isAgreed));
                          }),*/
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
}
