import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/app/routes/feedback.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_business_owner.dart';
import 'package:mapness/widgets/feedback/feedback_comment.dart';
import 'package:mapness/widgets/feedback/feedback_images.dart';
import 'package:mapness/widgets/feedback/feedback_input.dart';
import 'package:mapness/widgets/feedback/feedback_page_template.dart';
import 'package:urbi_utils/urbi_utils.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FeedbackInput(
              label: 'Company name',
              initialValue: companyName,
              onChanged: (value) {
                companyName = value;
              },
            ),
            FeedbackComment(
              onChanged: (value) {
                comment = value;
              },
            ),
            FeedbackBusinessOwner(
              value: isBusinessOwner,
              onChanged: (value) {
                setState(() {
                  isBusinessOwner = value;
                });
              },
            ),
            FeedbackImages(
              images: images,
              addImage: addImage,
              removeImage: removeImage,
            ),
          ].insertBetween(Spacing.$4x.heightBox).toList(),
        ),
      );

  void _onSend() {
    FeedbackSuccessRoute(objectId: widget.objectId, schemeId: '').push(context);
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
