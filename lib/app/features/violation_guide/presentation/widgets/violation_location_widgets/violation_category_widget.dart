import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../bloc/violation_bloc.dart';
import '../../bloc/violation_event.dart';
import '../../pages/map/bloc/map_bloc.dart';

class ViolationCategoryWidget extends StatelessWidget {
  const ViolationCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationBloc, ViolationState>(
        builder: (context, state) {
      return state.classificationStatus == BlocStatus.success
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.grayLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      state.violationClassificationResponse?.municipalityName ??
                          "",
                      textStyle: AppStyle.violationLocationDammamMapStyle,
                    ),
                    CustomTextWidget(
                      state.violationClassificationResponse
                              ?.classificationName ??
                          "",
                      textStyle: AppStyle.violationLocationCategoryMapStyle,
                    )
                  ]),
            )
          : state.classificationStatus == BlocStatus.failure
              ? ReloadWidget(onTab: () {
                  context
                      .read<ViolationBloc>()
                      .add(const GetViolationGuideClassificationsEvents());
                })
              : Container();
    });
  }
}
