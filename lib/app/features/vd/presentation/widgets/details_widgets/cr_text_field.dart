import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/check_boxes/text_field_with_check_btn.dart';

class CRTextField extends StatefulWidget {
  CRTextField();

  @override
  State<CRTextField> createState() => _CRTextFieldState();
}

class _CRTextFieldState extends State<CRTextField> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVDBloc, CreateVDState>(
      builder: (context, state) {
        return TextWithCheckBtn(
          controller: controller,
          maxLength: 10,
          validate: (String? t) {
            if ((t?.length ?? 0) < 10 || (t?.length ?? 0) > 10) {
              return ("cr_number_error_msg_length").tr();
            }
          },
          isValidate: state.isCrValid ?? false,
          currentValue: state.crNumber,
          onTextChanged: (String text) {
            context
                .read<CreateVDBloc>()
                .add(ChangeCrNumberEvent(crNumber: text));
          },
          title: ("cr_numbber").tr(),
          verify: () {
            context.read<CreateVDBloc>().add(VerifyCrNumberEvent());
          },
          //currentValue: "ww",
          hint: ("cr_hint").tr(),
        );
      },
    );
  }
}
