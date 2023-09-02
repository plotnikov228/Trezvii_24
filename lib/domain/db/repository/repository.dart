import 'package:firebase_auth/firebase_auth.dart';
import 'package:sober_driver_analog/domain/firebase/auth/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../firebase/order/model/order.dart';
import '../../map/models/address_model.dart';

abstract class DBRepository {
  Future<Database> initDB();

  Future<List<Map<String, dynamic>>> query(String table);

   Future<int> insert(String table, Map<String, dynamic> model);

   Future<int> update(String table, Map<String, dynamic> model, String variable);

   Future<int > delete(String table, Map<String, dynamic> model, String variable);

}
