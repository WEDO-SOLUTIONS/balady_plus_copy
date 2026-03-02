import 'package:mapness/entities/iwish/models/iwish_feedback_entity.dart';
import 'package:mapness/features/iwish/providers/iwish_entity.dart';
import 'package:mapness/widgets/iwish/ui/iwish_feedback_mood.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iwish_feedback.g.dart';

@riverpod
class _IwishFeedback extends _$IwishFeedback {
  set data(IwishFeedbackEntity value) => state = AsyncData(value);
  IwishFeedbackEntity get data => state.requireValue;

  void updateComment(String? comment) => data = data.copyWith(comment: comment);

  void updateMood(IwishFeedbackMoodType? mood) => data = data.copyWith(mood: mood);

  void toggleTag(String tagId) {
    final tags = state.requireValue.tags;
    if (tags.contains(tagId)) {
      tags.remove(tagId);
    } else {
      tags.add(tagId);
    }

    data = data.copyWith(tags: tags);
  }

  @override
  Future<IwishFeedbackEntity> build(String iwishId) async => IwishFeedbackEntity(
        tags: {},
        comment: null,
        mood: null,
      );

  Future<void> submitFeedback() async {
    final oldState = state;
    state = const AsyncLoading();
    final isSuccess = await ref.read(iwishEntityProvider(iwishId).notifier).submitFeedback(data);
    state = isSuccess ? oldState : AsyncError('error when send feedback', StackTrace.current);
  }
}

const iwishFeedbackProvider = _iwishFeedbackProvider;
