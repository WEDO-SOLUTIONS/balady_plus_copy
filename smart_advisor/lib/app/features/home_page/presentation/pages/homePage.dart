import 'package:smart_advisor/app/core/services/services_exports.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/shimmer_card%20copy.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../select_activity/domain/entities/activity_details_page_params.dart';
import '../../../shared_features/widgets/custom_button.dart';
import '../widgets/recently_card.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/_shared_feature_/presentation/models/grideViewModel.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/home_page/presentation/bloc/home_bloc.dart';
import '/app/features/home_page/presentation/bloc/home_event.dart';
import '/app/features/home_page/presentation/bloc/home_state.dart';
import '/app/features/home_page/presentation/widgets/home_sector_card_item.dart';
import '/app/features/home_page/presentation/widgets/chat_bot_widget.dart';
import '/app/features/home_page/presentation/widgets/home_header.dart';
import '/app/features/select_activity/domain/entities/categories_page_params.dart';
import '/app/core/utils/constants/language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<ActivityDetailsPageParams> list = sharedPrefs.getRecentlyOpened();
    //List<ActivityDetailsPageParams> list = [];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => HomeBloc(),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Stack(
              children: [
                Scaffold(
                  backgroundColor: const Color(0xFFF4F6FB),
                  body: Column(
                    children: [
                      const HomeHeader(),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: 24),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "اختر نوع المحل",
                                  style: GoogleFonts.cairo(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                if (state.sectorStatus ==
                                    BlocStatus.success) ...[
                                  MediaQuery.removePadding(
                                    removeTop: true,
                                    removeBottom: true,
                                    context: context,
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          (state.sectors?.length ?? 0) >= 4 &&
                                                  list.isNotEmpty
                                              ? 4
                                              : (state.sectors?.length ?? 0),
                                      itemBuilder: (context, index) {
                                        return HomeSectorCardItem(
                                          animation: 0,
                                          item: GrideViewModel(
                                              icon:
                                                  "packages/smart_advisor/smart_advisor_assets/icons/svg/${state.sectors?[index].id}.svg",
                                              sector:
                                                  state.sectors?[index].name ??
                                                      "",
                                              category: ""),
                                          onPress: () {
                                            NavigationService
                                                .navigatorKey.currentState!
                                                .pushNamed(
                                                    RouteName.categoriesPage,
                                                    arguments:
                                                        CategoriesPageParams(
                                                            sector:
                                                                state.sectors![
                                                                    index]));
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  if (list.isNotEmpty) ...[
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomButton(
                                        btnHeight: 48,
                                        btnColor: Colors.transparent,
                                        textColor: AppColor.statusAccentColor,
                                        btnBorderWidth: 1.2,
                                        btnBorderColor:
                                            AppColor.statusAccentColor,
                                        onPress: () {
                                          NavigationService
                                              .navigatorKey.currentState!
                                              .pushNamed(RouteName.sectors);
                                        },
                                        text: "browse_all_sectors".tr()),
                                    const SizedBox(height: 16),
                                  ],
                                ],
                                if (state.sectorStatus == BlocStatus.failure)
                                  ReloadWidget(
                                    onTab: () {
                                      context
                                          .read<HomeBloc>()
                                          .add(GetSectorEvent());
                                    },
                                  ),

                                if (state.sectorStatus == BlocStatus.loading)
                                  const Shimmer2VerticalList(),

                                // VdCard(),
                                //const SizedBox(height: 16),

                                if (list.isNotEmpty) ...[
                                  Text(
                                    ("recently").tr(),
                                    style: GoogleFonts.cairo(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 92,
                                    child: MediaQuery.removePadding(
                                      removeTop: true,
                                      removeBottom: true,
                                      context: context,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: list.length ?? 0,
                                          itemBuilder: (context, index) {
                                            return HomeRecentCard(
                                                animation: 0,
                                                item: list[index],
                                                onPress: () {
                                                  NavigationService.navigatorKey
                                                      .currentState!
                                                      .pushNamed(
                                                          RouteName
                                                              .activityDetails,
                                                          arguments:
                                                              list[index]);
                                                });
                                          }),
                                    ),
                                  ),
                                  const SizedBox(height: 150),
                                ]
                                //
                                //
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const ChatBotWidget()
              ],
            );
          },
        ),
      ),
    );
  }
}
