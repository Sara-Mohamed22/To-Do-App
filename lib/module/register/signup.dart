


import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/data/local/cashHelper.dart';
import 'package:todolist/layout/home.dart';
import 'package:todolist/share/component.dart';

import 'cubit-register/registerCubit.dart';
import 'cubit-register/registerState.dart';


class RegisterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    TextEditingController nameController =TextEditingController();
    TextEditingController phoneController =TextEditingController();
    TextEditingController emailController =TextEditingController();
    TextEditingController passController =TextEditingController();

    var _formKey=GlobalKey<FormState>();


    return BlocProvider(
      create: (context)=> RegisterCubit(),

      child: BlocConsumer<RegisterCubit,RegisterState>(
        listener: (context,state){
          if(state is RegisterSucessState)
          {
              CashHelper.saveData(key: 'uId', value:state.userData?.uId ).
              then((value) {

                Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
              });
            }

          if(state is RegisterErrorState)
            {

              showToast(message:state.error.toString() , state: ToastState.ERROR );
            }

        },
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Text('Register' ,
                            style: Theme.of(context).textTheme.headline5 ),

                        SizedBox(height: 20,),
                        TextFormField(

                          controller: nameController ,
                          keyboardType: TextInputType.name ,
                          validator: (value){
                            if(value!.isEmpty) return 'Please enter your name' ;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                              label: Text('Name')


                          ),
                        ),

                        SizedBox(height: 20,),

                        TextFormField(

                          controller: phoneController ,
                          keyboardType: TextInputType.phone ,
                          validator: (value){
                            if(value!.isEmpty) return 'Please enter Phone Number' ;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.call),
                              label: Text('Phone')


                          ),
                        ),

                        SizedBox(height: 20,),

                        TextFormField(

                          controller: emailController ,
                          keyboardType: TextInputType.emailAddress ,
                          validator: (value){
                            if(value!.isEmpty) return 'Please enter your Email Address' ;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email_outlined),
                              label: Text('Email Address')


                          ),
                        ),

                        SizedBox(height: 20,),

                        TextFormField(

                          controller: passController ,
                          keyboardType: TextInputType.phone ,
                          obscureText: RegisterCubit.get(context).obscuretext,
                          validator: (value){
                            if(value!.isEmpty) return 'Please enter Password' ;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock),
                              label: Text('Password'),
                              suffixIcon:
                              GestureDetector(
                                  onTap: (){
                                    print(RegisterCubit.get(context).isHidden);
                                    RegisterCubit.get(context).changevisibiliy() ;
                                  },
                                  child: RegisterCubit.get(context).visible


                              )


                          ),
                        ),

                        SizedBox(height: 20,),

                        Container(

                          width: double.infinity,
                          height: 50,

                          child: ConditionalBuilder(
                            condition: state is! RegisterLoadingState ,
                            builder: (context)=> MaterialButton(
                              shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0), // <-- Radius
                              ),
                              color: Colors.blueAccent,
                              onPressed: ()
                              {
                                if(_formKey.currentState!.validate())
                                {

                                  RegisterCubit.get(context).UserRegister(
                                      email: emailController.text ,
                                      password: passController.text ,
                                      name: nameController.text ,
                                      phone: phoneController.text);


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

                      ]
                  ),
                ),
              ),
            ),
          ) ;
        },
      ),
    );
  }



}
