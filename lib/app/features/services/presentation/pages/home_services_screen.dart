import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/services/core/home_services_routes/home_services_route_names.dart';
import 'package:balady_plus/app/features/services/presentation/cubit/home_services_cubit/home_services_cubit.dart';
import 'package:balady_plus/app/features/services/presentation/cubit/sub_service_cubit/sub_service_cubit.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/home_services/mini_apps_item_widget.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/home_services/mini_apps_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
                      child: TextFormField(
                        onTap: () {
                          NavigationService.navigatorKey.currentState!.pushNamed(
                            HomeServicesRouteName.subServicesScreen,
                            arguments: {
                              "services": state.homeServices.miniApps,
                            },
                          );
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "search".tr(),
                          filled: true,
                          isDense: true,
                          fillColor: Colors.grey.shade200,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10),
                            child: SvgPicture.asset(IconPath.search),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RefreshIndicator(
                        onRefresh: () {
                          context.read<HomeServicesCubit>().loadServices();
                          return Future.value();
                        },
                        child: SafeArea(
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 5,
                              childAspectRatio: .75,
                            ),
                            itemCount: state.homeServices.miniApps.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MiniAppsItemWidget(
                                service: state.homeServices.miniApps[index],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
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
