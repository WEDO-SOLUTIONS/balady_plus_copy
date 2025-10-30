import 'package:balady_plus/app/features/ekram/domain/entities/deceased_request_details/deceased_request_details.dart';

class TripDetailsParmas {
  int requestId;
  int requestStatusId;
  DeceasedInfoResponseDtoList info;
  List<TransportAttachResponseDto>? transportAttachResponseDtoList;

  TripDetailsParmas(
      {required this.info,
      required this.requestId,
      required this.requestStatusId,
      this.transportAttachResponseDtoList});
}
