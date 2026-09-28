import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_bloc.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_event.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_state.dart';
import 'package:balady_plus/app/core/utils/dialog_on_web_view/show_dialog_on_web_view.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_app_pages/web_mini_apps_screen.dart';
import 'package:mapness/features/balady_analytics/events/service_events.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/widgets/audio_player_banner.dart';

//!
class MiniAppsMainScreen extends ConsumerStatefulWidget {
  const MiniAppsMainScreen({super.key});

  @override
  ConsumerState<MiniAppsMainScreen> createState() => _MiniAppsMainScreenState();
}

class _MiniAppsMainScreenState extends ConsumerState<MiniAppsMainScreen> {
  late MiniApp data;
  bool showTooltip = true;

  // service_opened / service_closed boundary (docs/analytics-tracking-plan.md,
  // Phase 1): this screen is the single choke point every mini-app open goes
  // through, so it owns both events and the wall-clock duration between them.
  String? _analyticsServiceId;
  DateTime? _analyticsOpenedAt;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_analyticsServiceId == null) {
      final miniApp = ModalRoute.of(context)?.settings.arguments;
      if (miniApp is MiniApp) {
        _analyticsServiceId = miniApp.serviceKey;
        _analyticsOpenedAt = DateTime.now();
        ServiceEvents.opened(serviceId: miniApp.serviceKey);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Hide floating player and prepare for mini app navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioProvider = ref.read(streamAudioProvider);
      audioProvider.setInWeb(inWeb: true);
      audioProvider.setFloatingPlayerVisibility(isVisible: false);
      audioProvider.prepareForMiniAppNavigation();
    });
  }

  Future<bool> _showExitConfirmationDialog() async {
    Widget title = Text("closeService".tr(), style: const TextStyle(fontSize: 16, fontFamily: GeneralKey.appFontType));
    List<Widget> actions = [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text("cancel".tr(), style: TextStyle(fontFamily: GeneralKey.appFontType)),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(
          "yes".tr(),
          style: const TextStyle(color: Colors.red, fontFamily: GeneralKey.appFontType),
        ),
      ),
    ];
    return await ShowDialogOnWebView.showAlertDialog<bool>(context: context, title: title, actions: (_) => actions) ??
        false;
  }

  void openChatGPT() {
    if (CommonProperties.isLoggedIn) {
      NavigationService.navigatorKey.currentState?.pushNamed(RouteName.chatbot);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => NeedLoginDialog(
          onSuccessLogin: (bool? isSuccess) async {
            if (isSuccess ?? false) {
              NavigationService.navigatorKey.currentState?.pushNamed(RouteName.chatbot);
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)?.settings.arguments as MiniApp;
    // HomeMiniAppsListState state = context.read<HomeMiniAppsListCubit>().state;
    return BlocProvider<MiniAppsEngineBloc>(
      create: (context) => MiniAppsEngineBloc(miniApp: data),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldExit = await _showExitConfirmationDialog();
          if (shouldExit && context.mounted) {
            // Show floating player when mini app is closed
            final audioProvider = ref.read(streamAudioProvider);
            audioProvider.setInWeb(inWeb: false);
            audioProvider.setFloatingPlayerVisibility(isVisible: true);
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,

          //DynamicCardsServicesScreen?id=11010&requireDelegator=1&pageRourting=CommercialLicense_Service_Card_Page&needLogin=1
          appBar: AppBar(
            title: Text(
              data.name,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: GeneralKey.appFontType),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
                onPressed: () async {
                  final shouldExit = await _showExitConfirmationDialog();
                  if (shouldExit && context.mounted) {
                    // Show floating player when mini app is closed
                    final audioProvider = ref.read(streamAudioProvider);
                    audioProvider.setInWeb(inWeb: false);
                    audioProvider.setFloatingPlayerVisibility(isVisible: true);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
            leading: SizedBox.shrink(),
          ),
          body: SafeArea(
            top: false,
            bottom: true,
            child: Column(
              children: [
                // Audio Player Banner
                Consumer(
                  builder: (context, ref, child) {
                    final provider = ref.watch(streamAudioProvider);
                    if (provider.selectedChannel == null) {
                      return const SizedBox.shrink();
                    }
                    return AudioPlayerBanner(
                      onTap: () {
                        // Call togglePanel through the provider
                        ref.read(streamAudioProvider).togglePanel();
                      },
                      onClose: () async {
                        await ref.read(streamAudioProvider).exitPlayer();
                      },
                    );
                  },
                ),
                // Main content
                Expanded(
                  child: BlocBuilder<MiniAppsEngineBloc, MiniAppsEngineState>(
                    builder: (contextBloc, state) {
                      Widget content = const SizedBox.shrink();

                      if (state is MiniAppsEngineLoadedState) {
                        content = const WebMiniAppsScreen();
                      }

                      return Stack(
                        children: [
                          // Loader background
                          Container(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/images/newload.gif",
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 16),
                                  if (state is MiniAppsEngineLoadingState)
                                    state.progress.isEmpty
                                        ? const SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: SizedBox(
                                              height: 10,
                                              child: LinearProgressIndicator(
                                                value: (double.parse(state.progress) / 100),
                                                backgroundColor: Theme.of(context).disabledColor,
                                                valueColor: const AlwaysStoppedAnimation<Color>(
                                                  AppColor.primary900Light,
                                                ),
                                              ),
                                            ),
                                          ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "loading".tr(),
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // WebMiniAppsScreen
                          content,
                          // Error / reload overlay
                          if (state is FailedDownloadState || state is MiniAppsEngineErrorState)
                            Center(
                              child: ReloadWidget(
                                errorMessage: "errors_server_error_1".tr(),
                                onTab: () {
                                  BlocProvider.of<MiniAppsEngineBloc>(
                                    contextBloc,
                                  ).add(DownloadMiniAppsEngineEvent(miniApp: data));
                                },
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('MiniAppsMainScreen: Starting dispose');

    final serviceId = _analyticsServiceId;
    final openedAt = _analyticsOpenedAt;
    if (serviceId != null && openedAt != null) {
      ServiceEvents.closed(serviceId: serviceId, duration: DateTime.now().difference(openedAt));
    }

    // Restore audio provider and show floating player when mini app is closed
    if (mounted) {
      try {
        ref.read(streamAudioProvider).setInWeb(inWeb: false);
        ref.read(streamAudioProvider).setFloatingPlayerVisibility(isVisible: true);
      } catch (e) {
        debugPrint('MiniAppsMainScreen: Error restoring audio provider: $e');
      }
    }
    super.dispose();
  }
}
