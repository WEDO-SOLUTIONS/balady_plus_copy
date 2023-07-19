import 'package:balady_plus/app/features/quran/presentation/widgets/bookmarks/book_mark_item_widget.dart';
import 'package:balady_plus/app/features/quran/presentation/widgets/bookmarks/bookmark_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/book_mark_bloc/book_mark_bloc.dart';

class QuranBookMarkPage extends StatefulWidget {
  const QuranBookMarkPage({super.key});

  @override
  State<QuranBookMarkPage> createState() => _QuranBookMarkPageState();
}

class _QuranBookMarkPageState extends State<QuranBookMarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BookMarkAppBar(),
      body: BlocProvider(
        create: (context) => BookMarkBloc(),
        child: BlocConsumer<BookMarkBloc, BookMarkState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(children: [
              ListView.builder(
                  itemCount: state.items?.items?.length ?? 0,
                  itemBuilder: ((context, index) {
                    return BookMarkItem(item: state.items!.items![index]);
                  }))
            ]);
          },
        ),
      ),
    );
  }
}
