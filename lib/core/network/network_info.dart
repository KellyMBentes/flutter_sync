import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class INetworkInfo {
  String get checkUrl;
  Future<bool> isConnected();
}

@Injectable(as: INetworkInfo)
class NetworkInfoImpl implements INetworkInfo {
  final Connectivity connectivity;
  final Dio dio;

  NetworkInfoImpl({required this.connectivity, required this.dio});

  @override
  Future<bool> isConnected() async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      } else {
        final response = await dio.getUri(Uri.parse(checkUrl));
        return response.statusCode == 200;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  String get checkUrl => 'https://google.com';
}
