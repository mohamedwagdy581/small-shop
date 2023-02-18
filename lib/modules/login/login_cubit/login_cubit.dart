import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/login_model.dart';
import '../../../shared/network/end_points.dart';
import '../../../shared/network/remote/dio_helper.dart';
import 'login_state.dart';


class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;

  void userLogin(
      {
        required String email,
        required String password,
      })
  {
    emit(LoginLoadingState());

    DioHelper.postData(
      url: LOGIN,
      data:
      {
        'email' : email,
        'password' : password,
      },
    ).then((value)
    {
      loginModel = LoginModel.fromJson(value.data);
      emit(LoginSuccessState(loginModel!));
    }).catchError((error)
    {
      emit(LoginErrorState());
    });
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPasswordShown = true;
  void changePasswordVisibility()
  {
    isPasswordShown = !isPasswordShown;
    suffix = isPasswordShown ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(LoginChangePasswordVisibilityState());
  }


}