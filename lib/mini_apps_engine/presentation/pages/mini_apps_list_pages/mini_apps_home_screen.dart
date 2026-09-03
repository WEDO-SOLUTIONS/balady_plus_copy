import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/animations/staggered_appear.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/apps_group_section_widgets/custom_larg_more_apps.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/fav_section_widgets/custom_dashed_add_mini_app_fav.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/fav_section_widgets/custom_mini_apps_card.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_sub_heading_text.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/general_error_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/page_bar_section_widgets/custom_text_field.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/apps_group_section_shimmer_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/mini_apps_fav_section_shimmer_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/mini_apps_most_used_section_shimmer_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/mini_apps_search_bar_shimmer_loading_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/momtathel_shimmer_loading_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/overlay_blur_circle.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/apps_group_page.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/add_fav_mini_apps.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/mini_apps_search_page/mini_apps_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_authorization/src/authentication/bloc/authentication_bloc.dart';

class MiniAppsHomeScreen extends StatefulWidget {
  const MiniAppsHomeScreen({super.key});

  @override
  State<MiniAppsHomeScreen> createState() => _MiniAppsHomeScreenState();
}

class _MiniAppsHomeScreenState extends State<MiniAppsHomeScreen> {
  // The app-level BlocProvider serves this same get_it singleton, so callbacks
  // use this field instead of context.read: reorder/refresh callbacks fire
  // after their drop/snap animations, when a loading emit may have already
  // swapped the subtree and left the callback's context defunct.
  late final NewMiniAppLogicCubit _miniAppsCubit;
  StreamSubscription<dynamic>? _authSubscription;

