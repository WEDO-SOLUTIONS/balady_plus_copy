import 'package:balady_plus/app/features/quran/quran_exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/route_names.dart';
import '../widgets/menu/menu_app_bar.dart';
import '../widgets/menu/menu_card_widget.dart';

class MenuQuranPage extends StatefulWidget {
  const MenuQuranPage({super.key});

  @override
  State<MenuQuranPage> createState() => _MenuQuranPageState();
}

class _MenuQuranPageState extends State<MenuQuranPage> {
  List<QuranSuraInfoModel> searchedQuranData = [];

  @override
  void initState() {
    super.initState();
    searchedQuranData.addAll(quranData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuAppBar(
        onSearch: (String? text) {
          searchedQuranData =
              quranData.where((e) => e.name.contains(text ?? "")).toList();
          setState(() {});
        },
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
            itemCount: searchedQuranData.length,
            itemBuilder: (ctx, index) {
              return QuranMenuCardWidget(
                item: searchedQuranData[index],
                index: searchedQuranData[index].id,
                onTap: () {
                  Navigator.of(context).pushNamed(RouteName.quranScreen,
                      arguments: searchedQuranData[index].id);
                },
              );
            }),
      ),
    );
  }
}
