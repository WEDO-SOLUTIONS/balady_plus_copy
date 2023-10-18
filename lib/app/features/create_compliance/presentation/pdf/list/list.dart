import '../core/image_path.dart';
import '../home/custom_app_bar.dart';
import '../list/list_item/general_provisions/gen_prov.dart';
import '../list/list_item/introduction/intro.dart';
import '../list/list_item/list_item.dart';
import '../list/list_item/requir_building/requir_building.dart';
import '../list/list_item/requir_item/requir.dart';
import '../list/list_item/scope/scope.dart';
import '../list/list_item/terms/terms.dart';
import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 239, 238, 238),
      appBar: CustomAppBar(
        icon: ImagePath.closebutton,
        name: 'الفهرس',
        listicon: ImagePath.frame,
        showList: false,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 12),
            child: Column(
              children: [
                ListItem(
                  number: '1- ',
                  name: ' مقدمة',
                  page: Introduction(),
                ),
                ListItem(
                  number: '2- ',
                  name: ' نطاق التطبيق',
                  page: ScopeofApp(),
                ),
                ListItem(
                  number: '3- ',
                  name: ' المصطلحات والتعريفات',
                  page: TermsAndDefinitions(),
                ),
                ListItem(
                  number: '4- ',
                  name: ' اشتراطات شهادة امتثال المباني',
                  page: Requirements(),
                ),
                ListItem(
                  number: '5- ',
                  name:
                      ' متطلبات وإجراءات إصدار شهادة امتثال \nالمباني وتجديدها',
                  page: RequirBuilding(),
                ),
                ListItem(
                  number: '6- ',
                  name: ' الأحكام العامة',
                  page: GeneralProvisions(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
