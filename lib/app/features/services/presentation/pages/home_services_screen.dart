import 'package:balady_plus/app/features/services/presentation/cubit/home_services_cubit/home_services_cubit.dart';
import 'package:balady_plus/app/features/services/presentation/cubit/sub_service_cubit/sub_service_cubit.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/home_services/mini_apps_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../profile_features/dashboard/presentation/bloc/dashboard_bloc.dart';

class HomeServicesScreen extends StatefulWidget {
  const HomeServicesScreen({super.key});

  @override
  State<HomeServicesScreen> createState() => _HomeServicesScreenState();
}

class _HomeServicesScreenState extends State<HomeServicesScreen> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, dashboardState) {},
      builder: (context, dashboardState) {
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
          body: BlocBuilder<HomeServicesCubit, ServicesState>(
            builder: (context, state) {
              if (state is ServicesSuccessState) {
                return BlocProvider<ServiceCardsCubit>(
                    create: (context) => ServiceCardsCubit(listOfServices: state.homeServices.miniApps),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: RefreshIndicator(
                      onRefresh: () {
                        context.read<HomeServicesCubit>().loadServices();
                        return Future.value();
                      },
                      child: const MiniAppsSearchScreen(),
                    ),
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        );
      },
    );
  }
}
