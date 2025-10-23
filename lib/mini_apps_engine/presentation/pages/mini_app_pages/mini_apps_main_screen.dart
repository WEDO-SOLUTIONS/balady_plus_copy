import 'dart:io';

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_bloc.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_event.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_state.dart';
import 'package:balady_plus/app/core/utils/dialog_on_web_view/show_dialog_on_web_view.dart';
import 'package:balady_plus/app/core/utils/dialog_on_web_view/native_overlay_controller.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_app_pages/web_mini_apps_screen.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';

class MiniAppsMainScreen extends ConsumerStatefulWidget {
  const MiniAppsMainScreen({super.key});

  @override
  ConsumerState<MiniAppsMainScreen> createState() => _MiniAppsMainScreenState();
}

class _MiniAppsMainScreenState extends ConsumerState<MiniAppsMainScreen> {
  late MiniAppModel data;
  bool showTooltip = true;
  bool _webViewDialogActive = false;

  @override
  void initState() {
    super.initState();

    // Listen to dragging state changes on iOS
    if (Platform.isIOS) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('DEBUG: Setting up listener for dragging state');
        ref.listen<StreamAudioProvider>(streamAudioProvider, (previous, next) {
          print('DEBUG: Dragging state changed - Previous: ${previous?.isDragging}, Next: ${next.isDragging}');
          if (previous?.isDragging != next.isDragging) {
            if (next.isDragging && !_webViewDialogActive) {
              print('DEBUG: Showing WebView protection dialog');
              _showWebViewProtectionDialog();
            } else if (!next.isDragging && _webViewDialogActive) {
              print('DEBUG: Hiding WebView protection dialog');
              _hideWebViewProtectionDialog();
            }
          }
        });
      });
    }
  }

  Future<void> _showWebViewProtectionDialog() async {
    if (_webViewDialogActive) return;

    _webViewDialogActive = true;

    await ShowDialogOnWebView.showAlertDialog<void>(
      context: context,
      title: const Text('Player Controls'),
      content: const Text('You can now drag the player safely.'),
      actions: (context) => [
        TextButton(
          onPressed: () {
            _webViewDialogActive = false;
            Navigator.of(context).pop();
            // Also stop dragging state in provider
            ref.read(streamAudioProvider).setDraggingState(false);
          },
          child: const Text('Done'),
        ),
      ],
    );

    _webViewDialogActive = false;
  }

  void _hideWebViewProtectionDialog() {
    if (_webViewDialogActive && Navigator.of(context).canPop()) {
      _webViewDialogActive = false;
      Navigator.of(context).pop();
    }
  }

  Future<bool> _showExitConfirmationDialog() async {
    Widget title = Text(
      "closeService".tr(),
      style: const TextStyle(fontSize: 16),
    );
    List<Widget> actions = [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text("cancel".tr()),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(
          "yes".tr(),
          style: const TextStyle(color: Colors.red),
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
    data = ModalRoute.of(context)?.settings.arguments as MiniAppModel;

    // Listen to dragging state changes on iOS (alternative approach)
    if (Platform.isIOS) {
      ref.listen<StreamAudioProvider>(streamAudioProvider, (previous, next) {
        print('DEBUG: Build method listener - Previous: ${previous?.isDragging}, Next: ${next.isDragging}');
        if (previous?.isDragging != next.isDragging) {
          if (next.isDragging && !_webViewDialogActive) {
            print('DEBUG: Build method - Showing WebView protection dialog');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showWebViewProtectionDialog();
            });
          } else if (!next.isDragging && _webViewDialogActive) {
            print('DEBUG: Build method - Hiding WebView protection dialog');
            _hideWebViewProtectionDialog();
          }
        }
      });
    }

    // HomeMiniAppsListState state = context.read<HomeMiniAppsListCubit>().state;
    return BlocProvider<MiniAppsEngineBloc>(
      create: (context) => MiniAppsEngineBloc(miniApp: data),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldExit = await _showExitConfirmationDialog();
          if (shouldExit && context.mounted) Navigator.of(context).pop();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(data.serviceName ?? " "),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                final shouldExit = await _showExitConfirmationDialog();
                if (shouldExit && context.mounted) Navigator.of(context).pop();
              },
            ),
          ),
          body: BlocBuilder<MiniAppsEngineBloc, MiniAppsEngineState>(
            builder: (contextBloc, state) {
              Widget content = const SizedBox.shrink();

              if (state is MiniAppsEngineLoadedState) {
                content = const WebMiniAppsScreen();
              }

              return Stack(
                children: [
                  // Loader background
                  Container(
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/loader.gif",
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
                                        backgroundColor: Colors.grey[200],
                                        valueColor: const AlwaysStoppedAnimation<Color>(AppColor.primary900Light),
                                      ),
                                    ),
                                  ),
                          const SizedBox(height: 16),
                          Text(
                            "loading".tr(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
                          BlocProvider.of<MiniAppsEngineBloc>(contextBloc).add(
                            DownloadMiniAppsEngineEvent(miniApp: data),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    NativeOverlayController.hideOverlay();
    super.dispose();
  }
}
