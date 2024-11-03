import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/core/utils/enums/bloc_status.dart';
import 'package:smart_advisor/app/features/home_page/presentation/search_bloc/search_bloc.dart';
import 'package:smart_advisor/app/features/home_page/presentation/search_bloc/search_state.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/app_bar.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../_shared_feature_/domain/entities/lookUp_response.dart';
import '../../../_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import '../../../select_activity/domain/entities/activites_page_params.dart';
import '../../../select_activity/presentation/widgets/activity_item_card.dart';
import '../search_bloc/search_event.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => SearchBloc(),
        child: BlocConsumer<SearchBloc, SearchState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: CustomAppBar(
                title: "ابحث عن منشاه ",
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Textfield(
                        onChanged: (String? str) {
                          // If there's an active debounce, cancel it
                          if (_debounce?.isActive ?? false) _debounce?.cancel();

                          _debounce =
                              Timer(const Duration(milliseconds: 500), () {
                            // This will be called after the user stops typing for 500ms
                            context
                                .read<SearchBloc>()
                                .add(SearchIsicEvent(keyword: str ?? ""));
                          });
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Stack(
                        children: [
                          if (state.sectors?.isNotEmpty ?? false)
                            MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: state.sectors?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return ActivityItemCard(
                                    isSelected: false,
                                    id: state.sectors?[index].id.toString() ??
                                        "",
                                    name: state.sectors?[index].isicNameAr
                                            .toString() ??
                                        "",
                                    index: index,
                                    onPress: () {
                                      NavigationService
                                          .navigatorKey.currentState!
                                          .pushNamed(RouteName.activitesPage,
                                              arguments: ActivitesPageParams(
                                                  sector: LookUpItem(
                                                      id: 1, name: ""),
                                                  isic: LookUpItem(
                                                      id: int.tryParse(state
                                                                  .sectors![
                                                                      index]
                                                                  .isicCode ??
                                                              "") ??
                                                          0,
                                                      name: state
                                                              .sectors![index]
                                                              .isicNameAr ??
                                                          "")));
                                    },
                                  );
                                },
                              ),
                            ),
                          if (state.sectors?.isEmpty ?? true) ...[
                            Column(
                              children: [
                                const SizedBox(
                                  height: 120,
                                ),
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
                                  'ابحث عن كل المنشآت التي ترغب في الاستعلام عنها',
                                  textAlign: TextAlign.center,
                                  style: AppStyle.textRegularRomanStyle
                                      .copyWith(color: const Color(0xFF566069)),
                                ),
                              ],
                            )
                          ],
                          if (state.sectorStatus == BlocStatus.loading)
                            Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: AppColor.statusAccentColor,
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
