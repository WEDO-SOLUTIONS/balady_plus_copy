part of 'home_bloc.dart';

class HomeState extends Equatable {
  final BlocStatus newsStatus;
  final NewsResponse? newsResponse;
  final String? errorMessage;

  const HomeState({
    this.newsStatus = BlocStatus.initial,
    this.newsResponse,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        newsStatus,
        newsResponse,
        errorMessage,
      ];

  HomeState copyWith({
    BlocStatus? newsStatus,
    NewsResponse? newsResponse,
    String? errorMessage,
  }) {
    return HomeState(
      newsStatus: newsStatus ?? this.newsStatus,
      newsResponse: newsResponse ?? this.newsResponse,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() {
    return 'HomeState(newsResponse: $newsResponse, newsStatus: $newsStatus, errorMessage: $errorMessage)';
  }
}
