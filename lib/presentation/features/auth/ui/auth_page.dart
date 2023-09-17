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

import '../../../utils/size_util.dart';
import '../../../widgets/app_loading_message.dart';
import '../../../widgets/app_progress_container.dart';
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
          },
          builder: (BuildContext context, state) {
            final bloc = context.read<AuthBloc>();
            return Stack(
              children: [
                if (state is SignInState)
                  SignInPage(bloc: bloc, state: state),

                if (state is SignUpState)
                  SignUpPage(bloc: bloc, state: state),

                if (state is DriverDataState)
                  DriverDataPage(bloc: bloc, state: state),

                if (state is AuthDriverState)
                  AuthDriverPage(bloc: bloc, state: state),

                if (state is CarDataState)
                  CarDataPage(bloc: bloc, state: state),

                if (state is EnterPhotoState)
                  EnterPhotoPage(bloc: bloc, state: state),
                if (state is InputCodeState)
                  InputCodePage(bloc: bloc, state: state as InputCodeState),
                if(state.status == AuthStatus.Loading) Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.grey.withOpacity(0.3),
                    child: Center(
                        child: AppProgressContainer()
                    )
                    )
              ],
            );
          },
        ),
      ),
    );
  }
}
