import 'dart:io';

import 'package:sober_driver_analog/domain/firebase/storage/repository.dart';

import '../models/cloud_storage_result.dart';

class GetPhotoById {
  final FirebaseStorageRepository repository;

  GetPhotoById(this.repository);
  Future<String?> call (String id) {
    return repository.getPhotoById(id: id);
  }
}