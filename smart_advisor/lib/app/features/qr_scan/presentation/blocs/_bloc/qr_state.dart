part of 'qr_bloc.dart';

class QrState extends Equatable {
  final BlocStatus qrStatus;
  final QrDetailsResponse? qrResponse;
  final String? errorMessage;

  const QrState({
    this.qrStatus = BlocStatus.initial,
    this.qrResponse,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [qrStatus, errorMessage, qrResponse];

  QrState copyWith({
    BlocStatus? qrStatus,
    QrDetailsResponse? qrResponse,
    String? errorMessage,
  }) {
    return QrState(
        qrStatus: qrStatus ?? this.qrStatus,
        errorMessage: errorMessage,
        qrResponse: qrResponse ?? this.qrResponse);
  }
}
