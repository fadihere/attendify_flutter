import 'package:attendify_lite/core/error/exceptions.dart';
import 'package:attendify_lite/core/services/database/shared_pref.dart';

abstract class SingularLocalDB {
  Future<bool> setPin(String pin);
  String getPin();
  Future<bool> clearPin();
}

class SingularLocalImpl implements SingularLocalDB {
  @override
  Future<bool> clearPin() async {
    return SharedPref.clearInt('pin');
  }

  @override
  String getPin() {
    final pin = SharedPref.getString('pin');
    if (pin != null) {
      return pin;
    }
    throw CacheException();
  }

  @override
  Future<bool> setPin(String pin) async {
    final value = await SharedPref.setString('pin', pin);
    if (value) {
      return true;
    }
    throw CacheException();
  }
}
