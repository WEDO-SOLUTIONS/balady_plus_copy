part of 'test_validation_bloc.dart';

abstract class TestValidationEvent extends Equatable {
  const TestValidationEvent();

  @override
  List<Object?> get props => [];
}

class TestValidationOnChangeInfo extends TestValidationEvent {
  final String? phoneNumber;

  final String? email;

  final String? startDate;
  final String? endDate;

  final String? address;
  final String? description;

  final DropDownItem? city;

  const TestValidationOnChangeInfo({
    this.phoneNumber,
    this.email,
    this.startDate,
    this.endDate,
    this.address,
    this.description,
    this.city,
  });

  @override
  List<Object?> get props =>
      [phoneNumber, email, startDate, endDate, address, description, city];
}

class TestValidationOnSubmit extends TestValidationEvent {
  const TestValidationOnSubmit();
}
