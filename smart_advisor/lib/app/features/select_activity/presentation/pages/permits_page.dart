import 'package:smart_advisor/app/features/select_activity/presentation/widgets/button_bottom.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../_shared_feature_/presentation/widgets/shimmer_card copy.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import '/app/features/select_activity/domain/entities/permits_activites_response.dart';
import '/app/features/select_activity/presentation/blocs/permits_bloc/permits_bloc.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/app/core/utils/constants/language.dart';
import '../../../_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import '../../../shared_features/widgets/app_bar.dart';
import '../../domain/entities/permits_page_params.dart';
import '../widgets/permit_item_card.dart';
import '../widgets/title_subtitle_widget.dart';

class PermitsPage extends StatefulWidget {
  final ActivityDetailsPageParams args;
  const PermitsPage({super.key, required this.args});

  @override
  State<PermitsPage> createState() => _PermitsPageState();
}

class _PermitsPageState extends State<PermitsPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PermitsBloc>(
      create: (context) => PermitsBloc(args: widget.args),
      child: BlocBuilder<PermitsBloc, PermitsState>(
        buildWhen: (previous, current) =>
            previous.permitsStatus != current.permitsStatus ||
            previous.status != current.status,
        builder: (context, state) {
          Map<String, List<PermitItem>> permits = state.getPermits();

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColor.white,
              appBar: const CustomAppBar(
                title: "التصاريح",
              ),
              body: Container(
                color: AppColor.surfaceSecondaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, right: 16, left: 16),
                      child: SizedBox(
                        height: 400,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TitleSubTitleWidget(
                                title: "إختر التصاريح التي ترغب في إصدارها",
                                subTitle:
                                    "اختر نوع المنشأة الذي ترغب في الاستعلام عنه من القائمة",
                              ),
                              if (state.permitsStatus ==
                                  BlocStatus.success) ...[
                                MediaQuery.removePadding(
                                  removeTop: true,
                                  context: context,
                                  child: Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: permits.keys.length,
                                      itemBuilder: (context, index) {
                                        String key =
                                            permits.keys.toList()[index];

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            Text(
                                              permits[key]![0]
                                                      .detailedActivityName ??
                                                  "",
                                              style: AppStyle
                                                  .textRegularRomanStyle,
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            MediaQuery.removePadding(
                                                removeTop: true,
                                                context: context,
                                                child: ListView.builder(
                                                    physics:
                                                        const AlwaysScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        permits[key]!.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return PermitItemCard(
                                                        currentValue: permits[
                                                                    key]![index]
                                                                .isSelected ??
                                                            false,
                                                        isFreeOfCharge: permits[
                                                                    key]![index]
                                                                .isFreeOfCharge ??
                                                            false,
                                                        title:
                                                            permits[key]![index]
                                                                    .name ??
                                                                "",
                                                        onSelect:
                                                            (bool? value) {
                                                          context
                                                              .read<
                                                                  PermitsBloc>()
                                                              .add(TogglePermitEvent(
                                                                  index: permits[
                                                                              key]![
                                                                          index]
                                                                      .order!));
                                                        },
                                                      );
                                                    }))
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                              if (state.permitsStatus == BlocStatus.failure)
                                ReloadWidget(
                                  onTab: () {
                                    context
                                        .read<PermitsBloc>()
                                        .add(const GetPermitsEvent());
                                  },
                                ),
                              if (state.permitsStatus == BlocStatus.loading)
                                const Expanded(child: Shimmer2VerticalList()),
                            ]),
                      ),
                    ),
                    ButtonBottomWidget(
                      onPress: () {
                        NavigationService.navigatorKey.currentState!
                            .pushNamed(RouteName.activityDetails,
                                arguments: widget.args.copyWith(
                                    permits: state.permits
                                            ?.map((e) {
                                              if (e.isSelected == true) {
                                                return e;
                                              }
                                            })
                                            .toList()
                                            .nonNulls
                                            .toList() ??
                                        []));
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
