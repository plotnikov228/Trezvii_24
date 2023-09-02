import 'package:sober_driver_analog/domain/db/repository/repository.dart';
import 'package:sqflite/sqflite.dart';


import '../../firebase/auth/models/user_model.dart';

class DBQuery {
  final DBRepository repository;

  DBQuery(this.repository);

  Future<List<Map<String, dynamic>>> call (String table) {
    return repository.query(table);
  }
}