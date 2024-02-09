import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/athkar/athkar_exports.dart'
    show AthkarAppBar, AthkarEntityContentParams;
import 'package:balady_plus/app/features/athkar/data/models/athkar_entites_params.dart';
import 'package:balady_plus/app/features/athkar/domain/entities/athkar_entity.dart';
import 'package:balady_plus/app/features/athkar/presentation/widgets/counter/athkar_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';

class AthkarEntityContent extends StatefulWidget {
  const AthkarEntityContent({
    super.key,
  });

  @override
  State<AthkarEntityContent> createState() => _AthkarEntityContentState();
}

class _AthkarEntityContentState extends State<AthkarEntityContent> {
  PageController _controller = PageController();
  int _currentIndex = 0;
  late AthkarEntityContentParams params;
  late List<AthkarEntity> athkarEntitiesList;
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.jumpToPage(params.pageNumber);
    });

    CommonFunctions.sendUXCamEvent(UXCamEvents.Athkar_Open_Category_Item_Event);
  }

  @override
  Widget build(BuildContext context) {
    params =
        ModalRoute.of(context)!.settings.arguments as AthkarEntityContentParams;
    athkarEntitiesList = params.athkarEntitiesList;

    return Scaffold(
      appBar: const AthkarAppBar(title: ''),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                itemCount: athkarEntitiesList.length,
                controller: _controller,
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  _resetCounter();
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomTextWidget(
                            params.athkarEntitiesList[index].content ??
                                params.athkarEntitiesList[index].name,
                            fontColor: Colors.black,
                            maxLines: 2000,
                            height: 1.6,
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          CustomTextWidget(
                            params.athkarEntitiesList[index].description,
                            textStyle: AppStyle.serviceDescriptionStyle
                                .copyWith(color: AppColor.primary800Light),
                            maxLines: 100,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          CounterAthkarWidget(
            counter: counter,
            reset: _resetCounter,
            incrementCounter: _incrementCounter,
            countText: params.athkarEntitiesList[_currentIndex].quantityText,
            count: params.athkarEntitiesList[_currentIndex].quantity,
          ),
        ],
      ),
    );
  }

  int counter = 0;

  void _incrementCounter() {
    if (counter < params.athkarEntitiesList[_currentIndex].quantity) {
      setState(() {
        counter++;
      });
    }
    CommonFunctions.sendUXCamEvent(UXCamEvents.Athkar_Click_Count);
  }

  void _resetCounter() {
    setState(() {
      counter = 0;
    });

    CommonFunctions.sendUXCamEvent(UXCamEvents.Athkar_Click_Clear_Count);
  }
}
