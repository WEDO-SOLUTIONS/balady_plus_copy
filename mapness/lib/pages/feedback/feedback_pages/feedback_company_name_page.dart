import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/app/routes/feedback.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_business_owner.dart';
import 'package:mapness/widgets/feedback/feedback_images.dart';
import 'package:mapness/widgets/feedback/feedback_page_template.dart';

/// TODO: Implement the FeedbackCompanyNamePage
class FeedbackCompanyNamePage extends StatefulWidget {
  final String initialCompanyName;
  final String objectId;

  const FeedbackCompanyNamePage({
    required this.initialCompanyName,
    required this.objectId,
    super.key,
  });

  @override
  State<FeedbackCompanyNamePage> createState() => _FeedbackCompanyNamePageState();
}

class _FeedbackCompanyNamePageState extends State<FeedbackCompanyNamePage> {
  String companyName = '';
  String comment = '';
  bool isBusinessOwner = false;
  final images = <XFile>[];

  @override
  void initState() {
    super.initState();
    companyName = widget.initialCompanyName;
  }

  @override
  Widget build(BuildContext context) => FeedbackPageTemplate(
        title: context.l10n.feedbackCompanyName,
        onSend: _onSend,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaladyInput(
                labelText: 'Company name',
                labelStyle: context.textStyleV3.captionMediumRegular,
                initialValue: companyName,
                fillColor: context.colorsV2.backgroundSurface1,
                onChanged: (value) {
                  companyName = value;
                },
              ),
              Spacing.$4x.heightBox,
              BaladyInput(
                hintText: 'Add extra information',
                labelText: 'Company location',
                labelStyle: context.textStyleV3.captionMediumRegular,
                fillColor: context.colorsV2.backgroundSurface1,
                onChanged: (value) {
                  comment = value;
                },
              ),
              Spacing.$4x.heightBox,
              FeedbackBusinessOwner(
                value: isBusinessOwner,
                onChanged: (value) {
                  setState(() {
                    isBusinessOwner = value;
                  });
                },
              ),
              Spacing.$4x.heightBox,
              FeedbackImages(
                images: images,
                addImage: addImage,
                removeImage: removeImage,
              ),
            ],
          ),
        ),
      );

  void _onSend() {
    FeedbackSuccessRoute(objectId: widget.objectId).push(context);
  }

  Future<void> addImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    setState(() {
      images.add(image);
    });
  }

  void removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }
}
