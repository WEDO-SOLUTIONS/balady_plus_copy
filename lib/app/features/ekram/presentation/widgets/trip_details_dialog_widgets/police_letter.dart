import 'package:balady_new_app/app/core/core_exports.dart';
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:balady_new_app/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_new_app/shared/core/utils/utils_exports.dart';
import 'package:balady_new_app/shared/features/_shared_feature_/shared/data/entities/file_data_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                        fontColor: AppColors.darkTurquoise,
                      ),
                      CustomVerticalSpace(height: 8),
                      Row(
                        children: [
                          CustomSvgIconWidget(
                            "assets/icons/customer_pdf.svg",
                            iconHeight: 20,
                            iconWidth: 20,
                            iconColor: AppColors.black,
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
                                fontWeight: FONT_WEIGHT.medium,
                                fontColor: AppColors.black,
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
              CustomElevatedButtonWidget(
                btnPressed: () async {
                  FileDataItem? file = await CommonFunctions.pickFile();
                  if (file != null)
                    context.read<TripDetailsBloc>().add(UploadLetterEvent(
                        file: file, requestId: state.letterID()));
                },
                btnText: !state.isLetterExists()
                    ? Helpers.translatingWord("policeLetterAttache")
                    : Helpers.translatingWord("policeLetterUpate"),
                icon: Image.asset(
                  Constants.imgPath + "addButton@3x.png",
                  height: 12,
                  width: 12,
                ),
                btnTextSize: 16,
                btnTextWeight: FONT_WEIGHT.medium,
                btnHeight: 56,
                btnTextColor: AppColors.darkTurquoise,
                btnBorderColor: AppColors.darkTurquoise,
                btnColor: Colors.transparent,
              ),
              CustomVerticalSpace(height: 12),
              CustomElevatedButtonWidget(
                btnPressed: () async {
                  FileDataItem? file = await CommonFunctions.pickFile();
                  if (file != null)
                    context.read<TripDetailsBloc>().add(UploadHdSharieEvent(
                        file: file, requestId: state.hdSharieID()));
                },
                btnText: !state.isHdSharieExists()
                    ? Helpers.translatingWord("hdSharieLetterAttache")
                    : Helpers.translatingWord("hdSharieLetterUpate"),
                icon: Image.asset(
                  Constants.imgPath + "addButton@3x.png",
                  height: 12,
                  width: 12,
                ),
                btnTextSize: 16,
                btnTextWeight: FONT_WEIGHT.medium,
                btnHeight: 56,
                btnTextColor: AppColors.darkTurquoise,
                btnBorderColor: AppColors.darkTurquoise,
                btnColor: Colors.transparent,
              )
            ]
          ],
        );
      },
    );
  }
}
