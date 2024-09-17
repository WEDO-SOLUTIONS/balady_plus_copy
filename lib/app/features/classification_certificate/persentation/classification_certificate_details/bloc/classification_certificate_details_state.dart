import 'package:balady_plus/app/features/classification_certificate/domain/entity/classification_certificate_details_entity.dart';
import 'package:equatable/equatable.dart';

class ClassificationCertificateDetailsState extends Equatable {
  const ClassificationCertificateDetailsState();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoadingDetailsClassificationCertificateState extends ClassificationCertificateDetailsState {
  const LoadingDetailsClassificationCertificateState();
}

class FieldDetailsClassificationCertificateState extends ClassificationCertificateDetailsState {
  final String errorMessage;
  const FieldDetailsClassificationCertificateState({
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [errorMessage];
}

class SuccessDetailsClassificationCertificateState extends ClassificationCertificateDetailsState {
  final ClassificationCertificateDetailsEentity classificationCertificateDetails;
  const SuccessDetailsClassificationCertificateState({required this.classificationCertificateDetails});
  @override
  List<Object?> get props {
    return [classificationCertificateDetails,classificationCertificateDetails];
  }
}

