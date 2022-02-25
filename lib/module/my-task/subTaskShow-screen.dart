import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/layout/to-do-cubit/ToDOAppStates.dart';
import 'package:todolist/layout/to-do-cubit/ToDoAppCubit.dart';
import 'package:todolist/model/taskModel.dart';
import 'package:todolist/module/subTask/edit-subTask.dart';

import 'package:todolist/share/constant.dart';


class ShowSubTaskScreen extends StatelessWidget {
  String? taskId ;
  List<TaskModel> STasks =[] ;
   ShowSubTaskScreen({Key? key , this.taskId} ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('taskId : $taskId');


    ToDoAppCubit cubit = ToDoAppCubit.get(context);


    return BlocConsumer<ToDoAppCubit,ToDoAppStates>(
    listener:(context ,state){} ,
    builder: (context ,state){
     STasks =[] ;
     cubit.subtasks.forEach((element) {
      if(element.parentTaskId == taskId )
        {
          STasks.add(element);
        }
    });

    return Scaffold(
    appBar: AppBar(
    leading: InkWell(
    child: Icon(Icons.arrow_back_ios),
    onTap: (){
    Navigator.pop(context);
    },),
    title: Text('All Sub Tasks'),
    ),


    body:
    SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child:
    Column(
    children: [
    SingleChildScrollView(
    child: Column(
    children: [

    ConditionalBuilder(
    condition: cubit.subtasks.length >= 0   ,
    builder: (context)=> Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0 ,horizontal: 8),
    child: Column(
    children: [

      STasks.length !=0 ?
    ListView.separated(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (context , index) {
     return subtaskItem( STasks[index] , ToDoAppCubit.get(context) ,context );

    },
    itemCount: STasks.length,
    separatorBuilder: (context ,index)=>
    STasks[index].status != status.remove.name ?
    SizedBox(height: 20,) : SizedBox(height: 1,) ,
    ) :
      Padding(
        padding: const EdgeInsets.only(top: 200),
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note_outlined , size: 45,color: Colors.deepPurple,),
            SizedBox(height: 10,),
            Text('No Sub Tasks Yet, Please Add New Sub Task'),
          ],
        )),
      )
      ,
    ],
    ),
    ) ,
    fallback: (context)=>
    Padding(
    padding: const EdgeInsets.all(30.0),
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

                                        SimpleDialogOption(onPressed: () {
                                          print('edit');
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> EditSubTaskScreen(submodel)));
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
