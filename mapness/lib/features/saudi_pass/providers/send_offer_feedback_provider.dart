import 'package:mapness/entities/saudi_pass/offer_feedback.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/offer_location.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_offer_feedback_provider.g.dart';

@riverpod
class SendOfferFeedback extends _$SendOfferFeedback {
  @override
  int build(String offerId) => 0;

  Future<void> send(int rating, String? note) async {
    final repository = await ref.read(saudiPassRepositoryProvider.future);
    final position = ref.read(locationProvider);
    if (position == null) {
      return;
    }

    final location = OfferLocation(latitude: position.latitude.toString(), longitude: position.longitude.toString());

    await Future.wait([
      repository.sendFeedback(
        offerId: offerId,
        feedbackModel: OfferFeedback(typeId: OfferFeedbackType.rate, value: rating.toString(), location: location),
      ),
      if (note != null)
        repository.sendFeedback(
          offerId: offerId,
          feedbackModel: OfferFeedback(typeId: OfferFeedbackType.note, value: note, location: location),
        )
    ]);
    state = rating;
  }
}
