import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart'
    show BlocRequestStatus;
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
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/mini_apps_search_bar_shimmer_loading_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/overlay_blur_circle.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/page_bar_shimmer_loading_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/apps_group_page.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/apps_group_section_widgets/custom_larg_more_apps.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/fav_section_widgets/custom_dashed_add_mini_app_fav.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/fav_section_widgets/custom_mini_apps_card.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_dashed_line_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/page_bar_section_widgets/custom_text_field.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/mini_apps_search_page/mini_apps_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

final GlobalKey<NavigatorState> servicesNavigatorKey = GlobalKey<NavigatorState>();

class HomeMiniAppsListPages extends StatefulWidget {
  final String? groupId;

  const HomeMiniAppsListPages({super.key, this.groupId});

  @override
  State<HomeMiniAppsListPages> createState() => _HomeMiniAppsListPagesState();
}

class _HomeMiniAppsListPagesState extends State<HomeMiniAppsListPages> {
  bool _hasLoadedMiniAppsForBusinessStatus = false;
  bool? _lastIsUserAccountBusiness;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final miniAppsCubit = sl<NewMiniAppLogicCubit>();
    MiniApp? dashboard = miniAppsCubit.getMiniAppByServiceId("Dashboard");
    return Theme(
      data: Theme.of(NavigationService.navigatorKey.currentState!.context),
      child: Navigator(
        key: servicesNavigatorKey,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) {
                  final delegatorsCubit = sl<DelegatorsCubit>();

                  // Initialize: Fetch delegators/agents immediately on screen entry
                  // Check if we need to fetch (empty and not already loading)
                  final needsDelegatorsFetch = delegatorsCubit.state.delegators.isEmpty &&
                      delegatorsCubit.state.status != BlocRequestStatus.submissionGetLoading &&
                      delegatorsCubit.state.status != BlocRequestStatus.submissionGetSuccess;
                  final needsAgentsFetch = delegatorsCubit.state.agents.isEmpty &&
                      delegatorsCubit.state.agentStatus != BlocRequestStatus.submissionGetLoading &&
                      delegatorsCubit.state.agentStatus != BlocRequestStatus.submissionGetSuccess;

                  if (needsDelegatorsFetch) {
                    delegatorsCubit.getDelegators();
                  }
                  if (needsAgentsFetch) {
                    delegatorsCubit.getAgents();
                  }

                  return BlocProvider<DelegatorsCubit>.value(
                    value: delegatorsCubit,
                    child: BlocBuilder<DelegatorsCubit, DelegatorsState>(
                      builder: (context, delegatorsState) {
                        final isUserAccountBusiness =
                            delegatorsState.delegators.isNotEmpty || delegatorsState.agents.isNotEmpty;

                        final miniAppsCubit = sl<NewMiniAppLogicCubit>();
                        if (!_hasLoadedMiniAppsForBusinessStatus ||
                            _lastIsUserAccountBusiness != isUserAccountBusiness) {
                          _hasLoadedMiniAppsForBusinessStatus = true;
                          _lastIsUserAccountBusiness = isUserAccountBusiness;
                          miniAppsCubit.loadMiniApps(
                            isUserLoggedInLifeStyle: CommonProperties.isLoggedIn,
                            isUserLoggedInMunicipality: CommonProperties.isLoggedInMunicipality,
                            isUserAccountBusiness: isUserAccountBusiness,
                          );
                        }

                        return BlocProvider<NewMiniAppLogicCubit>.value(
                          value: miniAppsCubit,
                          child: Builder(
                            builder: (context) {
                                // if (widget.groupId != null && !_isInitialDeepLinkHandled) {
                                //   _isInitialDeepLinkHandled = true;
                                //   WidgetsBinding.instance.addPostFrameCallback((_) {
                                //     servicesNavigatorKey.currentState?.pushNamed(
                                //       '/group',
                                //       arguments: {
                                //         'groupId': widget.groupId,
                                //         'dashboard': getMiniAppByServiceId("Dashboard"),
                                //       },
                                //     );
                                //   });
                                // }
                                return Scaffold(
                                  body: Stack(
                                    children: [
                                      const Positioned(top: 0, child: OverlayBlurCircle()),
                                      BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                                          builder: (context, state) {
                                          final hasError = state.entryPointsError != null && state.favError != null;

                                          if (hasError) {
                                            return GeneralErrorWidget(error: state.favError ?? state.entryPointsError!);
                                          }
                                            return RefreshIndicator(
                                            color: const Color(0xFF1CA9A6),
                                            onRefresh: () async {
                                              // Fetch delegators and agents first on refresh
                                              final delegatorsCubit = context.read<DelegatorsCubit>();
                                              
                                              // Fetch delegators and agents if not already loading
                                              if (delegatorsCubit.state.status != BlocRequestStatus.submissionGetLoading) {
                                                delegatorsCubit.getDelegators();
                                              }
                                              if (delegatorsCubit.state.agentStatus != BlocRequestStatus.submissionGetLoading) {
                                                delegatorsCubit.getAgents();
                                              }
                                              
                                              // Wait for delegators/agents to finish loading (with timeout)
                                              int attempts = 0;
                                              while (attempts < 10) {
                                                await Future.delayed(const Duration(milliseconds: 200));
                                                attempts++;
                                                
                                                final delegatorsLoaded = delegatorsCubit.state.status == 
                                                    BlocRequestStatus.submissionGetSuccess ||
                                                    delegatorsCubit.state.status == BlocRequestStatus.submissionGetFailure;
                                                final agentsLoaded = delegatorsCubit.state.agentStatus == 
                                                    BlocRequestStatus.submissionGetSuccess ||
                                                    delegatorsCubit.state.agentStatus == BlocRequestStatus.submissionGetFailure;
                                                
                                                if (delegatorsLoaded && agentsLoaded) {
                                                  break;
                                                }
                                              }
                                              
                                              // Now compute the business account status with fresh data
                                              final refreshedDelegatorsState = delegatorsCubit.state;
                                              final refreshedIsUserAccountBusiness = 
                                                  refreshedDelegatorsState.delegators.isNotEmpty || 
                                                  refreshedDelegatorsState.agents.isNotEmpty;
                                              
                                              // Refresh mini apps with updated business account status
                                              return context.read<NewMiniAppLogicCubit>().refreshMiniApps(
                                                isUserAccountBusiness: refreshedIsUserAccountBusiness,
                                              );
                                            },
                                            child: SingleChildScrollView(
                                              physics: const AlwaysScrollableScrollPhysics(
                                                parent: ClampingScrollPhysics(),
                                              ),
                                              child: SafeArea(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: context.screenWidth * 0.04),
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
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(
                                                                  horizontal: context.screenWidth * 0.04,
                                                                ),
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child: RichText(
                                                                        textAlign: CommonFunctions.isAppAR
                                                                            ? TextAlign.right
                                                                            : TextAlign.left,
                                                                        text: TextSpan(
                                                                          style: const TextStyle(
                                                                            fontSize: 24,
                                                                            height: 28 / 24,
                                                                            fontWeight: FontWeight.w900,
                                                                            fontFamily: GeneralKey.appFontType,
                                                                            color: Color(0xFF1CA9A6),
                                                                          ),
                                                                          children: [
                                                                            TextSpan(text: "quick_apps".tr()),
                                                                            const TextSpan(text: '\n'),
                                                                            TextSpan(text: "one_place".tr()),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Spacer(),
                                                                    // dashboard != null
                                                                    //     ? InkWell(
                                                                    //         onTap: () {
                                                                    //           context
                                                                    //               .read<NewMiniAppLogicCubit>()
                                                                    //               .openMiniApp(dashboard);
                                                                    //         },
                                                                    //         child: Container(
                                                                    //           // width: 117,
                                                                    //           // height: 33,
                                                                    //           padding: const EdgeInsets.symmetric(
                                                                    //             horizontal: 3,
                                                                    //             vertical: 4,
                                                                    //           ),
                                                                    //           decoration: BoxDecoration(
                                                                    //             color: Theme.of(context).cardColor,
                                                                    //             borderRadius: BorderRadius.circular(
                                                                    //               18.5,
                                                                    //             ),
                                                                    //           ),
                                                                    //           child: Row(
                                                                    //             children: [
                                                                    //               Container(
                                                                    //                 padding: const EdgeInsets.symmetric(
                                                                    //                   horizontal: 8,
                                                                    //                   vertical: 4,
                                                                    //                 ),
                                                                    //                 decoration: BoxDecoration(
                                                                    //                   color: Theme.of(
                                                                    //                     context,
                                                                    //                   ).cardColor,
                                                                    //                   borderRadius:
                                                                    //                       BorderRadius.circular(13.5),
                                                                    //                 ),
                                                                    //                 child: CustomNetworkImageWidget(
                                                                    //                   dashboard.iconPath,
                                                                    //                   isVerifyingKey: true,
                                                                    //                   imageWidth: context.w(24),
                                                                    //                   imageHeight: context.h(24),
                                                                    //                 ),
                                                                    //               ),
                                                                    //               SizedBox(width: context.w(8)),
                                                                    //               Text(
                                                                    //                 "dashboard".tr(),
                                                                    //                 textAlign: TextAlign.center,
                                                                    //                 style: const TextStyle(
                                                                    //                   fontFamily:
                                                                    //                       GeneralKey.appFontType,
                                                                    //                   fontWeight: FontWeight.w400,
                                                                    //                 ),
                                                                    //               ),
                                                                    //               SizedBox(width: context.w(9)),
                                                                    //             ],
                                                                    //           ),
                                                                    //         ),
                                                                    //       )
                                                                    //     : const SizedBox(),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                      //!
                                                      SizedBox(height: context.h(14)),
                                                      state.isFavLoading ||
                                                              state.isUnFavLoading ||
                                                              state.isAppsGroupLoading ||
                                                              state.isEntryPointsLoading
                                                          ? MiniAppsSearchTextFieldShimmer()
                                                          : MiniAppsCustomTextField(
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
                                                              // width: context.w(150),
                                                              height: context.h(48),
                                                              keyboardType: TextInputType.text,
                                                              backgroundColor: Colors.transparent,
                                                              suffixString: Text(
                                                                "search2".tr(),
                                                                style: TextStyle(
                                                                  color: Theme.of(context).disabledColor,
                                                                  // color: Colors.black,
                                                                  fontFamily: GeneralKey.appFontType,
                                                                ),
                                                              ),
                                                              suffixIcon: SvgPicture.asset(
                                                                Theme.of(context).brightness == Brightness.dark
                                                                    ? IconPath.searchSVG2
                                                                    : IconPath.searchSVG,
                                                              ),
                                                            ),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                          left: CommonFunctions.isAppAR
                                                              ? context.screenWidth * 0.00
                                                              : context.screenWidth * 0.04,
                                                          right: CommonFunctions.isAppAR
                                                              ? context.screenWidth * 0.04
                                                              : context.screenWidth * 0.00,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
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
                                                                        SizedBox(
                                                                          width: context.w(195),
                                                                          child: Text(
                                                                            "my_favorite_apps".tr(),
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            textAlign: CommonFunctions.isAppAR
                                                                                ? TextAlign.right
                                                                                : TextAlign.left,
                                                                            style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontFamily: GeneralKey.appFontType,
                                                                              color:
                                                                                  Theme.of(context).brightness ==
                                                                                      Brightness.dark
                                                                                  ? Colors.white
                                                                                  : Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: context.screenHeight * 0.02),
                                                                        Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            const CustomDashedAddMiniAppFav(),
                                                                            SizedBox(width: context.screenWidth * 0.04),
                                                                              Expanded(
                                                                              child: SizedBox(
                                                                                height: context.screenHeight * 0.13,
                                                                                child: ReorderableListView.builder(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  itemCount: state.favoriteApps.length,
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
                                                                                            context.screenWidth * 0.03,
                                                                                      ),
                                                                                      child: CustomMiniAppsCard(
                                                                                        key: Key(favMiniApp.id),
                                                                                        width:
                                                                                            context.screenWidth * 0.14,
                                                                                        onTap: () {
                                                                                          context
                                                                                              .read<
                                                                                                NewMiniAppLogicCubit
                                                                                              >()
                                                                                              .openMiniApp(favMiniApp);
                                                                                        },
                                                                                        text: favMiniApp.name,
                                                                                        maxLines: 2,
                                                                                        maxFontSize: 20,
                                                                                        minFontSize: 9,
                                                                                        miniAppIcon:
                                                                                            favMiniApp.iconPath,
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(
                                                                                            8.0,
                                                                                          ),
                                                                                          child:
                                                                                              CustomNetworkImageWidget(
                                                                                                favMiniApp.iconPath,
                                                                                                isVerifyingKey: true,
                                                                                                imageFit:
                                                                                                    BoxFit.contain,
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: context.screenHeight * 0.01),
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
                                                                              final miniAppsCubit = sl<NewMiniAppLogicCubit>();
                                                                              MiniApp? miniApp = miniAppsCubit.getMiniAppByServiceId(
                                                                                "BaladyUrbiImtithal",
                                                                              );
                                                                              if (miniApp != null) {
                                                                                context
                                                                                    .read<NewMiniAppLogicCubit>()
                                                                                    .openMiniApp(miniApp);
                                                                              }
                                                                            },
                                                                            child: Image.asset(
                                                                              "assets/icons/png/${CommonFunctions.isAppAR ? 'promoAr.png' : 'promoEn.png'}",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                            //!
                                                            SizedBox(height: context.screenHeight * 0.02),
                                                              // const CustomDashedLineWidget(),
                                                            // SizedBox(height: context.screenHeight * 0.02),
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
                                                                          physics: const NeverScrollableScrollPhysics(),
                                                                          separatorBuilder: (context, index) =>
                                                                              SizedBox(
                                                                                height: context.screenHeight * 0.02,
                                                                              ),
                                                                          itemCount: state.entryPoints.length,
                                                                          itemBuilder: (context, index) {
                                                                            final section = state.entryPoints[index];
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
                                                                                Text(
                                                                                  title,
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  textAlign: CommonFunctions.isAppAR
                                                                                      ? TextAlign.right
                                                                                      : TextAlign.left,
                                                                                  style: TextStyle(
                                                                                    fontSize: 18,
                                                                                    fontWeight: FontWeight.w700,
                                                                                    fontFamily: GeneralKey.appFontType,
                                                                                    color:
                                                                                        Theme.of(context).brightness ==
                                                                                            Brightness.dark
                                                                                        ? Colors.white
                                                                                        : Colors.black,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: context.screenHeight * 0.01,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: context.screenHeight * 0.01,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: context.screenHeight * 0.2,
                                                                                  width: context.screenWidth,
                                                                                  child: ListView.separated(
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    separatorBuilder: (context, i) =>
                                                                                        SizedBox(
                                                                                          width:
                                                                                              context.screenWidth *
                                                                                              0.02,
                                                                                        ),
                                                                                    padding: const EdgeInsets.all(2),
                                                                                    itemCount: apps.length,
                                                                                    itemBuilder: (context, appIndex) {
                                                                                      final miniApp = apps[appIndex];

                                                                                      return CustomMiniAppsCard(
                                                                                        borderRadius:
                                                                                            BorderRadius.circular(28),
                                                                                        width: context.h(104),
                                                                                        height: context.h(104),
                                                                                        iconHeight: context.h(64),
                                                                                        iconWidth: context.w(64),
                                                                                        titlesWidth:
                                                                                            context.screenWidth / 3.8,
                                                                                        maxLines: 2,
                                                                                        maxFontSize: 20,
                                                                                        minFontSize: 8,
                                                                                        withCardEffect: true,
                                                                                        text: miniApp.name,
                                                                                        miniAppIcon: miniApp.iconPath,
                                                                                        onTap: () {
                                                                                          context
                                                                                              .read<
                                                                                                NewMiniAppLogicCubit
                                                                                              >()
                                                                                              .openMiniApp(miniApp);
                                                                                        },
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(
                                                                                            16.0,
                                                                                          ),
                                                                                          child:
                                                                                              CustomNetworkImageWidget(
                                                                                                miniApp.iconPath,
                                                                                                isVerifyingKey: true,
                                                                                                imageWidth: context.w(
                                                                                                  30,
                                                                                                ),
                                                                                                imageHeight: context.h(
                                                                                                  30,
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
                                                                final regularGroups = state.appGroups;

                                                                return StaggeredAppear(
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        // Regular groups (2+ apps)
                                                                        GridView.builder(
                                                                          physics: const NeverScrollableScrollPhysics(),
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
                                                                            final groupName = CommonFunctions.isAppAR
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
                                                                                    barrierColor: Colors.transparent,
                                                                                    pageBuilder: (_, __, ___) {
                                                                                      print('Group name: $groupName');
                                                                                      print(
                                                                                        'Navigating to group: ${appGroup.id}',
                                                                                      );
                                                                                      return AppsGroupPage(
                                                                                        groupId: appGroup.id,
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                        ),

                                                                        // Show dashed line and "Other Services" only if it exists
                                                                        // if (otherServicesGroup?.apps.isNotEmpty ??
                                                                        //     false) ...[
                                                                        //   SizedBox(height: context.screenHeight * 0.02),
                                                                        //   const CustomDashedLineWidget(),
                                                                        //   SizedBox(height: context.screenHeight * 0.02),
                                                                        //
                                                                        //   // "Other Services" group
                                                                        //   GridView.builder(
                                                                        //     physics:
                                                                        //         const NeverScrollableScrollPhysics(),
                                                                        //     shrinkWrap: true,
                                                                        //     itemCount: 1,
                                                                        //     // Only "Other Services" group
                                                                        //     gridDelegate:
                                                                        //         SliverGridDelegateWithFixedCrossAxisCount(
                                                                        //           crossAxisCount: 2,
                                                                        //           mainAxisSpacing:
                                                                        //               context.screenHeight * 0.02,
                                                                        //           crossAxisSpacing:
                                                                        //               context.screenWidth * 0.04,
                                                                        //           childAspectRatio: 0.8,
                                                                        //         ),
                                                                        //     itemBuilder: (context, index) {
                                                                        //       final groupName = CommonFunctions.isAppAR
                                                                        //           ? otherServicesGroup!.nameAr
                                                                        //           : otherServicesGroup!.nameEn;
                                                                        //
                                                                        //       return CustomLargMoreApps(
                                                                        //         withCardEffect: true,
                                                                        //         text: groupName,
                                                                        //         apps: otherServicesGroup.apps,
                                                                        //         totalAppCount:
                                                                        //             otherServicesGroup.appCount,
                                                                        //         onTap: () {
                                                                        //           Navigator.of(context).push(
                                                                        //             PageRouteBuilder(
                                                                        //               opaque: false,
                                                                        //               barrierColor: Colors.transparent,
                                                                        //               pageBuilder: (_, _, _) =>
                                                                        //                   AppsGroupPage(
                                                                        //                     groupId:
                                                                        //                         otherServicesGroup.id,
                                                                        //                     dashboard: dashboard,
                                                                        //                   ),
                                                                        //             ),
                                                                        //           );
                                                                        //         },
                                                                        //       );
                                                                        //     },
                                                                        //   ),
                                                                        // ],
                                                                      ],
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
                              },
                            ),
                          );
                        },
                      ),
                  );
                },
              );
            case '/search':
              return MaterialPageRoute(builder: (_) => const MiniAppsSearchPage(), fullscreenDialog: true);
            case '/group':
              final args = settings.arguments as Map<String, dynamic>;
              return PageRouteBuilder(
                opaque: false,
                barrierColor: Colors.transparent,
                pageBuilder: (_, __, ___) =>
                    AppsGroupPage(groupId: args['groupId'] as String),
              );
            default:
              return MaterialPageRoute(builder: (_) => const HomeMiniAppsListPages());
          }
        },
      ),
    );
  }
}
