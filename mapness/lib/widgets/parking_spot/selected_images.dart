import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/parking_spot/parking_image.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/int_extention.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';
import 'package:mapness/widgets/feedback/images/add_image_button.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_preview.dart';
import 'package:provider/provider.dart';

class SelectedImages extends ConsumerStatefulWidget {
  final bool isEdit;

  const SelectedImages({required this.isEdit, super.key});

  @override
  SelectedImagesState createState() => SelectedImagesState();
}

class SelectedImagesState extends ConsumerState<SelectedImages> {
  List<XFile> _images = [];

  @override
  Widget build(BuildContext context) {
    const _photoPadding = Spacing.$2x;
    const _imageSize = 62.0;

    _images = ref.watch(
      parkingImageProvider(theme: context.read<ThemeController>().currentTheme, isEdit: widget.isEdit),
    );
    final imageProvider = ref.watch(
      parkingImageProvider(theme: context.read<ThemeController>().currentTheme, isEdit: widget.isEdit).notifier,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.images,
          style: context.textStyles.captionMediumRegular.copyWith(color: context.colors.foregroundDefault),
        ),
        Spacing.$2x.heightBox,
        Wrap(
          spacing: _photoPadding,
          runSpacing: _photoPadding,
          children: [
            if (_images.length < maxImages)
              AddImageButton(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  final picked = await context.pushRoute<List<XFile>>(const AddPhotoRoute());
                  await imageProvider.onAddImages(picked);
                },
                size: _imageSize,
              ),
            ..._images.indexed.map(
              (indexedUpload) => FeedbackImagePreview(
                key: ValueKey(indexedUpload),
                imagePath: indexedUpload.$2.path,
                onRemove: () => imageProvider.removeImage(indexedUpload.$2),
                imageSize: _imageSize,
              ),
            ),
          ],
        ),
        Spacing.$3x.heightBox,
        Text(
          context.digits(context.l10n.feedbackImageLimitsError(maxImages, maxSizeInBytes.formatAsFileSize())),
          style: context.textStyles.captionMediumRegular.copyWith(color: context.colors.foregroundSoft),
        ),
      ],
    );
  }
}
