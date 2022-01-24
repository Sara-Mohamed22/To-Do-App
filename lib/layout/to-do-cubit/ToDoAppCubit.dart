import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/model/taskModel.dart';
import 'package:todolist/model/userModel.dart';
import 'package:todolist/module/my-task/my-tasks.dart';
import 'package:todolist/module/new-task/new-task.dart';
import 'package:todolist/module/profile/profile.dart';
import 'package:todolist/share/constant.dart';

import 'ToDOAppStates.dart';






class ToDoAppCubit extends Cubit<ToDoAppStates> {
  ToDoAppCubit() :super (ToDoAppInitializeState());

  static ToDoAppCubit get(context) => BlocProvider.of(context);

  UserModel? model;

  void getUserData() {

    emit(ToDoAppLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      model = UserModel.FromJson(value.data()!);

      emit(AppGetUserSuccessfulState());

    }).catchError((e){
      emit(AppGetUserErrorState(e.toString()));
    });


  }

  int currentIndex = 0;
  List<Widget> screens = [
    MyTasksScreen(),
    NewTaskScreen(),
    ProfileScreen(),
  ];

  List<String> titles = ['My Tasks', 'New Task', 'Profile'];

  void changeBottomNav(int index) {
    if (index == 1) {
      emit(NewTaskState());
    }
    else {

      currentIndex = index;
    }

    emit(ChangeBottomNavigatorState());
  }

  void createNewTask({
    @required String? taskname,
    @required String? totime,
    @required String? fromtime,
    @required String? desc,
    String? parentTask,


  }) {
    emit(CreateNewTaskLoadingState());
    TaskModel taskModel = TaskModel(
        uid:uId,
        taskName:taskname,
        todateTask:totime,
        fromdateTask:fromtime,
        taskDes:desc,
        taskParent: parentTask ?? '',
        status: status.oncreate.name,
        parentTaskId: ''
    );

    FirebaseFirestore.instance.collection('tasks').add(taskModel.toJson()).
    then((value) {
      final taskId = taskModel.toJson();
      taskId['taskId'] = value.id;

      FirebaseFirestore.instance.collection('tasks').doc(value.id).set(taskId).
      then((value) {
        print('create taskId Successfully ');
      }).catchError((e) {
        print('error in create taskId ${e.toString()}');
      });

      emit(CreateNewTaskSuccessfulState());
    }).
    catchError((e) {
      emit(CreateNewTasErrorState(e.toString()));
    });
  }

  List<TaskModel> alltasks = [];
  List<TaskModel> subtasks =[];



  void getAllTasks() {
    emit(GetAllTasksLoadingState());
    if(! alltasks.isEmpty)
      alltasks = [];
    FirebaseFirestore.instance.collection('tasks').where('uid' , isEqualTo: uId).snapshots().listen((value) {
      alltasks = [];

      value.docs.forEach((element){
        alltasks.add(TaskModel.fromJson(element.data()));

      });

      alltasks.forEach((element) {
        print('@@ ${element.taskId}');

      });
      emit(GetAllTasksSuccessfulState());

    });

  }


  void gatAllSubTasks() {
    emit(GetSubTasksLoadingState());


    FirebaseFirestore.instance.collection('tasks').where('uid', isEqualTo: uId).get().then((value) {
      value.docs.forEach((element) {
        subtasks = [];

        element.reference.collection('subTasks').snapshots().
        listen((value) {
         // subtasks = [];

          value.docs.forEach((element) {

            // subtasks.removeWhere((selement) =>
            //   selement.taskId == TaskModel.fromJson(element.data()).taskId
            // );

            subtasks.add(TaskModel.fromJson(element.data()));

          });

        });

        subtasks.forEach((element) {
          print('## ${element.taskId}');


        });
        print('555 ${subtasks.length}');


      });
      print('finish');
      emit(GetSubTasksSuccessfulState());
    }).catchError((e){
      emit(GetSubTasksErrorState(e.toString()));
    });
  }


