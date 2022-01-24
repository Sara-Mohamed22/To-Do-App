import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/layout/to-do-cubit/ToDOAppStates.dart';
import 'package:todolist/layout/to-do-cubit/ToDoAppCubit.dart';
import 'package:todolist/model/taskModel.dart';
import 'package:intl/intl.dart';



class EditTaskScreen extends StatelessWidget {
  final TaskModel? model ;
  EditTaskScreen(this.model);
  
  @override
  Widget build(BuildContext context) {

    var nametaskController = TextEditingController(text:  model?.taskName);
    var fromtaskController = TextEditingController(text: model?.fromdateTask);
    var totaskController = TextEditingController(text:  model?.todateTask);
    var taskDescriptionController = TextEditingController(text:  model?.taskDes);

    return BlocConsumer<ToDoAppCubit , ToDoAppStates>(
      listener: (context , state){},
      builder: (context , state){

        
        return Scaffold(
            appBar: AppBar(
              leading: InkWell(
                child: Icon(Icons.arrow_back_ios),
                onTap: (){
                  Navigator.pop(context);
                },),
              title: Text('Edit Task'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0 , horizontal: 22) ,
                child: Column(children: [

                  SizedBox(height: 20,),

                  TextFormField(

                    controller: nametaskController ,
                    keyboardType: TextInputType.name ,
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

                                  fromtaskController.text = DateFormat('yy-MM-dd').format(value!);
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
                    maxLines: 3,
                    keyboardType: TextInputType.name ,
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
                    validator: (value){
                      if(value!.isEmpty) return 'Please enter your task name' ;
                    },
                    decoration: InputDecoration(
                        hintText: 'Parent Task',
                        border: InputBorder.none
                    ),
                  ),
                  SizedBox(height: 50,),

                  Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(onPressed: (){
                        ToDoAppCubit.get(context).editTask(
                            taskId: model?.taskId,
                            taskname: nametaskController.text,
                            totime: totaskController.text,
                            fromtime: fromtaskController.text ,
                            taskDescription: taskDescriptionController.text
                        );
                      }, child: Text('Update')))
                ],),
              ),
            )) ;
      } ,
    );
  }
}
