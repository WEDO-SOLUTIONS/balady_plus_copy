import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, CommonFunctions, CommonProperties, IconPath, RouteName;
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
   bool showTooltip=true;

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



    showTooltip=true;

    return Stack(
      children: [
      BlocConsumer<DashboardBloc, DashboardState>(
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


                              const SizedBox(height: 100),


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


        Positioned(
          left: 20,
         bottom: 10,
          child:
          Stack(
            children:
            [
              SizedBox(
                height: 130,
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,

                      child: showTooltip==true?
                      Container(
                        margin: const EdgeInsets.only(left: 25),
                        padding: const EdgeInsets.all( 10),

                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Color(0x1a000000),
                                offset: Offset(0, 2),
                                blurRadius: 15,
                                spreadRadius: 0)
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: AppColor.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text("welcome".tr(),
                                  style: AppStyle.cardTitleTextStle.copyWith(fontSize: 14),
                                ),

                                // SizedBox(
                                //   width: 20,
                                //   height: 20,
                                //   child: IconButton(
                                //
                                //     padding:EdgeInsets.all( 0),
                                //     onPressed: () {
                                //
                                //       setState(() {
                                //         showTooltip = !showTooltip;
                                //       });
                                //
                                //
                                //     },
                                //     icon: const Icon(Icons.close,size: 20,),
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text("gptWelcome".tr(), style: AppStyle.serviceIconTextStyle.copyWith(fontSize: 12,color: AppColor.blackModern500Light)),
                            ),


                          ],

                        ),

                      ):Container(),
                    ),
                    SizedBox(height: 40,)

                  ],
                ),
              ),
              Positioned(
                left: 1,
                top: 60,
                child: FloatingActionButton(
                  onPressed: () {
                    openChatGPT();
                  },
                  backgroundColor:  AppColor.baladyDarkGreen2,
                  child: SvgPicture.asset(
                    IconPath.chat_gpt_bot_icon,),

                ),
              ),
            ]
          ),
        
        ),
      ]

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
  
  
 void  openChatGPT()
  {
    if (CommonProperties.isLoggedIn) {

      NavigationService.navigatorKey.currentState?.pushNamed(RouteName.chatbot);

    } else {
      showDialog(
          context: context,
          builder: (ctx) => NeedLoginDialog(
              onSuccessLogin: (bool? isSuccess) async {
                if (isSuccess ?? false) {

                  NavigationService.navigatorKey.currentState?.pushNamed(RouteName.chatbot);

                }
              }));
    }
  }
}
