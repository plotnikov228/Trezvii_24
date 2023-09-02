import 'package:sober_driver_analog/domain/db/repository/repository.dart';
import 'package:sqflite/sqflite.dart';


import '../../firebase/auth/models/user_model.dart';

class DBInsert {
  final DBRepository repository;

  DBInsert(this.repository);

  Future<int> call (String table, Map<String, dynamic> model) {
    return repository.insert(table, model);
  }
}