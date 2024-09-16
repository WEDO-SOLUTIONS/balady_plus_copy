import 'package:smart_advisor/app/core/services/services_exports.dart';

import '../../../_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import '/app/features/select_activity/presentation/blocs/activites_bloc/activites_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/app/core/utils/constants/language.dart';

import '../../../_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import '../../../shared_features/widgets/app_bar.dart';
import '../../domain/entities/activites_page_params.dart';
import '../widgets/activity_item_card.dart';
import '../widgets/title_subtitle_widget.dart';

class ActivitesPage extends StatefulWidget {
  final ActivitesPageParams args;

  const ActivitesPage({super.key, required this.args});

  @override
  State<ActivitesPage> createState() => _ActivitesPageState();
}

class _ActivitesPageState extends State<ActivitesPage> {
  String query = "";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivitesBloc(args: widget.args),
      child: BlocConsumer<ActivitesBloc, ActivitesState>(
        listener: (context, state) {},
        builder: (context, state) {
          List<LookUpItem>? isics = state.isics ?? [];
          isics = isics
              .map((e) {
                if (e.name.contains(query)) return e;
              })
              .nonNulls
              .toList();

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColor.white,
              appBar: CustomAppBar(
                title: widget.args.isic.name,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleSubTitleWidget(
                          title: "اختر من ${widget.args.isic.name}",
                          subTitle: ""),
                      const SizedBox(
                        height: 16,
                      ),
                      Textfield(
                        onChanged: (String str) {
                          setState(() {
                            query = str;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.isics?.length ?? 0,
                          itemBuilder: (context, index) {
                            return ActivityItemCard(
                              id: state.isics![index].id.toString(),
                              name: state.isics![index].name,
                              index: index,
                              onPress: () {
                                print("HH");
                                NavigationService.navigatorKey.currentState!
                                    .popAndPushNamed(RouteName.mapPage,
                                        arguments: ActivityDetailsPageParams(
                                            activityId: state.isics![index]));
                              },
                            );
                          },
                        ),
                      ),
                      if (state.isicsStatus == BlocStatus.failure)
                        ReloadWidget(
                          onTab: () {
                            context
                                .read<ActivitesBloc>()
                                .add(const GetActivitesEvent());
                          },
                        ),
                      if (state.isicsStatus == BlocStatus.loading)
                        const ShimmerVerticalList(),
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
