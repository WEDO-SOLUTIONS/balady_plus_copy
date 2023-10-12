import 'package:internet_connection_checker/internet_connection_checker.dart'
    show InternetConnectionChecker;

abstract class NetworkConnection {
  Future<bool> get isConnected;
}

class NetworkConnectionImplementation implements NetworkConnection {
  final InternetConnectionChecker connectionChecker;

  NetworkConnectionImplementation(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
