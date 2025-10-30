import 'package:smart_advisor/app/core/services/services_exports.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/custom_background_header.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/pages/search_page.dart';

import '../../../_shared_feature_/domain/entities/lookUp_response.dart';
import '../../../_shared_feature_/presentation/widgets/shimmer_card copy.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import '/app/features/select_activity/presentation/blocs/activites_bloc/activites_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/app/core/utils/constants/language.dart';
//import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

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
    return BlocProvider<ActivitesBloc>(
      create: (context) => ActivitesBloc(args: widget.args),
      child: BlocBuilder<ActivitesBloc, ActivitesState>(
          buildWhen: (previous, current) =>
              previous.isicsStatus != current.isicsStatus,
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
                backgroundColor: const Color(0xFFF4F6FB),
                body: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CustomImageAppBar(
                      title: "النشاط",
                      onSearch: (String? t) {
                        setState(() {
                          query = t ?? "";
                        });
                      },
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          if (state.isicsStatus == BlocStatus.failure)
                            ReloadWidget(
                              onTab: () {
                                context
                                    .read<ActivitesBloc>()
                                    .add(const GetActivitesEvent());
                              },
                            ),
                          if (state.isicsStatus == BlocStatus.loading)
                            const Shimmer2VerticalList(),
                          if (state.isicsStatus == BlocStatus.success)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "اختر النشاط",
                                      style: AppStyle.heading2BoldStyle,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    MediaQuery.removePadding(
                                      removeTop: true,
                                      context: context,
                                      child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: items.length ?? 0,
                                        itemBuilder: (context, index) {
                                          return ActivityItemCard(
                                            isSelected: false,
                                            id: items?[index].id.toString() ??
                                                "",
                                            name: items?[index].name ?? "",
                                            index: index,
                                            onPress: () async {
                                              /*   bool isSuccess =
                                                  await BaladyServices
                                                      .checkLocationSettings(
                                                          context);
                                              if (isSuccess) {*/
                                              NavigationService
                                                  .navigatorKey.currentState!
                                                  .popAndPushNamed(
                                                      RouteName.mapPage,
                                                      arguments:
                                                          ActivityDetailsPageParams(
                                                              sector: widget
                                                                  .args.sector,
                                                              activityId:
                                                                  state.isics![
                                                                      index]));
                                              //  }
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (items.isEmpty &&
                              state.isicsStatus == BlocStatus.success) ...[
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "packages/smart_advisor/smart_advisor_assets/images/searchimg.png",
                                    height: 122,
                                    width: 150,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'نتائج البحث',
                                    style: AppStyle.calloutBoldStyle.copyWith(
                                        color: AppColor.textPrimaryColor),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "لا يوجد",
                                    textAlign: TextAlign.center,
                                    style: AppStyle.textRegularRomanStyle
                                        .copyWith(
                                            color: const Color(0xFF566069)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
