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
  final List<Project>? projects;
  const PreviousWorksPage({Key? key, this.projects}) : super(key: key);

  @override
  State<PreviousWorksPage> createState() => _PreviousWorksPageState();
}

class _PreviousWorksPageState extends State<PreviousWorksPage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.PreviousWorksListPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: trans('previous_works')),
      body: Container(
        margin: EdgeInsets.only(top: 24),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        color: AppColor.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitleWidget(
              title: trans('previous_works'),
              primaryIcon: PrimaryIcons.providerWorksIcon,
            ),
            CustomTextWidget(
              trans('previous_works_desc'),
              fontColor: AppColor.bottomNavigationShadow,
              fontSize: 12,
              fontWeight: AppFontWeight.regular,
              textAlign: TextAlign.start,
            ),
            CustomVerticalSpace(height: 10),
            Expanded(
              child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 222,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12),
                  itemCount: widget.projects?.length ?? 0,
                  itemBuilder: (ctx, index) {
                    return PreviousWorkCard(project: widget.projects?[index]);
                  }),
            ),
            CustomVerticalSpace(height: 20),
          ],
        ),
      ),
    );
  }
}
