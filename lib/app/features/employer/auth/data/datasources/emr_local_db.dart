import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/services/database/object_box.dart';
import '../models/user_emr_model.dart';

abstract class AuthLocalDBEmr {
  bool setCurrentUser(UserEmrModel user);
  UserEmrModel? getCurrentUser();
  bool clearCurrentUser();
}

class AuthLocalDBEmrImpl implements AuthLocalDBEmr {
  final ObjectBox box;
  AuthLocalDBEmrImpl({required this.box});

  @override
  UserEmrModel getCurrentUser() {
    final users = box.userEmr.getAll();
    if (users.isNotEmpty) {
      return users.first;
    }
    throw CacheException();
  }

  @override
  bool clearCurrentUser() {
    final value = box.userEmr.removeAll();
    if (value != 0) {
      return true;
    }
    throw CacheException();
  }

  @override
  bool setCurrentUser(UserEmrModel user) {
    final value = box.userEmr.put(user);
    if (value != 0) {
      return true;
    }
    return false;
  }
}
