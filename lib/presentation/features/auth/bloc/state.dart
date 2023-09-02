
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/map/models/address_model.dart';

import 'bloc.dart';

abstract class AuthState {
  final String? error;
  final AuthStatus? status;
  AuthState( {this.status,this.error});
}

class SignInState extends AuthState {
  final TextEditingController? numberController;

  SignInState({this.numberController, super.error, super.status = AuthStatus.Wait});
}

class SignUpState extends AuthState {
  final TextEditingController? emailController;
  final TextEditingController? numberController;
  final bool? checkBoxIsAccepted;

  SignUpState({this.emailController, this.numberController, this.checkBoxIsAccepted, super.error, super.status = AuthStatus.Wait});
}

class InputCodeState extends AuthState {
  final TextEditingController? codeController;
  InputCodeState({this.codeController, super.error, super.status = AuthStatus.Wait});
}

class AuthDriverState extends AuthState {
  final bool? firstComplete;
  final bool? secondComplete;
  final bool? thirdComplete;
  final bool? checkBoxIsAccepted;

  AuthDriverState(
      {this.checkBoxIsAccepted, this.firstComplete, this.secondComplete, this.thirdComplete, super.error, super.status = AuthStatus.Success});

}

class ConfirmNumberDriverState extends AuthState {

}

class DriverDataState extends AuthState {
  final TextEditingController? driverName;
  final TextEditingController? driveAddress;
  final TextEditingController? driverNumber;
  final TextEditingController? driverEmail;
  final TextEditingController? driverBirthDate;
  final Gender? driverGender;
  final AuthState? nextState;

  DriverDataState(
      {this.nextState, this.driverName,
      this.driveAddress,
      this.driverNumber,
        this.driverEmail,
      this.driverBirthDate,
      this.driverGender, super.error, super.status = AuthStatus.Success});
}

class CarDataState extends AuthState {
  final TextEditingController? carBrand;
  final TextEditingController? carModel;
  final TextEditingController? carColor;
  final TextEditingController? carNumber;
  final TextEditingController? carReleaseYear;
  final AuthState? nextState;
  CarDataState(
      {this.nextState, this.carBrand,
      this.carModel,
      this.carColor,
      this.carNumber,
      this.carReleaseYear,  super.error, super.status = AuthStatus.Success});
}

class EnterPhotoState extends AuthState {
  final AuthState? nextState;
  final List<File?>? files;
  final List<String>? titles;

  EnterPhotoState(
      {this.nextState,this.titles,this.files, super.error, super.status = AuthStatus.Success});
}

enum AuthStatus {
  Success,
  Error,
  Wait,
  Loading
}