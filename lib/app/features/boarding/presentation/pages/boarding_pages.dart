import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/boarding/presentation/widgets/boarding_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

class BoardingPage extends StatefulWidget {
  const BoardingPage({super.key});

  @override
  State<BoardingPage> createState() => _BoardingPageState();
}

class _BoardingPageState extends State<BoardingPage> {
  late int selectedPage;
  late final PageController _pageController;

  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);
  }

  void _goToNextPage() {
    if (selectedPage < _pages.length - 1) {
      _pageController.animateToPage(
        selectedPage + 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  final List<Widget> _pages = [
    BoardingWidget(
      phoneDisplay: ImagePath.boardingMainImage,
      subtitle: 'boarding_subtitle'.tr(),
      title: 'boarding_main_title'.tr(),
    ),
    BoardingWidget(
      phoneDisplay: ImagePath.boardingCloseImage,
      subtitle: 'boarding_subtitle'.tr(),
      title: 'boarding_close_title'.tr(),
    ),
    BoardingWidget(
      phoneDisplay: ImagePath.boardingServiceImage,
      subtitle: 'boarding_subtitle'.tr(),
      title: 'boarding_service_title'.tr(),
    ),
    BoardingWidget(
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
                selectedPage = index;
              });
            },
            children: _pages,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: AppColor.white,
          ),
          child: PageViewDotIndicator(
            currentItem: selectedPage,
            count: _pages.length,
            boxShape: BoxShape.rectangle,
            size: const Size(31, 9),
            unselectedSize: const Size(9, 9),
            unselectedColor: Color(0xffE8EFF1),
            selectedColor: AppColor.primary900Light,
            duration: const Duration(milliseconds: 200),
            onItemClicked: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: AppColor.white,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(
                height: 26,
              ),
              CustomElevatedButtonWidget(
                onPressed: _goToNextPage,
                btnWidth: 343,
                btnRadius: 8,
                btnPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                btnColor: AppColor.primary900Light,
                text: selectedPage < _pages.length - 1
                    ? "boarding_button_text".tr()
                    : "boarding_end_text".tr(),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        )
      ]),
    );
  }
}
