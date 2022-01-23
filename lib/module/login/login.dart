
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:todolist/data/local/cashHelper.dart';
import 'package:todolist/layout/home.dart';
import 'package:todolist/module/register/signup.dart';
import 'package:todolist/share/component.dart';

import 'cubit-login/LoginCubit.dart';
import 'cubit-login/loginStates.dart';


class LoginScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();


  @override

  Widget build(BuildContext context) {

    var usernameController = TextEditingController();

    var passwordController = TextEditingController();


    return BlocProvider(
        create: (BuildContext context) => LoginCubit(),
        child:BlocConsumer< LoginCubit , LoginState > (
          listener: (context , state)
          {
            if(state is LoginSucessState )
                {
                   CashHelper.saveData(key: 'uId', value: state.uid).then((value) {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                     });
                 }
            if (state is LoginErrorState)
              {

                showToast(message:state.error.toString() , state: ToastState.ERROR );

              }

          } ,
          builder:(context , state){
            return     Scaffold(
                appBar: AppBar() ,
                body:Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey ,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start ,
                          children: [
                            Center(
                              child: Text('Login' ,
                                  style: Theme.of(context).textTheme.headline5 ),
                            ),

                            SizedBox(height: 30,),
                            TextFormField(

                              controller: usernameController ,
                              keyboardType: TextInputType.emailAddress ,
                              validator: (value){
                                if(value!.isEmpty) return 'Please enter your email address' ;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.email_outlined),
                                  label: Text('Email Address')


                              ),
                            ),

                            SizedBox(height: 20,),

                            TextFormField(

                                controller: passwordController ,
                                keyboardType: TextInputType.visiblePassword ,
                                obscureText: LoginCubit.get(context).obscuretext ,
                                validator: (value){
                                  if(value!.isEmpty) return 'Please enter your password' ;
                                },
                                onFieldSubmitted: (value) {
                                  if (formKey.currentState!.validate()) {
                                    LoginCubit.get(context).UserLogin(email: usernameController.text,
                                        password: passwordController.text);
                                  }
                                },
                                decoration: InputDecoration(

                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.lock_open_outlined),
                                    label: Text('Password'),

                                    suffixIcon:
                                    GestureDetector(
                                        onTap: (){
                                          print(LoginCubit.get(context).isHidden);
                                          LoginCubit.get(context).changevisibiliy() ;
                                        },
                                        child:
                                        LoginCubit.get(context).visible


                                    ))) , SizedBox(height: 30,),

                            Container(

                              width: double.infinity,
                              height: 50,

                              child: ConditionalBuilder(
                                condition: state is! LoginLoadingState ,
                                builder: (context)=> MaterialButton(
                                  shape:  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0), // <-- Radius
                                  ),
                                  color: Colors.blueAccent,
                                  onPressed: ()
                                  {
                                    if(formKey.currentState!.validate())
                                    {
                                      LoginCubit.get(context).UserLogin(
                                          email: usernameController.text ,
                                          password: passwordController.text
                                      );



                                    }

                                  }
                                  ,
                                  child: Text('Login' ,
                                    style: TextStyle(
                                        color: Colors.white ,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 19
                                    ),),),
                                fallback: (context)=> Center(child: CircularProgressIndicator()) ,

                              ),
                            ),

                            SizedBox(height: 15,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Don\'t have account ?' ),
                                TextButton(
                                    onPressed: ()
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterScreen()));

                                    }, child: Text('Register Now'))
                              ],)
                          ],
                        ),
                      ),
                    ),
                  ),
                )
            );
          }  ,
        )

    );
  }
}

