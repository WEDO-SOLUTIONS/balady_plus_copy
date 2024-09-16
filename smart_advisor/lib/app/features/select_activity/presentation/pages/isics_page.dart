import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/features/select_activity/domain/entities/activites_page_params.dart';
import '/app/features/select_activity/domain/entities/isics_page_params.dart';
import '/app/features/select_activity/presentation/blocs/isics_bloc/isics_bloc.dart';
import '/app/features/select_activity/presentation/blocs/isics_bloc/isics_event.dart';
import '/app/features/select_activity/presentation/blocs/isics_bloc/isics_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import '../../../shared_features/widgets/app_bar.dart';
import '../widgets/activity_item_card.dart';
import '../widgets/title_subtitle_widget.dart';

class IsicsPage extends StatefulWidget {
  final IsicsPageParams args;
  const IsicsPage({super.key, required this.args});

  @override
  State<IsicsPage> createState() => _IsicsPageState();
}

class _IsicsPageState extends State<IsicsPage> {
  String query = "";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IsicsBloc(args: widget.args),
      child: BlocConsumer<IsicsBloc, IsicsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          List<LookUpItem>? items = state.isics ?? [];
          items = items
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
                title: widget.args.rubric.name,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleSubTitleWidget(
                          title: "اختر من ${widget.args.rubric.name}",
                          subTitle: ""),
                      const SizedBox(
                        height: 16,
                      ),
                      Textfield(
                        onChanged: (String? str) {
                          setState(() {
                            query = str ?? "";
                          });
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (state.isicsStatus == BlocStatus.success)
                        MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: items.length ?? 0,
                            itemBuilder: (context, index) {
                              return ActivityItemCard(
                                id: items?[index].id.toString() ?? "",
                                name: items?[index].name ?? "",
                                index: index,
                                onPress: () {
                                  NavigationService.navigatorKey.currentState!
                                      .pushNamed(RouteName.activitesPage,
                                          arguments: ActivitesPageParams(
                                              isic: items![index]));
                                },
                              );
                            },
                          ),
                        ),
                      if (state.isicsStatus == BlocStatus.failure)
                        ReloadWidget(
                          onTab: () {
                            context
                                .read<IsicsBloc>()
                                .add(const GetIsicsEvent());
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
