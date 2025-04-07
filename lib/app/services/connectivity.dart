import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> hasInternet() async {
final List<ConnectivityResult> result =
      await (Connectivity().checkConnectivity());
  
    return  result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet);
  
}
