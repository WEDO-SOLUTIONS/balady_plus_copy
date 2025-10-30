import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/pages/violation_results_page.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_location_widgets/violation_address_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_location_widgets/violation_category_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_location_widgets/violation_establishment_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_location_widgets/violation_title_location_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../vd/domain/entities/map/map_screen_params.dart';
import '../../bloc/violation_bloc.dart';
import '../../bloc/violation_event.dart';
import '../../bloc/violation_state.dart';
import '../../pages/map/bloc/map_bloc.dart';
import '../../pages/map/page/cr_map_page.dart';

class ViolationLocationListWidget extends StatelessWidget {
  const ViolationLocationListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationBloc, ViolationState>(
        builder: (context, state1) {
      return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    const ViolationLocationTitleWidget(),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (ctx) {
                              return BlocProvider.value(
                                  value: context.read<MapBloc>(),
                                  child: CRMapScreen());
                            }),
                          ).then((value) {
                            if (value != null) {
                              MapScreenParams? params =
                                  value as MapScreenParams;
                              context.read<MapBloc>().emit(state.copyWith(
                                    gisResponse: params.gisResponse,
                                    location: params.gisParams,
                                  ));
                              context.read<ViolationBloc>().add(
                                  GetViolationGuideClassificationsEvents(
                                      location: params.gisParams));
                            }
                          });
                        },
                        child: const ViolationAddressSectionWidget()),
                    const SizedBox(
                      height: 12,
                    ),
                    const ViolationCategoryWidget(),
                    const SizedBox(height: 16),
                    if (state1.violatorItem?.violatorIdNumber != null &&
                        state1.violatorItem?.violatorIdNumber != "003")
                      const ViolationEstabloshmentWidget(),
                    const SizedBox(height: 50),
                    ElevatedButtonWidget.custom(
                      text: 'result-1'.tr(),
                      isDisabled: !state1.isFormValid(),
                      onPressed: () {
                        context
                            .read<ViolationBloc>()
                            .add(const GetRegulationClausess());
                      },
                    ),
                  ]),
            ),
          ],
        );
      });
    });
  }
}
