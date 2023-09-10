import 'package:sober_driver_analog/domain/db/constants.dart';
import 'package:sober_driver_analog/domain/map/models/address_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../domain/db/repository/repository.dart';
import '../../firebase/auth/models/user.dart';

Database? _db;

class DBRepositoryImpl extends DBRepository {
  Future<Database> _getDb() async {
    String _path = await getDatabasesPath() + 'db';
    _db = await openDatabase(_path, version: 1, onCreate: onCreate);
    return _db!;
  }

  @override
  Future<Database> initDB() async {
    return _db == null ? await _getDb() : _db!;
  }

  void onCreate(Database db, int version) async {
    db
      ..execute('''
    CREATE TABLE ${DBConstants.favoriteAddressesTable} (
      id INTEGER PRIMARY KEY NOT NULL,
      name STRING NOT NULL,
      addressName STRING NOT NULL,
      lat INTEGER NOT NULL,
      long INTEGER NOT NULL
      comment STRING NULL,
    );
  ''')
      ..execute('''
    CREATE TABLE ${DBConstants.userTable} (
      id INTEGER NOT NULL PRIMARY KEY,
      userId STRING NOT NULL,
      number STRING NOT NULL,
      email STRING NOT NULL,
      name STRING NOT NULL,
      registrationDate STRING NOT NULL,
      bonuses INTEGER NULL
      );
  ''');
  }

  @override
  Future<List<Map<String, dynamic>>> query(String table) async =>
      _db!.query(table);

  @override
  Future<int> insert(String table, Map<String, dynamic> model) async =>
      await _db!.insert(table, model);

  @override
  Future<int> update(
          String table, Map<String, dynamic> model, String variable) async =>
      await _db!.update(table, model,
          where: '$variable = ?', whereArgs: [model[variable]]);

  @override
  Future<int> delete(
          String table, Map<String, dynamic> model, String variable) async =>
      await _db!
          .delete(table, where: '$variable = ?', whereArgs: [model[variable]]);
}
