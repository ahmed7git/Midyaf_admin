import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkInternet() async {
  try {
    // أولاً: فحص سريع عبر connectivity_plus (يعمل بشكل موثوق على iOS وAndroid)
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }

    // ثانياً: تأكيد فعلي للاتصال مع timeout لتجنب التجمد على iOS
    final result = await InternetAddress.lookup("google.com")
        .timeout(const Duration(seconds: 5));
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  } on TimeoutException catch (_) {
    return false;
  } catch (_) {
    return false;
  }
}