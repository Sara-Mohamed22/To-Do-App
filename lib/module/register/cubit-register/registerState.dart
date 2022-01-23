
import 'package:todolist/model/userModel.dart';

abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSucessState extends RegisterState {
  final UserModel? userData ;
  RegisterSucessState(this.userData);
}


class RegisterErrorState extends RegisterState {
  final String error ;
  RegisterErrorState(this.error);
}


class ShowHidden extends RegisterState {}
