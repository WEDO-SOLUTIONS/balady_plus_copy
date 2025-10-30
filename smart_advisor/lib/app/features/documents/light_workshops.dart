import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/features/documents/models/light_workshops_model.dart';

class LightWorkshops extends StatefulWidget {
  const LightWorkshops({super.key});

  @override
  State<LightWorkshops> createState() => _LightWorkshopsState();
}

class _LightWorkshopsState extends State<LightWorkshops> {
  List<Content> _Conditions = [];

  Future<void> loadLightWorkshopRequirements() async {
    try {
      final String response = await rootBundle.loadString(
          'packages/smart_advisor/smart_advisor_assets/files/light_workshops.json');
      final data = await json.decode(response);

      LightWorkshopsModel model = LightWorkshopsModel.fromJson(data);

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
    loadLightWorkshopRequirements();
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _Conditions[index].term ?? "",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColor.primary),
                          ),
                              _Conditions[index].conditionNumber != null ?
                          Text(
                                "${_Conditions[index].conditionNumber} ${_Conditions[index].conditionName}",
                                
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColor.primary),
                          ) : const SizedBox.shrink(),
                        ],
                      ),
                        _Conditions[index].description != null ?
                      Text(
                        _Conditions[index].description!,
                        textAlign: TextAlign.right,
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: AppColor.gray),
                      ) : const SizedBox.shrink(),
                      // const SizedBox(height: 5,),

                      _Conditions[index].item != null
                          ? Column(
                              children: _Conditions[index]
                                  .item!
                                  .map(
                                    (item) => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              item.subConditionOn != null
                                                  ?
                                                                                              Text(
                                                   "${item.subConditionOn} ${item.subConditionName}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  color:
                                                      AppColor.primary),
                                                                                              )
                                                  : const SizedBox.shrink(),
                                            ],
                                          ),
                                          Row(
                                             mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              item.subConditionDescript != null ?
                                                                                              Text(
                                              item.subConditionDescript! ,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                  color: AppColor.gray),
                                                                                              ): const SizedBox.shrink(),
                                            ],
                                          ),

                                          item.additionalListCondition != null
                                              ? Column(
                                                 children: item
                                                      .additionalListCondition!
                                                      .map(
                                                        (addition) => Column(
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                            
                                                              children: [
                                                                    Flexible(
                                                                      child: 
                                                                addition.additionOn !=
                                                                        null
                                                                    ? 
                                                                                                                                      Text(
                                                                    "${addition.additionOn} ${addition.additionName}",
                                                                    maxLines: 3,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight: FontWeight
                                                                        .w600,
                                                                    color:
                                                                        AppColor.primary),
                                                                                                                                      )
                                                                                                                                      : const SizedBox.shrink()),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Flexible(
                                                                  child: addition.additionDescripe !=
                                                                          null
                                                                      ?                                                                
                                                                                                                                         Text(
                                                                      "${addition.additionDescripe}",
                                                                  textAlign: TextAlign.start,  
                                                                  maxLines: 4,
                                                                  overflow: TextOverflow.ellipsis,   
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: AppColor
                                                                          .gray),
                                                                                                                                        ) : const SizedBox.shrink(),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 3),

                                                            addition.thirdList !=
                                                                    null
                                                                ? Column(
                                                                    children: addition
                                                                        .thirdList!
                                                                        .map((thirdList) =>
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                  thirdList.title != null ?
                                                                                Text(
                                                                                  thirdList.title!,
                                                                                  style: TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: AppColor.textPrimaryColor
                                                                                  )
                                                                                ): const SizedBox.shrink(),
                                                                                thirdList.list != null
                                                                                    ? Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: thirdList.list!
                                                                                            .map(
                                                                                              (dataList) => Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.start, 
                                                                                                children: [
                                                                                                Row(
                                                                                                  children: [
                                                                                                    Flexible(
                                                                                                      child: Text(
                                                                                                        dataList.number != null ? "${dataList.number} ${dataList.name}" : "",
                                                                                                        maxLines: 8,
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        textDirection: TextDirection.rtl,
                                                                                                        style: const TextStyle(
                                                                                                          fontSize: 14,
                                                                                                          fontWeight: FontWeight.w300,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),

                                                                                                        dataList.images != null ?
                                                                                                        Column(
                                                                                                          children: 
                                                                                                  
                                                                                                          
                                                                                                           dataList.images!.map((img) =>
                                                                                                           Column(
                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                            children: [
                                                                                                              Container(
                                                                                                                width: 250,
                                                                                                                height: 200,
                                                                                                                margin: const EdgeInsets.only(top:8),
                                                                                                                clipBehavior: Clip.antiAlias,
                                                                                                                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)),
                                                                                                              
                                                                                                                ),
                                                                                                                child: 
                                                                                                                Image.asset(img.path!, fit: BoxFit.cover, ),
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                width: 245,
                                                                                                                child: Center(
                                                                                                                  child: Text(img.description ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColor.gray),),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ])
                                                                                                          ).toList()
                                                                                                        )
                                                                                                        : const SizedBox.shrink(),
                                                                                                        // // ),
                                                                                             

                                                                                              ]),
                                                                                            )
                                                                                            .toList(),
                                                                                      )
                                                                                    : const SizedBox.shrink(),
                                                                                const SizedBox(height: 6),
                                                                              ],
                                                                            ))
                                                                        .toList(),
                                                                  )
                                                                : const SizedBox
                                                                    .shrink(),
                                                          ],
                                                        ),
                                                      )
                                                      .toList(),
                                                )
                                              : const SizedBox.shrink(),

                                          // const Text("ddd"),
                                          // Image.asset("packages/smart_advisor/smart_advisor_assets/images/conditions_images/picture1.png", width: 200, height: 300,),
                                        ]),
                                  )
                                  .toList())
                          : const SizedBox.shrink()
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
