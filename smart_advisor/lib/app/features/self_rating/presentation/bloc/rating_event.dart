part of 'rating_bloc.dart';

abstract class RatingEvent extends Equatable {
  const RatingEvent();

  @override
  List<Object?> get props => [];
}

class GetRatings extends RatingEvent {
  const GetRatings();
}

class SubmitRatings extends RatingEvent {
  const SubmitRatings();
}

class ChangeItemRating extends RatingEvent {
  final int ratnig;
  final int i;
  final int j;
  const ChangeItemRating(
      {required this.ratnig, required this.i, required this.j});
}

class UpdateItemsRatings extends RatingEvent {
  final List<RatingItemsResponseItem> items;
  final String key;
  const UpdateItemsRatings({required this.items, required this.key});
}
