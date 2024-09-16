import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/feedback_field_payload_entity.dart';
import 'package:mapness/entities/feedback/feedback_form_payload_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'submit_feedback_payload.g.dart';

/// God, please forgive me for this

/// Provider that holds form data for a while and do necessary transformations
@riverpod
class SubmitFeedbackPayload extends _$SubmitFeedbackPayload {
  /// payloadId is needed just to collect form in one place and move to second screen.
  /// Since gorouter could not transfer compex structures.
  @override
  FeedbackFormPayloadEntity? build(String payloadId) => null;

  void collectForm({
    required int objectId,
    required String categoryId,
    required Iterable<FeedbackBaseEntity> fields,
  }) {
    state = FeedbackFormPayloadEntity(
      fields: fields
          .map((e) => FeedbackFieldPayloadEntity(
                fieldId: e.id,
                value: e.value,
              ))
          .toIList(),
      category: categoryId,
      objectId: objectId,
    );
  }

  void keepAliveForAWhile() {
    final link = ref.keepAlive();
    // TODO(Demezy): tweak somehow not to do such shit
    /// Since some navigation it is possible that provider would be disposed
    Future.delayed(const Duration(minutes: 1), () {
      link.close();
    });
  }
}
