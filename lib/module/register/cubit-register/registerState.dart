
import 'package:todolist/model/userModel.dart';

abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSucessState extends RegisterState {
  final String? uid ;
  RegisterSucessState(this.uid);
}


class RegisterErrorState extends RegisterState {
  final String error ;
  RegisterErrorState(this.error);
}




class ShowHidden extends RegisterState {}
