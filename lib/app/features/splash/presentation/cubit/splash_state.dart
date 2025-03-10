part of 'splash_cubit.dart';

class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class InitialSplashState extends SplashState {
  const InitialSplashState();

  @override
  List<Object?> get props => [];
}

class OfflineSplashState extends SplashState {
  const OfflineSplashState();

  @override
  List<Object?> get props => [];
}

class OnlineSplashState extends SplashState {
  final File splashFile;
  final int splashDuration;

  const OnlineSplashState({
    required this.splashFile,
    required this.splashDuration,
  });

  @override
  List<Object?> get props => [splashFile, splashDuration];
}

class CompletedSplashState extends SplashState {
  const CompletedSplashState();

  @override
  List<Object?> get props => [];
}
