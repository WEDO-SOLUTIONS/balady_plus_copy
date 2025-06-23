import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/expandable_with_controller_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class LocationInfoConclusionWidget extends StatelessWidget {
  final ChooseMuncipalityState state;

  const LocationInfoConclusionWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ExpandableWithControllerWidget(
      controller: ExpandableController(),
      title: 'location'.tr(),
      expanded: Column(
        children: [
          CardParameter(
            title: 'license_health_municipality'.tr(),
            value: state.requestData?.municipality?.name ?? "",
          ),
          CardParameter(
            title: 'city'.tr(),
            value: state.requestData?.city?.name ?? "",
          ),
          CardParameter(
            title: 'district'.tr(),
            value: state.requestData?.district?.name ?? "",
          ),
        ],
      ),
    );
  }
}
