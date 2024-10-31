import '../../../../core/services/local/navigation_services.dart';
import '../../../_shared_feature_/presentation/widgets/shimmer_card copy.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/constants/route_names.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/features/select_activity/domain/entities/isics_page_params.dart';
import '/app/features/select_activity/domain/entities/rubrics_page_params.dart';
import '/app/features/select_activity/presentation/blocs/rubrics_bloc/rubrics_bloc.dart';
import '/app/features/select_activity/presentation/blocs/rubrics_bloc/rubrics_event.dart';
import '/app/features/select_activity/presentation/blocs/rubrics_bloc/rubrics_state.dart';
import '/app/features/select_activity/presentation/dialogs/rubric_item.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class RubricDialog extends StatefulWidget {
  final RubricsPageParams args;
  const RubricDialog({super.key, required this.args});

  @override
  State<RubricDialog> createState() => _RubricDialogState();
}

class _RubricDialogState extends State<RubricDialog> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RubricsBloc>(
      create: (context) => RubricsBloc(args: widget.args),
      child: BlocConsumer<RubricsBloc, RubricsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                )),
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top indicator
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: AppColor.surfaceMidContrast,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'اختر من التفاصيل',
                      style: AppStyle.heading2BoldStyle
                          .copyWith(color: AppColor.textPrimaryColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigationService.navigatorKey.currentState!.pop();
                      },
                      child: SvgPicture.asset(
                          "packages/smart_advisor/smart_advisor_assets/icons/svg/Button.svg"),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                if (state.rubricsStatus == BlocStatus.success)
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: state.rubrics?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      LookUpItem item = state.rubrics![index];
                      return RubricItem(
                        title: item.name,
                        isSelected: selectedIndex == index,
                        onPressed: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      );
                    },
                  ),
                if (state.rubricsStatus == BlocStatus.failure)
                  ReloadWidget(
                    onTab: () {
                      context.read<RubricsBloc>().add(const GetRubricsEvent());
                    },
                  ),
                if (state.rubricsStatus == BlocStatus.loading)
                  const Shimmer2VerticalList(
                    height: 60,
                    count: 2,
                  ),

                CustomButton(
                    btnColor: selectedIndex != -1
                        ? AppColor.primary
                        : AppColor.surfaceLowContrast,
                    textColor: selectedIndex != -1
                        ? AppColor.white
                        : AppColor.surfaceHighContrast,
                    onPress: () {
                      Navigator.pushNamed(
                        context,
                        RouteName.isicsPage,
                        arguments: IsicsPageParams(
                          rubric: state.rubrics![selectedIndex],
                          category: widget.args.category,
                          sector: widget.args.sector,
                        ),
                      );
                    },
                    text: "التالي"),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
