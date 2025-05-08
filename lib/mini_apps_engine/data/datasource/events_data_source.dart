import 'package:balady_plus/app/core/services/global/web_service.dart';



abstract class EventsRemoteDataSource {

}

class EventDataSourceImpl extends EventsRemoteDataSource {
  final WebService webService;
  EventDataSourceImpl({required this.webService});


}
