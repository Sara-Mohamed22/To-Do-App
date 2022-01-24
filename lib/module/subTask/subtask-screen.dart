import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/layout/home.dart';
import 'package:todolist/layout/to-do-cubit/ToDOAppStates.dart';
import 'package:todolist/layout/to-do-cubit/ToDoAppCubit.dart';
import 'package:intl/intl.dart';
import 'package:todolist/model/taskModel.dart';
import 'package:todolist/share/component.dart';

class AddSubTaskScreen extends StatelessWidget {

  final TaskModel? model ;
  AddSubTaskScreen(this.model) ;

  @override
  Widget build(BuildContext context) {


    var _formKey = GlobalKey<FormState>();

    var nametaskController = TextEditingController();
    var parenttaskController = TextEditingController(text: model?.taskName);
    var fromtaskController = TextEditingController();
    var totaskController = TextEditingController();
    var taskDescriptionController = TextEditingController();


    return BlocConsumer<ToDoAppCubit , ToDoAppStates>(
      listener: (context , state){
        if(state is AddSubTaskSuccessfulState)
        {
          showToast(message: 'Sucessfully', state: ToastState.SUCCESS);
          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));

        }
        else if ( state is AddSubTasErrorState)
        {
          showToast(message: 'try again ', state: ToastState.ERROR);

        }
      },
      builder:(context , state){


        return  Scaffold(
          appBar: AppBar(
            leading: InkWell(
              child: Icon(Icons.arrow_back_ios),
              onTap: (){
                Navigator.pop(context);
              },),
            title: Text('Add Sub Task'),
          ),
          body:

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0 , horizontal: 22),
              child: Form(
                  key: _formKey,
                  child:
                  Column(
                    children: [

                      TextFormField(

                        controller: nametaskController ,
                        keyboardType: TextInputType.name ,
                        autofocus: true,
                        validator: (value){
                          if(value!.isEmpty) return 'Please enter your task name' ;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Task Name')
                        ),
                      ),
                      SizedBox(height: 20,),

                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.brown[50],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [

                            Expanded(
                              child: Container(
                                child:
                                TextFormField(

                                  controller: fromtaskController,
                                  keyboardType: TextInputType.none,

                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.calendar_today_outlined,

                                      ),
                                      hintText: 'from',

                                      border: InputBorder.none
                                  ),
                                  onTap: () async{

                                    showDatePicker(context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-10-18'),)
                                        .then((value) {
                                      print(DateFormat.yMMMd().format(value!));

                                      fromtaskController.text =
                                          DateFormat('yy-MM-dd').format(value);
                                    }
                                    );
                                  },

                                  validator: (value) {
                                    if(value!.isEmpty) return 'Please enter your date'  ;
                                  },


                                ),

                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.none,
                                  controller: totaskController ,
                                  validator: (value){
                                    if(value!.isEmpty) return 'Please enter your date'  ;
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.calendar_today_outlined),
                                      hintText: 'to'

                                  ),
                                  onTap: () {
                                    showDatePicker(context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-10-18'),)
                                        .then((value) {
                                      print(DateFormat('yy-MM-dd').format(value!));
                                      totaskController.text = DateFormat('yy-MM-dd').format(value);

                                    }
                                    );
                                  },
                                ),
                              ),
                            ),


                          ],),
                      ),

                      SizedBox(height: 20,),

                      TextFormField(

                        controller: taskDescriptionController ,
                        keyboardType: TextInputType.name ,
                        maxLines: 4,
                        validator: (value){
                          if(value!.isEmpty) return 'Please enter your description' ;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Task Description')
                        ),
                      ),

                      SizedBox(height: 20,),

                      TextFormField(
                        readOnly: true,
                        controller:  parenttaskController,
                        decoration: InputDecoration(
                            hintText: 'Parent Task',
                            border: OutlineInputBorder(),
                            label: Text('Parent Task')
                        ),
                      ),
                      SizedBox(height: 20,),

                         ConditionalBuilder(
                           condition:  state is ! AddSubTaskLoadingState,
                           builder:(context)=> Container(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ToDoAppCubit.get(context).createSubTask(
                                      taskname: nametaskController.text,
                                      totime: totaskController.text,
                                      fromtime: fromtaskController.text,
                                      desc: taskDescriptionController.text ,
                                    parentTask: model?.taskName,
                                    taskid: model?.taskId
                                  );
                                }
                              }
                                  , child: Text('Save'))),
                           fallback: (context)=> Center(child: CircularProgressIndicator()),
                         ),




                    ],
                  )),
            ),
          )
          ,
        ) ;
      } ,
    );
  }
}
