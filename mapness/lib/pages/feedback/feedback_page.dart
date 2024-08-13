import 'package:balady_plus/app/features/map_page/extensions/directory_object_ext.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/app/routes/feedback.dart';
import 'package:mapness/entities/feedback/feedback_scheme_data.dart';
import 'package:mapness/entities/feedback/feedback_type.dart';
import 'package:mapness/features/feedback/feedback_scheme.dart';
import 'package:mapness/features/feedback/poi_feedback.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_business_owner.dart';
import 'package:mapness/widgets/feedback/feedback_chips.dart';
import 'package:mapness/widgets/feedback/feedback_comment.dart';
import 'package:mapness/widgets/feedback/feedback_images.dart';
import 'package:mapness/widgets/feedback/feedback_input.dart';
import 'package:mapness/widgets/feedback/feedback_page_template.dart';
import 'package:urbi_utils/urbi_utils.dart';

class FeedbackPage extends ConsumerStatefulWidget {
  final String schemeId;
  final String poiId;
  const FeedbackPage({required this.poiId, required this.schemeId, super.key});

  @override
  ConsumerState<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage> {
  final _fields = <String, dynamic>{};
  String title = 'Feedback';
  @override
  Widget build(BuildContext context) => FeedbackPageTemplate(
        title: title,
        onSend: _sendFeedback,
        child: Builder(
          builder: (context) {
            final objectId = int.tryParse(widget.poiId);
            if (objectId == null) {
              return Center(child: Text(context.l10n.failedToLoadData));
            }
            final poiData = ref.watch(poiFeedbackProvider(objectId));
            final schemes = ref.watch(feedbackSchemeProvider);
            if (poiData.isLoading || schemes.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (poiData.hasError || schemes.hasError) {
              return Center(child: Text(context.l10n.failedToLoadData));
            }
            final poiDataValue = poiData.value;
            final schemeValue = schemes.value;
            final scheme = schemeValue?.feedbacks.firstWhereOrNull((element) => element.id == widget.schemeId);

            title = scheme?.appBar ?? 'Feedback';

            final fields = scheme?.fields;
            return ListView(
              padding: EdgeInsets.zero,
              primary: true,
              shrinkWrap: true,
              children: fields
                      ?.map((e) => _buildField(context, e, poiDataValue))
                      .insertBetween(Spacing.$4x.heightBox)
                      .toList() ??
                  [],
            );
          },
        ),
      );

  Widget _buildField(
    BuildContext context,
    FeedbackFieldData field,
    DirectoryObjectMessage? data,
  ) {
    switch (field) {
      case FeedbackFieldInputData():
        if (_fields[FeedbackFieldInputData.typeValue] == null) {
          _fields[FeedbackFieldInputData.typeValue] = _getInputInitialValue(data: data, id: field.inputId);
        }

        return FeedbackInput(
          label: field.label,
          hintText: field.hint,
          initialValue: _fields[FeedbackFieldInputData.typeValue],
          onChanged: (value) {
            _fields[FeedbackFieldInputData.typeValue] = value;
          },
        );
      case FeedbackFieldChipsData():
        if (_fields[FeedbackFieldChipsData.typeValue] == null) _fields[FeedbackFieldChipsData.typeValue] = null;
        final selectedIndex = _fields[FeedbackFieldChipsData.typeValue] as int?;
        return FeedbackChips(
          label: field.label,
          selectedIndex: selectedIndex,
          onIndexChanged: (value) {
            setState(() {
              _fields[FeedbackFieldChipsData.typeValue] = value;
            });
          },
          data: field.values
              .map(
                (e) => FeedbackChipsData(
                  leadingIcon: e.icon.feedbackIcon(isLTR: context.isLTR),
                  title: e.text,
                ),
              )
              .toList(),
        );
      case FeedbackFieldCommentData():
        if (_fields[FeedbackFieldCommentData.typeValue] == null) {
          _fields[FeedbackFieldCommentData.typeValue] = '';
        }
        return FeedbackComment(
          onChanged: (value) {
            _fields[FeedbackFieldCommentData.typeValue] = value;
          },
        );

      case FeedbackFieldBusinessOwnerData():
        if (_fields[FeedbackFieldBusinessOwnerData.typeValue] == null) {
          _fields[FeedbackFieldBusinessOwnerData.typeValue] = false;
        }
        return FeedbackBusinessOwner(
          onChanged: (value) {
            setState(() {
              _fields[FeedbackFieldBusinessOwnerData.typeValue] = value;
            });
          },
          value: _fields[FeedbackFieldBusinessOwnerData.typeValue],
        );
      case FeedbackFieldImagesData():
        if (_fields[FeedbackFieldImagesData.typeValue] == null) {
          _fields[FeedbackFieldImagesData.typeValue] = <XFile>[];
        }
        return FeedbackImages(
          images: _fields[FeedbackFieldImagesData.typeValue] as List<XFile>,
          addImage: addImage,
          removeImage: removeImage,
        );
    }
  }

  Future<void> addImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    setState(() {
      _fields[FeedbackFieldImagesData.typeValue].add(image);
    });
  }

  void removeImage(int index) {
    setState(() {
      _fields[FeedbackFieldImagesData.typeValue].removeAt(index);
    });
  }

  String _getInputInitialValue({
    required DirectoryObjectMessage? data,
    required String id,
  }) {
    if (data == null) {
      return '';
    }
    switch (id) {
      case 'company_name':
        return data.title;
      case 'area_of_activity':
        return data.subtitle;
      case 'address':
        return data.makeAddress();
    }
    return '';
  }

  void _sendFeedback() {
    FeedbackSuccessRoute(objectId: widget.poiId, schemeId: widget.schemeId).push(context);
  }
}
