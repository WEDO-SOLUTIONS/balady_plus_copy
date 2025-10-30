import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/quran/data/models/quran_book_mark_item_model.dart';
import 'package:balady_plus/app/features/quran/presentation/bloc/book_mark_bloc/book_mark_bloc.dart';
import 'package:balady_plus/app/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../data/models/quran_sura_info_model.dart';
import '../jozz/menu_card_widget.dart';
import '../menu/menu_card_widget.dart';

class QuranFooter extends StatefulWidget {
  QuranFooter({super.key});

  @override
  State<QuranFooter> createState() => _QuranFooterState();
}

class _QuranFooterState extends State<QuranFooter> {
  final PageNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 140,
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColor.primary900Light.withOpacity(0.98)),
            child: Column(children: [
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      height: 32,
                      width: (MediaQuery.of(context).size.width - 16) / 2,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RouteName.quranSearchPage,
                                  arguments: state.suras)
                              .then((value) {
                            if (int.tryParse(value.toString()) != null)
                              context.read<QuranBloc>().add(MoveToPageEvent(
                                  page: int.parse(value.toString())));
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              child: CustomTextFieldWidget(
                                textFieldHeight: 32,
                                enabled: false,
                                fillColor: Color(0x45FFFFFF),
                                hintText: ("إبحث عن آية").tr(),
                                hintStyle: TextStyle(color: AppColor.white),
                                textFieldVerticalPadding: 4,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                      IconPath.quranSearchIcon)),
                            )
                          ],
                        ),
                      ),
                    ),
                    CustomHorizontalSpace(width: 10),
                    GestureDetector(
                      onTap: () async {
                        context.read<QuranBloc>().add(SaveBookMarkEvent());
                      },
                      child: Container(
                        height: 32,
                        width: (MediaQuery.of(context).size.width - 16) / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0x45FFFFFF)),
                        child: Row(children: [
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: SvgPicture.asset(IconPath.quranSaveIcon)),
                          CustomTextWidget(
                            state.showBookMark == true
                                ? ("quran_book_mark_ramoved").tr()
                                : ("quran_book_mark_save").tr(),
                            fontSize: 12,
                            fontWeight: AppFontWeight.semiBold,
                          )
                        ]),
                      ),
                    )
                  ],
                ),
              ),
              DrawLineWidget(
                horizontalMargin: 16,
                lineColor: Color(0x1AF3F3F3),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Navigator.of(context)
                          .pushNamed(RouteName.quranBookMarkPage)
                          .then((value) {
                        if (int.tryParse(value.toString()) != null)
                          context.read<QuranBloc>().add(MoveToPageEvent(
                              page: int.parse(value.toString())));
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(IconPath.quranBookMarkIcon),
                        CustomHorizontalSpace(width: 8),
                        CustomTextWidget(
                          ("move_to_mark").tr(),
                          fontSize: 12,
                          fontWeight: AppFontWeight.semiBold,
                        )
                      ],
                    ),
                  ),
                  DrawLineWidget(
                    lineColor: Color(0x1AF3F3F3),
                    lineWidth: 1,
                    lineHeight: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final bool? actionTaked =
                          await BottomSheetDialog.showDraggableSheet(context,
                              isFullHeight: true,
                              dialogKeyName: DialogName.quranPageFilterDialog,
                              currentRouteName: RouteName.quranScreen,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: BottomSheetWithActions(
                                  body: Container(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CustomTextWidget(
                                                ("pageNumber").tr(),
                                                fontColor: AppColor
                                                    .blackModern700Light,
                                                fontSize: 16,
                                                textAlign: TextAlign.start,
                                                fontWeight: AppFontWeight.bold,
                                              ),
                                            ],
                                          ),
                                          CustomVerticalSpace(height: 16),
                                          Container(
                                              height: 48,
                                              child: CustomTextFieldWidget(
                                                textFieldHeight: 48,
                                                controller:
                                                    PageNumberController,
                                                keyboardType:
                                                    TextInputType.number,
                                              )),
                                          CustomVerticalSpace(height: 16),
                                          CustomTextWidget(
                                            ("pageEntry").tr(),
                                            fontColor:
                                                AppColor.blackModern600Light,
                                            fontSize: 15,
                                            textAlign: TextAlign.start,
                                            fontWeight: AppFontWeight.semiBold,
                                          ),
                                          CustomVerticalSpace(height: 32),
                                          ElevatedButtonWidget.primaryCustom(
                                              onPressed: () {
                                                if (int.tryParse(
                                                        PageNumberController
                                                            .text) !=
                                                    null)
                                                  context.read<QuranBloc>().add(
                                                      MoveToPageEvent(
                                                          page: int.parse(
                                                              PageNumberController
                                                                  .text)));
                                                Navigator.pop(context);
                                              },
                                              text: ("move").tr())
                                        ],
                                      ),
                                    ),
                                  ),
                                  title: ("move_to_page").tr(),
                                ),
                              ));
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(IconPath.quranChangePageIcon),
                        CustomHorizontalSpace(width: 8),
                        CustomTextWidget(
                          ("change_page").tr(),
                          fontSize: 12,
                          fontWeight: AppFontWeight.semiBold,
                        )
                      ],
                    ),
                  )
                ],
              ),
              DrawLineWidget(
                horizontalMargin: 16,
                lineColor: Color(0x1AF3F3F3),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      /**
                       *       
                                                    
                       */
                      final bool? actionTaked =
                          await BottomSheetDialog.showDraggableSheet(context,
                              dialogKeyName: DialogName.quranSuraFilterDialog,
                              currentRouteName: RouteName.quranScreen,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: BottomSheetWithActions(
                                  body: Container(
                                    padding: EdgeInsets.all(16),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                              itemCount: quranData.length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (ctx, index) {
                                                return QuranMenuCardWidget(
                                                  item: quranData[index],
                                                  index: index,
                                                  onTap: () {
                                                    context
                                                        .read<QuranBloc>()
                                                        .controller
                                                        .jumpToPage(context
                                                            .read<QuranBloc>()
                                                            .getSuraPageNumber(
                                                                index + 1));
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  title: "chooseSurah".tr(),
                                ),
                              ));
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(IconPath.quranMenuIcon),
                        CustomHorizontalSpace(width: 8),
                        CustomTextWidget(
                          ("index").tr(),
                          fontSize: 12,
                          fontWeight: AppFontWeight.semiBold,
                        )
                      ],
                    ),
                  ),
                  DrawLineWidget(
                    lineColor: Color(0x1AF3F3F3),
                    lineWidth: 1,
                    lineHeight: 43,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final bool? actionTaked =
                          await BottomSheetDialog.showDraggableSheet(context,
                              dialogKeyName: DialogName.quranJozzFilterDialog,
                              currentRouteName: RouteName.quranScreen,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: BottomSheetWithActions(
                                  body: Container(
                                    padding: EdgeInsets.all(16),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                              itemCount: 30,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (ctx, index) {
                                                return QuranJozzCardWidget(
                                                  index: index + 1,
                                                  onTap: () {
                                                    context
                                                        .read<QuranBloc>()
                                                        .controller
                                                        .jumpToPage(context
                                                            .read<QuranBloc>()
                                                            .getJozzPageNumber(
                                                                index + 1));
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  title: "choosePart".tr(),
                                ),
                              ));
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(IconPath.quranJozzIcon),
                        CustomHorizontalSpace(width: 8),
                        CustomTextWidget(
                          ("parts").tr(),
                          fontSize: 12,
                          fontWeight: AppFontWeight.semiBold,
                        )
                      ],
                    ),
                  ),
                  DrawLineWidget(
                    lineColor: Color(0x1AF3F3F3),
                    lineWidth: 1,
                    lineHeight: 43,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(RouteName.quranDoaaPage);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(IconPath.quranPrayIcon),
                        CustomHorizontalSpace(width: 8),
                        CustomTextWidget(
                          ("end_doaa").tr(),
                          fontSize: 12,
                          fontWeight: AppFontWeight.semiBold,
                        )
                      ],
                    ),
                  )
                ],
              )
            ]),
          ),
        );
      },
    );
  }
}
