import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_bloc.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_event.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_state.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/pages/violation_address_select_page.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/details_app_bar.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_create_widgets/violation_create_list_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViolationCreatePage extends StatefulWidget {
  const ViolationCreatePage({super.key});

  @override
  State<ViolationCreatePage> createState() => _ViolationCreatePageState();
}

class _ViolationCreatePageState extends State<ViolationCreatePage> {
  PageController pageController = PageController(initialPage: 0);
  double currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ViolationBloc(),
      child: BlocBuilder<ViolationBloc, ViolationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.scaffoldBackground,
            appBar: ViolationAppBar(
              currentStep: state.currentStep,
              stepCounter: 2,
              backOnPress: () {},
            ),
            body: Container(
              padding: const EdgeInsets.all(16),
              child: PageView(
                  onPageChanged: (int index) {
                    context
                        .read<ViolationBloc>()
                        .add(ChangePageEvent(index.toDouble()));
                  },
                  controller: pageController,
                  children: [
                    ViolationCreateListWidget(onPressed: () {
                      pageController.jumpToPage(1);
                      context
                          .read<ViolationBloc>()
                          .add(const ChangePageEvent(2));
                    }),
                    const ViolationAddressSelectPage(),
                  ]),
            ),
          );
        },
      ),
    );
  }
}
