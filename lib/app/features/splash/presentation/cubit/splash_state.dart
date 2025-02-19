part of 'splash_cubit.dart';

class SplashState extends Equatable {
  final BlocStatus status;
final String? splashUrl;
final int? splashDuration;

  SplashState(
      {this.status = BlocStatus.initial,this.splashUrl,this.splashDuration});

  SplashState copyWith(
      {final BlocStatus? status,
      final String? splashUrl,
      final int? splashDuration
}) {
    return SplashState(
      status: status ?? this.status,
splashUrl: splashUrl ?? this.splashUrl,
splashDuration: splashDuration ?? this.splashDuration
    );
  }

  @override
  List<Object?> get props => [
        status,
splashUrl,
splashDuration
      ];

  
}
