import 'dart:developer';

import 'package:dgis_map/library.dart';
import 'package:mapness/entities/feedback/feedback.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poi_feedback.g.dart';

@riverpod
class PoiFeedback extends _$PoiFeedback {
  @override
  Future<DirectoryObjectMessage?> build(int objectId) async {
    state = const AsyncValue.loading();
    final dgisController = ref.watch(dgisControllerProvider);
    final data = await dgisController.value?.searchByObjectId(
      DgisObjectIdMessage(
        objectId: objectId,
        entranceId: 0,
      ),
    );

    return data;
  }

  Future<void> sendFeedback(FeedbackData data) async {
    log('Sending feedback');
  }
}
