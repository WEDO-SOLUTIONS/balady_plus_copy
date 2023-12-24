import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/need_login_widget.dart';
import 'package:balady_plus/app/features/quran/presentation/widgets/bookmarks/book_mark_item_widget.dart';
import 'package:balady_plus/app/features/quran/presentation/widgets/bookmarks/bookmark_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../bloc/book_mark_bloc/book_mark_bloc.dart';

class QuranBookMarkPage extends StatefulWidget {
  const QuranBookMarkPage({super.key});

  @override
  State<QuranBookMarkPage> createState() => _QuranBookMarkPageState();
}

class _QuranBookMarkPageState extends State<QuranBookMarkPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: BookMarkAppBar(),
        body: BlocProvider(
          create: (context) => BookMarkBloc(),
          child: BlocConsumer<BookMarkBloc, BookMarkState>(
            listener: (context, state) {},
            builder: (context, state) {
              return (((state.items?.items?.length ?? 0) > 0))
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.items?.items?.length ?? 0,
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pop(state.items!.items![index].pageNumber);
                            },
                            child:
                                BookMarkItem(item: state.items!.items![index]));
                      }))
                  : EmptyListWidget(
                      title: "no_quran_bookmarks".tr(),
                    );
            },
          ),
        ),
      ),
    );
  }
}
