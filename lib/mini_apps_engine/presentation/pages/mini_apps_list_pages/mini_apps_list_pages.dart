import 'package:balady_plus/mini_apps_engine/presentation/bloc/home_mini_apps_list_bloc/home_mini_apps_list_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/widgets/mini_apps_item_widget.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("services".tr()),
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<HomeMiniAppsListCubit, HomeMiniAppsListState>(
        builder: (context, state) {
          if (state is HomeMiniAppsListFiledState) {
            return Center(
              child: Text(state.errors),
            );
          }
          if (state is HomeMiniAppsListSuccessState) {
            return SafeArea(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: .9,
                ),
                itemCount: state.miniAppsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return MiniAppsItemWidget(
                    miniApp: state.miniAppsList[index],
                  );
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}