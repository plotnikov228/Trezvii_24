import 'package:sober_driver_analog/domain/db/repository/repository.dart';
import 'package:sqflite/sqflite.dart';


import '../../firebase/auth/models/user_model.dart';

class InitDB {
  final DBRepository repository;

  InitDB(this.repository);

  Future<Database> call () {
    return repository.initDB();
  }
}