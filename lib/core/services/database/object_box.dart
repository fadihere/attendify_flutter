import 'package:attendify_lite/app/features/employee/auth/data/models/user_emp_model.dart';
import 'package:attendify_lite/core/services/keys/local.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../app/features/employer/auth/data/models/user_emr_model.dart';
import 'objectbox.g.dart';

class ObjectBox {
  late final Store _store;


  late final Box<UserEmpModel> userEmp;
  late final Box<UserEmrModel> userEmr;

  ObjectBox._create(this._store) {
    userEmp = _store.box<UserEmpModel>();
    userEmr = _store.box<UserEmrModel>();
    
  }
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, LocalKeys.db));
    return ObjectBox._create(store);
  }
}
