import 'package:flutter/foundation.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as pb;
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/entities/iwish/models/iwish_feedback_entity.dart';
import 'package:mapness/features/iwish/lib/iwish_object_mapper.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iwish_entity.g.dart';

@riverpod
class _IwishEntity extends _$IwishEntity {
  void refresh() {
    ref.invalidateSelf();
  }

  Future<bool> submitFeedback(IwishFeedbackEntity feedback) async {
    final request = pb.IWishFeedbackRequest(
      rating: feedback.mood?.index ?? -1 + 1,
      tags: feedback.tags.map((e) => pb.IWishFeedbackRequest_Tag(name: e)),
      text: feedback.comment,
    );
    print(request.toProto3Json());

    final dio = ref.read(dGisNetworkProvider);
    final raw = await dio.post(
      '/iwish/$iwishId/feedback',
      data: request.writeToBuffer(),
    );
    print(raw.requestOptions.headers['X-Device-ID']);
    if (raw.statusCode != 200) {
      if (kDebugMode) {
        final error = pb.ErrorResponse.fromBuffer(raw.data);
        print(error.toDebugString());
        return false;
      }
    }

    final response = pb.IWishItemResponse.fromBuffer(raw.data);
    state = AsyncData(response.object.toDomain());
    return true;
  }

  @override
  Future<IwishEntity> build(String iwishId) async {
    final dio = ref.watch(dGisNetworkProvider);
    final raw = await dio.get('iwish/$iwishId');

    final response = pb.IWishItemResponse.fromBuffer(raw.data).object;
    print(response.toProto3Json());

    return response.toDomain();
  }
}

const iwishEntityProvider = _iwishEntityProvider;
