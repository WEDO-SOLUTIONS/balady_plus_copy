import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomAppBar,
        CustomTextWidget,
        CustomVerticalSpace,
        SectionTitleWidget;
import 'package:flutter/material.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, CommonFunctions, PrimaryIcons, trans;
import '../../../../services/services_exports.dart'
    show PreviousWorkCard, Project;

class PreviousWorksPage extends StatefulWidget {
  const PreviousWorksPage({Key? key}) : super(key: key);

  @override
  State<PreviousWorksPage> createState() => _PreviousWorksPageState();
}

class _PreviousWorksPageState extends State<PreviousWorksPage> {
  List<Project>? projects;

  @override
  Widget build(BuildContext context) {
    projects = ModalRoute.of(context)!.settings.arguments as List<Project>?;

    return Scaffold(
      appBar: DefaultAppBarWidget(title: trans('previous_works')),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemCount: projects?.length ?? 0,
          itemBuilder: (_, index) => PreviousWorkCard(
            project: projects?[index],
          ),
        ),
      ),
      // Container(
      //   margin: EdgeInsets.only(top: 24),
      //   padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      //   color: AppColor.white,
      //   child: Column(
      //
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       SectionTitleWidget(
      //         title: trans('previous_works'),
      //         primaryIcon: PrimaryIcons.providerWorksIcon,
      //       ),
      //       CustomTextWidget(
      //         trans('previous_works_desc'),
      //         fontColor: AppColor.bottomNavigationShadow,
      //         fontSize: 12,
      //         fontWeight: AppFontWeight.regular,
      //         textAlign: TextAlign.start,
      //       ),
      //       CustomVerticalSpace(height: 10),
      //       Expanded(
      //         child: GridView.builder(
      //             padding: EdgeInsets.symmetric(horizontal: 5),
      //             physics: const BouncingScrollPhysics(),
      //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //                 crossAxisCount: 2,
      //                 mainAxisExtent: 222,
      //                 mainAxisSpacing: 12,
      //                 crossAxisSpacing: 12),
      //             itemCount: widget.projects?.length ?? 0,
      //             itemBuilder: (ctx, index) {
      //               return PreviousWorkCard(project: widget.projects?[index]);
      //             }),
      //       ),
      //       CustomVerticalSpace(height: 20),
      //     ],
      //   ),
      // ),
    );
  }
}
