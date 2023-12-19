import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/utils_exports.dart'
    show
        AppColor,
        AppFontWeight,
        BlocRequestStatus,
        CommonProperties,
        IconPath,
        RouteName;
import '../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        CustomTextWidget,
        DefaultAppBarWidget,
        ElevatedButtonWidget,
        TabPageContainer;
import '../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../../../home_page/home_exports.dart' show CircleIcon;
import '../../../profile/presentation/widgets/sign_in_card.dart';
import '../../../profile_features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../profile_features/dashboard/presentation/widgets/dashboard_list_shimmer.dart';
import '../../../profile_features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import '../../../profile_features/delegators/presentation/widgets/delegator_list.dart';
import '../../services_exports.dart'
    show SearchServicesTextField, ServicesCubit, ServicesList, ServicesState;
import '../widgets/dashboard_card.dart';
import '../widgets/enhanced_app_bar.dart';
import '../widgets/header_with_all.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ServicesCubit>().checkEkramServices();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>(
      create: (context) => sl<DashboardBloc>()..add(DashboardEventInitial()),
      child: BlocConsumer<DashboardBloc, DashboardState>(
          listener: (context, dashboardState) {},
          builder: (context, dashboardState) {
            return BlocBuilder<ServicesCubit, ServicesState>(
              builder: (context, state) {
                return Scaffold(
                  backgroundColor: AppColor.white,
                  appBar: EnhancedAppBar(
                    title: "services".tr(),
                    actions: [
                      IconButton(
                          onPressed: () async {
                            openDelegators();
                          },
                          icon:
                              SvgPicture.asset("assets/icons/svg/refresh.svg"))
                    ],
                  ),
                  body: BlocBuilder<ServicesCubit, ServicesState>(
                    builder: (context, state) {
                      print("islamicServices ${state.islamicServices.length}");
                      return BlocBuilder<EntryPointCubit, EntryPointState>(
                          builder: (context, entryPointState) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SearchServicesTextField(),
                              /* if (CommonProperties.isLoggedIn)
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ElevatedButtonWidget.logout(
                                      onPressed: () {
                                    sl<EntryPointCubit>().clearAuth();
                                  }),
                                ),
                              if (!CommonProperties.isLoggedIn)
                                const SignInCard(),*/
                              if (CommonProperties.isLoggedIn) ...[
                                HeaderWithAll(
                                  text: "dashboard".tr(),
                                  margin: const EdgeInsets.all(16),
                                  onPressAll: () {
                                    NavigationService.navigatorKey.currentState!
                                        .pushNamed(RouteName.DashbordDataPage,
                                            arguments: context
                                                .read<DelegatorsCubit>());
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  height: 58,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: dashboardState.cards.length,
                                    itemBuilder: (context, index) {
                                      return DashboardCard(
                                        card: dashboardState.cards[index],
                                        totalCount: dashboardState
                                                .cardsStates[
                                                    dashboardState.cards[index]]
                                                ?.totalCount ??
                                            0,
                                      );
                                    },
                                  ),
                                ),
                              ],
                              const SizedBox(
                                height: 16,
                              ),
                              if (state.islamicServices.isNotEmpty)
                                ServicesList(
                                  title: "islamic_services".tr(),
                                  services: state.islamicServices,
                                ),
                              if (state.municipalServicee.isNotEmpty)
                                ServicesList(
                                  title: "municipal_services".tr(),
                                  services: state.municipalServicee,
                                ),
                              if (state.businessLicenseServices.isNotEmpty)
                                ServicesList(
                                  title: "business_license_services".tr(),
                                  services: state.businessLicenseServices,
                                ),
                              if (state.helpServices.isNotEmpty)
                                ServicesList(
                                  title: "help_services".tr(),
                                  services: state.helpServices,
                                ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        );
                      });
                    },
                  ),
                );
              },
            );
          }),
    );
  }

  void openDelegators() async {
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

      context.read<DashboardBloc>().add(DashboardEventInitial());
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

                  context.read<DashboardBloc>().add(DashboardEventInitial());
                }
              }));
    }
  }
}
