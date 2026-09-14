import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/agent_entity.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/delegator_entity.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/widgets/profile/profile_header.dart';

final InAppReview inAppReview = InAppReview.instance;

@RoutePage()
class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final textDirection = Directionality.of(context);
    final trailing = ContentRowTextTrailingOptions(
      icon: SystemIcons.arrowCornerRightLarge,
      iconColor: context.colors.foregroundMuted,
    );
    final Widget Function(IconData icon) leadingIconBuilder = (icon) =>
        Icon(icon, color: context.colors.accentDefault, size: 24);
    final userData = ref.watch(authProvider);
    final isAuth = userData.value != null;
    final isDGA =
        context.read<ThemeController>().currentTheme == BaladyAppThemes.darkDGA ||
        context.read<ThemeController>().currentTheme == BaladyAppThemes.lightDGA;
    final activeEvent = ref.watch(activeCityEventProvider);
    final isFoundingDay = activeEvent == CityEventType.foundingDay;
    final backgroundColor = isAuth
        ? context.colors.backgroundSurface1
        : isFoundingDay
        ? context.colors.accentDefault
        : isDGA
        ? context.colors.accentDefault
        : context.colorsV3.staticDarkblue;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.read<ThemeController>().systemOverlayStyle,
      child: Scaffold(
        backgroundColor: context.colors.accentDefault,
        body: SafeArea(
          bottom: false,
          child: Directionality(
            textDirection: textDirection,
            child: Stack(
              children: [
                CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    const SliverToBoxAdapter(
                      child: SafeArea(
                        bottom: false,
                        right: false,
                        left: false,
                        child: ProfileHeader(),
                      ),
                    ),
                    DecoratedSliver(
                      decoration: BoxDecoration(
                        color: context.colors.backgroundSurface4,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(RadiusBorder.xxl),
                          topRight: Radius.circular(RadiusBorder.xxl),
                        ),
                      ),
                      sliver: SliverFillAfter(
                        sliver: SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              const SizedBox(height: Spacing.$4x),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(RadiusBorder.l),
                                child: ContentWrapper(
                                  color: isDGA ? context.colors.accentSecondarySoft : context.colors.backgroundSurface1,
                                  children: [
                                    userData.maybeWhen(
                                      orElse: () => const SizedBox.shrink(),
                                      data: (data) => data == null
                                          ? const SizedBox.shrink()
                                          : Column(
                                              children: [
                                                ContentRow(
                                                  isDividerEnabled: true,
                                                  onTap: () => context.router.push(const ProfileInfoRoute()),
                                                  trailing: trailing,
                                                  leading: leadingIconBuilder(GeneralIcons.userCircle),
                                                  text: ContentRowTextOptions(title: context.l10n.account),
                                                ),
                                                if (CommonProperties.isLoggedInMunicipality)
                                                  ContentRowV2(
                                                    isDividerEnabled: true,
                                                    onTap: () => CommonFunctions.openVolunteerProfileScreen(),
                                                    trailing: trailing,
                                                    leading: leadingIconBuilder(Icons.favorite),
                                                    text: ContentRowTextOptions(title: 'volunteer_info'.tr()),
                                                  )
                                                else
                                                  const SizedBox.shrink(),
                                              ],
                                            ),
                                    ),
                                    ContentRowV2(
                                      onTap: () => context.router.push(const SettingsRoute()),
                                      trailing: trailing,
                                      leading: leadingIconBuilder(SystemIcons.settings),
                                      text: ContentRowTextOptions(title: context.l10n.settings),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: Spacing.$4x),
                              ContentWrapper(
                                color: isDGA ? context.colors.accentSecondarySoft : context.colors.backgroundSurface1,
                                children: [
                                  ContentRowV2(
                                    isDividerEnabled: true,
                                    onTap: () => context.router.push(const HelpCenterRoute()),
                                    trailing: trailing,
                                    leading: leadingIconBuilder(GeneralIcons.questionCircle),
                                    text: ContentRowTextOptions(title: context.l10n.helpCenter),
                                  ),
                                  ContentRowV2(
                                    isDividerEnabled: true,
                                    onTap: () {
                                      context.router.push(const AboutBaladyRoute());
                                    },
                                    trailing: trailing,
                                    leading: leadingIconBuilder(GeneralIcons.infoSquare),
                                    text: ContentRowTextOptions(title: context.l10n.aboutApp),
                                  ),
                                  ContentRowV2(
                                    onTap: () {
                                      context.router.push(const PrivacyAndTermsOfUseRoute());
                                    },
                                    trailing: trailing,
                                    leading: Padding(
                                      padding: const EdgeInsetsGeometry.directional(start: 2),
                                      child: SvgPicture.asset(
                                        'assets/icons/svg/shield-lock.svg',
                                        color: context.colors.accentDefault,
                                      ),
                                    ),
                                    text: ContentRowTextOptions(title: 'privacyAndTermsTitle'.tr()),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Spacing.$4x),
                              userData.maybeWhen(
                                orElse: () => const SizedBox.shrink(),
                                data: (data) => data == null
                                    ? const SizedBox.shrink()
                                    : ContentWrapper(
                                        color: isDGA
                                            ? context.colors.accentSecondarySoft
                                            : context.colors.backgroundSurface1,
                                        children: [
                                          ContentRowV2(
                                            backgroundColor: isDGA
                                                ? context.colors.accentSecondarySoft
                                                : context.colors.backgroundSurface1,
                                            onTap: () => _logOut(context, ref, isLoading),
                                            text: ContentRowTextOptions(
                                              title: context.l10n.signOut,
                                              titleOptions: ContentRowTextOption(
                                                baseColor: context.colors.errorDefault,
                                              ),
                                            ),
                                            leading: Icon(
                                              GeneralIcons.doorEntrance,
                                              size: AppSizes.xxs,
                                              color: context.colors.errorDefault,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (isLoading.value) Center(child: CircularProgressIndicator(color: context.colors.accentDefault)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  void _testSelectedDelegator(BuildContext context) {
    try {
      DelegatorEntity? selectedDelegate;
      DelegatorsCubit? foundCubit;
      String? savedDelegatorId;

      // Method 1: Try context.read
      try {
        foundCubit = context.read<DelegatorsCubit>();
        selectedDelegate = foundCubit.state.selectedDelegate;
        print('✅ Method 1 SUCCESS: Got DelegatorsCubit from context.read');
        print('   Selected: ${selectedDelegate?.entityName ?? 'NULL'}');
      } catch (e) {
        print('❌ Method 1 FAILED: context.read - $e');
      }

      // Method 2: Try BlocProvider.of
      if (selectedDelegate == null) {
        try {
          foundCubit = BlocProvider.of<DelegatorsCubit>(context);
          selectedDelegate = foundCubit.state.selectedDelegate;
          print('✅ Method 2 SUCCESS: Got DelegatorsCubit from BlocProvider.of');
          print('   Selected: ${selectedDelegate?.entityName ?? 'NULL'}');
        } catch (e) {
          print('❌ Method 2 FAILED: BlocProvider.of - $e');
        }
      }

      // Method 3: Try NavigationService context
      if (selectedDelegate == null) {
        try {
          final navContext = NavigationService.navigatorKey.currentContext;
          if (navContext != null) {
            foundCubit = navContext.read<DelegatorsCubit>();
            selectedDelegate = foundCubit.state.selectedDelegate;
            print('✅ Method 3 SUCCESS: Got DelegatorsCubit from NavigationService context');
            print('   Selected: ${selectedDelegate?.entityName ?? 'NULL'}');
          } else {
            print('❌ Method 3 FAILED: NavigationService context is null');
          }
        } catch (e) {
          print('❌ Method 3 FAILED: NavigationService context.read - $e');
        }
      }

      // Method 4: Try BlocProvider.of with NavigationService context
      if (selectedDelegate == null) {
        try {
          final navContext = NavigationService.navigatorKey.currentContext;
          if (navContext != null) {
            foundCubit = BlocProvider.of<DelegatorsCubit>(navContext);
            selectedDelegate = foundCubit.state.selectedDelegate;
            print('✅ Method 4 SUCCESS: Got DelegatorsCubit from NavigationService BlocProvider.of');
            print('   Selected: ${selectedDelegate?.entityName ?? 'NULL'}');
          }
        } catch (e) {
          print('❌ Method 4 FAILED: NavigationService BlocProvider.of - $e');
        }
      }

      // Method 5: Try reading from SharedPreferences (saved selection)
      if (selectedDelegate == null) {
        try {
          savedDelegatorId = sharedPrefs.getSelectedDelegatorId();
          print('📦 Method 5: Reading from SharedPreferences');
          print('   Saved delegator ID: ${savedDelegatorId ?? 'NULL'}');
          if (savedDelegatorId != null) {
            print('   ✅ Selection EXISTS in SharedPreferences but cubit instance not accessible');
          }
        } catch (e) {
          print('❌ Method 5 FAILED: SharedPreferences read - $e');
        }
      }

      // Method 6: Last resort - sl<> (creates NEW instance - will be empty)
      if (selectedDelegate == null) {
        final cubit = sl<DelegatorsCubit>();
        selectedDelegate = cubit.state.selectedDelegate;
        print('⚠️ Method 6: Using sl<> - creates NEW factory instance');
        print('   Delegators count: ${cubit.state.delegators.length}');
        print('   Selected delegate: ${selectedDelegate?.entityName ?? 'NULL'}');
        print('   ⚠️ WARNING: This is a NEW instance, selection is in a DIFFERENT instance!');
      }

      // Debug: Print final state information
      print('🔍 FINAL Delegator Selection Debug:');
      print('  - Selected delegate from cubit: ${selectedDelegate?.entityName ?? 'NULL'}');
      print(
        '  - Selected delegate CR/UNN: ${selectedDelegate?.crNumber ?? selectedDelegate?.unifiedNationalNumber ?? 'NULL'}',
      );
      print('  - Saved delegator ID from SharedPrefs: ${savedDelegatorId ?? 'NULL'}');
      if (foundCubit != null) {
        print('  - Found cubit instance: ${foundCubit.hashCode}');
        print('  - Delegators in cubit: ${foundCubit.state.delegators.length}');
      }

      // Create the response data manually like JsDelegatorModel would
      Map<String, dynamic>? responseData;
      // Get saved delegator ID if not already retrieved
      savedDelegatorId ??= sharedPrefs.getSelectedDelegatorId();

      print('🔍 Creating response data:');
      print('  - selectedDelegate: ${selectedDelegate?.entityName ?? 'NULL'}');
      print('  - savedDelegatorId: $savedDelegatorId');

      if (selectedDelegate != null) {
        responseData = {
          'crNumber': selectedDelegate.crNumber,
          'unifiedNationalNumber': selectedDelegate.unifiedNationalNumber,
          'delegationSource': selectedDelegate.delegationSource,
          'relationTypeId': selectedDelegate.relationTypeId,
          'relationTypeName': selectedDelegate.relationTypeName,
          'roleId': selectedDelegate.roleId,
          'roleName': selectedDelegate.roleName,
          'entityName': selectedDelegate.entityName,
          'crType': selectedDelegate.crType,
        };
        print('  - Created responseData with full entity data');
      } else if (savedDelegatorId != null) {
        // If we can't get the full entity but have the ID from SharedPrefs,
        // create a minimal response to show selection exists
        responseData = {
          'id': savedDelegatorId,
          'note': 'Selection exists in SharedPreferences but full entity data not accessible from this context',
        };
        print('  - Created responseData with ID only: $savedDelegatorId');
      } else {
        print('  - No responseData created (no selection found)');
      }

      // Simulate the BaseResponse JSON structure
      final mockResponse = {
        'code': 200,
        'message': 'success',
        'eventName': 'selectedDelegator',
        'data': responseData,
      };

      final jsonResponse = jsonEncode(mockResponse);
      final responseMap = jsonDecode(jsonResponse);

      final code = responseMap['code'];
      final data = responseMap['data'];
      final message = responseMap['message'];

      print('🔍 Response parsing:');
      print('  - code: $code');
      print('  - data: $data');
      print('  - data type: ${data.runtimeType}');
      if (data != null) {
        print('  - data keys: ${(data as Map).keys.toList()}');
        print('  - has entityName: ${data.containsKey('entityName')}');
        print('  - has id: ${data.containsKey('id')}');
      }

      String snackbarMessage;
      Color backgroundColor;

      if (code == 200) {
        if (data != null) {
          if (data['entityName'] != null) {
            // Full entity data available
            snackbarMessage =
                '✅ JS Bridge Response - Delegator Found:\n'
                "Entity Name: ${data['entityName']}\n"
                "Role: ${data['roleName'] ?? 'N/A'}\n"
                "CR/UNN: ${data['crNumber'] ?? data['unifiedNationalNumber'] ?? 'N/A'}\n"
                'Check console for access method';
            backgroundColor = Colors.green;
            print('✅ Showing full entity data snackbar');
          } else if (data['id'] != null) {
            // Only ID available from SharedPreferences
            snackbarMessage =
                '✅ JS Bridge Response - Delegator ID Found:\n'
                "Saved Delegator ID: ${data['id']}\n"
                '✅ Selection exists in SharedPreferences\n'
                '⚠️ Full entity data not accessible from ProfilePage\n'
                'This is expected - cubit is in different widget tree\n'
                'JS Bridge will work correctly from mini apps';
            backgroundColor = Colors.green;
            print('✅ Showing ID-only snackbar with ID: ${data['id']}');
          } else {
            // Data exists but doesn't match expected format
            snackbarMessage =
                '⚠️ JS Bridge Response - Unexpected data format\n'
                'Code: $code\n'
                'Data exists but format unexpected\n'
                "Data keys: ${(data as Map).keys.join(', ')}";
            backgroundColor = Colors.orange;
            print('⚠️ Showing unexpected format snackbar');
          }
        } else {
          snackbarMessage =
              '⚠️ JS Bridge Response - No delegator selected\n'
              'Code: $code\n'
              'Selected delegate is NULL\n'
              'No selection found in SharedPreferences either';
          backgroundColor = Colors.orange;
          print('⚠️ Showing no selection snackbar');
        }
      } else {
        snackbarMessage = '❌ JS Bridge Error (Code $code): $message';
        backgroundColor = Colors.red;
        print('❌ Showing error snackbar');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarMessage),
          duration: const Duration(seconds: 6),
          backgroundColor: backgroundColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error simulating JS bridge: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ignore: unused_element
  void _testSelectedAgent(BuildContext context) {
    try {
      AgentEntity? selectedAgent;
      DelegatorsCubit? foundCubit;
      String? savedAgentId;

      // Method 1: Try context.read
      try {
        foundCubit = context.read<DelegatorsCubit>();
        selectedAgent = foundCubit.state.selectedAgent;
        print('✅ Method 1 SUCCESS: Got DelegatorsCubit from context.read');
        print('   Selected: ${selectedAgent?.agentName ?? 'NULL'}');
      } catch (e) {
        print('❌ Method 1 FAILED: context.read - $e');
      }

      // Method 2: Try BlocProvider.of
      if (selectedAgent == null) {
        try {
          foundCubit = BlocProvider.of<DelegatorsCubit>(context);
          selectedAgent = foundCubit.state.selectedAgent;
          print('✅ Method 2 SUCCESS: Got DelegatorsCubit from BlocProvider.of');
          print('   Selected: ${selectedAgent?.agentName ?? 'NULL'}');
        } catch (e) {
          print('❌ Method 2 FAILED: BlocProvider.of - $e');
        }
      }

      // Method 3: Try NavigationService context
      if (selectedAgent == null) {
        try {
          final navContext = NavigationService.navigatorKey.currentContext;
          if (navContext != null) {
            foundCubit = navContext.read<DelegatorsCubit>();
            selectedAgent = foundCubit.state.selectedAgent;
            print('✅ Method 3 SUCCESS: Got DelegatorsCubit from NavigationService context');
            print('   Selected: ${selectedAgent?.agentName ?? 'NULL'}');
          } else {
            print('❌ Method 3 FAILED: NavigationService context is null');
          }
        } catch (e) {
          print('❌ Method 3 FAILED: NavigationService context.read - $e');
        }
      }

      // Method 4: Try BlocProvider.of with NavigationService context
      if (selectedAgent == null) {
        try {
          final navContext = NavigationService.navigatorKey.currentContext;
          if (navContext != null) {
            foundCubit = BlocProvider.of<DelegatorsCubit>(navContext);
            selectedAgent = foundCubit.state.selectedAgent;
            print('✅ Method 4 SUCCESS: Got DelegatorsCubit from NavigationService BlocProvider.of');
            print('   Selected: ${selectedAgent?.agentName ?? 'NULL'}');
          }
        } catch (e) {
          print('❌ Method 4 FAILED: NavigationService BlocProvider.of - $e');
        }
      }

      // Method 5: Try reading from SharedPreferences (saved selection)
      if (selectedAgent == null) {
        try {
          savedAgentId = sharedPrefs.getSelectedAgentId();
          print('📦 Method 5: Reading from SharedPreferences');
          print('   Saved agent ID: ${savedAgentId ?? 'NULL'}');
          if (savedAgentId != null) {
            print('   ✅ Selection EXISTS in SharedPreferences but cubit instance not accessible');
          }
        } catch (e) {
          print('❌ Method 5 FAILED: SharedPreferences read - $e');
        }
      }

      // Method 6: Last resort - sl<> (creates NEW instance - will be empty)
      if (selectedAgent == null) {
        final cubit = sl<DelegatorsCubit>();
        selectedAgent = cubit.state.selectedAgent;
        print('⚠️ Method 6: Using sl<> - creates NEW factory instance');
        print('   Agents count: ${cubit.state.agents.length}');
        print('   Selected agent: ${selectedAgent?.agentName ?? 'NULL'}');
        print('   ⚠️ WARNING: This is a NEW instance, selection is in a DIFFERENT instance!');
      }

      // Debug: Print final state information
      print('🔍 FINAL Agent Selection Debug:');
      print('  - Selected agent from cubit: ${selectedAgent?.agentName ?? 'NULL'}');
      print('  - Selected agent agency: ${selectedAgent?.agencyNumber ?? 'NULL'}');
      print('  - Saved agent ID from SharedPrefs: ${savedAgentId ?? 'NULL'}');
      if (foundCubit != null) {
        print('  - Found cubit instance: ${foundCubit.hashCode}');
        print('  - Agents in cubit: ${foundCubit.state.agents.length}');
      }

      // Create the response data manually like JsAgentModel would
      Map<String, dynamic>? responseData;
      // Get saved agent ID if not already retrieved
      savedAgentId ??= sharedPrefs.getSelectedAgentId();

      if (selectedAgent != null) {
        responseData = {
          'requestId': selectedAgent.requestId,
          'agencyNumber': selectedAgent.agencyNumber,
          'agencyTypeId': selectedAgent.agencyTypeId,
          'agencyTypeName': selectedAgent.agencyTypeName,
          'agentNumber': selectedAgent.agentNumber,
          'agentTypeId': selectedAgent.agentTypeId,
          'agentTypeName': selectedAgent.agentTypeName,
          'agentName': selectedAgent.agentName,
          'grantorName': selectedAgent.grantorName,
          'grantorNumber': selectedAgent.grantorNumber,
          'grantorTypeId': selectedAgent.grantorTypeId,
          'grantorTypeName': selectedAgent.grantorTypeName,
          'ownerNumber': selectedAgent.ownerNumber,
          'ownerTypeId': selectedAgent.ownerTypeId,
          'correlationId': selectedAgent.correlationId,
          'active': selectedAgent.active,
          'isActive': selectedAgent.isActive,
        };
      } else if (savedAgentId != null) {
        // If we can't get the full entity but have the ID from SharedPrefs,
        // create a minimal response to show selection exists
        responseData = {
          'agencyNumber': savedAgentId,
          'note': 'Selection exists in SharedPreferences but full entity data not accessible from this context',
        };
      }

      // Simulate the BaseResponse JSON structure
      final mockResponse = {
        'code': 200,
        'message': 'success',
        'eventName': 'selectedAgent',
        'data': responseData,
      };

      final jsonResponse = jsonEncode(mockResponse);
      final responseMap = jsonDecode(jsonResponse);

      final code = responseMap['code'];
      final data = responseMap['data'];
      final message = responseMap['message'];

      String snackbarMessage;
      Color backgroundColor;

      if (code == 200) {
        if (data != null) {
          if (data['agentName'] != null) {
            // Full entity data available
            snackbarMessage =
                '✅ JS Bridge Response - Agent Found:\n'
                "Agent Name: ${data['agentName']}\n"
                "Grantor Name: ${data['grantorName'] ?? 'N/A'}\n"
                "Agency Number: ${data['agencyNumber'] ?? 'N/A'}\n"
                'Check console for access method';
            backgroundColor = Colors.green;
          } else if (data['agencyNumber'] != null) {
            // Only ID available from SharedPreferences
            snackbarMessage =
                '⚠️ JS Bridge Response - Agent ID Found:\n'
                "Saved Agency Number: ${data['agencyNumber']}\n"
                '⚠️ Full entity data not accessible\n'
                'Selection exists in SharedPreferences\n'
                'But cubit instance not accessible from this context';
            backgroundColor = Colors.orange;
          } else {
            // Data exists but doesn't match expected format
            snackbarMessage =
                '⚠️ JS Bridge Response - Unexpected data format\n'
                'Code: $code\n'
                'Data exists but format unexpected';
            backgroundColor = Colors.orange;
          }
        } else {
          snackbarMessage =
              '⚠️ JS Bridge Response - No agent selected\n'
              'Code: $code\n'
              'Selected agent is NULL\n'
              'No selection found in SharedPreferences either';
          backgroundColor = Colors.orange;
        }
      } else {
        snackbarMessage = '❌ JS Bridge Error (Code $code): $message';
        backgroundColor = Colors.red;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarMessage),
          duration: const Duration(seconds: 6),
          backgroundColor: backgroundColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error simulating JS bridge: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _logOut(BuildContext context, WidgetRef ref, ValueNotifier isLoading) async {
    final shouldLogout = await context.router.root.push<bool>(const ProfileLogoutSheetRoute());
    if (shouldLogout != true || !context.mounted) {
      return;
    }
    isLoading.value = true;
    try {
      await ref.read(authProvider.notifier).logOut();
    } catch (exception) {
      logger.log('Error logging out: $exception', logLevel: MapnessLogLevel.error);
    } finally {
      isLoading.value = false;
    }
  }
}
