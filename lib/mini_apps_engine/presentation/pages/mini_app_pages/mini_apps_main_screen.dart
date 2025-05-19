import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_bloc.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_state.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_app_pages/web_mini_apps_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
      create: (context) => MiniAppsEngineBloc(miniApp: data),
      child: Scaffold(
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
          builder: (context, state) {
            if (state is MiniAppsEngineInitialState) {
              return const Center(child: Text('Loading ...'));
            } else if (state is MiniAppsEngineLoadedState) {
              return WebMiniAppsScreen(servicePath: state.servicePath);
            } else if (state is MiniAppsEngineErrorState) {
              return Center(child: Text(state.errorMessage));
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
        // floatingActionButton: favoriteButton(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
