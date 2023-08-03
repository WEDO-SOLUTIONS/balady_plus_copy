import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/athkar/athkar_exports.dart'
    show AthkarAppBar, AthkarEntityContentParams;
import 'package:balady_plus/app/features/athkar/presentation/widgets/counter/athkar_counter.dart';
import 'package:flutter/material.dart';

class AthkarEntityContent extends StatelessWidget {
  const AthkarEntityContent({super.key, required this.params});
  final AthkarEntityContentParams params;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AthkarAppBar(title: ''),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: SizedBox(
              child: CustomTextWidget(
                params.athkarEntity.content,
                fontColor: Colors.black,
                maxLines: 10,
              ),
            ),
          ),
          CustomTextWidget(
            params.athkarEntity.description,
            textStyle: AppStyle.desscriptionAthkarStyle,
            maxLines: 4,
          ),
          Expanded(
            child: SizedBox(),
          ),
          CounterAthkarWidget(
            countText: params.athkarEntity.quantityText,
            count: params.athkarEntity.quantity,
          ),
        ],
      ),
    );
  }
}
