import 'package:flutter/material.dart';
import 'package:todolist/layout/to-do-cubit/ToDoAppCubit.dart';
import 'package:todolist/model/taskModel.dart';

class EditTaskScreen extends StatelessWidget {
  final TaskModel? model ;
  EditTaskScreen(this.model);



  @override
  Widget build(BuildContext context) {

    var nametaskController = TextEditingController(text:  model?.taskName);
    var fromtaskController = TextEditingController(text: model?.fromdateTask);
    var totaskController = TextEditingController(text:  model?.todateTask);
    var taskDescriptionController = TextEditingController(text:  model?.taskDes);



    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios),
          title: Text('Edit Task'),
        ),
        body: Column(children: [
          Form(child: Column(
            children: [
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
              Row(children: [
                TextFormField(

                  controller: fromtaskController ,
                  validator: (value){
                    if(value!.isEmpty) return 'Please enter your date' ;
                  },
                  decoration: InputDecoration(
                    //  border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today_outlined)
                  ),
                ),
                TextFormField(

                  controller: totaskController ,
                  validator: (value){
                    if(value!.isEmpty) return 'Please enter your date' ;
                  },
                  decoration: InputDecoration(
                    //  border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today_outlined)
                  ),
                ),


              ],),
              TextFormField(

                controller: taskDescriptionController ,
                keyboardType: TextInputType.name ,
                validator: (value){
                  if(value!.isEmpty) return 'Please enter your description' ;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Task Description')
                ),
              ),

              TextFormField(

                validator: (value){
                  if(value!.isEmpty) return 'Please enter your task name' ;
                },
                decoration: InputDecoration(
                    hintText: 'Parent Task',
                    border: InputBorder.none
                ),
              ),
              Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(onPressed: (){
                    ToDoAppCubit.get(context).editTask(
                        taskname: nametaskController.text,
                        totime: totaskController.text,
                        fromtime: fromtaskController.text ,
                        taskDescription: taskDescriptionController.text);
                  }, child: Text('Update')))



            ],
          ))
        ],));
  }
}
