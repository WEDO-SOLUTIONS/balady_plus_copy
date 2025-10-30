part of 'qr_bloc.dart';

abstract class QrEvent extends Equatable {
  const QrEvent();

  @override
  List<Object?> get props => [];
}

class GetQrDetailsEvent extends QrEvent {
  final String qr;
  const GetQrDetailsEvent({required this.qr});
}
