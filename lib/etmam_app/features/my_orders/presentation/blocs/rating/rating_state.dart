part of 'rating_bloc.dart';

class RatingState extends Equatable {
  BlocStatus status;
  RatingPageParams? args;
  List<RatingItem>? items;
  String? comment;
  String? errorMessage;
  bool? isFormValid;
  RatingState(
      {this.status = BlocStatus.initial,
      this.items,
      this.errorMessage,
      this.comment,
      this.isFormValid,
      this.args});

  RatingState copyWith(
      {BlocStatus? status,
      List<RatingItem>? items,
      String? errorMessage,
      String? comment,
      bool? isFormValid}) {
    return RatingState(
        items: items ?? this.items,
        status: status ?? this.status,
        args: args ?? this.args,
        isFormValid: isFormValid ?? this.isFormValid,
        comment: comment ?? this.comment,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [status];
}
