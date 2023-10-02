import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:sober_driver_analog/data/firebase/auth/models/driver.dart';
import 'package:sober_driver_analog/domain/firebase/auth/models/personal_data_of_the_driver.dart';
import 'package:sober_driver_analog/domain/firebase/auth/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/firebase/auth/models/car.dart';
import '../../../domain/firebase/auth/repository/repository.dart';
import '../../../domain/map/models/app_lat_long.dart';
import 'models/user.dart';

class FirebaseAuthRepositoryImpl extends FirebaseAuthRepository {
  final _instance = FirebaseFirestore.instance;
  final _authInstance = auth.FirebaseAuth.instance;

  static const _usersCollection = 'Users';
  static const _driversCollection = 'Drivers';
  static const _existedUsersCollection = 'ExistedUsers';

  @override
  Future<UserModel?> createUser(User userModel) async {
    final doc = _instance.collection(_usersCollection).doc(userModel.userId);
    if((await doc.get()).exists) {
      return null;
    } else {
      await doc.set(userModel.toJson());
      return userModel;
    }
  }

  @override
  Future addUserToExisted(UserModel userModel) async {
    final doc = _instance.collection(_existedUsersCollection).doc(userModel.number);
    if(!(await doc.get()).exists) {
      await doc.set({
      });
    }
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    final doc = _instance.collection(_usersCollection).doc(userId);
    if((await doc.get()).exists) {
    return User.fromJson((await doc.get()).data()!);
    }
  }

  @override
  Future updateUser(String id,
      {String? number,
      String? email,
      String? name,
        bool? blocked,

        List<double>? ratings,
      int? bonuses}) async {
    Map<String, dynamic> mapForUpdate = {};
    if(number != null) mapForUpdate['number'] = number;
    if(email != null) mapForUpdate['email'] = email;
    if(name != null) mapForUpdate['name'] = name;
    if(bonuses != null) mapForUpdate['bonuses'] = bonuses;
    if(blocked != null)mapForUpdate['blocked'] = blocked;
    if(ratings != null) mapForUpdate['ratings'] = ratings;
      await _instance.collection( _usersCollection).doc(id).update(mapForUpdate);
      print('updated');

  }

  @override
  Future<UserModel?> getDriverById(String userId) async{
    try {
      final doc = _instance.collection(_driversCollection).doc(userId);
      if ((await doc.get()).exists) {
        return Driver.fromJson((await doc.get()).data()!);
      }
    } catch (_) {

    }
  }

  @override
  Future<UserModel?> sendDriverDataForVerification(Driver driverModel,) async {
    final doc = _instance.collection(_driversCollection).doc(driverModel.userId);
    if(!(await doc.get()).exists) {
    await doc.set(driverModel.toJson());
    return driverModel;
    }
  }

  @override
  Future updateDriver(
      String id,
      {String? number,
        String? email,
        String? name,
        AppLatLong? currentPosition,
        Car? car,
        PersonalDataOfTheDriver? personalDataOfTheDriver,
        List<double>? ratings,
        }) async {
    Map<String, dynamic> mapForUpdate = {};
    if(number != null) mapForUpdate['number'] = number;
    if(email != null) mapForUpdate['email'] = email;
    if(name != null) mapForUpdate['name'] = name;
    if(currentPosition != null) mapForUpdate['currentPosition'] = currentPosition.toJson();
    if(car != null) mapForUpdate['car'] = car.toJson();
    if(personalDataOfTheDriver != null) mapForUpdate['personalDataOfTheDriver'] = personalDataOfTheDriver.toJson();
    if(ratings != null) mapForUpdate['ratings'] = ratings;
    await _instance.collection(_driversCollection).doc(id).update(mapForUpdate);
  }

  @override
  Future<bool> userIsExist(String number) async {
    final doc = _instance.collection(_existedUsersCollection).doc(number);
    return (await doc.get()).exists;
  }

}