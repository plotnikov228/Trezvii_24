import 'dart:io';

import 'models/cloud_storage_result.dart';

abstract class FirebaseStorageRepository  {
  Future<CloudStorageResult> uploadImageToCloudStorage (File file, String fileName, String storage);

  Future<String?> getPhotoById ({required String id});
}