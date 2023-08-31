import 'package:balady_plus/app/features/self_ratiing/presentation/bloc/self_rating_bloc.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/bloc/self_rating_event.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/bloc/self_rating_state.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_sections_widgets/first_section_rating.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_sections_widgets/second_section_rationg.dart';

import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_sections_widgets/self_rating_appbar.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_sections_widgets/third_section_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelfRatingSectionPage extends StatefulWidget {
  const SelfRatingSectionPage({super.key});

  @override
  State<SelfRatingSectionPage> createState() => _SelfRatingSectionPageState();
}

class _SelfRatingSectionPageState extends State<SelfRatingSectionPage> {
  PageController pageController = PageController(initialPage: 0);
  double currentStep = 1;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelfRatingBloc(),
      child: BlocBuilder<SelfRatingBloc, SelfRatingState>(
        builder: (context, state) {
          return Scaffold(
            appBar: SelfRatingAppBar(
              currentStep: state.currentStep,
              stepCounter: 4,
              backOnPress: () {},
            ),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: PageView(
                onPageChanged: (int index) {
                  context
                      .read<SelfRatingBloc>()
                      .add(SelfRatingChangePageEvent(index.toDouble()));
                },
                controller: pageController,
                children: [
                  FirstSectionRatingWidget(
                    onPressed: () {
                      pageController.jumpToPage(1);
                      context
                          .read<SelfRatingBloc>()
                          .add(SelfRatingChangePageEvent(2));
                    },
                  ),
                  SecondSectionRatingWidget(
                    onPressed: () {
                      pageController.jumpToPage(2);
                      context
                          .read<SelfRatingBloc>()
                          .add(SelfRatingChangePageEvent(3));
                    },
                  ),
                  ThirdSectionRatingWidget(
                    onPressed: () {
                      pageController.jumpToPage(3);
                      context
                          .read<SelfRatingBloc>()
                          .add(SelfRatingChangePageEvent(4));
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
