import 'package:collection/collection.dart';
import 'package:mapness/features/happiness_map/data/happiness_repository.dart';
import 'package:mapness/features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/features/map/providers/camera_position.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'happines_manager.g.dart';

@riverpod
class HappinessManager extends _$HappinessManager {
  void updateCoordinates(Coordinates coordinates) {
    state = state.copyWith(coordinates: coordinates);
  }

  void removeTag(String tag) {
    state = state.copyWith(
      tags: state.tags.whereNot((element) => element == tag).toList(),
    );
  }

  void addTag(String tag) {
    state = state.copyWith(
      tags: {...state.tags, tag}.toList(),
    );
  }

  void onFeedbackPressed(HappinessFeedback buttonType) {
    state = state.copyWith(feedback: buttonType);
  }

  void updateComment(String comment) {
    state = state.copyWith(comment: comment);
  }

  Future<void> submitFeedback() async {
    final cameraPosition =
        ref.read(cameraPositionProvider.select((x) => x?.point));

    updateCoordinates(
      Coordinates(cameraPosition!.latitude, cameraPosition.longitude),
    );
    // print('FLAG: send feedback $_comment');
    // print('FLAG: feedback ${state.feedback}');
    // print('FLAG: tags ${state.tags}');
    final happinessRepository = ref.read(happinessRepositoryProvider.notifier);
    await happinessRepository.submitFeedback(state);
  }

  @override
  HappinessState build() {
    return HappinessState(
      feedback: null,
      coordinates: const Coordinates(0, 0),
      tags: [],
      comment: '',
    );
  }
}
