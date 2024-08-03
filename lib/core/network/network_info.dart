import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<bool> get isNotConnected;
}

class NetworkInfoImpl extends NetworkInfo {
  final Connectivity connectivity;
  NetworkInfoImpl(this.connectivity);
  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    if (result[0] == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> get isNotConnected async {
    final result = await connectivity.checkConnectivity();

    if (result[0] == ConnectivityResult.none) {
      return true;
    }
    return false;
  }
}
