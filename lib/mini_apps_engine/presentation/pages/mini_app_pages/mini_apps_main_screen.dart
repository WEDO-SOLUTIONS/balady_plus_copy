import 'package:balady_plus/app/core/remote_services/pega_web_service.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/home_mini_apps_list_bloc/home_mini_apps_list_cubit.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MiniAppModel data =
        ModalRoute.of(context)?.settings.arguments as MiniAppModel;

    HomeMiniAppsListSuccessState state =
        BlocProvider.of<HomeMiniAppsListCubit>(context).state
            as HomeMiniAppsListSuccessState;

    Widget body = Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(data.serviceName ?? ""),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocBuilder<MiniAppsEngineBloc, MiniAppsEngineState>(
        builder: (contextBloc, state) {
          if (state is MiniAppsEngineInitialState) {
            return const Center(child: Text('Loading ...'));
          } else if (state is MiniAppsEngineLoadedState) {
            return WebMiniAppsScreen(servicePath: state.servicePath);
          } else if (state is MiniAppsEngineErrorState) {
            return Center(child: Text(state.errorMessage));
          } else if (state is FailedDownloadState) {
            return ReloadWidget(
              errorMessage: "errors_server_error_1".tr(),
              onTab: () {
                BlocProvider.of<MiniAppsEngineBloc>(contextBloc).add(
                  DownloadMiniAppsEngineEvent(miniApp: data),
                );
              },
            );
          } else if (state is MiniAppsEngineLoadingState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    state.progress,
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
    );

    return (state.municipalAppBloc != null &&
            state.municipalAppBloc!.miniApp.serviceKey == data.serviceKey && state.municipalAppBloc!.state is! MiniAppsEngineLoadedState)
        ? BlocProvider.value(
            value: state.municipalAppBloc!
              ..add(
                OpenServerEngineEvent(miniApp: data),
              ),
            child: body,
          )
        : BlocProvider<MiniAppsEngineBloc>(
            create: (context) {
              return MiniAppsEngineBloc(miniApp: data);
            },
            child: body,
          );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
