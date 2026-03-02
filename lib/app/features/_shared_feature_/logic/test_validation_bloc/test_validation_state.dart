part of 'test_validation_bloc.dart';

class TestValidationState extends Equatable {
  final String? phoneNumber;

  final String? email;

  final String? startDate;
  final String? endDate;

  final String? address;
  final String? description;

  final DropDownItem? city;

  final BlocRequestStatus status;
  final String? errorMessage;

  const TestValidationState({
    this.phoneNumber,
    this.email,
    this.startDate,
    this.endDate,
    this.address,
    this.description,
    this.city,
    //
    this.status = BlocRequestStatus.initial,
    this.errorMessage,
  });

  //! Validators
  PhoneNumberValidation get phoneNumberValidator => PhoneNumberValidation.dirty(value: phoneNumber ?? '');

  EmailValidation get emailValidator => EmailValidation.dirty(email: email ?? '');

  RequiredFieldValidation get startDateValidator => RequiredFieldValidation.dirty(value: startDate ?? '');
  DateAfterValidation get endDateValidator => DateAfterValidation.dirty(
        startDate: startDate ?? '',
        endDate: endDate ?? '',
      );

  OptionalFieldValidation get addressValidator =>
      OptionalFieldValidation.dirty(value: isAddress ? address ?? '' : null);
  RequiredFieldValidation get descriptionValidator => RequiredFieldValidation.dirty(value: description ?? '');

  RequiredDropDownValidation get cityValidator => RequiredDropDownValidation.dirty(value: city ?? sl<DropDownItem>());

  //! Errors
  String? get phoneNumberErrorText => phoneNumber != null ? phoneNumberValidator.error?.message : null;

  String? get emailErrorText => email != null ? emailValidator.error?.message : null;

  String? get startDateErrorText => startDate != null ? startDateValidator.error?.message : null;
  String? get endDateErrorText => endDate != null ? endDateValidator.error?.message : null;

  String? get addressErrorText => address != null ? addressValidator.error?.message : null;
  String? get descriptionErrorText => description != null ? descriptionValidator.error?.message : null;

  String? get cityErrorText => city != null ? cityValidator.error?.message : null;

  bool get isAddress => true;

  String get error => errorMessage ?? "";

  bool get isFormValid => Formz.validate([
        phoneNumberValidator,
        emailValidator,
        startDateValidator,
        endDateValidator,
        addressValidator,
        descriptionValidator,
        cityValidator,
      ]);

  @override
  List<Object?> get props => [
        phoneNumber,
        email,
        startDate,
        endDate,
        address,
        description,
        city,
        //
        status,
        errorMessage,
      ];

  TestValidationState copyWith({
    String? phoneNumber,
    String? email,
    String? startDate,
    String? endDate,
    String? address,
    String? description,
    DropDownItem? city,
    BlocRequestStatus? status,
    String? errorMessage,
  }) {
    return TestValidationState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      address: address ?? this.address,
      description: description ?? this.description,
      city: city ?? this.city,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() {
    return 'TestValidationState(phoneNumber: $phoneNumber, email: $email, startDate: $startDate, endDate: $endDate, address: $address, description: $description, city: $city, status: $status, errorMessage: $errorMessage)';
  }
}
