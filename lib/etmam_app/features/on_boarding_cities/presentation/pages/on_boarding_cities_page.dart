import 'package:balady_plus/etmam_app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:balady_plus/etmam_app/features/on_boarding_cities/on_boarding_cities_exports.dart'
    show CityBloc, CityState, SearchForCityEvent;
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, ImagePath, trans;
import '../../on_boarding_cities_exports.dart' show CitiesContainerWidget;

class OnBoardingCitiesPage extends StatefulWidget {
  const OnBoardingCitiesPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingCitiesPage> createState() => _OnBoardingCitiesPageState();
}

class _OnBoardingCitiesPageState extends State<OnBoardingCitiesPage> {
  @override
  Widget build(BuildContext context) {
/*    return Scaffold(
        body: Stack(
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/splash/background.svg',
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Container(
              child: Column(
                children: <Widget>[Expanded(child: _createLogo())],
              ),
            ),
          ],
        ));*/
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return Future.value(true);
      },
      child: Scaffold(
          appBar: null,
          backgroundColor: AppColor.blue700,
          body: BlocBuilder<CityBloc, CityState>(builder: (context, state) {
            return BlocConsumer<CityBloc, CityState>(
              bloc: sl(),
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                            flex: 5,
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(ImagePath.onBoardingBg),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Center(
                                  child: CustomTextWidget(
                                trans('on_boarding_header'),
                                fontColor: AppColor.white,
                                fontSize: 24,
                                fontWeight: AppFontWeight.w600,
                              )),
                            )),
                        const Expanded(flex: 7, child: CitiesContainerWidget()),
                        // Container(
                        //     height: 485,
                        //     child: CitiesContainerWidget()),
                      ],
                    ),
                    if (state.status == BlocStatus.loading)
                      const CustomLoadingWidget()
                  ],
                );
              },
            );
          })),
    );
  }

  @override
  void dispose() {
    super.dispose();
    sl<CityBloc>().add(SearchForCityEvent(text: ""));
  }
}
