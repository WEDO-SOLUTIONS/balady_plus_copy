import 'package:balady_plus/mini_apps_engine/presentation/bloc/home_mini_apps_list_bloc/home_mini_apps_list_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/widgets/mini_apps_item_widget.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class HomeMiniAppsListPages extends StatefulWidget {
  const HomeMiniAppsListPages({super.key});

  @override
  State<HomeMiniAppsListPages> createState() => _HomeMiniAppsListPagesState();
}

class _HomeMiniAppsListPagesState extends State<HomeMiniAppsListPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "AppsTitle".tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'packages/balady_uikit/Frutiger',
          ),
        ),
        centerTitle: true,
        backgroundColor: context.colors.accentDefault,
        elevation: 0,
      ),
      body: BlocBuilder<HomeMiniAppsListCubit, HomeMiniAppsListState>(
        builder: (context, state) {
          if (state is HomeMiniAppsListFiledState) {
            return _buildErrorState(context, state.errors);
          }

          if (state is HomeMiniAppsListSuccessState) {
            return SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeMiniAppsListCubit>().loadMiniApps();
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.miniAppsList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return MiniAppsItemWidget(
                      miniApp: state.miniAppsList[index],
                    );
                  },
                ),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  context.read<HomeMiniAppsListCubit>().loadMiniApps();
                },
                child: Text("refresh".tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
