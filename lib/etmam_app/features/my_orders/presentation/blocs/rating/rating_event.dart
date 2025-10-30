part of 'rating_bloc.dart';

abstract class RatingEvent extends Equatable {
  const RatingEvent();

  @override
  List<Object> get props => [];
}

class GetRatingItemsEvent extends RatingEvent {
  GetRatingItemsEvent();
}

class ChangeRateEvent extends RatingEvent {
  int index;
  int rate;

  ChangeRateEvent({required this.index, required this.rate});
}

class SubmitRateEvent extends RatingEvent {
  SubmitRateEvent();
}

class ChangeRatingComment extends RatingEvent {
  String? text;
  ChangeRatingComment({this.text});
}

class ValidateFormEvent extends RatingEvent {
  ValidateFormEvent();
}
