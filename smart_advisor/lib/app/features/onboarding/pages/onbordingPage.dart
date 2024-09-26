import 'package:smart_advisor/smart_advisor.dart';

import '../../../core/services/local/navigation_services.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/constants/language.dart';
import 'package:flutter/material.dart';

// import '../../home/pages/homePage.dart';
import '../../shared_features/widgets/custom_button.dart';
import '../../start_page/startPage.dart';
import '../widgets/firstpage_onbording.dart';
import '../widgets/secPage_onb.dart';

class Onbordingpage extends StatefulWidget {
  const Onbordingpage({Key? key}) : super(key: key);

  @override
  State<Onbordingpage> createState() => _OnbordingpageState();
}

class _OnbordingpageState extends State<Onbordingpage> {
  // Page controller for controlling the PageView
  final PageController _pageController = PageController();

  // Current page index for the PageView
  int _currentPage = 0;

  // List of pages in the PageView
  final List<Widget> _pages = [
    const FirstpageOnbording(),
    const SecpageOnb(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: null,
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: _pages,
              ),
            ),

            // Indicator circles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
            const SizedBox(
              height: 32,
            ),

            CustomButton(
              btnHeight: 48,
              btnColor: AppColor.textPrimaryColor,
              textColor: AppColor.white,
              onPress: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) {
                  return Startpage();
                }));
              },
              btnMargin: const EdgeInsets.symmetric(horizontal: 16),
              text: ("continue").tr(),
            )
          ],
        ),
      ),
    );
  }

  // Method to build the page indicators (circles)
  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _pages.length; i++) {
      indicators.add(
        Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i
                ? AppColor.textSecondaryColor
                : Colors.grey[400],
          ),
        ),
      );
    }
    return indicators;
  }
}
