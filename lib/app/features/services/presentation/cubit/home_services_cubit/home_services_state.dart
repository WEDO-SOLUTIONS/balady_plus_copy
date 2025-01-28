part of 'home_services_cubit.dart';

class ServicesState   {
  const ServicesState();

  // @override
  // List<Object?> get props {
  //   return [];
  // }
}

class ServicesSuccessState extends ServicesState {
  final HomeServices homeServices;

  const ServicesSuccessState({required this.homeServices});

  // @override
  // List<Object?> get props {
  //   return [
  //     homeServices.servicesCategories.length,
  //     homeServices.servicesCategories.first.title,
  //     homeServices.servicesCategories.last.title,
  //     homeServices.servicesCategories.first.listOfServices.length,
  //     homeServices.servicesCategories.first.listOfServices.first.title,
  //     homeServices.servicesCategories.last.listOfServices.length,
  //     homeServices.servicesCategories.last.listOfServices.first.title,
  //     homeServices.mostUsedService.title,
  //     homeServices.mostUsedService.label,
  //     homeServices.mostUsedService.color,
  //     homeServices.mostUsedServices.length,
  //   ];
  // }
}

class ServicesLoadingState extends ServicesSuccessState {
  const ServicesLoadingState({required super.homeServices});
}
