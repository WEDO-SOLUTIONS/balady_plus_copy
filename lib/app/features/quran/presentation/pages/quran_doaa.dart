import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/need_login_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/quran/presentation/widgets/bookmarks/book_mark_item_widget.dart';
import 'package:balady_plus/app/features/quran/presentation/widgets/bookmarks/bookmark_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../bloc/book_mark_bloc/book_mark_bloc.dart';
import '../widgets/doaa/doaa_app_bar.dart';

class QuranDoaaPage extends StatefulWidget {
  const QuranDoaaPage({super.key});

  @override
  State<QuranDoaaPage> createState() => _QuranDoaaPageState();
}

class _QuranDoaaPageState extends State<QuranDoaaPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: DoaaAppBar(),
          body: Container(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextWidget(
                      "quran_doaa".tr(),
                      fontWeight: AppFontWeight.medium,
                      fontSize: 26,
                      maxLines: 1000,
                      height: 1.6,
                      fontColor: AppColor.black,
                    ),
                  ],
                ),
              ))),
    );
  }
}
