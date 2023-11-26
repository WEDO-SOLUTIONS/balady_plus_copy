import 'package:balady_new_app/app/core/core_exports.dart'
    show
        AppColors,
        Constants,
        CustomElevatedButtonWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        FONT_WEIGHT,
        RoutesNames;
import 'package:balady_new_app/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_new_app/app/core/shared_widgets/custom_buttons_widgets.dart';

import 'package:balady_new_app/shared/core/services/services_exports.dart';
import 'package:balady_new_app/shared/core/utils/common_properties.dart';
import 'package:balady_new_app/shared/core/utils/utils_exports.dart';
import 'package:balady_new_app/shared/features/authorization/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';

import '../../../../../etmam_app/core/utils/utils_exports.dart' show trans;

class EkramHomePage extends StatefulWidget {
  const EkramHomePage({Key? key}) : super(key: key);

  @override
  State<EkramHomePage> createState() => _EkramHomePageState();
}

class _EkramHomePageState extends State<EkramHomePage> {
  bool isDriver = false;

  @override
  void initState() {
    super.initState();
    sl<AuthCubit>().getEkramPermissions(allowTracking: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
            right: 16,
            left: 16,
            top: MediaQuery.of(context).padding.top + 10,
            bottom: 30),
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    Constants.whiteCloseImg,
                    height: 20.0,
                    width: 20.0,
                    color: Colors.black,
                  ),
                ),
                if (CommonProperties.showEkramDriver == true)
                  CustomTextButtonWidget(
                    btnPressed: () {
                      setState(() {
                        isDriver = !isDriver;
                      });
                    },
                    btnText: isDriver ? "تحويل إلى مستفيد" : "تحويل لموظف نقل",
                    btnTextWeight: FONT_WEIGHT.regular,
                  ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/upIcon@3x.png",
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                    CustomVerticalSpace(height: 32),
                    CustomTextWidget(
                      trans('ekramService'),
                      fontSize: 22,
                      fontWeight: FONT_WEIGHT.bold,
                      fontColor: AppColors.black,
                    ),
                    CustomVerticalSpace(height: 12),
                    CustomTextWidget(
                      trans('ekramServiceDesc'),
                      fontSize: 16,
                      fontWeight: FONT_WEIGHT.medium,
                      fontColor: AppColors.black500,
                      height: 1.4,
                    ),
                    CustomVerticalSpace(height: 32),
                    Image.asset(
                      "assets/images/downIcon@3x.png",
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: CustomElevatedButtonWidget(
                btnPressed: () {
                  if (CommonProperties.isUserLogged) {
                    if (isDriver) {
                      NavigationService.navigatorKey.currentState!.pushNamed(
                          RoutesNames.driverEkramTransportationListScreen);
                    } else {
                      NavigationService.navigatorKey.currentState!
                          .pushNamed(RoutesNames.ekramOrdersScreen);
                    }
                  } else {
                    sl<AuthCubit>().onLogin().then((value) {
                      if (value == true) {
                        if (isDriver) {
                          NavigationService.navigatorKey.currentState!
                              .pushNamed(RoutesNames
                                  .driverEkramTransportationListScreen);
                        } else {
                          NavigationService.navigatorKey.currentState!
                              .pushNamed(RoutesNames.ekramOrdersScreen);
                        }
                      }
                    });
                  }
                },
                btnText: trans('ekramStartService'),
                btnTextSize: 16,
                btnTextWeight: FONT_WEIGHT.regular,
                btnHeight: 56,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
