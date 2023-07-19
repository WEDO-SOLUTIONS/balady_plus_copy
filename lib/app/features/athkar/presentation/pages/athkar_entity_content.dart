import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/athkar/athkar_exports.dart'
    show AthkarAppBar, AthkarEntityContentParams;
import 'package:flutter/material.dart';

class AthkarEntityContent extends StatelessWidget {
  const AthkarEntityContent({super.key, required this.params});
  final AthkarEntityContentParams params;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AthkarAppBar(title: params.title),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: SizedBox(
                height: 450,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: CustomTextWidget(
                    params.athkarEntity.content,
                    fontColor: Colors.black,
                    maxLines: 10,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
