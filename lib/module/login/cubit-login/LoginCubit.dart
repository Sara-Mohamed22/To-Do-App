
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/model/userModel.dart';

import 'loginStates.dart';


class LoginCubit extends Cubit<LoginState>
{

  UserModel? model ;

  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context) ;

  void UserLogin(
      {
        @required String? email ,
        @required String? password
      }
      ) {
    emit(LoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email !,
        password: password!
    ).
    then((value) {
      print('Login Successfully ');
      print(value.user?.uid);
      emit(LoginSucessState(value.user?.uid));
    }).
    catchError((error)
    {
      print('Error****');
      print(error.toString());
      emit(LoginErrorState(error.toString()));
    });


  }


  bool isHidden =true ;
  Widget visible = Icon(Icons.visibility_outlined);
  bool obscuretext =true ;

  void changevisibiliy()
  {
    if(isHidden) {
      isHidden = false;
      obscuretext = false ;
      visible = Icon(Icons.visibility_off_outlined);

      emit(ShowHidden());
    }
    else {
      visible = Icon(Icons.visibility_outlined);
      isHidden = true;
      obscuretext = true ;
      emit(ShowHidden());
    }
  }


}

