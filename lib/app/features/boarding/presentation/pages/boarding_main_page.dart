import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/boarding/presentation/pages/boarding_pages.dart';
import 'package:flutter/material.dart';

class BoardingMainPage extends StatelessWidget {
  const BoardingMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      //Navigator
      NavigationService.navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (context) => BoardingPage()));
    });
    return Scaffold(
      backgroundColor: AppColor.splashGreen,
      body: Center(
        child: Image.asset(
          ImagePath.boardingSplashImage,
        ),
      ),
    );
  }
}
