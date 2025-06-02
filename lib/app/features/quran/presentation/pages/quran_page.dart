import 'dart:async';
import 'dart:convert';

import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/paths/image_paths.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../data/models/quran_aya_model.dart';
import '../widgets/main/book_mark_sign.dart';
import '../widgets/main/quran_footer.dart';
import '../widgets/main/quran_header.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance!.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    int initialSuraNo = ModalRoute.of(context)!.settings.arguments as int;

    return BlocProvider(
      create: (context) => QuranBloc(initialSuraNo: initialSuraNo),
      child: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          return BlocListener<QuranBloc, QuranState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title: CustomTextWidget(
                    state.currentTitle ?? "",
                    fontColor: AppColor.white,
                    fontSize: 20,
                    textAlign: TextAlign.center,
                  ),
                  leading: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      NavigationService.navigatorKey.currentState?.pop();
                    },
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  flexibleSpace: Stack(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.only(bottom: 40, left: 16, right: 16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage(ImagePath.zmzmBackground),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: Constants.appBarBoxShadow,
                        ),
                        alignment: AlignmentDirectional.bottomCenter,
                      ),
                    ],
                  ),
                  actions: [],
                  systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
                    statusBarBrightness: Brightness.light,
                  ),
                ),
                body: Container(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<QuranBloc>().add(ToggleDetailsEvent());
                        },
                        onPanEnd: (details) {
                          print(details);
                          // Swiping in right direction.
                          if (details.velocity.pixelsPerSecond.dx > 0) {
                            context.read<QuranBloc>().add(GoToNextPageEvent());
                          }

                          // Swiping in left direction.
                          if (details.velocity.pixelsPerSecond.dx < 0) {
                            context
                                .read<QuranBloc>()
                                .add(GoToPreviousPageEvent());
                          }
                        },
                        child: PageView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: context.read<QuranBloc>().controller,
                          onPageChanged: (int page) {
                            context
                                .read<QuranBloc>()
                                .add(ChangePageEvent(page: page));
                          },
                          itemCount: state.suras?.length ?? 0,
                          itemBuilder: ((context, i) {
                            return Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                // padding: EdgeInsets.all(8),
                                child: SvgPicture.file(context
                                    .read<QuranBloc>()
                                    .getImagePath((i + 1).toString()))
                                /*: ListView(children: [
                                          for (int index = 0;
                                              (index <
                                                  (state.suras?[i + 1]?.values
                                                          .length ??
                                                      0));
                                              index++) ...[
                                            if (state.suras?[i + 1]?[index + 1]
                                                    ?.suraAyat.first.keys.first ==
                                                1)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                        ImagePath.ayah),
                                                    CustomTextWidget(
                                                      state
                                                              .suras?[i + 1]
                                                                  ?[index + 1]
                                                              ?.suraName ??
                                                          "",
                                                      fontColor: AppColor.black,
                                                      textAlign: TextAlign.center,
                                                      height: 1.6,
                                                      fontSize: 24,
                                                      fontFamily:
                                                          "sura_juza_names",
                                                      maxLines: 1000,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            CustomTextWidget(
                                              "${state.suras?[i + 1]?[index + 1]?.suraAyat.map((e) => e.values).toList().join(" ").replaceAll("(", "").replaceAll(")", "")}" ??
                                                  "",
                                              fontColor: AppColor.black,
                                              textAlign: TextAlign.center,
                                              height: 1.6,
                                              fontSize: 25,
                                              letterSpacing: 0.0001,
                                              fontFamily: "HafsSmart",
                                              maxLines: 1000,
                                            )
                                          ],
                                          CustomVerticalSpace(height: 20),
                                          CustomTextWidget(
                                            (state.currentPageValue + 1)
                                                .toString(),
                                            fontColor: AppColor.primary900Light,
                                            textAlign: TextAlign.center,
                                            fontWeight: AppFontWeight.bold,
                                          )
                                        ])*/
                                );
                          }),
                        ),
                      ),
                      if (state.showDetails == true) ...[
                        QuranHeader(
                          jozz: state.currentJozz ?? 0,
                          suraName: state.currentTitle ?? "",
                          pageNumber: state.currentPageValue,
                        ),
                        QuranFooter()
                      ],
                      BookMarkSign(),
                      if (state.status == BlocStatus.loading)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const CustomCircularLoadingWidget(),
                                const SizedBox(
                                  width: double.maxFinite,
                                  height: 16,
                                ),
                                Text(
                                  state.progressDownload >= 100
                                      ? "done_download_open_moments".tr()
                                      : "${state.progressDownload} %",
                                )
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
