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

class AthkarEntityContent extends StatefulWidget {
  const AthkarEntityContent({
    super.key,
    required this.params,
    required this.athkarEntitiesList,
  });
  final AthkarEntityContentParams params;
  final List<AthkarEntity> athkarEntitiesList;

  @override
  State<AthkarEntityContent> createState() => _AthkarEntityContentState();
}

class _AthkarEntityContentState extends State<AthkarEntityContent> {
  PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.jumpToPage(widget.params.pageNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AthkarAppBar(title: ''),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                itemCount: widget.athkarEntitiesList.length,
                controller: _controller,
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomTextWidget(
                            widget.params.athkarEntitiesList[index].content,
                            fontColor: Colors.black,
                            maxLines: 2000,
                            height: 1.6,
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          CustomTextWidget(
                            widget.params.athkarEntitiesList[index].description,
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
            countText:
                widget.params.athkarEntitiesList[_currentIndex].quantityText,
            count: widget.params.athkarEntitiesList[_currentIndex].quantity,
          ),
        ],
      ),
    );
  }
}
