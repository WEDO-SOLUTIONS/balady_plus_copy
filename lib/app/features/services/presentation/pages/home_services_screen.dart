import 'package:balady_plus/app/features/services/presentation/cubit/home_services_cubit/home_services_cubit.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/home_services/category_service_item.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/home_services/most_used_service.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/home_services/most_used_services_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/utils_exports.dart'
    show CommonProperties;
import '../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog;
import '../../../profile_features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../profile_features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import '../../../profile_features/delegators/presentation/widgets/delegator_list.dart';
import '../../services_exports.dart'
    show SearchServicesTextField;

class HomeServicesScreen extends StatefulWidget {
  const HomeServicesScreen({super.key});

  @override
  State<HomeServicesScreen> createState() => _HomeServicesScreenState();
}

class _HomeServicesScreenState extends State<HomeServicesScreen> {
  bool showTooltip = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (CommonProperties.isLoggedIn)
    // context.read<ServicesCubit>().checkEkramServices();
  }

  @override
  Widget build(BuildContext context) {
    Color? color;
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
            actions: [
              // IconButton(
              //   onPressed: () async {
              //     openDelegators(context);
              //     CommonFunctions.sendUXCamEvent(
              //       UXCamEvents
              //           .DashBoard_Click_Switch_Account_From_Services_Event,
              //     );
              //   },
              //   icon: SvgPicture.asset(
              //     "assets/icons/svg/shift_persona.svg",
              //     color: color,
              //   ),
              // )
            ],
          ),
          body: BlocBuilder<HomeServicesCubit, ServicesState>(
            builder: (context, state) {
              if (state is ServicesSuccessState) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SearchServicesTextField(),
                      //////////////////////////////////////////////////////
                      //////////////////////////////////////////////////////
                      //////////////////////////////////////////////////////
                      const SizedBox(height: 16),
                      MostUsedService(
                        mostUsedService: state.homeServices.mostUsedService,
                      ),
                      //////////////////////////////////////////////////////
                      //////////////////////////////////////////////////////
                      //////////////////////////////////////////////////////

                      // Dashboard
                      // if (CommonProperties.isLoggedIn) ...[
                      //   HeaderWithAll(
                      //     text: "dashboard".tr(),
                      //     margin: const EdgeInsets.all(16),
                      //     onPressAll: () {
                      //       NavigationService.navigatorKey.currentState!
                      //           .pushNamed(RouteName.DashbordDataPage,
                      //               arguments: context.read<DelegatorsCubit>());
                      //
                      //       CommonFunctions.sendUXCamEvent(
                      //           UXCamEvents.DashBoard_Click_View_All_Event);
                      //     },
                      //   ),
                      //   const SizedBox(
                      //     height: 8
                      //   ),
                      //   SingleChildScrollView(
                      //     scrollDirection: Axis.horizontal,
                      //     child: IntrinsicHeight(
                      //       child: Row(
                      //         crossAxisAlignment: CrossAxisAlignment.stretch,
                      //         children: dashboardState.cards
                      //             .map(
                      //               (e) => DashboardCard(
                      //                 card: e,
                      //                 totalCount: dashboardState
                      //                         .cardsStates[e]?.totalCount ??
                      //                     0,
                      //               ),
                      //             )
                      //             .toList(),
                      //       ),
                      //     ),
                      //   ),
                      // ],
                      //////////////////////////////////////////////////////
                      //////////////////////////////////////////////////////
                      //////////////////////////////////////////////////////
                      const SizedBox(height: 16),
                      FeatureServicesList(
                        mostUsedServices : state.homeServices.mostUsedServices,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "services_categories".tr(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1.1,
                          ),
                          itemCount:
                              state.homeServices.servicesCategories.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CategoryServiceItem(
                              servicesCategory:
                                  state.homeServices.servicesCategories[index],
                            );
                          },
                        ),
                      ),
                      //////////////////////////////////////////////////////
                      //////////////////////////////////////////////////////
                      //////////////////////////////////////////////////////
                    ],
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

  void openDelegators(BuildContext context) async {
    if (CommonProperties.isLoggedIn) {
      context.read<DelegatorsCubit>().getDelegators();
      context.read<DelegatorsCubit>().getAgents();
      await BottomSheetDialog.showDraggableSheet(
        context,
        dialogKeyName: DialogName.delegatorsDialog,
        currentRouteName: "ServicesPage",
        child: DelegatorList(
          delegatorsCubit: context.read<DelegatorsCubit>(),
        ),
      );

      BlocProvider.of<DashboardBloc>(context).add(DashboardEventInitial());
    } else {
      showDialog(
          context: context,
          builder: (ctx) =>
              NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                if (isSuccess ?? false) {
                  context.read<DelegatorsCubit>().getDelegators();
                  context.read<DelegatorsCubit>().getAgents();
                  await BottomSheetDialog.showDraggableSheet(
                    context,
                    dialogKeyName: DialogName.delegatorsDialog,
                    currentRouteName: "ServicesPage",
                    child: DelegatorList(
                      delegatorsCubit: context.read<DelegatorsCubit>(),
                    ),
                  );

                  BlocProvider.of<DashboardBloc>(context)
                      .add(DashboardEventInitial());
                }
              }));
    }
  }

}