  @override
  void initState() {
    super.initState();

    _miniAppsCubit = sl<NewMiniAppLogicCubit>();
    final authenticationBloc = sl<AuthenticationBloc>();
    if (authenticationBloc.state is UnAuthenticatedState) {
      if (_miniAppsCubit.state.isInitial) {
        _miniAppsCubit.loadMiniApps();
      }
    } else {
      _authSubscription = authenticationBloc.stream.listen((state) {
        if (state is UnAuthenticatedState) {
          if (_miniAppsCubit.state.isInitial) {
            _miniAppsCubit.loadMiniApps();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: CustomSubHeadingText(
          text: "AppsTitle".tr(),
          width: context.screenWidth,
          isTextCenter: true,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const Positioned(top: 0, child: OverlayBlurCircle()),
          BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
            builder: (context, state) {
              final bool isLoading =
                  state.isFavLoading ||
                  state.isUnFavLoading ||
                  state.isAppsGroupLoading ||
                  state.isEntryPointsLoading ||
                  state.isInitial;
              final hasError = state.entryPointsError != null || state.favError != null;

              if (hasError) {
                return GeneralErrorWidget(error: state.favError ?? state.entryPointsError!);
              }

              return RefreshIndicator(
                color: Theme.of(context).primaryColor,
                onRefresh: () async {
                  return _miniAppsCubit.refreshMiniApps();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(top: context.screenWidth * 0.04, bottom: context.screenHeight * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Page bar / header (no real UI placeholder, omitted from shimmer) ──
                          SizedBox(height: context.h(14)),

                          //! ── Search bar ───────────────────────────────────
                          isLoading
                              ? MiniAppsSearchTextFieldShimmer()
                              : MiniAppsCustomTextField(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        opaque: false,
                                        barrierColor: Colors.transparent,
                                        pageBuilder: (_, _, _) => const MiniAppsSearchPage(),
                                      ),
                                    );
                                  },
                                  isReadOnly: true,
                                  height: context.h(48),
                                  keyboardType: TextInputType.text,
                                ),

                          Padding(
                            padding: EdgeInsets.only(
                              left: CommonFunctions.isAppAR ? context.screenWidth * 0.00 : context.screenWidth * 0.04,
                              right: CommonFunctions.isAppAR ? context.screenWidth * 0.04 : context.screenWidth * 0.00,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: context.screenHeight * 0.02),

                                //! ── Favourites section ───────────────────
                                BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                                  buildWhen: (previous, current) =>
                                      previous.isFavLoading != current.isFavLoading ||
                                      previous.isInitial != current.isInitial ||
                                      previous.favoriteApps != current.favoriteApps,
                                  builder: (context, state) {
                                    if (state.isFavLoading || state.isInitial) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const MiniAppsFavSectionShimmerWidget(),
                                          SizedBox(height: context.screenHeight * 0.02),
                                          const MomtathelCardShimmer(), // <-- Added here so it shows during loading!
                                        ],
                                      );
                                    }
                                    return StaggeredAppear(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "my_favorite_apps2".tr(),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: GeneralKey.appFontType,
                                                    color: Theme.of(context).brightness == Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Padding(
                                                  padding: CommonFunctions.isAppAR
                                                      ? const EdgeInsets.only(left: 10)
                                                      : const EdgeInsets.only(right: 10),
                                                  child: CustomTextButtonWidget(
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (_) => BlocProvider.value(
                                                            value: _miniAppsCubit,
                                                            child: const AddFavMiniApps(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    // fontSize: 14,
                                                    btnTextColor: Theme.of(context).primaryColor,
                                                    btnTextWeight: AppFontWeight.regular,
                                                    btnTextSize: 14,
                                                    text: "view_all".tr(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: context.screenHeight * 0.02),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const CustomDashedAddMiniAppFav(),
                                                SizedBox(width: context.screenWidth * 0.04),
                                                Expanded(
                                                  child: Builder(
                                                    builder: (ctx) {
                                                      final textScale = MediaQuery.of(ctx).textScaler.scale(1.0);
                                                      const lines = 3;
                                                      final maxTitleHeightForScale = (56.0 * textScale + 20).clamp(
                                                        70.0,
                                                        115.0,
                                                      );
                                                      final minHeightForLines = (13.0 * 1.4 * lines * textScale + 10)
                                                          .clamp(36.0, maxTitleHeightForScale);
                                                      final defaultTitleHeight = (ctx.h(45) * textScale).clamp(
                                                        minHeightForLines,
                                                        maxTitleHeightForScale,
                                                      );
                                                      final gap = (4.0 * textScale).clamp(4.0, 10.0);
                                                      final gapHeight = ctx.screenHeight * 0.01 + ctx.h(gap);
                                                      final rowHeight = ctx.h(70) + gapHeight + defaultTitleHeight;

                                                      return SizedBox(
                                                        height: rowHeight,
                                                        child: ReorderableListView.builder(
                                                          scrollDirection: Axis.horizontal,
                                                          itemCount: state.favoriteApps.length,
                                                          onReorder: (oldIndex, newIndex) {
                                                            // Fires ~250ms after the drop; ctx may be defunct by then.
                                                            _miniAppsCubit.reorderFavoriteApps(
                                                              oldIndex,
                                                              newIndex,
                                                            );
                                                          },
                                                          itemBuilder: (context, index) {
                                                            final favMiniApp = state.favoriteApps[index];
                                                            return Padding(
                                                              key: Key(favMiniApp.id),
                                                              padding: EdgeInsets.symmetric(
                                                                horizontal: context.screenWidth * 0.0,
                                                              ),
                                                              child: CustomMiniAppsCard(
                                                                key: Key(favMiniApp.id),
                                                                width: context.screenWidth * 0.14,
                                                                onTap: () {
                                                                  _miniAppsCubit.openMiniApp(
                                                                    favMiniApp,
                                                                  );
                                                                },
                                                                text: favMiniApp.name,
                                                                titlesHeight: defaultTitleHeight,
                                                                maxLines: 3,
                                                                maxFontSize: 20,
                                                                minFontSize: 9,
                                                                miniAppIcon: favMiniApp.iconPath,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(3.0),
                                                                  child: CustomNetworkImageWidget(
                                                                    favMiniApp.iconPath,
                                                                    isVerifyingKey: true,
                                                                    imageFit: BoxFit.contain,
                                                                    imageWidth: ctx.w(32),
                                                                    imageHeight: ctx.h(32),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            //! Momtahel map section .....
                                            SizedBox(height: context.screenHeight * 0.02),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: CommonFunctions.isAppAR
                                                    ? context.screenWidth * 0.04
                                                    : context.screenWidth * 0.00,
                                                right: CommonFunctions.isAppAR
                                                    ? context.screenWidth * 0.00
                                                    : context.screenWidth * 0.04,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  final MiniApp? miniApp = _miniAppsCubit.getMiniAppByServiceId(
                                                    "BaladyUrbiImtithal",
                                                  );
                                                  if (miniApp != null) {
                                                    _miniAppsCubit.openMiniApp(miniApp);
                                                  }
                                                },
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(11.19),
                                                  child: Container(
                                                    width: double.infinity,
                                                    constraints: const BoxConstraints(minHeight: 100),
                                                    decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage("assets/icons/png/momtathel.png"),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          DecoratedBox(
                                                            decoration: BoxDecoration(
                                                              color: const Color(0XffFFFAEB),
                                                              borderRadius: BorderRadius.circular(50),
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(
                                                                horizontal: 10,
                                                                vertical: 4,
                                                              ),
                                                              child: Text(
                                                                "new".tr(),
                                                                style: TextStyle(
                                                                  color: const Color(0xff93370D),
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontFamily: GeneralKey.appFontType,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 8),
                                                          Text(
                                                            "compliance_map".tr(),
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: GeneralKey.appFontType,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 4),
                                                          Text(
                                                            "building_compliance_question".tr(),
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w400,
                                                              fontFamily: GeneralKey.appFontType,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),

                                SizedBox(height: context.screenHeight * 0.02),

                                //! ── Most used / entry points section ─────
                                BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                                  buildWhen: (previous, current) =>
                                      previous.isEntryPointsLoading != current.isEntryPointsLoading ||
                                      previous.isInitial != current.isInitial ||
                                      previous.entryPoints != current.entryPoints,
                                  builder: (context, state) {
                                    if (state.isEntryPointsLoading || state.isInitial) {
                                      return const MiniAppsMostUsedSectionShimmerWidget();
                                    }
                                    if (state.entryPoints.isEmpty) {
                                      return const SizedBox.shrink();
                                    }
                                    final textScale = MediaQuery.of(context).textScaler.scale(1.0);
                                    return StaggeredAppear(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              separatorBuilder: (context, index) =>
                                                  SizedBox(height: context.screenHeight * 0.02),
                                              itemCount: state.entryPoints.length,
                                              itemBuilder: (context, index) {
                                                final section = state.entryPoints[index];
                                                final apps = section.apps;
                                                if (apps.isEmpty) {
                                                  return const SizedBox.shrink();
                                                }

                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "most_used_apps".tr(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          textAlign: CommonFunctions.isAppAR
                                                              ? TextAlign.right
                                                              : TextAlign.left,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w600,
                                                            fontFamily: GeneralKey.appFontType,
                                                            color: Theme.of(context).brightness == Brightness.dark
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        // const Spacer(),
                                                        /*
                                                        Padding(
                                                          padding: CommonFunctions.isAppAR
                                                              ? const EdgeInsets.only(left: 10)
                                                              : const EdgeInsets.only(right: 10),
                                                          child: CustomTextButtonWidget(
                                                            onPressed: () {
                                                              Navigator.of(context).push(
                                                                PageRouteBuilder(
                                                                  opaque: false,
                                                                  barrierColor: Colors.transparent,
                                                                  pageBuilder: (_, _, _) => const MiniAppsSearchPage(),
                                                                ),
                                                              );
                                                            },
                                                            // fontSize: 14,
                                                            btnTextColor: Theme.of(context).primaryColor,
                                                            btnTextWeight: AppFontWeight.regular,
                                                            btnTextSize: 14,
                                                            text: "view_all".tr(),
                                                          ),
                                                        ),
                                                        */
                                                      ],
                                                    ),
                                                    SizedBox(height: context.screenHeight * 0.01),
                                                    SizedBox(
                                                      height: context.h(64) * (1.0 + (textScale - 1.0) * 0.4),
                                                      width: context.screenWidth,
                                                      child: ListView.separated(
                                                        scrollDirection: Axis.horizontal,
                                                        separatorBuilder: (context, i) =>
                                                            SizedBox(width: context.screenWidth * 0.02),
                                                        itemCount: apps.length,
                                                        itemBuilder: (context, appIndex) {
                                                          final miniApp = apps[appIndex];
                                                          return SizedBox(
                                                            width: context.w(177) * (1.0 + (textScale - 1.0) * 0.2),
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                _miniAppsCubit.openMiniApp(
                                                                  miniApp,
                                                                );
                                                              },
                                                              child: DecoratedBox(
                                                                decoration: BoxDecoration(
                                                                  color: Theme.of(context).cardColor,
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  border: Border.all(
                                                                    color: Theme.of(
                                                                      context,
                                                                    ).disabledColor.withAlpha(90),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(5),
                                                                      child: SizedBox(
                                                                        width: context.w(48),
                                                                        height: context.h(48),
                                                                        child: DecoratedBox(
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(8),
                                                                            color: Theme.of(context).primaryColorLight,
                                                                          ),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(4),
                                                                            child: CustomNetworkImageWidget(
                                                                              miniApp.iconPath,
                                                                              isVerifyingKey: true,
                                                                              imageWidth: context.w(40),
                                                                              imageHeight: context.h(40),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(
                                                                          horizontal: 4.0,
                                                                        ),
                                                                        child: AutoSizeText(
                                                                          miniApp.name,
                                                                          maxLines: 2,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: const TextStyle(
                                                                            fontFamily: GeneralKey.appFontType,
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: 14,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
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

                                SizedBox(height: context.screenHeight * 0.02),

                                //! ── App groups grid section ──────────────
                                BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                                  buildWhen: (previous, current) =>
                                      previous.isAppsGroupLoading != current.isAppsGroupLoading ||
                                      previous.isInitial != current.isInitial ||
                                      previous.appGroups != current.appGroups,
                                  builder: (context, state) {
                                    if (state.isAppsGroupLoading || state.isInitial) {
                                      return const AppsGroupSectionShimmerWidget();
                                    }
                                    final regularGroups = state.appGroups;
                                    final textScale = MediaQuery.of(context).textScaler.scale(1.0);
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "all_apps".tr(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: CommonFunctions.isAppAR ? TextAlign.right : TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: GeneralKey.appFontType,
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: context.screenHeight * 0.01),
                                        Padding(
                                          padding: CommonFunctions.isAppAR
                                              ? const EdgeInsets.only(left: 10)
                                              : const EdgeInsets.only(right: 10),
                                          child: StaggeredAppear(
                                            children: [
                                              GridView.builder(
                                                itemCount: regularGroups.length,
                                                shrinkWrap: true, // 1. Allows GridView to size itself to its children
                                                physics:
                                                    const NeverScrollableScrollPhysics(), // 2. Prevents double-scrolling if inside another list
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  mainAxisExtent:
                                                      context.h(98) *
                                                      (1.0 +
                                                          (textScale - 1.0) *
                                                              0.45), // 3. Forces the EXACT height of the card
                                                  crossAxisSpacing: 8, // Optional: Spacing between columns
                                                  mainAxisSpacing: 8, // Optional: Spacing between rows
                                                ),
                                                itemBuilder: (context, index) {
                                                  final appGroup = regularGroups[index];
                                                  final groupName = CommonFunctions.isAppAR
                                                      ? appGroup.nameAr
                                                      : appGroup.nameEn;
                                                  final groupIcon = appGroup.apps.last.iconPath;
                                                  return CustomLargMoreApps(
                                                    categoryIconPath: groupIcon,
                                                    categoryName: groupName,
                                                    withCardEffect: true,
                                                    text: groupName,
                                                    apps: appGroup.apps,
                                                    totalAppCount: appGroup.appCount,
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                        PageRouteBuilder(
                                                          opaque: false,
                                                          barrierColor: Colors.transparent,
                                                          pageBuilder: (_, _, _) => AppsGroupPage(groupId: appGroup.id),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
