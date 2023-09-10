import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/update_user.dart';
import 'package:sober_driver_analog/presentation/features/profile/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/profile/bloc/state.dart';

import '../../../../data/auth/repository/repository.dart';
import '../../../../data/firebase/auth/models/driver.dart';
import '../../../../data/firebase/auth/repository.dart';
import '../../../../data/firebase/storage/repository.dart';
import '../../../../data/payment/repository/repository.dart';
import '../../../../domain/auth/usecases/get_user_id.dart';
import '../../../../domain/firebase/auth/models/user_model.dart';
import '../../../../domain/firebase/auth/usecases/get_driver_by_id.dart';
import '../../../../domain/firebase/auth/usecases/get_user_by_id.dart';
import '../../../../domain/firebase/storage/usecases/upload_file_to_cloud_storage.dart';
import '../../../utils/app_operation_mode.dart';
import '../../../utils/status_enum.dart';
import '../../../widgets/bottom_sheet_for_select_photo.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  File? _file;
  String? _userPhotoUrl;
  UserModel? _user;

  final _authRepo = AuthRepositoryImpl();
  final _firebaseAuthRepo = FirebaseAuthRepositoryImpl();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  ProfileBloc(super.initialState) {
    bool isDriver = AppOperationMode.mode == AppOperationModeEnum.driver;

    on<InitProfileEvent>((event, emit) async {
      final id = await GetUserId(_authRepo).call();

      _user = (await GetUserById(_firebaseAuthRepo).call(id));
      try {
        _userPhotoUrl = await FirebaseStorage.instance
            .ref('${_user?.userId}/photo')
            .getDownloadURL();
      } catch (_) {}
      if (isDriver && _userPhotoUrl == null) {
        _user = (await GetDriverById(_firebaseAuthRepo).call(id));
        _userPhotoUrl =
            (_user as Driver?)?.personalDataOfTheDriver.driverPhotoUrl;
      }

      print('username ${_user!.name}');
      _emailController.text = _user!.email;
      _nameController.text = _user!.name;
      emit(ProfileState(
          imageFile: _file,
          imageUrl: _userPhotoUrl,
          name: _nameController,
          email: _emailController));
    });

    on<ChangePhotoProfileEvent>((event, emit) async {
      emit(ProfileState(
          imageFile: _file,
          imageUrl: _userPhotoUrl,
          name: _nameController,
          email: _emailController,
          status: Status.Loading));
      final image = await ImagePicker().pickImage(source: event.source);
      File file = File(image!.path);
      _file = file;
      try {
        await UploadFileToCloudStorage(FirebaseStorageRepositoryImpl())
            .call(file, 'photo', _user!.userId);
        emit(ProfileState(
            imageFile: _file,
            imageUrl: _userPhotoUrl,
            name: _nameController,
            email: _emailController));
      } catch (_) {
        emit(ProfileState(
            imageFile: _file,
            imageUrl: _userPhotoUrl,
            name: _nameController,
            email: _emailController,
            status: Status.Failed));
      }
    });

    on<CompleteChangesProfileEvent>((event, emit) async {
      emit(ProfileState(
          imageFile: _file,
          imageUrl: _userPhotoUrl,
          name: _nameController,
          email: _emailController,
          status: Status.Loading));
      try {
        await UpdateUser(_firebaseAuthRepo)
            .call(email: _emailController.text, name: _nameController.text);
        emit(ProfileState(
            imageFile: _file,
            imageUrl: _userPhotoUrl,
            name: _nameController,
            email: _emailController,
            status: Status.Success));
      } catch (_) {
        emit(ProfileState(
            imageFile: _file,
            imageUrl: _userPhotoUrl,
            name: _nameController,
            email: _emailController,
            status: Status.Failed));
      }
    });
  }
}
