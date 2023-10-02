import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/update_driver.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/update_user.dart';
import 'package:sober_driver_analog/domain/firebase/storage/usecases/get_photo_by_id.dart';
import 'package:sober_driver_analog/presentation/features/profile/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/profile/bloc/state.dart';

import '../../../../data/auth/repository/repository.dart';
import '../../../../data/firebase/auth/models/driver.dart';
import '../../../../data/firebase/auth/repository.dart';
import '../../../../data/firebase/storage/repository.dart';
import '../../../../domain/firebase/auth/models/user_model.dart';
import '../../../../domain/firebase/auth/usecases/get_driver_by_id.dart';
import '../../../../domain/firebase/auth/usecases/get_user_by_id.dart';
import '../../../../domain/firebase/storage/usecases/upload_file_to_cloud_storage.dart';
import '../../../utils/status_enum.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  File? _file;
  String? _userPhotoUrl;
  UserModel? _user;

  final _authRepo = AuthRepositoryImpl();
  final _firebaseAuthRepo = FirebaseAuthRepositoryImpl();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  ProfileBloc(super.initialState) {

    on<InitProfileEvent>((event, emit) async {
      final id = FirebaseAuth.instance.currentUser!.uid;

      _user =  (await GetUserById(_firebaseAuthRepo).call(id));
        _userPhotoUrl =await GetPhotoById(FirebaseStorageRepositoryImpl()).call(id);

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
            .call(FirebaseAuth.instance.currentUser!.uid ,email: _emailController.text, name: _nameController.text);

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
