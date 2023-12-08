import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/report_damaged_car/presentation/widgets/create_dc_request/details_widgets/plate_number_widget.dart';
import 'package:balady_plus/app/features/report_damaged_car/presentation/widgets/create_dc_request/details_widgets/plate_widget.dart';
import 'package:balady_plus/app/features/report_damaged_car/presentation/widgets/create_dc_request/details_widgets/previous_next_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/enums/border_types.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/extensions/number_text_input_formatter.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../../blocs/create_dc_request/create_dc_details_bloc/create_dc_bloc.dart';

class IncidentCarPlateSection extends StatelessWidget {
  const IncidentCarPlateSection({Key? key}) : super(key: key);

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
                        header: ("dc_vc_plate_details").tr(),
                      ),
                      PlateWidget(
                        arLetters: state.arLetters,
                        arNumbers: state.arNumbers,
                        enNumbers: state.enNumbers,
                        enLetters: state.enLetters,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextFieldWithValueWidget(
                                label: ("dc_vc_plate_number").tr(),
                                borderType: BorderType.outline,
                                onValidate: (String? t) {},
                                value: state.plateDigit ?? "",
                                inputFormatters: [
                                  NumberTextInputFormatter(
                                      onError: (bool isValid) {
                                    //  if (!isValid)
                                    //    CommonFunctions.showError("only_english_numbers".tr());
                                  }),
                                  new LengthLimitingTextInputFormatter(4),
                                ],
                                keyboardType: TextInputType.number,
                                onChanged: (String? text) {
                                  context.read<CreateDCBloc>().add(
                                      ChangeCarDetailsEvent(plateDigit: text));
                                },
                              ),
                            ),
                            SizedBox(width: 32), // Helpers.translatingWord(
                            // "dc_vc_plate_letters")

                            PlateNumberWidget(),
                          ]),
                      CustomVerticalSpace(height: 10),
                      CustomTextFieldWithValueWidget(
                        label: ("dc_vc_chassie").tr(),
                        hintText: ("dc_vc_chassie").tr(),
                        value: state.chassisNumber,
                        onValidate: (String? t) {},
                        onChanged: (String? text) {
                          context
                              .read<CreateDCBloc>()
                              .add(ChangeCarDetailsEvent(chassisNumber: text));
                        },
                      )
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
