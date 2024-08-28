import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/utils_exports.dart'
    show
        AppColor,
        CommonFunctions,
        CommonProperties,
        RouteName;
import '../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog;
import '../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../../../profile_features/dashboard/presentation/bloc/dashboard_bloc.dart';
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
    if (CommonProperties.isLoggedIn)
      context.read<ServicesCubit>().checkEkramServices();
  }

  @override
  Widget build(BuildContext context) {
    //Color? color = CommonFunctions.isFoundationDay() ? Color(0xff6B4E45) : null;
    Color? color;

    return BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, dashboardState) {},
        builder: (context, dashboardState) {
          return BlocBuilder<ServicesCubit, ServicesState>(
            builder: (context, state) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: AppColor.white,
                appBar: EnhancedAppBar(
                  title: "services".tr(),
                  titleColor: color,
                  actions: [
                    IconButton(
                        onPressed: () async {
                          openDelegators(context);

                          CommonFunctions.sendUXCamEvent(UXCamEvents
                              .DashBoard_Click_Switch_Account_From_Services_Event);
                        },
                        icon: SvgPicture.asset(
                          "assets/icons/svg/refresh.svg",
                          color: color,
                        ))
                  ],
                ),
                body: BlocBuilder<ServicesCubit, ServicesState>(
                  builder: (context, state) {
                    return BlocBuilder<EntryPointCubit, EntryPointState>(
                        builder: (context, entryPointState) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                          arguments:
                                              context.read<DelegatorsCubit>());

                                  CommonFunctions.sendUXCamEvent(UXCamEvents
                                      .DashBoard_Click_View_All_Event);
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: dashboardState.cards
                                        .map((e) => DashboardCard(
                                              card: e,
                                              totalCount: dashboardState
                                                      .cardsStates[e]
                                                      ?.totalCount ??
                                                  0,
                                            ))
                                        .toList(),
                                  ),
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
        });
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
