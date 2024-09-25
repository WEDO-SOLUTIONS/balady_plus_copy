part of 'commercial_license_cancel_bloc.dart';

@immutable
abstract class CommercialLicenseEvent extends Equatable {
  const CommercialLicenseEvent();

  @override
  List<Object> get props => [];
}

class SubmitFirstPage extends CommercialLicenseEvent {
  const SubmitFirstPage();
}

class SubmitCancelRequestPage extends CommercialLicenseEvent {
  const SubmitCancelRequestPage();
}

class SelectReasonCancel extends CommercialLicenseEvent {
  final ReasonCancel reasonCancel;

  const SelectReasonCancel(this.reasonCancel);
}

class SelectAcknowledgePledge extends CommercialLicenseEvent {
  final bool acknowledgePledge;

  const SelectAcknowledgePledge(this.acknowledgePledge);
}

class SelectHijriCalendar extends CommercialLicenseEvent {
  final HijriCalendar? hijriCalendar;

  const SelectHijriCalendar(this.hijriCalendar);
}

class ShowCostInfo extends CommercialLicenseEvent {
  final bool showCostInfo;

  const ShowCostInfo(this.showCostInfo);
}
