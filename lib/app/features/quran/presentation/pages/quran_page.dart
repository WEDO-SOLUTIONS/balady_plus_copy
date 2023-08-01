import 'dart:async';
import 'dart:convert';

import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/paths/image_paths.dart';
import '../../data/models/quran_aya_model.dart';
import '../widgets/main/book_mark_sign.dart';
import '../widgets/main/quran_footer.dart';
import '../widgets/main/quran_header.dart';

class QuranPage extends StatefulWidget {
  final int initialSuraNo;
  const QuranPage({super.key, required this.initialSuraNo});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuranBloc(initialSuraNo: widget.initialSuraNo),
      child: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          return BlocListener<QuranBloc, QuranState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title: CustomTextWidget(
                    state.currentTitle ?? "",
                    fontColor: AppColor.white,
                    fontSize: 20,
                    fontFamily: "uthmanic",
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
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(ImagePath.quranBackgroundPage))),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<QuranBloc>().add(ToggleDetailsEvent());
                        },
                        child: PageView.builder(
                          controller: context.read<QuranBloc>().controller,
                          onPageChanged: (int page) {
                            context
                                .read<QuranBloc>()
                                .add(ChangePageEvent(page: page));
                            print(state.suras?.length);
                          },
                          itemCount: state.suras?.length ?? 0,
                          itemBuilder: ((context, i) {
                            return Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                // padding: EdgeInsets.all(8),
                                child: i == 603
                                    ? SvgPicture.asset("assets/quran/604.svg")
                                    : ListView(children: [
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
                                      ]));
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
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }
}
