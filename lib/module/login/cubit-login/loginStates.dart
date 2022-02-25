

abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSucessState extends LoginState {

  final String? uid ;
  LoginSucessState(this.uid);
}


class LoginErrorState extends LoginState {
  final String error ;
  LoginErrorState(this.error);
}


class ShowHidden extends LoginState {}


