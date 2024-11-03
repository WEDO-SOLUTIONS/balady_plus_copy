import 'dart:convert';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:smart_advisor/app/core/utils/constants/language.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import 'package:smart_advisor/app/features/documents/models/general_conditions_model.dart';
import 'package:collection/collection.dart';

import '../../core/utils/layout_size_wrapper.dart';
import '../_shared_feature_/presentation/widgets/custom_widgets/general_text_dialog.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/features/shared_features/widgets/app_bar.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter/services.dart';

import 'widgets/document_header.dart';

class GeneralCommercialConditionPage extends StatefulWidget {
  const GeneralCommercialConditionPage({super.key});

  @override
  State<GeneralCommercialConditionPage> createState() =>
      _CommercialConditionRegulationState();
}

String searchText = "";

class _CommercialConditionRegulationState
    extends State<GeneralCommercialConditionPage> {
  bool isViewDetail = false;
  List<GeneralConditionsModel> _requirements = [];

  final ScrollController _scrollController = ScrollController();
  List<int> highlightedIndexes = [];
  List<int> highlightedChildsIndexes = [];

  List<Map<int, double>> _itemHeights = [];

  String textToSearch = "";
  @override
  void dispose() {
    super.dispose();
  }

  void searchAndScroll(String term) {
    searchText = term;
    highlightedChildsIndexes = [];
    highlightedIndexes = _findSearchTermPositions(term);
    // print("Scroll ${highlightedIndexes}");

    if (highlightedIndexes.isNotEmpty) {
      _scrollToHighlightedText();
    }
  }

  void _scrollToHighlightedText() {
    if (highlightedIndexes.isNotEmpty) {
      // Calculate the cumulative height of all items before the target index
      double scrollPosition = 0.0;

      for (int i = 0; i <= highlightedIndexes[0]; i++) {
        try {
          if (i != highlightedIndexes[0]) {
            for (int k = 0; k < _itemHeights[i].length; k++) {
              scrollPosition += (_itemHeights[i][k] ?? 0.0);
            }
          } else {
            for (int j = 0; j < highlightedChildsIndexes[0]; j++) {
              scrollPosition += (_itemHeights[i][j] ?? 0.0);
            }
          }
        } catch (ex) {}
      }

      // Scroll to the calculated position
      _scrollController.animateTo(
        scrollPosition + 200,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToSectionIndex(int index) {
    double scrollPosition = 0.0;

    for (int i = 0; i < index; i++) {
      for (int k = 0; k < _itemHeights[i].length; k++) {
        scrollPosition += (_itemHeights[i][k] ?? 0.0);
      }
    }

    // Scroll to the calculated position
    _scrollController.animateTo(
      scrollPosition + 200,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  List<int> _findSearchTermPositions(String term) {
    List<int> indexes = [];
    if (term.isEmpty) return indexes;

    for (int i = 0; i < _requirements.length; i++) {
      var item = _requirements[i];

      for (int j = 0; j < (item.points?.length ?? 0); j++) {
        //  print("Scroll ${item.points?[j]}");

        if (item.points?[j].contains(term) ?? false) {
          indexes
              .add(i); // Add the index (or whatever `value` is supposed to be)

          highlightedChildsIndexes.add(j);
        }
      }
    }

    return indexes;
  }

  @override
  void initState() {
    super.initState();
    searchText = "";
    loadRequirements();
  }

  Future<void> loadRequirements() async {
    final String response = await rootBundle.loadString(
        'packages/smart_advisor/smart_advisor_assets/files/13.json');
    final data = await json.decode(response);

    List<GeneralConditionsModel> loadedRequirements = [];
    for (var item in data['sections']) {
      loadedRequirements.add(GeneralConditionsModel.fromJson(item));
    }

    setState(() {
      _requirements = loadedRequirements;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Build 111");
    return Scaffold(
      body: Column(
        children: [
          DocumentHeader(
            title: "files_title_1".tr(),
            onSubmit: (value) => searchAndScroll(value),
            onChanged: (String t) {
              setState(() {
                searchText = t;
              });
            },
            onFilter: () {
              showModalBottomSheet(
                backgroundColor: const Color(0xff000000),
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) => GeneralTextDialog(
                  title: "بحث",
                  items: _requirements.map((e) => e.name ?? "").toList(),
                  onPress: (int index) {
                    _scrollToSectionIndex(index);
                  },
                ),
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
              child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      /* Text("files_title_1".tr(),
                              style: AppStyle.calloutBoldStyle.copyWith(
                                color: AppColor.primary,
                              )),
                          const SizedBox(
                            height: 4,
                          ),*/
                      Text("files_title_2".tr(),
                          style: AppStyle.footNoteRomanStyle.copyWith(
                            color: AppColor.textSecondaryColor,
                          )),
                      const SizedBox(
                        height: 4,
                      ),
                      const SizedBox(height: 20),
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                            itemCount: _requirements.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              ValueKey itemKey = ValueKey(index.toString());

                              return SectionWidget(
                                key: itemKey,
                                item: _requirements[index],
                                onUpdateHeights: (double height, int i) {
                                  print("FFFFF ${index} ${i} ${height}");
                                  if (_itemHeights.length - 1 < index) {
                                    _itemHeights.add({});
                                    _itemHeights[index][i] = height;
                                  } else {
                                    _itemHeights[index][i] = height;
                                  }
                                },
                              );
                            }),
                      ),
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}

class SectionWidget extends StatefulWidget {
  final GeneralConditionsModel item;
  final Key key;
  final Function(double height, int index) onUpdateHeights;
  const SectionWidget(
      {required this.item, required this.key, required this.onUpdateHeights});

  @override
  State<SectionWidget> createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      key: widget.key,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display letter and name at the top
          Row(
            children: [
              Text(
                "${widget.item.letter} - ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                widget.item.name ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(height: 8), // Space between title and points

          Column(
            children: widget.item.points?.mapIndexed((i, e) {
                  GlobalKey itemKey = GlobalKey();

                  return MeasureSize(
                    onChange: (size) {
                      setState(() {
                        widget.onUpdateHeights(size.height, i);
                      });
                    },
                    child: Padding(
                      key: itemKey,
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${i + 1}. ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: SearchHighlightText(
                              widget.item.points?[i] ?? "",
                              searchText: searchText,
                              style: AppStyle.footNoteRomanStyle
                                  .copyWith(color: AppColor.textPrimaryColor),
                              highlightStyle: AppStyle.footNoteRomanStyle
                                  .copyWith(color: AppColor.orange),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList() ??
                [],
          )
        ],
      ),
    );
  }
}
