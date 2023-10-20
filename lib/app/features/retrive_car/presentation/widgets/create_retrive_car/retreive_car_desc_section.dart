import 'package:balady_plus/app/features/retrive_car/presentation/widgets/create_retrive_car/note_field_section.dart';
import 'package:balady_plus/app/features/retrive_car/presentation/widgets/create_retrive_car/previous_next_buttons.dart';
import 'package:balady_plus/app/features/retrive_car/presentation/widgets/create_retrive_car/retrive_attachment_section.dart';
import 'package:balady_plus/app/features/retrive_car/presentation/widgets/create_retrive_car/retrive_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_agreement_section.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../blocs/create_retrive_bloc/create_retrive_bloc.dart';

class RetreiveCarDescSection extends StatelessWidget {
  const RetreiveCarDescSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRetriveCarBloc, CreateRetriveCarState>(
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
                        header: ("enter_veichle_data").tr(),
                      ),
                      RetriveDate(),
                      NotesFieldsSection(initialDesc: state.issueDesc),
                      RetriveAttachmentSection(),
                      VdAgreementSection(
                          initalChecked: state.agreement,
                          onChecked: (bool? isAgreed) {
                            context
                                .read<CreateRetriveCarBloc>()
                                .add(ChangeAgreementEvent(isagree: isAgreed));
                          }),
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
