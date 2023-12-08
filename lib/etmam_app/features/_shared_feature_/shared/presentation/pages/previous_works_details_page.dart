import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomAppBar,
        CustomTextWidget,
        CustomVerticalSpace,
        DownloadProjectFileButton,
        ProjectImagesSliderWidget;
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show Project;
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, CommonFunctions, trans;

class PreviousWorksDetailsPage extends StatefulWidget {
  const PreviousWorksDetailsPage({Key? key}) : super(key: key);

  @override
  State<PreviousWorksDetailsPage> createState() =>
      _PreviousWorksDetailsPageState();
}

class _PreviousWorksDetailsPageState extends State<PreviousWorksDetailsPage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.PreviousWorksDetailsPage);
  }

  late Project project;

  @override
  Widget build(BuildContext context) {
    project = ModalRoute.of(context)!.settings.arguments as Project;

    return Scaffold(
        appBar: DefaultAppBarWidget(title: trans('project_details')),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (project.images != null && (project.images?.length ?? 0) > 0)
                  ProjectImagesSliderWidget(
                    images: project.images ?? [],
                  ),
                const CustomVerticalSpace(height: 16),
                CustomTextWidget(
                  project.name ?? "",
                  fontSize: 16,
                  fontColor: AppColor.hunterGreen,
                  fontWeight: AppFontWeight.w600,
                  textAlign: TextAlign.start,
                ),
                const CustomVerticalSpace(height: 8),
                CustomTextWidget(
                  project.description ?? "",
                  fontSize: 12,
                  fontColor: AppColor.greyText,
                  fontWeight: AppFontWeight.regular,
                  textAlign: TextAlign.start,
                ),
                const CustomVerticalSpace(height: 32),
                if (project.documentUrl != null &&
                    project.documentUrl!.isNotEmpty) ...[
                  DownloadProjectFileButton(
                    documentUrl: project.documentUrl ?? "",
                  ),
                  const CustomVerticalSpace(height: 30),
                ]
              ],
            ),
          ),
        ));
  }
}
