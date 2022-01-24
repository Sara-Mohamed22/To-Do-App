
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/model/userModel.dart';
import 'package:todolist/module/register/cubit-register/registerState.dart';



class RegisterCubit extends Cubit<RegisterState>
{

  UserModel? userdata ;

  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context) ;

  void UserRegister(
      {
        @required String? email ,
        @required String? password ,
        @required String? name ,
        @required String? phone
      }
      ) {
    emit(RegisterLoadingState());

   FirebaseAuth.instance.createUserWithEmailAndPassword(
       email: email!,
       password: password!
   ).
   then((value) {
     print('register sucessfully');
    print('uiid ${value.user?.uid}');

     UserModel userData = UserModel(name: name, email: email, phone: phone, uId: value.user?.uid);

     FirebaseFirestore.instance.collection('users').doc(value.user?.uid).
     set(userData.ToJson()).
     then((value) {
       print('store user data sucessfully');
     }).
     catchError((error) {
       print('Error****');
       print(error.toString());
     });

     emit(RegisterSucessState(value.user?.uid));

   }
   ).catchError((e){
     print('Error****');
     print(e.toString());
     emit(RegisterErrorState(e.toString()));
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

