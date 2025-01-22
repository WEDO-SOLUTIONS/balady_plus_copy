part of 'home_services_cubit.dart';


class ServicesState extends Equatable {
  const ServicesState();
  @override
  List<Object?> get props {
    return [];
  }
}


class ServicesSuccessState extends ServicesState {
  final HomeServices homeServices;
  const ServicesSuccessState({required this.homeServices});
  @override
  List<Object?> get props {
    return [];
  }
}