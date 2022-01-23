import 'package:flutter/cupertino.dart';

class TaskModel
{
  String? taskName ;
  String? todateTask ;
  String? uid ;
  String? fromdateTask;
  String?  taskDes ;
  String? taskParent ;
  String? status ;
  String? parentTaskId ;
  String? taskId ;

  TaskModel({
  @required this.uid ,
    @required this.parentTaskId ,
    @required this.fromdateTask,
    @required this.taskParent ,
  @required this.status ,
  @required this.taskName ,
  @required this.taskDes ,
  @required this.todateTask});

  Map<String , dynamic> toJson()
  {
    return {

   'taskName' : taskName ,
   'todateTask' : todateTask ,
   'uid' : uid ,
   'fromdateTask' : fromdateTask,
   'taskDes'  : taskDes ,
   'taskParent' : taskParent ,
  'status'  : status ,
   'parentTaskId' : parentTaskId ,

    };



  }

  TaskModel.fromJson(Map<String , dynamic>json)
  {

     taskName= json['taskName'] ;
     todateTask= json['todateTask'] ;
     uid = json['uid'];
     fromdateTask = json['fromdateTask'];
      taskDes= json['taskDes'] ;
     taskParent= json['taskParent'] ;
     status = json['status'];
     parentTaskId= json['parentTaskId'] ;
     taskId = json['taskId'];



  }

}