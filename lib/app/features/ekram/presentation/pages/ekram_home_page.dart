import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/enums/auth_status.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../etmam_app/core/utils/utils_exports.dart'
    show AppColor, trans;
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

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
    //MM Ekram  sl<AuthCubit>().getEkramPermissions(allowTracking: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EntryPointCubit, EntryPointState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          if (isDriver) {
            NavigationService.navigatorKey.currentState!
                .pushNamed(RouteName.driverEkramTransportationListScreen);
          } else {
            NavigationService.navigatorKey.currentState!
                .pushNamed(RouteName.ekramOrdersScreen);
          }
        }
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(
              right: 16,
              left: 16,
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 30),
          color: AppColor.white,
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
                  // if (CommonProperties.showEkramDriver == true) //MM Ekram
                  CustomTextButtonWidget(
                    onPressed: () {
                      setState(() {
                        isDriver = !isDriver;
                      });
                    },
                    text: isDriver ? "تحويل إلى مستفيد" : "تحويل لموظف نقل",
                    btnTextWeight: AppFontWeight.regular,
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
                        fontWeight: AppFontWeight.bold,
                        fontColor: AppColor.black,
                      ),
                      CustomVerticalSpace(height: 12),
                      CustomTextWidget(
                        trans('ekramServiceDesc'),
                        fontSize: 16,
                        fontWeight: AppFontWeight.medium,
                        fontColor: AppColor.black500,
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
                  onPressed: () {
                    if (CommonProperties.isLoggedInMunicipality) {
                      if (isDriver) {
                        NavigationService.navigatorKey.currentState!.pushNamed(
                            RouteName.driverEkramTransportationListScreen);
                      } else {
                        NavigationService.navigatorKey.currentState!
                            .pushNamed(RouteName.ekramOrdersScreen);
                      }
                    } else {
                      sl<EntryPointCubit>().onLogin(
                        isMunicipality: true,
                      );
                    }
                  },
                  text: trans('ekramStartService'),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  btnHeight: 56,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
