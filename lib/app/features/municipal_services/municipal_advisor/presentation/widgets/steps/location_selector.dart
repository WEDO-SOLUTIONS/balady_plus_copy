import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart'
    show AppStyle, RouteName;
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, ElevatedButtonWidget;
import '../../../municipal_advisor_exports.dart' show MunicipalAdvisorBloc;

class LocationSelector extends StatelessWidget {
  const LocationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        CustomTextWidget(
          'municipalAdvisorLocationHint'.tr(),
          textStyle: AppStyle.subMessageTextStle,
        ),
        const SizedBox(height: 16),
        ElevatedButtonWidget.chooseLocation(
          onPressed: () {
            Navigator.of(context).pushNamed(
              RouteName.locationPage,
              arguments: context.read<MunicipalAdvisorBloc>(),
            );
          },
        ),
      ],
    );
  }
}
