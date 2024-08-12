import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/widgets/feedback/feedback_business_owner.dart';
import 'package:mapness/widgets/feedback/feedback_chips.dart';
import 'package:mapness/widgets/feedback/feedback_comment.dart';
import 'package:mapness/widgets/feedback/feedback_images.dart';
import 'package:mapness/widgets/feedback/feedback_page_template.dart';
import 'package:urbi_utils/urbi_utils.dart';

class FeedbackCompanyClosedPage extends StatefulWidget {
  const FeedbackCompanyClosedPage({super.key});

  @override
  State<FeedbackCompanyClosedPage> createState() => _FeedbackCompanyClosedPageState();
}

class _FeedbackCompanyClosedPageState extends State<FeedbackCompanyClosedPage> {
  int? selectedIndex;
  String comment = '';
  bool isBusinessOwner = false;
  final images = <XFile>[];
  @override
  Widget build(BuildContext context) => FeedbackPageTemplate(
        title: 'Company closed',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FeedbackChips(
              selectedIndex: selectedIndex,
              onIndexChanged: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              data: const [
                FeedbackChipsData(
                  title: 'There is no such company here',
                  leadingIcon: GeneralIcons.clearCircle,
                ),
                FeedbackChipsData(
                  title: 'Temporarily closed',
                  leadingIcon: GeneralIcons.timeQuarter,
                ),
                FeedbackChipsData(
                  title: 'Company has moved',
                  leadingIcon: GeneralIcons.pin,
                ),
                FeedbackChipsData(
                  title: 'Other',
                  leadingIcon: GeneralIcons.questionCircle,
                ),
              ],
            ),
            FeedbackComment(
              onChanged: (value) {
                comment = value;
              },
            ),
            FeedbackBusinessOwner(
              onChanged: (value) {
                setState(() {
                  isBusinessOwner = value;
                });
              },
              value: isBusinessOwner,
            ),
            FeedbackImages(
              images: images,
              addImage: addImage,
              removeImage: removeImage,
            ),
          ].insertBetween(Spacing.$4x.heightBox).toList(),
        ),
      );

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
