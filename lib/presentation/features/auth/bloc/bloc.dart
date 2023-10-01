import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sober_driver_analog/data/auth/repository/repository.dart';
import 'package:sober_driver_analog/data/firebase/notification/repository.dart';
import 'package:sober_driver_analog/domain/auth/models/auth_result.dart';
import 'package:sober_driver_analog/domain/auth/usecases/sign_in.dart';
import 'package:sober_driver_analog/domain/auth/usecases/sign_up.dart';
import 'package:sober_driver_analog/domain/auth/usecases/sign_up_for_driver.dart';
import 'package:sober_driver_analog/domain/firebase/auth/models/personal_data_of_the_driver.dart';
import 'package:sober_driver_analog/domain/firebase/notification/usecases/add_user_to_newsletter.dart';
import 'package:sober_driver_analog/domain/firebase/notification/usecases/add_user_to_pushes.dart';
import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:sober_driver_analog/presentation/routes/routes.dart';
import '../../../../data/firebase/auth/models/driver.dart';
import '../../../../domain/auth/models/auth_type.dart';
import '../../../../domain/auth/usecases/verify_code.dart';
import '../../../../domain/firebase/auth/models/car.dart';
import '../../../utils/status_enum.dart';
import 'event.dart';
import 'state.dart';
import 'package:image_picker/image_picker.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final TextEditingController signInNumber;
  final TextEditingController signUpNumber;
  final TextEditingController signUpEmail;
  final TextEditingController code;

  final BuildContext Function() getBuildContext;

  final TextEditingController _driverName = TextEditingController();
  final TextEditingController _driveAddress = TextEditingController();
  final TextEditingController _driverNumber = TextEditingController();
  final TextEditingController _driverBirthDate = TextEditingController();
  final _driverEmail = TextEditingController();
  Gender _driverGender = Gender.Man;

  final _carBrand = TextEditingController();
  final _carModel = TextEditingController();
  final _carColor = TextEditingController();
  final _carNumber = TextEditingController();
  final _carReleaseYear = TextEditingController();

  File? _passport;
  File? _registration;
  File? _driverLicenseFront;
  File? _driverLicenseBack;
  File? _driverPhoto;

  AuthState? previousState;
  AuthState? currentState;
  final _repo = AuthRepositoryImpl();

  AuthType? _authType;

  AuthResult? _authResult;
  bool _checkBoxValue = false;

  AuthState? _nextDriverState(AuthState next) {
    if (currentState != next && !carDataStateComplete()) return CarDataState();
    if (currentState != next && !driverDataStateComplete()) {
      return DriverDataState();
    }
    if (currentState != next && !enterPhotoStateComplete()) {
      return EnterPhotoState();
    }
  }

  bool enterPhotoStateComplete() {
    return _driverPhoto != null &&
        _driverLicenseFront != null &&
        _driverLicenseBack != null &&
        _registration != null &&
        _passport != null;
  }

  bool driverDataStateComplete() {
    return (_driverNumber.text.isNotEmpty &&
        _driverName.text.isNotEmpty &&
        _driveAddress.text.isNotEmpty &&
        _driverBirthDate.text.length == 10);
  }

  bool carDataStateComplete() {
    return _carBrand.text.isNotEmpty &&
        _carReleaseYear.text.isNotEmpty &&
        _carNumber.text.isNotEmpty &&
        _carModel.text.isNotEmpty &&
        _carReleaseYear.text.length == 10 &&
        _carColor.text.isNotEmpty;
  }

  AuthBloc(super.initialState, this.getBuildContext,
      {required this.signInNumber,
      required this.signUpNumber,
      required this.signUpEmail,
      required this.code}) {
    void _changeState(AuthState state, Emitter<AuthState> emit) {
      if (currentState != null) previousState = currentState;

      if (state is SignInState) {
        emit(currentState = SignInState(
            numberController: signInNumber,
            error: state.error,
            status: state.status));
        code.text = '';
      }
      if (state is SignUpState) {
        emit(currentState = SignUpState(
            checkBoxIsAccepted: state.checkBoxIsAccepted ?? _checkBoxValue,
            numberController: signUpNumber,
            emailController: signUpEmail,
            error: state.error,
            status: state.status));
        code.text = '';
      }
      if (state is InputCodeState) {
        emit(InputCodeState(
            codeController: code, error: state.error, status: state.status));
      }
      if (state is AuthDriverState) {
        if (state.checkBoxIsAccepted != null)
          _checkBoxValue = state.checkBoxIsAccepted!;
        emit(currentState = AuthDriverState(
            firstComplete: driverDataStateComplete(),
            secondComplete: carDataStateComplete(),
            thirdComplete: enterPhotoStateComplete(),
            checkBoxIsAccepted: _checkBoxValue,
            error: state.error,
            status: state.status));
      }
      if (state is DriverDataState) {
        if ((state as DriverDataState).driverGender != null) {
          _driverGender = state.driverGender!;
        }
        emit(currentState = DriverDataState(
            driveAddress: _driveAddress,
            driverBirthDate: _driverBirthDate,
            driverGender: _driverGender,
            driverEmail: _driverEmail,
            driverName: _driverName,
            driverNumber: _driverNumber,
            error: state.error,
            status: state.status,
            nextState: _nextDriverState(DriverDataState())));
      }
      if (state is CarDataState) {
        emit(currentState = CarDataState(
            carBrand: _carBrand,
            carColor: _carColor,
            carModel: _carModel,
            carNumber: _carNumber,
            carReleaseYear: _carReleaseYear,
            error: state.error,
            status: state.status,
            nextState: _nextDriverState(CarDataState())));
      }
      if (state is EnterPhotoState) {
        emit(currentState = EnterPhotoState(
            titles: [
              'Фото второй страницы паспорта',
              'Фото прописки паспорта',
              'Фото с лицевой стороны водительского удостоверения',
              'Фото с задней стороны водительского удостоверения',
              'Фото водителя'
            ],
            files: [
              _passport,
              _registration,
              _driverLicenseFront,
              _driverLicenseBack,
              _driverPhoto
            ],
            error: state.error,
            status: state.status,
            nextState: _nextDriverState(EnterPhotoState())));
      }
    }

    on<ChangeAuthStateEvent>((event, emit) {
      _changeState(event.state, emit);
    });

    on<SignUpEvent>((event, emit) async {
      add(ChangeAuthStateEvent(SignUpState(status: AuthStatus.Loading)));
      if(event.updatedCheckBoxValue  != null) {
        _checkBoxValue = event.updatedCheckBoxValue!;
        add(ChangeAuthStateEvent(SignUpState(checkBoxIsAccepted: event.updatedCheckBoxValue)));
      }
      else if (!event.textFieldHasError) {
        SignUp(_repo).call(signUpNumber.text, signUpEmail.text, (result) {
          add(ChangeAuthStateEvent(
              SignUpState(error: result.exception!, status: AuthStatus.Error)));
        }, (result) {
          _authResult = result;
          _authType = AuthType.userSignUp;
          add(ChangeAuthStateEvent(SignUpState(status: AuthStatus.Success)));
          add(ChangeAuthStateEvent(InputCodeState()));
        });
      }
    });

    on<SignInEvent>((event, emit) async {
      add(ChangeAuthStateEvent(SignInState(status: AuthStatus.Loading)));

      if (!event.textFieldHasError) {
        SignIn(_repo).call(signInNumber.text, (result) {
          add(ChangeAuthStateEvent(
              SignInState(error: result.exception!, status: AuthStatus.Error)));
        }, (result) {
          _authResult = result;
          _authType = AuthType.userSignIn;
          add(ChangeAuthStateEvent(SignInState(status: AuthStatus.Success)));

          add(ChangeAuthStateEvent(InputCodeState()));
        });
      }
    });

    on<InputCodeAuthEvent>((event, emit) async {
      add(ChangeAuthStateEvent(InputCodeState(status: AuthStatus.Loading)));

      final result = await VerifyCode(_repo).call(code.text, _authResult!,
          whenComplete: (userNotCreated) {
        if (userNotCreated && currentState is SignInState) {
          code.text = '';
          add(ChangeAuthStateEvent(SignInState(
              error: 'Такого пользователя не существует, пройдите регистрацию',
              status: AuthStatus.Error)));
        } else if (userNotCreated) {
          if (currentState is AuthDriverState) {
            add(ChangeAuthStateEvent(AuthDriverState(
                error:
                    'Произошла непредвиденная ошибка, заявка не была отправлена',
                status: AuthStatus.Error)));
          }
          if (currentState is SignUpState) {
            add(ChangeAuthStateEvent(SignUpState(
                error:
                    'Произошла непредвиденная ошибка, пользователь не был создан',
                status: AuthStatus.Error)));
          }
        } else {
          final notifyRepo =NotificationRepositoryImpl();
          try {
            AddUserToPushes(notifyRepo).call();
            AddUserToNewsletter(notifyRepo).call();
          } catch (_) {

          }
          getBuildContext().pushReplacement(AppRoutes.home);
        }
      }, type: _authType!);

      if (result.successful) {
        add(ChangeAuthStateEvent(InputCodeState(status: AuthStatus.Success)));

        emit(InputCodeState(codeController: code, status: AuthStatus.Loading));
      } else {
        emit(InputCodeState(
            codeController: code,
            error: result.exception,
            status: AuthStatus.Error));
      }
    });

    on<InsertPhotoEvent>((event, emit) async {
      final image = await ImagePicker().pickImage(source: event.source);
      File file =File(image!.path);
      print(image!.path);
      switch (event.fileIndex) {
        case 0:
          _passport = file;
        case 1:
          _registration = file;
        case 2:
          _driverLicenseFront = file;
          case 3:
            _driverLicenseBack = file;
        default:
          _driverPhoto =file;
      }
      add(ChangeAuthStateEvent(EnterPhotoState()));
    });

    on<CreateRequestEvent>((event, emit) async {
      SignUpForDriver(_repo).call(
          _driverNumber.text,
          Driver(
            confirmed: false,
            ratings: [],
            userId: '',
            number: '+7${_driverNumber.text}',
            email: _driverEmail.text,
            registrationDate: DateTime.now(),
            personalDataOfTheDriver: PersonalDataOfTheDriver(
              name: _driverName.text,
              birthDate: _driverBirthDate.text,
              male: _driverGender == Gender.Man,
              address: _driveAddress.text,
              number: _driverNumber.text,
              passPhotoUrl: '',
              registrationPhotoUrl: '',
              driverLicenseFrontPhotoUrl: '',
              driverLicenseBackPhotoUrl: '',
              driverPhotoUrl: '',
              passPhoto: _passport,
              registrationPhoto: _registration,
              driverLicenseFrontPhoto: _driverLicenseFront,
              driverLicenseBackPhoto: _driverLicenseBack,
              driverPhoto: _driverPhoto
            ),
            car: Car(color: _carColor.text, model: _carModel.text, number: _carNumber.text, brand: _carBrand.text, releaseDate: _carReleaseYear.text),
            name: _driverName.text,
          ), onError: (result) {
        add(ChangeAuthStateEvent(
            SignInState(error: result.exception!, status: AuthStatus.Error)));
      }, onSuccess: (result) {
        _authResult = result;
        _authType = AuthType.driverSignUp;
        add(ChangeAuthStateEvent(InputCodeState()));
      });
    });
  }
}

enum Gender { Man, Woman }
