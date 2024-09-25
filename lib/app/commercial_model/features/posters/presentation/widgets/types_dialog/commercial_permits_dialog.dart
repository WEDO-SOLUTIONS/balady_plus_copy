import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/summery_widgets/field_data.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../blocs/posters_license_bloc.dart';

class CommercialPermitsDialog extends StatefulWidget {
  final Function(int) onSelect;
  const CommercialPermitsDialog({super.key, required this.onSelect});

  @override
  State<CommercialPermitsDialog> createState() =>
      _CommercialPermitsDialogState();
}

class _CommercialPermitsDialogState extends State<CommercialPermitsDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            PostersLicenseBloc()..add(const GetPostersGroupsEvent()),
        child: BlocConsumer<PostersLicenseBloc, PostersLicenseState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Container(
                color: AppColor.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget(
                            "permits_for_licenes".tr(),
                            fontColor: AppColor.blackModern900Light,
                            fontWeight: AppFontWeight.bold,
                            maxLines: 10,
                          ),
                          InkWell(
                              onTap: () => Navigator.pop(context),
                              child: CircleIcon(
                                icon: Icons.close,
                                iconColor: AppColor.primary600Light,
                                backgroundColor:
                                    AppColor.geyser.withOpacity(0.4),
                                iconSize: 18,
                              )),
                        ]),
                    SizedBox(
                      height: 32,
                    ),
                    ListView.builder(
                        itemCount: state.permitGroups?.length ?? 0,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: FieldData(
                                title: state.permitGroups?[index].name ?? ""),
                            onTap: () {
                              widget.onSelect(state.permitGroups![index].id!);
                            },
                          );
                        }),
                    if (state.status == BlocStatus.loading)
                      const CustomCircularLoadingWidget(),
                  ],
                ),
              );
            }));
  }
}
