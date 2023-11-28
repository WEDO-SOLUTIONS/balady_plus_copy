import 'package:flutter/material.dart';

import '../../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../ekram_status_widget.dart';

class DeceassedInfoWidget extends StatelessWidget {
  final String? name;
  final String? gender;
  final String? nationality;
  final String? religion;
  const DeceassedInfoWidget(
      {super.key, this.gender, this.name, this.nationality, this.religion});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      color: AppColor.grayLight,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 2,
                  child: EkramHeaderAndDescWidget(
                    title: trans('cemetry_deceassed_name'),
                    details: name ?? "",
                  )),
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('cemetry_deceassed_gender'),
                details: gender ?? "",
              )),
            ],
          ),
          CustomVerticalSpace(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 2,
                  child: EkramHeaderAndDescWidget(
                    title: trans('cemetry_deceassed_nationality'),
                    details: nationality ?? "",
                  )),
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('cemetry_deceassed_religion'),
                details: religion ?? "",
              )),
            ],
          ),
        ],
      ),
    );
  }
}
