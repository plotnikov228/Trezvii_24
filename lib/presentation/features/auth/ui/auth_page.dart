import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sober_driver_analog/presentation/features/auth/ui/widgets/auth_driver_page.dart';
import 'package:sober_driver_analog/presentation/features/auth/ui/widgets/car_data_page.dart';
import 'package:sober_driver_analog/presentation/features/auth/ui/widgets/driver_data_page.dart';
import 'package:sober_driver_analog/presentation/features/auth/ui/widgets/enter_photo_page.dart';
import 'package:sober_driver_analog/presentation/features/auth/ui/widgets/sign_in_page.dart';
import 'package:sober_driver_analog/presentation/features/auth/ui/widgets/sign_up_page.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/widgets/app_snack_bar.dart';

import '../bloc/bloc.dart';
import '../bloc/state.dart';
import 'widgets/input_code_page.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  final TextEditingController _signInNumber = TextEditingController();
  final TextEditingController _signUpNumber = TextEditingController();
  final TextEditingController _signUpEmail = TextEditingController();
  final TextEditingController _code = TextEditingController();

  AuthState? previous;
  AuthState? current;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          AuthBloc(
              SignInState(numberController: _signInNumber),
              () {
                return context;
              },
              signInNumber: _signInNumber,
              signUpEmail: _signUpEmail,
              signUpNumber: _signUpNumber,
              code: _code),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColor.firstColor,
        body: BlocConsumer<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
          current.status == AuthStatus.Error ||
              current.status == AuthStatus.Loading,
          listener: (context, state) {
            if (current != null) {
              previous = current;
            }
            if (previous != null && previous!.status == AuthStatus.Loading) {
              context.pop();
            }
            current = state;
            if (state.error != null) {
              AppSnackBar.showSnackBar(context, content: state.error!);
            }
            else if (state.status == AuthStatus.Loading) {
              showDialog(
                  barrierColor: Colors.transparent,
                  context: context, builder: (context) {
                return Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: const BorderRadius.all(Radius.circular(8))
                    ),
                    child: Center(child: CircularProgressIndicator(
                      color: AppColor.firstColor,
                    ),),
                  ),
                );
              });
            }
          },
          builder: (BuildContext context, state) {
            final bloc = context.read<AuthBloc>();
            if (state is SignInState) {
              return SignInPage(bloc: bloc, state: state);
            }
            if (state is SignUpState) {
              return SignUpPage(bloc: bloc, state: state);
            }
            if (state is DriverDataState) {
              return DriverDataPage(bloc: bloc, state: state);
            }
            if (state is AuthDriverState) {
              return AuthDriverPage(bloc: bloc, state: state);
            }
            if (state is CarDataState) {
              return CarDataPage(bloc: bloc, state: state);
            }
            if (state is EnterPhotoState) {
              return EnterPhotoPage(bloc: bloc, state: state);
            }

            return InputCodePage(bloc: bloc, state: state as InputCodeState);
          },
        ),
      ),
    );
  }
}
