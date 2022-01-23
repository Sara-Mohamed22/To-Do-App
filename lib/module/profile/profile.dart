import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/data/local/cashHelper.dart';
import 'package:todolist/layout/to-do-cubit/ToDOAppStates.dart';
import 'package:todolist/layout/to-do-cubit/ToDoAppCubit.dart';
import 'package:todolist/module/login/login.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ToDoAppCubit d = ToDoAppCubit.get(context) ;

    var _formKey = GlobalKey<FormState>();

    TextEditingController nameController = TextEditingController(text:  d.model?.name);
    TextEditingController emailController = TextEditingController(text: d.model?.email);
    TextEditingController phoneController = TextEditingController(text:  d.model?.phone);


    return
      BlocConsumer<ToDoAppCubit , ToDoAppStates>(
        listener: (context ,state){},
        builder: (context , state){
          return ConditionalBuilder(
            condition: ToDoAppCubit.get(context).model !=null ,
            builder: (context)=> Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(

                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(

                    child: Form(
                      key: _formKey,
                      child: Column(

                        children: [
                          TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            validator: (value)=> value!.isEmpty ? 'This field Required' : null ,
                            decoration: InputDecoration(
                              //  label: Text('Name'),
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder()
                            ),


                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value)=> value!.isEmpty ? 'This field Required' : null ,
                            decoration: InputDecoration(
                             //   label: Text('Email'),
                                prefixIcon: Icon(Icons.mail),
                                border: OutlineInputBorder()
                            ),



                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value)=> value!.isEmpty ? 'This field Required' : null ,
                            decoration: InputDecoration(
                             //   label: Text('Phone'),
                                prefixIcon: Icon(Icons.call),
                                border: OutlineInputBorder()
                            ),



                          ),

                          SizedBox(height: 20,),

                          Container(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(onPressed: (){
                                CashHelper.removeData(key: 'uId').then((value) {
                                  print('logout Successfully !');
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                                }).catchError((e){
                                  print('error in logout ${e.toString()}');
                                });
                              }, child: Text('LOGOUT'))),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            fallback: (context)=> Center(child: CircularProgressIndicator()),
          );
        },

      );
  }
}


















// child: Column(
// children: [
// TextFormField(
// controller: nameController,
// keyboardType: TextInputType.name,
// validator: (value)=> value!.isEmpty ? 'This field Required' : null ,
// decoration: InputDecoration(
// label: Text('Name'),
// prefixIcon: Icon(Icons.person),
// enabledBorder: OutlineInputBorder()
// ),
//
// ),
// SizedBox(height: 20,),
// TextFormField(
// controller: emailController,
// keyboardType: TextInputType.emailAddress,
// validator: (value)=> value!.isEmpty ? 'This field Required' : null ,
// decoration: InputDecoration(
// label: Text('Email'),
// prefixIcon: Icon(Icons.mail),
// enabledBorder: OutlineInputBorder()
// ),
//
//
//
// ),
// SizedBox(height: 20,),
// TextFormField(
// controller: phoneController,
// keyboardType: TextInputType.phone,
// validator: (value)=> value!.isEmpty ? 'This field Required' : null ,
// decoration: InputDecoration(
// label: Text('Phone'),
// prefixIcon: Icon(Icons.call),
// enabledBorder: OutlineInputBorder()
// ),
//
//
//
// ),
// SizedBox(height: 20,),
//
// Container(
// width: double.infinity,
// height: 50,
// child: ElevatedButton(onPressed: (){
// CashHelper.removeData(key: 'token').then((value) {
// print('logout Successfully !');
// Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopLoginScreen()));
// }).catchError((e){
// print('error in logout ${e.toString()}');
// });
// }, child: Text('LOGOUT')))
// ],*/