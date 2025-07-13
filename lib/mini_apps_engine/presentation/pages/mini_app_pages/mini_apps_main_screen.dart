import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_bloc.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_event.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_state.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_app_pages/web_mini_apps_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

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
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "closeService".tr(),
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("cancel".tr()),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  "yes".tr(),
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)?.settings.arguments as MiniAppModel;

    return BlocProvider<MiniAppsEngineBloc>(
      create: (context) {
        return MiniAppsEngineBloc(miniApp: data);
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldExit = await _showExitConfirmationDialog();
          if (shouldExit) Navigator.of(context).pop();
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
                if (shouldExit) Navigator.of(context).pop();
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
    super.dispose();
  }
}
