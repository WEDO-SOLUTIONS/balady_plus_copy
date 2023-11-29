import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';
import 'cemetry_burial_date_gorgian.dart';
import 'cemetry_burial_date_hijri.dart';
import 'cemetry_is_epidamic_widget.dart';
import 'cemetry_previous_next_buttons.dart';
import 'deceased_info_widget.dart';

class CemetryBurialInfoSection extends StatefulWidget {
  const CemetryBurialInfoSection({Key? key}) : super(key: key);

  @override
  State<CemetryBurialInfoSection> createState() =>
      _CemetryBurialInfoSectionState();
}

class _CemetryBurialInfoSectionState extends State<CemetryBurialInfoSection> {
  final deathLocationTextEditController = TextEditingController();
  final deathLocationShipFocusNode = FocusNode();

  // final otherHospitalTextEditController = TextEditingController();
  //final otherHospitalShipFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //  deathLocationTextEditController.dispose();
    //  deathLocationShipFocusNode.dispose();

    // otherHospitalTextEditController.dispose();
    // otherHospitalShipFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
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
                        header:
                            Helpers.translatingWord("cemetry_deceassed_burial"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CemetryreviousNextButtons(
              isBtnDisabled: state.isNextButtonEnabled(),
              onPressed: () {
                context.read<EkramBookCemetryBloc>().add(GoToNextPageEvent());
              },
            )
          ],
        );
      },
    );
  }
}
