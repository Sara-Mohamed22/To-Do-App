import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({@required String? message , @required ToastState? state })=> Fluttertoast.showToast(
    msg: '${message}' ,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: changeToastColor(state!),
    textColor: Colors.white,
    fontSize: 16.0
);

//enum
enum ToastState { SUCCESS , ERROR ,WARNING }

Color changeToastColor(ToastState state)
{
  Color? color ;
  switch(state)
  {
    case ToastState.SUCCESS :
      color = Colors.green ;
      break;
    case ToastState.ERROR:
      color = Colors.red ;
      break;
    case ToastState.WARNING:
      color = Colors.amber ;
      break;
  }

  return color ;


}