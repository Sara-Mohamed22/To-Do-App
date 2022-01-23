
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/data/local/cashHelper.dart';
import 'package:todolist/layout/to-do-cubit/ToDOAppStates.dart';
import 'package:todolist/layout/to-do-cubit/ToDoAppCubit.dart';
import 'package:todolist/model/taskModel.dart';
import 'package:todolist/module/edit-task-screen/edit-task-screen.dart';
import 'package:todolist/module/subTask/subtask-screen.dart';
import 'package:todolist/share/constant.dart';




class MyTasksScreen extends StatelessWidget {
  const MyTasksScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    DatePickerController _controller = DatePickerController();

    ToDoAppCubit cubit = ToDoAppCubit.get(context);

    return BlocConsumer<ToDoAppCubit,ToDoAppStates>(
        listener:(context ,state){
          // if(state is UpDateCompleteTaskSuccessfulState ||
          //      state is DeleteTaskSuccessfulState ||
          //      state is EditTaskSuccessfulState ||
          //      state is UpDateCompleteSubTaskSuccessfulState
          //  )
          //    {
          //      cubit.getAllTasks();
          //    }
          //////////////////////////////////////////

          if(state is ToDoAppLoadingState)
          {
            cubit.getUserData();
          }
          if(cubit.alltasks.length !=0 || cubit.subtasks.length !=0
          )
          {


            CashHelper.saveData(key: 'noTask', value: false).then((value) {
              print('no post yet');
            }).catchError((e){
              print('error in num of post ${e.toString()}');
            });

          }
          else
          {
            CashHelper.saveData(key: 'noTask', value: true).then((value) {
              print('no post yet');
            }).catchError((e){
              print('error in num of post ${e.toString()}');
            });
          }

        } ,
        builder: (context ,state){

          print('length ${cubit.alltasks.length}');
          print('sublength ${cubit.subtasks.length}');

          var noTask = CashHelper.getData(key: 'noTask');

          return Scaffold(

            body:
            noTask == true  ?
            Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_note_outlined , size: 45,color: Colors.blue,),
                SizedBox(height: 10,),
                Text('No Tasks Yet, Please Add New Task'),
              ],
            )):

            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child:
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10 , horizontal: 10),
                      height: 100,
                      child: DatePicker(
                        DateTime.now(),
                        width: 60,
                        height: 80,
                        controller: _controller,
                        initialSelectedDate: DateTime.now(),
                        selectionColor: Colors.deepPurple,
                        selectedTextColor: Colors.white,
                        inactiveDates: [
                          DateTime.now().add(Duration(days: 3)),
                          DateTime.now().add(Duration(days: 4)),
                          DateTime.now().add(Duration(days: 7))
                        ],
                        onDateChange: (date) {

                        },
                      ), ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ConditionalBuilder(
                            condition: cubit.alltasks.length > 0   ,
                            builder: (context)=> Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0 ,horizontal: 8),
                              child: Column(
                                children: [
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context , index) {

                                      return taskItem( cubit.alltasks[index] , ToDoAppCubit.get(context) ,context );
                                    },
                                    itemCount: cubit.alltasks.length,
                                    separatorBuilder: (context ,index)=>
                                    cubit.alltasks[index].status != status.remove.name ?
                                    SizedBox(height: 18,) : SizedBox(height: 1,),
                                  ),

                                  /* ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context , index) {

                                          return subtaskItem( cubit.subtasks[index] , ToDoAppCubit.get(context) ,context );
                                        },
                                        itemCount: cubit.subtasks.length,
                                        separatorBuilder: (context ,index)=> SizedBox(height: 20,),),*/
                                ],
                              ),
                            ) ,
                            fallback: (context)=>
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 200),
                                  child: Center(child:
                                  CircularProgressIndicator(),
                                  ),
                                )
                        ),

                        ConditionalBuilder(
                            condition: cubit.subtasks.length > 0   ,
                            builder: (context)=> Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0 ,horizontal: 8),
                              child: Column(
                                children: [

                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context , index) {

                                      return subtaskItem( cubit.subtasks[index] , ToDoAppCubit.get(context) ,context );
                                    },
                                    itemCount: cubit.subtasks.length,
                                    separatorBuilder: (context ,index)=>
                                    cubit.subtasks[index].status != status.remove.name ?
                                    SizedBox(height: 20,) : SizedBox(height: 1,) ,
                                  ),
                                ],
                              ),
                            ) ,
                            fallback: (context)=>
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 80),
                                  child: Center(child:
                                  CircularProgressIndicator(),
                                  ),
                                )
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),




          );





        });
  }



  Widget taskItem(TaskModel model , ToDoAppCubit cubit ,context )=>  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child:
      model.status != status.remove.name ?
      Stack(
        alignment: AlignmentDirectional.centerStart,
        children:
        [
          Container(
            height: 130,
            decoration: BoxDecoration(
                color:  model.taskParent == '' ? Colors.pink[50] : Colors.brown[50]  ,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0 , vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text('${model.taskName }',
                          style:TextStyle(fontWeight: FontWeight.bold , fontSize: 18),
                          overflow: TextOverflow.ellipsis,),


                        Text('Task Description : \n   ${model.taskDes}.',
                          style:TextStyle(fontWeight: FontWeight.bold ),
                          overflow: TextOverflow.ellipsis, ),
                        Text(' Due Date : ${model.todateTask}', style:TextStyle(fontWeight: FontWeight.bold ),
                          overflow: TextOverflow.ellipsis,),
                        model.taskParent != '' ?
                        Text('Parent Task : ${model.taskParent}' , style:
                        TextStyle(fontWeight: FontWeight.bold ),
                          overflow: TextOverflow.ellipsis,)
                            : Text('')
                        /* Text('Sub Task : ---' , style:
                        TextStyle(fontWeight: FontWeight.bold ),
                          overflow: TextOverflow.ellipsis,)*/




                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                          onTap: (){

                            showDialog(
                                context: context,
                                builder: (context)=>
                                    SimpleDialog(title: Text('Task '),
                                      children: [
                                        SimpleDialogOption(onPressed: () {
                                          print('Add SubTask');
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddSubTaskScreen(model)));
                                        }, child: Row(
                                          children: [
                                            Icon(Icons.note_add),
                                            SizedBox(width: 5,),
                                            Text('Add SubTask'),
                                          ],
                                        ),),
                                        SimpleDialogOption(onPressed: () {
                                          print('edit');
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> EditTaskScreen(model)));
                                        }, child: Row(
                                          children: [
                                            Icon(Icons.edit),
                                            SizedBox(width: 5,),
                                            Text('Edit'),
                                          ],
                                        ),),
                                        SimpleDialogOption(onPressed: () {
                                          print('delete');
                                          cubit.deleteTask(model);
                                          Navigator.pop(context);

                                        }, child: Row(
                                          children: [
                                            Icon(Icons.delete),
                                            SizedBox(width: 5,),

                                            Text('delete'),
                                          ],
                                        ),),
                                      ],
                                    ));

                          } ,
                          child: Icon (Icons.more_vert)),

                      InkWell(
                          onTap: (){
                            print('done');
                            /*  if(model.haveChild == true)
                            {
                              cubit.checkDoneTask(model);

                            }
                          else if(model.taskParent != '' &&  model.parentTaskId !='')
                            {
                              cubit.checkDonSubTask(model);
                            }
                          else if(model.taskParent == '' &&  model.parentTaskId =='')
                            {
                              cubit.checkDoneTask(model);

                            }*/

                            cubit.checkDoneTask(model);
                          },
                          child:
                          model.status == status.complete.name ?
                          Icon(Icons.check_circle , color: Colors.green,) :
                          Icon(Icons.check_circle_outline)
                      ),
                    ],
                  )
                ],
              ),
            ),
          ) ,
          Container(width: 5,height: 60,
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(5)
            ),),

        ],
      ): SizedBox(height: 1,)
    //  Text('delete'),
  ) ;

  Widget subtaskItem(TaskModel submodel , ToDoAppCubit cubit ,context )=>  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child:
      submodel.status != status.remove.name ?
      Stack(
        alignment: AlignmentDirectional.centerStart,
        children:
        [
          Container(
            height: 130,
            decoration: BoxDecoration(
                color:  Colors.brown[50]  ,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0 , vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text('${submodel.taskName }',
                          style:TextStyle(fontWeight: FontWeight.bold , fontSize: 18),
                          overflow: TextOverflow.ellipsis,),


                        Text('Task Description : \n   ${submodel.taskDes}.',
                          style:TextStyle(fontWeight: FontWeight.bold ),
                          overflow: TextOverflow.ellipsis, ),
                        Text(' Due Date : ${submodel.todateTask}', style:TextStyle(fontWeight: FontWeight.bold ),
                          overflow: TextOverflow.ellipsis,),

                        Text('Parent Task : ${submodel.taskParent}' , style:
                        TextStyle(fontWeight: FontWeight.bold ),
                          overflow: TextOverflow.ellipsis,)






                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                          onTap: (){

                            showDialog(
                                context: context,
                                builder: (context)=>
                                    SimpleDialog(title: Text('Task '),
                                      children: [
                                        /*   SimpleDialogOption(onPressed: () {
                                          print('Add SubTask');
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddSubTaskScreen(submodel)));
                                        }, child: Row(
                                          children: [
                                            Icon(Icons.note_add),
                                            SizedBox(width: 5,),
                                            Text('Add SubTask'),
                                          ],
                                        ),),*/
                                        SimpleDialogOption(onPressed: () {
                                          print('edit');
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> EditTaskScreen(submodel)));
                                        }, child: Row(
                                          children: [
                                            Icon(Icons.edit),
                                            SizedBox(width: 5,),
                                            Text('Edit'),
                                          ],
                                        ),),
                                        SimpleDialogOption(onPressed: () {
                                          print('delete');
                                          cubit.deleteSubTask(submodel);
                                          Navigator.pop(context);

                                        }, child: Row(
                                          children: [
                                            Icon(Icons.delete),
                                            SizedBox(width: 5,),

                                            Text('delete'),
                                          ],
                                        ),),
                                      ],
                                    ));

                          } ,
                          child: Icon (Icons.more_vert)),

                      InkWell(
                          onTap: (){
                            print('done');

                            cubit.checkDonSubTask(submodel);

                          },
                          child:
                          submodel.status == status.complete.name ?
                          Icon(Icons.check_circle , color: Colors.green,) :
                          Icon(Icons.check_circle_outline)
                      ),
                    ],
                  )
                ],
              ),
            ),
          ) ,
          Container(width: 5,height: 60,
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(5)
            ),),

        ],
      ): SizedBox(height: 5,)
    //  Text('delete'),
  ) ;
}



/*
 ListView(
                   scrollDirection: Axis.horizontal,
                   children: [
                     Container(
                       child: DatePicker(
                         DateTime.now(),
                         width: 60,
                         height: 80,
                         controller: _controller,
                         initialSelectedDate: DateTime.now(),
                         selectionColor: Colors.black,
                         selectedTextColor: Colors.white,
                         inactiveDates: [
                           DateTime.now().add(Duration(days: 3)),
                           DateTime.now().add(Duration(days: 4)),
                           DateTime.now().add(Duration(days: 7))
                         ],
                         onDateChange: (date) {

                         },
                       ), ),
                   ],
                 ),
* */