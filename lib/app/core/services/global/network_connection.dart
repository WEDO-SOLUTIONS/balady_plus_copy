import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    show InternetConnection;

abstract class NetworkConnection {
  Future<bool> get isConnected;
}

class NetworkConnectionImplementation implements NetworkConnection {
  final InternetConnection connectionChecker;

  NetworkConnectionImplementation(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasInternetAccess;
}
