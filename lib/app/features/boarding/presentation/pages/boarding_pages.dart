import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/boarding/presentation/widgets/boarding_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class BoardingPage extends StatefulWidget {
  const BoardingPage({super.key});

  @override
  State<BoardingPage> createState() => _BoardingPageState();
}

class _BoardingPageState extends State<BoardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    BoardingWidget(
      loadingImage: ImagePath.boardingloader1,
      phoneDisplay: ImagePath.boardingMainImage,
      subtitle: 'boarding_subtitle'.tr(),
      title: 'boarding_main_title'.tr(),
    ),
    BoardingWidget(
      loadingImage: ImagePath.boardingloader2,
      phoneDisplay: ImagePath.boardingCloseImage,
      subtitle: 'boarding_subtitle'.tr(),
      title: 'boarding_close_title'.tr(),
    ),
    BoardingWidget(
      loadingImage: ImagePath.boardingloader3,
      phoneDisplay: ImagePath.boardingServiceImage,
      subtitle: 'boarding_subtitle'.tr(),
      title: 'boarding_service_title'.tr(),
    ),
    BoardingWidget(
      loadingImage: ImagePath.boardingloader4,
      phoneDisplay: ImagePath.boardingAccountImage,
      subtitle: 'boarding_subtitle'.tr(),
      title: 'boarding_account_title'.tr(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            children: _pages,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColor.white,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 26,
              ),
              CustomElevatedButtonWidget(
                btnWidth: 343,
                btnRadius: 8,
                btnPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                btnColor: AppColor.blueSkyLight800,
                text: 'boarding_button_text'.tr(),
                onPressed: () {
                  if (_currentPageIndex < _pages.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        )
      ]),
    );
  }
}
