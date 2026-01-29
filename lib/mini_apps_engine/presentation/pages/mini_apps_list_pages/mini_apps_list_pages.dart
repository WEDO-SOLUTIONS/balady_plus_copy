import 'package:balady_plus/app/core/utils/common_functions.dart';
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
  void initState() {
    super.initState();
    // Load mini apps when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeMiniAppsListCubit>().loadMiniApps();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.backgroundSurface4,
      appBar: CommonFunctions.isTodayInRanges ? null : _buildDefaultAppBar(context),
      body: CommonFunctions.isTodayInRanges
          ? Column(children: [Expanded(child: _buildCustomAppBarLayout())])
          : _buildDefaultLayout(),
    );
  }

  Widget _buildDefaultLayout() {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            child: Container(
              color: context.colors.backgroundSurface4,
              child: BlocBuilder<HomeMiniAppsListCubit, HomeMiniAppsListState>(
                builder: (context, state) {
                  return _buildContent(state);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomAppBarLayout() {
    return Stack(
      children: [
        // Custom AppBar
        _buildCustomAppBar(context),

        Positioned(top: 130, bottom: 0, left: 0, right: 0, child: _buildDefaultLayout()),
      ],
    );
  }

  Widget _buildContent(HomeMiniAppsListState state) {
    if (state is HomeMiniAppsListFiledState) {
      return _buildErrorState(context, state.errors);
    }

    if (state is HomeMiniAppsListSuccessState) {
      return _buildSuccessState(state);
    }

    if (state is HomeMiniAppsListLoadingState) {
      return _buildLoadingState();
    }

    return _buildLoadingState();
  }

  Widget _buildSuccessState(HomeMiniAppsListSuccessState state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeMiniAppsListCubit>().loadMiniApps();
      },
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
        itemCount: state.miniAppsList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return MiniAppsItemWidget(miniApp: state.miniAppsList[index], isEvent: CommonFunctions.isTodayInRanges);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  PreferredSizeWidget _buildDefaultAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "AppsTitle".tr(),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: context.colors.foregroundDefault,
          fontFamily: 'packages/balady_uikit/Frutiger',
        ),
      ),
      centerTitle: true,
      backgroundColor: context.colors.backgroundSurface4,
      elevation: 0,
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      height: 210,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/national.png"), fit: BoxFit.fill),
      ),
      child: Center(
        child: Text(
          "AppsTitle".tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'packages/balady_uikit/Frutiger',
          ),
        ),
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
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade700),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  context.read<HomeMiniAppsListCubit>().loadMiniApps();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.accentDefault,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("refresh".tr(), style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
