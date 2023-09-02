import 'dart:io';

import 'package:sober_driver_analog/domain/firebase/storage/repository.dart';

import '../models/cloud_storage_result.dart';

class UploadFileToCloudStorage {
  final FirebaseStorageRepository repository;

  UploadFileToCloudStorage(this.repository);
  Future<CloudStorageResult> call (File file, String fileName, String folder) {
    return repository.uploadImageToCloudStorage(file, fileName, folder);
  }
}