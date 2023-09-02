import 'package:sober_driver_analog/domain/db/repository/repository.dart';
import 'package:sqflite/sqflite.dart';


import '../../firebase/auth/models/user_model.dart';

class DBDelete {
  final DBRepository repository;

  DBDelete(this.repository);

  Future<int> call (String table, Map<String, dynamic> model, String variable) {
    return repository.delete(table, model, variable);
  }
}