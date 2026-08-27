import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mapness/entities/feedback/dto/feedback_field_payload_dto.dart';
import 'package:mapness/entities/feedback/feedback_form_payload_entity.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'submit_feedback_payload.g.dart';

/// God, please forgive me for this

/// Provider that holds form data for a while and do necessary transformations
/// If you want to actually see how data sent to backend refer to [submitFeedbackPayloadProvider]
@riverpod
class SubmitFeedbackPayload extends _$SubmitFeedbackPayload {
  /// payloadId is needed just to collect form in one place and move to second screen.
  /// Since gorouter could not transfer compex structures.
  @override
  FeedbackFormPayloadEntity? build(String payloadId) => null;

  void collectForm({
    required String categoryId,

    /// complex fields should be already mapped to json
    required Iterable<MapEntry<String, dynamic>> fields,
    int? objectId,
    bool hasPhotos = false,
  }) {
    /// get curretn
    final cameraViewport = ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect;

    /// should not fire under any regular circumstances, but still
    if (cameraViewport == null) {
      throw Exception('UserFeedback: collect form failed, unable to get camra viewport');
    }

    state = FeedbackFormPayloadEntity(
      category: categoryId,
      objectId: objectId,
      hasPhotos: hasPhotos,
      fields: fields
          .map(
            (entry) => entry.value != null
                ? FeedbackFieldPayloadDto(
                    id: entry.key,
                    value: entry.key == 'business_owner' ? false : entry.value,
                  )
                : null,
          )
          .nonNulls
          .toIList(),
      viewport: cameraViewport,
    );
  }

  void keepAliveForAWhile() {
    final link = ref.keepAlive();
    // TODO(Demezy): tweak somehow not to do such shit
    /// Since some navigation, it is possible that provider would be disposed
    Future.delayed(const Duration(minutes: 1), link.close);
  }
}
