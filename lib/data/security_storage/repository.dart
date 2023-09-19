import 'dart:typed_data';

import 'package:sober_driver_analog/domain/security_storage/repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _secureStorage = FlutterSecureStorage();

class SecurityStorageRepositoryImpl extends SecurityStorageRepository {

  @override
  void initializeSecurityStorage() {
    _secureStorage.write(key: 'secure9', value: '-driver_balance');
  }



  @override
  Future<String> getSecretKey() async {
    String? accessKey = await _secureStorage.read(key: 'secure9');
    return accessKey!;
  }}