//////////////////////////////////////////////////////////////////////////////////////////////
  /*void getAllTasks() {
    emit(GetAllTasksLoadingState());
    if(! alltasks.isEmpty)
      alltasks = [];
    FirebaseFirestore.instance.collection('tasks').where('uid' , isEqualTo: uId).snapshots().listen((value) {
      alltasks = [];

      value.docs.forEach((element) {
          alltasks.add(TaskModel.fromJson(element.data()));

        //  subtasks = [] ;
          element.reference.collection('subTasks').snapshots().
          listen((value) {
            // if(!subtasks.isEmpty)
             subtasks=[];
            value.docs.forEach((element) {

                subtasks.add(TaskModel.fromJson(element.data()));

              emit(GetSubTasksSuccessfulState());
            });

             subtasks.forEach((element) {
               print('## ${element.taskId}');
             });
          });


      });

      alltasks.forEach((element) {
        print('@@ ${element.taskId}');
      });
      emit(GetAllTasksSuccessfulState());

    });

  }*/
  /////////////////////////////////////////////////////////////////////////////



  /*checkDoneTask(TaskModel model) {
    print('state ${model.taskId}');

    if (model.status == 'oncreate') {
      FirebaseFirestore.instance.collection('tasks').
      doc(model.taskId).update({'status': status.complete.name}).
      then((value) {
        emit(UpDateCompleteTaskSuccessfulState());
      }).
      catchError((e) {
        print('Error in check ${e.toString()}');
        emit(UpDateCompleteTaskErrorState());
      });
    }

    else {
      FirebaseFirestore.instance.collection('tasks').
      doc(model.taskId).update({'status': status.oncreate.name}).
      then((value) {
        emit(UpDateCompleteTaskSuccessfulState());
      }).
      catchError((e) {
        print('Error in check ${e.toString()}');
        emit(UpDateCompleteTaskErrorState());
      });
    }
  }*/

  checkDoneTask(TaskModel model) {

    print('model ${model.taskId}');

    if (model.status == 'oncreate') {
      FirebaseFirestore.instance.collection('tasks').doc(model.taskId)
          .update({'status':status.complete.name }).then((value) {
        //    getAllTasks() ;
        emit(UpDateCompleteTaskSuccessfulState());
      }).
      catchError((e) {
        print('error ${e.toString()}');
        emit(UpDateCompleteTaskErrorState());
      });
    }

    else if (model.status == 'complete') {
      FirebaseFirestore.instance.collection('tasks').
      doc(model.taskId)
          .update({'status':status.oncreate.name}).then((value) {
        //  getAllTasks() ;

        emit(UpDateCompleteTaskSuccessfulState());
      }).
      catchError((e) {
        print('error ${e.toString()}');
        emit(UpDateCompleteTaskErrorState());
      });

    }

  }


  checkDonSubTask(TaskModel model)
  {

    //  subtasks.removeWhere((element) =>element.taskId == model.taskId );


    if (model.status == 'oncreate') {
      FirebaseFirestore.instance.collection('tasks').doc(model.parentTaskId).collection('subTasks').
      doc(model.taskId)
          .update({'status': status.complete.name}).then((value) {
        // subtasks.removeWhere((element) =>element.taskId == model.taskId );
        emit(UpDateCompleteSubTaskSuccessfulState());
      }).
      catchError((e) {
        print('error ${e.toString()}');
        emit(UpDateCompleteSubTaskErrorState());
      });
    }

    else if (model.status == 'complete') {
      FirebaseFirestore.instance.collection('tasks').
      doc(model.parentTaskId).
      collection('subTasks').doc(model.taskId)
          .update({'status': status.oncreate.name}).then((value) {
        emit(UpDateCompleteSubTaskSuccessfulState());
      }).
      catchError((e) {
        print('error ${e.toString()}');
        emit(UpDateCompleteSubTaskErrorState());
      });
    }
  }



  editTask({
    @required String? taskId,
    @required String? taskname,
    @required String? totime,
    @required String? fromtime,
    @required String? taskDescription,
    String? parentTask,

  }) {
    emit(EditTaskLoadingState());
    TaskModel taskEditModel = TaskModel(
      uid: uId,
      taskName: taskname,
      todateTask: totime,
      fromdateTask: fromtime,
      taskDes: taskDescription,
      taskParent: parentTask ?? '',
      status: 'oncreate',

    );
    var updateTaskModel = taskEditModel.toJson();

    updateTaskModel ['taskId'] = taskId;
    print('taskId ${taskId}');
    FirebaseFirestore.instance.collection('tasks').doc(taskId).update(updateTaskModel).
    then((value) {
      //  getAllTasks();
      emit(EditTaskSuccessfulState());
    }).
    catchError((e) {
      print('error in edit ${e.toString()}');
      emit(EditTaskErrorState());
    });
  }

  editSubTask({
    @required String? taskId,
    @required String? taskname,
    @required String? totime,
    @required String? fromtime,
    @required String? taskDescription,
    @required String? parentTask,
    @required String? parentId ,

  }) {
    emit(EditSubTaskLoadingState());
    TaskModel taskEditModel = TaskModel(
      uid: uId,
      taskName: taskname,
      todateTask: totime,
      fromdateTask: fromtime,
      taskDes: taskDescription,
      taskParent: parentTask ,
      parentTaskId:parentId ,
      status: 'oncreate',

    );
    var updateTaskModel = taskEditModel.toJson();
    updateTaskModel ['taskId'] = taskId;
    print('taskId ${taskId}');
    FirebaseFirestore.instance.collection('tasks').doc(parentId).collection('subTasks').
    doc(taskId).update(updateTaskModel).
    then((value) {
      // gatAllSubTasks();

      emit(EditSubTaskSuccessfulState());
    }).
    catchError((e) {
      print('error in edit ${e.toString()}');
      emit(EditSubTaskErrorState());
    });
  }

  deleteTask(TaskModel model) {
    FirebaseFirestore.instance.collection('tasks').
    doc(model.taskId).update({'status': status.remove.name}).
    then((value) {
      // getAllTasks();
      emit(DeleteTaskSuccessfulState());
    }).
    catchError((e) {
      print('Error in delete ${e.toString()}');
      emit(DeleteTaskErrorState());
    });
  }

  deleteSubTask(TaskModel model) {
    FirebaseFirestore.instance.collection('tasks').doc(model.parentTaskId).collection('subTasks').
    doc(model.taskId).update({'status': status.remove.name}).
    then((value) {
      //    gatAllSubTasks();
      emit(DeleteSubTaskSuccessfulState());
    }).
    catchError((e) {
      print('Error in delete ${e.toString()}');
      emit(DeleteSubTaskErrorState());
    });
  }

  createSubTask({
    @required String? taskname,
    @required String? totime,
    @required String? fromtime,
    @required String? desc,
    @required String? parentTask,
    @required String? taskid,

  }) {
    emit(AddSubTaskLoadingState());

    TaskModel subtaskModel = TaskModel(
        uid: uId,
        taskName: taskname,
        todateTask: totime,
        fromdateTask: fromtime,
        taskDes: desc,
        taskParent: parentTask,
        status: status.oncreate.name,
        parentTaskId: taskid
    );

    FirebaseFirestore.instance.collection('tasks').
    doc(taskid).collection('subTasks').add(subtaskModel.toJson()).
    then((value) {
      final subtaskId = subtaskModel.toJson();
      subtaskId['taskId'] = value.id;
      //  subtaskId['parentTaskId'] = taskid ;

      FirebaseFirestore.instance.collection('tasks').
      doc(taskid).update({'haveChild':true}).then((value) {
        print('doneeee');
      }).catchError((e){
        print('error in child ${e.toString()}');
      });

      FirebaseFirestore.instance.collection('tasks').
      doc(taskid).collection('subTasks').
      doc(value.id).set(subtaskId).
      then((value) {
        print('create taskId Successfully ');
      }).catchError((e) {
        print('error in create taskId ${e.toString()}');
      });
      //  gatAllSubTasks();
      emit(AddSubTaskSuccessfulState());
    }).
    catchError((e) {
      emit(AddSubTasErrorState(e.toString()));
    });
  }






}
