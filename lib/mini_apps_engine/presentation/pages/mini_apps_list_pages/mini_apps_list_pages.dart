import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/animations/staggered_appear.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/general_error_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/apps_group_section_shimmer_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/mini_apps_fav_section_shimmer_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/mini_apps_most_used_section_shimmer_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/page_bar_shimmer_loading_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/apps_group_page.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/apps_group_section_widgets/custom_larg_more_apps.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/fav_section_widgets/custom_dashed_add_mini_app_fav.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/fav_section_widgets/custom_mini_apps_card.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_dashed_line_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_sub_heading_text.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/page_bar_section_widgets/custom_text_field.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/mini_apps_search_page/mini_apps_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class HomeMiniAppsListPages extends StatelessWidget {
  const HomeMiniAppsListPages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewMiniAppLogicCubit>.value(
      value: sl<NewMiniAppLogicCubit>()..loadMiniApps(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
          builder: (context, state) {
            final hasError =
                state.entryPointsError != null && state.favError != null;

            if (hasError) {
              return GeneralErrorWidget(
                error: state.favError ?? state.entryPointsError!,
              );
            }
            return RefreshIndicator(
              color: const Color(0xFF1CA9A6),
              onRefresh: () =>
                  context.read<NewMiniAppLogicCubit>().refreshMiniApps(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.04,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //! Page bar section (Title & Text field widgets) ....
                        BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                          builder: (context, state) {
                            if (state.isFavLoading) {
                              return const PageBarShimmerLoadingWidget();
                            }
                            return StaggeredAppear(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: context.w(175),
                                          height: context.h(40),
                                          child: AutoSizeText(
                                            "quick_apps".tr(),
                                            maxLines: 1,
                                            minFontSize: 25,
                                            maxFontSize: 30,
                                            overflow: TextOverflow.visible,
                                            style: const TextStyle(
                                              color: Color(0xFF1CA9A6),
                                              fontWeight: FontWeight.w700,
                                              fontFamily:
                                                  GeneralKey.appFontType,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: context.w(175),
                                          height: context.h(40),
                                          child: AutoSizeText(
                                            "one_place".tr(),
                                            maxLines: 1,
                                            minFontSize: 25,
                                            maxFontSize: 30,
                                            overflow: TextOverflow.visible,
                                            style: const TextStyle(
                                              color: Color(0xFF1CA9A6),
                                              fontWeight: FontWeight.w700,
                                              fontFamily:
                                                  GeneralKey.appFontType,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    MiniAppsCustomTextField(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            opaque: false,
                                            barrierColor: Colors.transparent,
                                            pageBuilder: (_, __, ___) =>
                                                const MiniAppsSearchPage(),
                                          ),
                                        );
                                      },
                                      isEnabled: false,
                                      isReadOnly: true,
                                      width: context.w(150),
                                      height: context.h(48),
                                      keyboardType: TextInputType.text,
                                      suffixString: Text(
                                        "search2".tr(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      suffixIcon:
                                          SvgPicture.asset(IconPath.searchSVG),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        //!
                        SizedBox(height: context.screenHeight * 0.02),
                        //! Fav apps section (Fav title & show and add fav apps) ....
                        BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                          builder: (context, state) {
                            if (state.isFavLoading) {
                              return const MiniAppsFavSectionShimmerWidget();
                            }

                            return StaggeredAppear(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomSubHeadingText(
                                      text: "my_favorite_apps".tr(),
                                      width: context.w(170),
                                      height: context.h(33),
                                    ),
                                    SizedBox(
                                        height: context.screenHeight * 0.02),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CustomDashedAddMiniAppFav(),
                                        SizedBox(
                                            width: context.screenWidth * 0.04),
                                        SizedBox(
                                          height: context.screenHeight * 0.13,
                                          width: context.screenWidth * 0.70,
                                          child: ReorderableListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                state.favoriteApps.length,
                                            onReorder: (oldIndex, newIndex) {
                                              context
                                                  .read<NewMiniAppLogicCubit>()
                                                  .reorderFavoriteApps(
                                                    oldIndex,
                                                    newIndex,
                                                  );
                                            },
                                            itemBuilder: (context, index) {
                                              final favMiniApp =
                                                  state.favoriteApps[index];

                                              return Padding(
                                                key: Key(favMiniApp.id),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      context.screenWidth *
                                                          0.03,
                                                ),
                                                child: CustomMiniAppsCard(
                                                  key: Key(favMiniApp.id),
                                                  width: context.screenWidth *
                                                      0.14,
                                                  titlesWidth:
                                                      context.screenWidth *
                                                          0.14,
                                                  onTap: () {
                                                    context
                                                        .read<
                                                            NewMiniAppLogicCubit>()
                                                        .openMiniApp(
                                                            favMiniApp);
                                                  },
                                                  text: favMiniApp.name,
                                                  titlesHeight:
                                                      context.screenHeight *
                                                          0.05,
                                                  maxLines: 2,
                                                  maxFontSize: 20,
                                                  minFontSize: 9,
                                                  miniAppIcon:
                                                      favMiniApp.iconPath,
                                                  child:
                                                      CustomNetworkImageWidget(
                                                    favMiniApp.iconPath,
                                                    isVerifyingKey: true,
                                                    imageFit: BoxFit.contain,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //todo: open promo mini app from static data
                                        final miniApp = MiniApp.fromJson({
                                          "id":
                                              "76fdfee4-4086-436c-2e59-08de371bca28",
                                          "serviceName": "Emtithal Map",
                                          "description": "BaladyUrbiImtithal",
                                          "entity":
                                              "0d75ade9-62b9-450b-c606-08dd8d47ec0f",
                                          "logoKey":
                                              "https://apiservicesstg.balady.gov.sa/v1/balady-mini-apps/download/logo_c96414fc-6578-407b-a2c3-6b2ae1cf1bbc.png",
                                          "serviceKey": "BaladyUrbiImtithal",
                                          "parentServiceKey": null,
                                          "cdnLogoRef":
                                              "logo_c96414fc-6578-407b-a2c3-6b2ae1cf1bbc.png",
                                          "attachmentConfiguration": "CDN",
                                          "serviceOrder": null,
                                          "portNumber": 2546,
                                          "haveChilds": false,
                                          "isChild": false,
                                          "requirements": [],
                                          "entryPoints": [],
                                          "categories": [
                                            {
                                              "id":
                                                  "6f736c81-c998-4c3e-09ea-08de2cce6088",
                                              "name": "Business Municipal Apps",
                                              "categoryOrder": null,
                                              "serviceOrderByCategory": null
                                            },
                                            {
                                              "id":
                                                  "124a4dd1-7a7b-47f1-09eb-08de2cce6088",
                                              "name":
                                                  "Individual Municipal Apps",
                                              "categoryOrder": null,
                                              "serviceOrderByCategory": null
                                            }
                                          ],
                                          "childDeepLinkUrl": null,
                                          "latestVersion": {
                                            "id":
                                                "b9d25306-522a-4bc3-9b79-08de371b7e8c",
                                            "versionDescription":
                                                "EMTITHAL MAP",
                                            "versionNumber": "v1.0.4",
                                            "serviceUrl":
                                                "https://gisappstg.momra.gov.sa/BaladyUrbiImtithal",
                                            "nafathLogin": false,
                                            "otpLogin": false,
                                            "forceUpdate": false,
                                            "status": 3,
                                            "packageMetaDataDto": null,
                                            "webPackageMetaDataDto": null,
                                            "androidPackageMetaDataDto": null,
                                            "iosPackageMetaDataDto": null,
                                            "deepLinkDto": null,
                                            "type": 1,
                                            "notes": null
                                          },
                                          "childServices": null,
                                          "parentService": null,
                                          "serviceCategoryOrder": 0,
                                          "serviceEntryPointOrder": 0,
                                          "nafathLogin": false,
                                          "otpLogin": false
                                        });

                                        context
                                            .read<NewMiniAppLogicCubit>()
                                            .openMiniApp(
                                              miniApp,
                                            );
                                      },
                                      child: Image.asset(
                                          "assets/icons/png/${CommonFunctions.isAppAR ? 'promoAr.png' : 'promoEn.png'}"),
                                    )
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        //!
                        SizedBox(height: context.screenHeight * 0.02),
                        const CustomDashedLineWidget(),
                        SizedBox(height: context.screenHeight * 0.02),
                        //! Most used apps section
                        BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                          builder: (context, state) {
                            if (state.isEntryPointsLoading) {
                              return const MiniAppsMostUsedSectionShimmerWidget();
                            }

                            if (state.entryPoints.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            return StaggeredAppear(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                              height:
                                                  context.screenHeight * 0.02),
                                      itemCount: state.entryPoints.length,
                                      itemBuilder: (context, index) {
                                        final section =
                                            state.entryPoints[index];
                                        final apps = section.apps;

                                        if (apps.isEmpty) {
                                          return const SizedBox.shrink();
                                        }

                                        final title = CommonFunctions.isAppAR
                                            ? section.arName
                                            : section.enName;

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomSubHeadingText(
                                              text: title,
                                            ),
                                            SizedBox(
                                                height: context.screenHeight *
                                                    0.01),
                                            SizedBox(
                                                height: context.screenHeight *
                                                    0.01),
                                            SizedBox(
                                              height:
                                                  context.screenHeight * 0.20,
                                              width: context.screenWidth,
                                              child: ListView.separated(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                separatorBuilder:
                                                    (context, i) => SizedBox(
                                                  width: context.screenWidth *
                                                      0.02,
                                                ),
                                                itemCount: apps.length,
                                                itemBuilder:
                                                    (context, appIndex) {
                                                  final miniApp =
                                                      apps[appIndex];

                                                  return CustomMiniAppsCard(
                                                    width: context.screenWidth /
                                                        3.8,
                                                    height: context.h(104),
                                                    iconHeight: context.h(64),
                                                    iconWidth: context.w(64),
                                                    titlesHeight: context.h(47),
                                                    titlesWidth:
                                                        context.screenWidth /
                                                            3.8,
                                                    maxLines: 3,
                                                    maxFontSize: 20,
                                                    minFontSize: 8,
                                                    withCardEffect: true,
                                                    text: miniApp.name,
                                                    miniAppIcon:
                                                        miniApp.iconPath,
                                                    onTap: () {
                                                      context
                                                          .read<
                                                              NewMiniAppLogicCubit>()
                                                          .openMiniApp(miniApp);
                                                    },
                                                    child:
                                                        CustomNetworkImageWidget(
                                                      miniApp.iconPath,
                                                      isVerifyingKey: true,
                                                      imageWidth: context.w(42),
                                                      imageHeight:
                                                          context.h(42),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        //!
                        SizedBox(height: context.screenHeight * 0.02),
                        const CustomDashedLineWidget(),
                        SizedBox(height: context.screenHeight * 0.02),
                        //! Apps group section
                        BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                          builder: (context, state) {
                            if (state.isAppsGroupLoading) {
                              return const AppsGroupSectionShimmerWidget();
                            }

                            // Separate regular groups from "Other Services"
                            final regularGroups = state.appGroups
                                .where((group) =>
                                    group.id != 'other_services_group')
                                .toList();

                            final otherServicesGroup =
                                state.appGroups.firstWhere(
                              (group) => group.id == 'other_services_group',
                            );

                            return StaggeredAppear(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Regular groups (2+ apps)
                                    GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: regularGroups.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing:
                                            context.screenHeight * 0.02,
                                        crossAxisSpacing:
                                            context.screenWidth * 0.04,
                                        childAspectRatio: 0.8,
                                      ),
                                      itemBuilder: (context, index) {
                                        final appGroup = regularGroups[index];
                                        final groupName =
                                            CommonFunctions.isAppAR
                                                ? appGroup.nameAr
                                                : appGroup.nameEn;

                                        return CustomLargMoreApps(
                                          withCardEffect: true,
                                          text: groupName,
                                          apps: appGroup.apps,
                                          totalAppCount: appGroup.appCount,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                opaque: false,
                                                barrierColor:
                                                    Colors.transparent,
                                                pageBuilder: (_, __, ___) =>
                                                    AppsGroupPage(
                                                        appGroup: appGroup),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),

                                    // Show dashed line and "Other Services" only if it exists
                                    if (otherServicesGroup.apps.isNotEmpty) ...[
                                      SizedBox(
                                          height: context.screenHeight * 0.02),
                                      const CustomDashedLineWidget(),
                                      SizedBox(
                                          height: context.screenHeight * 0.02),

                                      // "Other Services" group
                                      GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            1, // Only "Other Services" group
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing:
                                              context.screenHeight * 0.02,
                                          crossAxisSpacing:
                                              context.screenWidth * 0.04,
                                          childAspectRatio: 0.8,
                                        ),
                                        itemBuilder: (context, index) {
                                          final groupName =
                                              CommonFunctions.isAppAR
                                                  ? otherServicesGroup.nameAr
                                                  : otherServicesGroup.nameEn;

                                          return CustomLargMoreApps(
                                            withCardEffect: true,
                                            text: groupName,
                                            apps: otherServicesGroup.apps,
                                            totalAppCount:
                                                otherServicesGroup.appCount,
                                            onTap: () {
                                              Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  opaque: false,
                                                  barrierColor:
                                                      Colors.transparent,
                                                  pageBuilder: (_, __, ___) =>
                                                      AppsGroupPage(
                                                          appGroup:
                                                              otherServicesGroup),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            );
                          },
                        )
                      ],
                    ),
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
