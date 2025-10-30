import 'package:internet_connection_checker/internet_connection_checker.dart'
    show InternetConnectionChecker;

abstract class SmartAdvisorNetworkConnection {
  Future<bool> get isConnected;
}

class SmartAdvisorNetworkConnectionImplementation
    implements SmartAdvisorNetworkConnection {
  final InternetConnectionChecker connectionChecker;

  SmartAdvisorNetworkConnectionImplementation(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
