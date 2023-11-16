import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../../../damaged_cars_exports.dart';
import '../../../blocs/create_dc_request/create_dc_details_bloc/create_dc_bloc.dart';

class IncidentDescSection extends StatelessWidget {
  const IncidentDescSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateDCBloc, CreateDCState>(
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
                      VdFieldsSection(initialDesc: state.issueDesc),
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
