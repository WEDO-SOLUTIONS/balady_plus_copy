import 'package:balady_plus/mini_apps_engine/presentation/bloc/home_mini_apps_list_bloc/home_mini_apps_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_bloc.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_event.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_state.dart';
import 'package:balady_plus/app/core/utils/dialog_on_web_view/show_dialog_on_web_view.dart';
import 'package:balady_plus/app/core/utils/dialog_on_web_view/native_overlay_controller.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_app_pages/web_mini_apps_screen.dart';

class MiniAppsMainScreen extends StatefulWidget {
  const MiniAppsMainScreen({super.key});

  @override
  State<MiniAppsMainScreen> createState() => _MiniAppsMainScreenState();
}

class _MiniAppsMainScreenState extends State<MiniAppsMainScreen> {
  late MiniAppModel data;

  @override
  void initState() {
    super.initState();
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
    return await ShowDialogOnWebView.showAlertDialog<bool>(
            context: context, title: title, actions: (_) => actions) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)?.settings.arguments as MiniAppModel;

    HomeMiniAppsListState state = context.read<HomeMiniAppsListCubit>().state;

    return BlocProvider<MiniAppsEngineBloc>(
      create: (context) => state is HomeMiniAppsListSuccessState &&
              data.serviceKey == "municipalservice" &&
              !(state.municipalAppBloc?.isClosed ?? true) &&
              state.municipalAppBloc?.state is MiniAppsEngineLoadedState
          ? state.municipalAppBloc!
          : MiniAppsEngineBloc(miniApp: data),
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
              if (state is MiniAppsEngineInitialState) {
                return const SizedBox.shrink();
              } else if (state is MiniAppsEngineLoadedState) {
                return const WebMiniAppsScreen();
              } else if (state is FailedDownloadState ||
                  state is MiniAppsEngineErrorState) {
                return ReloadWidget(
                  errorMessage: "errors_server_error_1".tr(),
                  onTab: () {
                    BlocProvider.of<MiniAppsEngineBloc>(contextBloc).add(
                      DownloadMiniAppsEngineEvent(miniApp: data),
                    );
                  },
                );
              } else if (state is MiniAppsEngineLoadingState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                        child: LinearProgressIndicator(
                          value: state.progress.isEmpty
                              ? null
                              : (double.parse(state.progress) / 100),
                          backgroundColor: Colors.grey[200],
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
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
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Ensure overlay is hidden when screen is disposed
    NativeOverlayController.hideOverlay();
    super.dispose();
  }
}
