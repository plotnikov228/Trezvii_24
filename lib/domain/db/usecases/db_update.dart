import 'package:sober_driver_analog/domain/db/repository/repository.dart';
import 'package:sqflite/sqflite.dart';


import '../../firebase/auth/models/user_model.dart';

class DBUpdate {
  final DBRepository repository;

  DBUpdate(this.repository);

  Future<int> call (String table, Map<String, dynamic> model, String variable) {
    return repository.update(table, model, variable);
  }
}