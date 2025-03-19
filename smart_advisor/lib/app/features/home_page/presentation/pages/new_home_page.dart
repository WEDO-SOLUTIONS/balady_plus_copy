import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/language.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/home_page/presentation/pages/area.dart';
import 'package:smart_advisor/app/features/home_page/presentation/pages/location.dart';
import 'package:smart_advisor/app/features/home_page/presentation/pages/pdf_viwer.dart';
import 'package:smart_advisor/app/features/home_page/presentation/pages/select_activity.dart';
import 'package:smart_advisor/app/features/home_page/presentation/widgets/widgetsNew/chatGPT_widget.dart';
import 'package:smart_advisor/app/features/home_page/presentation/widgets/widgetsNew/home_card_items.dart';
import 'package:smart_advisor/app/features/home_page/presentation/widgets/widgetsNew/recently_card.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/main_flow_page.dart';

import '../../../../../smart_advisor.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/services/local/shared_prefs_manager.dart';
import '../../../select_activity/domain/entities/activity_details_page_params.dart';
import '../../domain/entities/Home_card_item_model.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../widgets/chat_bot_widget.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  @override
  Widget build(BuildContext context) {
    List<ActivityDetailsPageParams> list = sharedPrefs.getRecentlyOpened();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => HomeBloc(),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColor.backgroundColor,
              body: Stack(
                children: [
                  Container(
                    height: 400,
                    decoration: const BoxDecoration(
                      // color: Colors.red,
                      image: DecorationImage(
                        image: AssetImage(
                            'packages/smart_advisor/smart_advisor_assets/images/backshadow.png'), // Correct way to reference the asset image
                        fit: BoxFit
                            .cover, // Adjust the fit of the image if needed
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFCCC9DC)
                                .withOpacity(0.24), // Color with 24% opacity
                            offset: const Offset(0, 6), // X: 0, Y: 6
                            blurRadius: 20, // Blur radius of 20
                            spreadRadius: 0, // Spread of 0
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // (Balady logo and arrow)
                                /* GestureDetector(
                                  onTap: () {
                                    Navigator.pop(SmartAdvisor.ctx);
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          IconPath.ArrowCornerRight),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      SvgPicture.asset(IconPath.baladyLogo),
                                    ],
                                  ),
                                ),*/
                                // (QR code )
                                GestureDetector(
                                    onTap: () {
                                      /*  NavigationService
                                          .navigatorKey.currentState!
                                          .pushNamed(RouteName.qrDetails);*/

                                      Navigator.pop(SmartAdvisor.ctx);
                                    },
                                    child: SvgPicture.asset(IconPath.close)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      'smartAdvisor'.tr(),
                                      style: AppStyle.headingBoldStyle.copyWith(
                                          color: AppColor.textPrimaryColor),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      'needSpecialAdvice'.tr(),
                                      style: AppStyle.textRegularRomanStyle
                                          .copyWith(
                                              color:
                                                  AppColor.textSecondaryColor),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),

                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                RouteName.mainFlowPage,
                                              );

                                              // Navigator.of(context).pushNamed(
                                              //     RouteName.newDetails,
                                              //     arguments:
                                              //         ActivityDetailsPageParams());
                                            },
                                            child: HomeCardItems(
                                              title: homeCardItems[0].title,
                                              image: homeCardItems[0].image,
                                              isDisabled:
                                                  homeCardItems[0].isDisabled,
                                              isLast: false,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 11,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              /* Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (ctx) => PDFViewer(
                                                            text:
                                                                'اشتراطات إنشاء المباني السكنية',
                                                            url:
                                                                'https://apps.balady.gov.sa/BALADYCDN/Content/Construction/ashtratatanshaalmbanyalsknytmalqrar3.pdf',
                                                          )));*/
                                            },
                                            child: HomeCardItems(
                                              title: homeCardItems[1].title,
                                              image: homeCardItems[1].image,
                                              isDisabled:
                                                  homeCardItems[1].isDisabled,
                                              isLast: false,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 11,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              /*Navigator.of(context).pushNamed(
                                                RouteName.mainFlowPage,
                                              );*/

                                              //   Navigator.of(context).pushNamed(
                                              //     RouteName.newDetails,
                                              //      arguments:
                                              //          ActivityDetailsPageParams());
                                            },
                                            child: HomeCardItems(
                                              title: homeCardItems[2].title,
                                              image: homeCardItems[2].image,
                                              isDisabled:
                                                  homeCardItems[2].isDisabled,
                                              isLast: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  /* SizedBox(
                                        height: 221,
                                        child: ListView.builder(
                                          itemCount: homeCardItems.length,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (ctx, index) {
                                            return HomeCardItems(
                                              title: homeCardItems[index].title,
                                              image: homeCardItems[index].image,
                                              isLast: false,
                                            );
                                          },
                                        ),
                                      ),*/
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  const ChatgptWidget(),
                                  const SizedBox(height: 24),
                                  // Previous consultations section
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 16),
                                    child: Text(
                                      'previousConsultations'.tr(),
                                      style: AppStyle.heading2BoldStyle
                                          .copyWith(
                                              color: AppColor.textPrimaryColor),
                                    ),
                                  ),
                                  //  const SizedBox(height: 6),

                                  SizedBox(
                                    height: 129,
                                    child: ListView.builder(
                                        itemCount: list.length ?? 0,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                end: 16, start: 16),
                                        itemBuilder: (ctx, index) {
                                          return RecentlyCard(
                                            item: list[index],
                                          );
                                        }),
                                  ),

                                  const SizedBox(
                                    height: 0,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const ChatBotWidget()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
