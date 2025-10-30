import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/debouncer.dart';
import '../../data/models/quran_sura_model.dart';
import '../bloc/search_bloc/search_bloc.dart';
import '../widgets/search/search_app_bar.dart';
import '../widgets/search/search_card_widget.dart';

class QuranSearchPage extends StatefulWidget {
  const QuranSearchPage({super.key});

  @override
  State<QuranSearchPage> createState() => _QuranSearchPageState();
}

class _QuranSearchPageState extends State<QuranSearchPage> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  late Map<int, Map<int, QuranSuraModel>>? suras;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    suras = ModalRoute.of(context)!.settings.arguments
        as Map<int, Map<int, QuranSuraModel>>;
    return BlocProvider(
      create: (context) => SearchBloc(suras: suras),
      child: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: SearchAppBar(
                onSearch: (String? text) {
                  _debouncer.run(() {
                    context.read<SearchBloc>().add(SearchAyaEvent(text: text));
                  });
                },
              ),
              body: Container(
                padding: EdgeInsets.all(16),
                child: ListView.builder(
                    itemCount: state.searchedData?.length ?? 0,
                    itemBuilder: (ctx, index) {
                      return QuranSearchCardWidget(
                        item: state.searchedData![index],
                        onTap: () {
                          Navigator.of(context)
                              .pop(state.searchedData![index].pageNo);
                        },
                      );
                    }),
              ),
            ),
          );
        },
      ),
    );
  }
}
