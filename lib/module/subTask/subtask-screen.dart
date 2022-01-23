import 'package:flutter/material.dart';
import 'package:todolist/layout/to-do-cubit/ToDoAppCubit.dart';
import 'package:todolist/model/taskModel.dart';

class AddSubTaskScreen extends StatelessWidget {

final TaskModel? submodel ;
AddSubTaskScreen(this.submodel);

  @override
  Widget build(BuildContext context) {

    var parenttaskController = TextEditingController(text:  submodel?.taskName);
    var nametaskController = TextEditingController();
    var fromtaskController = TextEditingController();
    var totaskController = TextEditingController();
    var taskDescriptionController = TextEditingController();



    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios),
          title: Text('Add Sub Task'),
        ),
        body: Column(children: [
          Form(child: Column(
            children: [
              TextFormField(

                // controller: nametaskController ,
                // keyboardType: TextInputType.name ,
                validator: (value){
                  if(value!.isEmpty) return 'Please enter your task name' ;
                },
                readOnly: true ,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                //    label: Text('Task Name')
                ),
              ),
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
                    ToDoAppCubit.get(context).createSubTask(
                        taskname: nametaskController.text,
                        totime: totaskController.text,
                        fromtime: fromtaskController.text ,
                        desc: taskDescriptionController.text,
                         taskid: submodel?.taskId,
                        parentTask: submodel?.taskName
                    );
                  }, child: Text('Save')))



            ],
          ))
        ],));
  }
}
