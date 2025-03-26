part of 'choose_muncipality_bloc.dart';

abstract class ChooseMuncipalityEvent extends Equatable {
  const ChooseMuncipalityEvent();

  @override
  List<Object> get props => [];
}

class SetRequestDataEvent extends ChooseMuncipalityEvent {
  final RegisterObserverRequest dataModel;

  const SetRequestDataEvent({required this.dataModel});
}

class SubmitCertifiedObserverRequestEvent extends ChooseMuncipalityEvent {
  final RegisterObserverRequest dataModel;

  const SubmitCertifiedObserverRequestEvent({required this.dataModel});
}

////// For Freelancer Certificate //////



class CreateNewFreelancerCertificateEvent extends ChooseMuncipalityEvent {
  const CreateNewFreelancerCertificateEvent();
}

class CheckOnStateOfFreelancerCertificate extends ChooseMuncipalityEvent {
  final ObserverStatusEntity observerStatus;

  const CheckOnStateOfFreelancerCertificate({required this.observerStatus});
}




class GoToNextPageEvent extends ChooseMuncipalityEvent {
  const GoToNextPageEvent();
}

class GoToPreviousPageEvent extends ChooseMuncipalityEvent {
  const GoToPreviousPageEvent();
}

class GetObserverStatusEvent extends ChooseMuncipalityEvent {
  final String identityNumber;

  const GetObserverStatusEvent({required this.identityNumber});
}
