import 'package:connectivity_plus/connectivity_plus.dart';
abstract class NetworkInfo {
  Future<bool>  isConnected();
}
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool>  isConnected() async {
    var connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
  }
}
