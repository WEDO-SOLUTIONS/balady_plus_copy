import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../blocs/retrieve_vehicles_bloc/retrieve_vehicles_bloc.dart';

class CarCrField extends StatelessWidget {
  const CarCrField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RetrieveVehiclesBloc, RetrieveVehiclesState>(
      builder: (context, state) {
        return CustomTextFieldWithValueWidget(
          label: ("dc_cr_number").tr(),
          hintText: ("dc_cr_number").tr(),
          value: state.crNumber,
          keyboardType: TextInputType.number,
          inputFormatters: [],
          onChanged: (String? text) {
            context
                .read<RetrieveVehiclesBloc>()
                .add(ChangeFieldsEvent(crNumber: text));
          },
          onValidate: (String? t) {},
        );
      },
    );
  }
}
