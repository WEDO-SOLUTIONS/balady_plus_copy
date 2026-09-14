part of 'notifications_filter_cubit.dart';

class NotificationsFilterState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class InitialNotificationsFilterState implements NotificationsFilterState {
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => throw UnimplementedError();
}

final class LoadingNotificationsFilterState extends NotificationsFilterState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class FailureNotificationsFilterState extends NotificationsFilterState {
  final String errorMessage;

  FailureNotificationsFilterState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class SucceedProductsFilterState extends NotificationsFilterState {
  final List<NotificationType> listProducts;
  final NotificationType? selectedProduct;

  SucceedProductsFilterState({required this.listProducts, this.selectedProduct});

  @override
  List<Object?> get props => [listProducts, listProducts.length, selectedProduct];
}

final class LoadingServicesFilterState extends NotificationsFilterState {
  LoadingServicesFilterState();

  @override
  List<Object?> get props => [];
}

final class SucceedServicesFilterState extends SucceedProductsFilterState {
  final List<NotificationType> listServices;
  final NotificationType? selectedServices;

  SucceedServicesFilterState({
    required this.listServices,
    this.selectedServices,
    required super.listProducts,
    selectedProduct,
  });

  SucceedServicesFilterState copyWith({
    List<NotificationType>? listServices,
    NotificationType? selectedServices,
    List<NotificationType>? listProducts,
    NotificationType? selectedProduct,
  }) {
    return SucceedServicesFilterState(
      listServices: listServices ?? this.listServices,
      selectedServices: selectedServices,
      listProducts: listProducts ?? super.listProducts,
      selectedProduct: selectedProduct ?? super.selectedProduct,
    );
  }

  @override
  List<Object?> get props => [listProducts, selectedProduct, listServices, selectedServices];
}
