import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class PoliceLetter extends StatefulWidget {
  const PoliceLetter({super.key});

  @override
  State<PoliceLetter> createState() => _PoliceLetterState();
}

class _PoliceLetterState extends State<PoliceLetter> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripDetailsBloc, TripDetailsState>(
      builder: (context, state) {
        return Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: state.transportAttachResponseDtoList?.length ?? 0,
                itemBuilder: (ctx, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextWidget(
                        state.transportAttachResponseDtoList?[index]
                                .getLetterName() ??
                            "",
                        fontColor: AppColor.primary900Light,
                      ),
                      CustomVerticalSpace(height: 8),
                      Row(
                        children: [
                          CustomSvgIconWidget(
                            "assets/icons/customer_pdf.svg",
                            iconHeight: 20,
                            iconWidth: 20,
                            iconColor: AppColor.black,
                          ),
                          CustomHorizontalSpace(width: 8),
                          Flexible(
                            child: GestureDetector(
                              onTap: () async {
                                context.read<TripDetailsBloc>().add(
                                    DownLoadAttachmentEvent(
                                        id: state
                                                .transportAttachResponseDtoList?[
                                                    index]
                                                .id ??
                                            0));
                              },
                              child: CustomTextWidget(
                                state.transportAttachResponseDtoList?[index]
                                        .fileName ??
                                    "",
                                fontSize: 16,
                                textAlign: TextAlign.start,
                                fontWeight: AppFontWeight.medium,
                                fontColor: AppColor.black,
                                maxLines: 1,
                              ),
                            ),
                          )
                        ],
                      ),
                      CustomVerticalSpace(height: 16),
                    ],
                  );
                }),
            if (state.isCompleted != true) ...[
              ElevatedButtonWidget.primaryCustomBorder(
                onPressed: () async {
                  FileDataItem? file = await CommonFunctions.pickFile(context);
                  if (file != null)
                    context.read<TripDetailsBloc>().add(UploadLetterEvent(
                        file: file, requestId: state.letterID()));
                },
                text: !state.isLetterExists()
                    ? Helpers.translatingWord("policeLetterAttache")
                    : Helpers.translatingWord("policeLetterUpate"),
              ),
              CustomVerticalSpace(height: 12),
              ElevatedButtonWidget.primaryCustomBorder(
                onPressed: () async {
                  FileDataItem? file = await CommonFunctions.pickFile(context);
                  if (file != null)
                    context.read<TripDetailsBloc>().add(UploadHdSharieEvent(
                        file: file, requestId: state.hdSharieID()));
                },
                text: !state.isHdSharieExists()
                    ? Helpers.translatingWord("hdSharieLetterAttache")
                    : Helpers.translatingWord("hdSharieLetterUpate"),
              )
            ]
          ],
        );
      },
    );
  }
}
