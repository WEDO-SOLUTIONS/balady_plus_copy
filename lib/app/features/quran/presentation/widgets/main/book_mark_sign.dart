import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/services/local/shared_prefs_manager.dart';
import '../../../data/models/quran_book_mark_item_model.dart';
import '../../bloc/quran_bloc.dart';

class BookMarkSign extends StatelessWidget {
  const BookMarkSign({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(left: 70, top: 24),
        child: BlocBuilder<QuranBloc, QuranState>(
          builder: (context, state) {
            return state.showBookMark == true
                ? SvgPicture.asset(IconPath.quranMainMarkIcon)
                : SizedBox();
          },
        ),
      ),
    );
  }
}
