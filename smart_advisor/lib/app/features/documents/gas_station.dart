import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_advisor/app/features/documents/models/gas_station_model.dart';

class GasStationRequirement extends StatefulWidget {
  const GasStationRequirement({super.key});

  @override
  State<GasStationRequirement> createState() => _GasStationRequirementState();
}

class _GasStationRequirementState extends State<GasStationRequirement> {
  List<Content> _Conditions = [];

  Future<void> loadGasStationRequirements() async {
    try {
      final String response = await rootBundle.loadString(
          'packages/smart_advisor/smart_advisor_assets/files/14.json');
      final data = await json.decode(response);

      GasStationModel model = GasStationModel.fromJson(data);

      print("------------_Conditions-------------");
      print(model);
      print(model);
      setState(() {
        _Conditions = model.content!;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadGasStationRequirements();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: ListView.builder(
                itemCount: _Conditions.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              "${_Conditions[index].title}",
                              textDirection: TextDirection.rtl,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      _Conditions[index].items!.isEmpty
                          ? Column(
                              children: [
                                Text(
                                  "${_Conditions[index].items![0].description}",
                                  maxLines: 10,
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                      _Conditions[index].items!.isNotEmpty
                          ? Column(
                              children: _Conditions[index]
                                  .items!
                                  .map((item) => Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.number == null
                                                      ? "${item.description}" 
                                                      : "${item.number} ${item.description}",
                                                  maxLines: 20,
                                                  textAlign: TextAlign.right,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          item.subItems != null
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: item.subItems!
                                                      .map(
                                                        (subItem) => Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  height: 5,
                                                                  width: 5,
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              6),
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  child: const SizedBox
                                                                      .shrink(),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              4.0),
                                                                  child: Text(
                                                                    " ${subItem.subNumber} - ",
                                                                    maxLines:
                                                                        10,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textDirection:
                                                                        TextDirection
                                                                            .rtl,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                  child: Text(
                                                                    subItem.name ==
                                                                            null
                                                                        ? ""
                                                                        : subItem
                                                                            .name!,
                                                                    maxLines:
                                                                        10,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textDirection:
                                                                        TextDirection
                                                                            .rtl,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 6,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                      .toList())
                                              : const SizedBox.shrink(),
                                          item.annex != null
                                              ? Container(
                                                  child: Column(
                                                      children: item.annex!
                                                          .map(
                                                              (annex) => Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Flexible(
                                                                            child:
                                                                                Text(
                                                                              "${annex.title} ${annex.arabicName}" ?? "",
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 3,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            annex.englishName != null
                                                                                ? "${annex.englishName}"
                                                                                : "",
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            maxLines:
                                                                                2,
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                12,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      annex.standards !=
                                                                              null
                                                                          ? SingleChildScrollView(
                                                                              scrollDirection: Axis.horizontal,
                                                                              child: Row(
                                                                                children: [
                                                                                  Stack(
                                                                                    children: [
                                                                                      Column(
                                                                                          children: annex.standards!.asMap().entries.map((table) {
                                                                                        int index = table.key;
                                                                                        var tableData = table.value;
                                                                                        return Column(children: [
                                                                                          index == 0
                                                                                              ? Row(
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      width: 135,
                                                                                                      height: 80,
                                                                                                      padding: const EdgeInsets.only(top: 8, right: 16),
                                                                                                      margin: const EdgeInsets.only(bottom: 3),
                                                                                                      decoration: const BoxDecoration(
                                                                                                        color: Color(0xffDAE8EC),
                                                                                                        border: Border(
                                                                                                          left: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.white),
                                                                                                        ),
                                                                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                                                                                      ),
                                                                                                      child: Center(
                                                                                                          child: Text(
                                                                                                        tableData.arabicTitle!,
                                                                                                        maxLines: 2,
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                                                                                                      )),
                                                                                                    ),
                                                                                                    Container(
                                                                                                      width: 193,
                                                                                                      height: 80,
                                                                                                      padding: const EdgeInsets.only(top: 8, right: 16),
                                                                                                      margin: const EdgeInsets.only(bottom: 3),
                                                                                                      decoration: const BoxDecoration(
                                                                                                        color: Color(0xffF2F2F2),
                                                                                                        border: Border(
                                                                                                          left: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.white),
                                                                                                        ),
                                                                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6)),
                                                                                                      ),
                                                                                                      child: Flexible(
                                                                                                          child: Center(
                                                                                                              child: Text(
                                                                                                        tableData.englishTitle!,
                                                                                                        maxLines: 2,
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                                                                                                      ))),
                                                                                                    ),
                                                                                                    Container(
                                                                                                      width: 193,
                                                                                                      height: 80,
                                                                                                      padding: const EdgeInsets.only(top: 8, right: 16),
                                                                                                      margin: const EdgeInsets.only(bottom: 3),
                                                                                                      decoration: const BoxDecoration(
                                                                                                        color: Color(0xffF2F2F2),
                                                                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6)),
                                                                                                      ),
                                                                                                      child: Text(
                                                                                                        tableData.standardNumber!,
                                                                                                        maxLines: 2,
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        style: const TextStyle(color: Color(0xff353D39), fontSize: 16, fontWeight: FontWeight.w500),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                )
                                                                                              : Row(
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      width: 135,
                                                                                                      height: 120,
                                                                                                      padding: const EdgeInsets.all(8),
                                                                                                      decoration: BoxDecoration(color: const Color(0xffDAE8EC), border: Border(left: const BorderSide(width: 1, style: BorderStyle.solid, color: Colors.white), bottom: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.black.withOpacity(0.04)))),
                                                                                                      child: Center(
                                                                                                          child: Text(
                                                                                                        tableData.arabicTitle!,
                                                                                                        maxLines: 6,
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w300),
                                                                                                      )),
                                                                                                    ),
                                                                                                    Container(
                                                                                                      width: 193,
                                                                                                      height: 120,
                                                                                                      padding: const EdgeInsets.all(16),
                                                                                                      decoration: BoxDecoration(color: const Color(0xffF2F2F2), border: Border(left: const BorderSide(width: 1, style: BorderStyle.solid, color: Colors.white), bottom: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.black.withOpacity(0.04)))),
                                                                                                      child: Center(
                                                                                                          child: Text(
                                                                                                        tableData.englishTitle!,
                                                                                                        textAlign: TextAlign.left,
                                                                                                        maxLines: 6,
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w300),
                                                                                                      )),
                                                                                                    ),
                                                                                                    Container(
                                                                                                      width: 193,
                                                                                                      height: 120,
                                                                                                      padding: const EdgeInsets.all(8),
                                                                                                      decoration: BoxDecoration(color: const Color(0xffF2F2F2), border: Border(left: const BorderSide(width: 1, style: BorderStyle.solid, color: Colors.white), bottom: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.black.withOpacity(0.04)))),
                                                                                                      child: Center(
                                                                                                          child: Text(
                                                                                                        tableData.standardNumber!,
                                                                                                        textAlign: TextAlign.left,
                                                                                                        maxLines: 6,
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        style: const TextStyle(color: Color(0xff353D39), fontSize: 12, fontWeight: FontWeight.w300),
                                                                                                      )),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                        ]);
                                                                                      }).toList()),

                                                                                      // -- Switch between column--

                                                                                      //  Positioned(
                                                                                      //     top: 45,
                                                                                      //     left: 15,
                                                                                      //     child: Row(children: [
                                                                                      //    Icon(Icons.arrow_circle_right_rounded, size: 25, color: const Color(0xff554154).withOpacity(0.25)),
                                                                                      //    const Icon(Icons.arrow_circle_left_rounded, size: 25, ),
                                                                                      //  ],),
                                                                                      //  ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          : const SizedBox
                                                                              .shrink(),
                                                                      Text(annex.note !=
                                                                              null
                                                                          ? "ملاحظة \n ${annex.note}"
                                                                          : " "),
                                                                      const SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      annex.items !=
                                                                              null
                                                                          ? Container(
                                                                              child: Column(
                                                                                  children: annex.items!
                                                                                      .map((item) => Column(
                                                                                            children: [
                                                                                              Row(children: [
                                                                                                Expanded(
                                                                                                    child: Text(
                                                                                                  item.englishTitle != null ? "${item.number} - ${item.arabicTitle} ${item.englishTitle}:" : "${item.number} - ${item.arabicTitle}",
                                                                                                  maxLines: 5,
                                                                                                  overflow: TextOverflow.ellipsis,
                                                                                                )),
                                                                                              ]),
                                                                                              Text(
                                                                                                item.description != null ? "${item.description}" : "",
                                                                                                maxLines: 15,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                              ),
                                                                                              item.subItems != null
                                                                                                  ? Column(
                                                                                                      children: item.subItems!
                                                                                                          .map(
                                                                                                            (subitem) => Column(
                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                              children: [
                                                                                                                Row(
                                                                                                                  children: [
                                                                                                                    Flexible(
                                                                                                                        child: Text(
                                                                                                                      subitem.arabicTitle != null
                                                                                                                          ? subitem.englishTitle != null
                                                                                                                              ? "${subitem.subNumber} ${subitem.arabicTitle} ${subitem.englishTitle} :"
                                                                                                                              : "${subitem.subNumber} ${subitem.arabicTitle}"
                                                                                                                          : "${subitem.subNumber} ${subitem.description}",
                                                                                                                      maxLines: 5,
                                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                                    )),
                                                                                                                  ],
                                                                                                                ),
                                                                                                                Text(
                                                                                                                  subitem.description != null
                                                                                                                      ? subitem.arabicTitle != null
                                                                                                                          ? "${subitem.description}"
                                                                                                                          : ""
                                                                                                                      : "",
                                                                                                                  maxLines: 10,
                                                                                                                  overflow: TextOverflow.ellipsis,
                                                                                                                ),
                                                                                                                subitem.categories != null
                                                                                                                    ? Column(
                                                                                                                        children: subitem.categories!
                                                                                                                            .map((category) => Column(
                                                                                                                                  children: [
                                                                                                                                    Row(
                                                                                                                                      children: [
                                                                                                                                        Expanded(
                                                                                                                                          child: Text(category.code != null ? "${category.code} ${category.description}" : "", maxLines: 15, overflow: TextOverflow.ellipsis),
                                                                                                                                        ),
                                                                                                                                      ],
                                                                                                                                    ),
                                                                                                                                  ],
                                                                                                                                ))
                                                                                                                            .toList(),
                                                                                                                      )
                                                                                                                    : const SizedBox.shrink(),
                                                                                                                subitem.sections != null
                                                                                                                    ? Column(
                                                                                                                        children: subitem.sections!
                                                                                                                            .map((section) => Column(
                                                                                                                                  children: [
                                                                                                                                    Row(
                                                                                                                                      children: [
                                                                                                                                        Expanded(
                                                                                                                                          child: Text(section.code != null ? "${section.code} - ${section.description}" : "${section.subNumber} ${section.name}", maxLines: 15, overflow: TextOverflow.ellipsis),
                                                                                                                                        ),
                                                                                                                                      ],
                                                                                                                                    ),
                                                                                                                                    const SizedBox(
                                                                                                                                      height: 6,
                                                                                                                                    ),
                                                                                                                                    section.categories != null
                                                                                                                                        ? Column(
                                                                                                                                            children: section.categories!
                                                                                                                                                .map((category) => Column(
                                                                                                                                                      children: [
                                                                                                                                                        Row(
                                                                                                                                                          children: [
                                                                                                                                                            Flexible(
                                                                                                                                                                child: Text(
                                                                                                                                                              "${category.code} ${category.description}",
                                                                                                                                                              maxLines: 4,
                                                                                                                                                              overflow: TextOverflow.ellipsis,
                                                                                                                                                            )),
                                                                                                                                                          ],
                                                                                                                                                        ),
                                                                                                                                                        category.additionalRequirements != null
                                                                                                                                                            ? Column(
                                                                                                                                                                children: category.additionalRequirements!
                                                                                                                                                                    .map((requirement) => Column(children: [
                                                                                                                                                                          Row(
                                                                                                                                                                            children: [
                                                                                                                                                                              Flexible(child: Text("${requirement.code} ${requirement.name}", maxLines: 4, overflow: TextOverflow.ellipsis)),
                                                                                                                                                                            ],
                                                                                                                                                                          ),
                                                                                                                                                                        ]))
                                                                                                                                                                    .toList())
                                                                                                                                                            : const SizedBox.shrink(),
                                                                                                                                                      ],
                                                                                                                                                    ))
                                                                                                                                                .toList())
                                                                                                                                        : const SizedBox.shrink(),
                                                                                                                                  ],
                                                                                                                                ))
                                                                                                                            .toList(),
                                                                                                                      )
                                                                                                                    : const SizedBox.shrink(),
                                                                                                                subitem.tables != null
                                                                                                                    ? Row(
                                                                                                                        children: subitem.tables!.asMap().entries.map((table) {
                                                                                                                        int index = table.key;
                                                                                                                        var tableData = table.value;
                                                                                                                        return Row(children: [
                                                                                                                          index == 0
                                                                                                                              ? Column(
                                                                                                                                  children: [
                                                                                                                                    Container(
                                                                                                                                      width: 70,
                                                                                                                                      height: 60,
                                                                                                                                      padding: const EdgeInsets.only(top: 8, right: 16),
                                                                                                                                      decoration: const BoxDecoration(
                                                                                                                                        color: Color(0xffDAE8EC),
                                                                                                                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), topRight: Radius.circular(16)),
                                                                                                                                      ),
                                                                                                                                      child: Text(
                                                                                                                                        tableData.upBoundary!,
                                                                                                                                        maxLines: 2,
                                                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                                                        style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                    Container(
                                                                                                                                      width: 70,
                                                                                                                                      height: 60,
                                                                                                                                      padding: const EdgeInsets.only(top: 8, right: 16),
                                                                                                                                      margin: const EdgeInsets.only(bottom: 8),
                                                                                                                                      decoration: const BoxDecoration(
                                                                                                                                        color: Color(0xffDAE8EC),
                                                                                                                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), topRight: Radius.circular(16)),
                                                                                                                                      ),
                                                                                                                                      child: Flexible(
                                                                                                                                          child: Text(
                                                                                                                                        tableData.downBoundary!,
                                                                                                                                        maxLines: 2,
                                                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                                                        style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                                                                                                                                      )),
                                                                                                                                    ),
                                                                                                                                  ],
                                                                                                                                )
                                                                                                                              : Column(
                                                                                                                                  children: [
                                                                                                                                    Container(
                                                                                                                                      width: 60,
                                                                                                                                      height: 60,
                                                                                                                                      padding: const EdgeInsets.all(16),
                                                                                                                                      decoration: const BoxDecoration(color: Color(0xffF2F2F2), border: Border(right: BorderSide(width: 1, style: BorderStyle.solid, color: Color.fromARGB(255, 199, 198, 198)), bottom: BorderSide(width: 1, style: BorderStyle.solid, color: Color.fromARGB(255, 199, 198, 198)))),
                                                                                                                                      child: Center(
                                                                                                                                          child: Text(
                                                                                                                                        tableData.upBoundary!,
                                                                                                                                        style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                                                                                                                                      )),
                                                                                                                                    ),
                                                                                                                                    Container(
                                                                                                                                      width: 60,
                                                                                                                                      height: 60,
                                                                                                                                      padding: const EdgeInsets.all(8),
                                                                                                                                      margin: const EdgeInsets.only(bottom: 8),
                                                                                                                                      decoration: const BoxDecoration(color: Color(0xffF2F2F2), border: Border(right: BorderSide(width: 1, style: BorderStyle.solid, color: Color.fromARGB(255, 199, 198, 198)))),
                                                                                                                                      child: Center(
                                                                                                                                          child: Text(
                                                                                                                                        tableData.downBoundary!,
                                                                                                                                        style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                                                                                                                                      )),
                                                                                                                                    ),
                                                                                                                                  ],
                                                                                                                                ),
                                                                                                                        ]);
                                                                                                                      }).toList())
                                                                                                                    : const SizedBox.shrink(),
                                                                                                              ],
                                                                                                            ),
                                                                                                          )
                                                                                                          .toList(),
                                                                                                    )
                                                                                                  : const SizedBox.shrink(),
                                                                                              const SizedBox(
                                                                                                height: 6,
                                                                                              ),
                                                                                            ],
                                                                                          ))
                                                                                      .toList()),
                                                                            )
                                                                          : const SizedBox
                                                                              .shrink(),
                                                                    ],
                                                                  ))
                                                          .toList()))
                                              : const SizedBox.shrink(),
                                        ],
                                      ))
                                  .toList(),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
