import '/app/core/utils/enums/bloc_status.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import '/app/features/select_activity/domain/entities/permits_page_params.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/app/core/utils/constants/language.dart';

import '../../../../core/utils/constants/route_names.dart';
import '../../../_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import '../../../shared_features/widgets/app_bar.dart';
import '../../../shared_features/widgets/check_box_item.dart';
import '../../domain/entities/addetional_activites_page_params.dart';
import '../blocs/addetional_activity_bloc/addetional_activity_bloc.dart';
import '../widgets/title_subtitle_widget.dart';

class AddetionalActivitesPage extends StatefulWidget {
  final ActivityDetailsPageParams params;
  const AddetionalActivitesPage({super.key, required this.params});

  @override
  State<AddetionalActivitesPage> createState() =>
      _AddetionalActivitesPageState();
}

class _AddetionalActivitesPageState extends State<AddetionalActivitesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddetionalActivityBloc>(
      create: (context) => AddetionalActivityBloc(args: widget.params),
      child: BlocBuilder<AddetionalActivityBloc, AddetionalActivityState>(
        buildWhen: (previous, current) =>
            previous.addetionalActivitesStatus !=
                current.addetionalActivitesStatus ||
            previous.status != current.status,
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColor.white,
              appBar: CustomAppBar(
                title: "addetional_activities".tr(),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleSubTitleWidget(
                        title: "select_addetional_activity".tr(),
                        subTitle: "",
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      // const Textfield(),
                      /* const SizedBox(
                        height: 16,
                      ),*/
                      MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              state.addetionalActivitesResponse?.length ?? 0,
                          itemBuilder: (context, index) {
                            return CheckBoxItem(
                              currentValue: state
                                      .addetionalActivitesResponse?[index]
                                      .isSelected ??
                                  false,
                              title: state.addetionalActivitesResponse?[index]
                                      .activityName ??
                                  "",
                              onSelect: (bool? value) {
                                print(value);
                                context.read<AddetionalActivityBloc>().add(
                                    ToggleAddetionalActivity(index: index));
                              },
                            );
                          },
                        ),
                      ),
                      if (state.addetionalActivitesStatus == BlocStatus.failure)
                        ReloadWidget(
                          onTab: () {
                            context
                                .read<AddetionalActivityBloc>()
                                .add(const GetAddetionalActivites());
                          },
                        ),
                      if (state.addetionalActivitesStatus == BlocStatus.loading)
                        const ShimmerVerticalList(),
                      if (state.addetionalActivitesStatus ==
                              BlocStatus.success &&
                          (state.addetionalActivitesResponse?.isEmpty ?? true))
                        Center(
                            child: Text(
                          "no_data_found".tr(),
                          style: AppStyle.heading2BoldStyle,
                        )),
                      SizedBox(
                        height: 64,
                      ),
                      CustomButton(
                          onPress: () {
                            Navigator.pushNamed(context, RouteName.permitsPage,
                                arguments: widget.params.copyWith(
                                    addetionalActivites:
                                        state.addetionalActivitesResponse
                                                ?.map((e) {
                                                  if (e.isSelected == true)
                                                    return e;
                                                })
                                                .toList()
                                                .nonNulls
                                                .toList() ??
                                            []));
                          },
                          text: "next".tr())
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
