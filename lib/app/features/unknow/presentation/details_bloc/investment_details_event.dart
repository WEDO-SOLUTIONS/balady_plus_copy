part of 'investment_details_bloc.dart';

abstract class InvestmentDetailsEvent extends Equatable {
  const InvestmentDetailsEvent();

  @override
  List<Object?> get props => [];
}

class DownloadFileEvent extends InvestmentDetailsEvent {
  String fileKey;
  DownloadFileEvent({required this.fileKey});
}
