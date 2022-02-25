import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/data/local/cashHelper.dart';
import 'package:todolist/model/taskModel.dart';
import 'package:todolist/model/userModel.dart';
import 'package:todolist/module/my-task/my-tasks.dart';
import 'package:todolist/module/new-task/new-task.dart';
import 'package:todolist/module/profile/profile.dart';
import 'package:todolist/share/constant.dart';

import 'ToDOAppStates.dart';
import 'package:intl/intl.dart';




class ToDoAppCubit extends Cubit<ToDoAppStates> {
  ToDoAppCubit() :super (ToDoAppInitializeState());

  static ToDoAppCubit get(context) => BlocProvider.of(context);

  UserModel? model;


  void getUserData() {
    emit(ToDoAppLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      model = UserModel.FromJson(value.data()!);

      emit(AppGetUserSuccessfulState());
    }).catchError((e) {
      print('error in get user ${e.toString()}');
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


  }) {
    emit(CreateNewTaskLoadingState());
    TaskModel taskModel = TaskModel(
        uid:uId,
        taskName:taskname,
        todateTask:totime,
        fromdateTask:fromtime,
        taskDes:desc,
        taskParent: '',
        status: status.oncreate.name,
        parentTaskId:'',
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

int numofTasks =0 ;
  void getAllTasks() {
    emit(GetAllTasksLoadingState());
    if(! alltasks.isEmpty)
      alltasks = [];

    FirebaseFirestore.instance.collection('tasks').where('uid' , isEqualTo: uId).snapshots().listen((value) {
      alltasks = [];

      value.docs.forEach((element){
        alltasks.add(TaskModel.fromJson(element.data()));
        numofTasks ++ ;

      });

      alltasks.forEach((element) {
       // print('@@ ${element.taskId}');

      });
      emit(GetAllTasksSuccessfulState());

    });

  }




  checkDoneTask(TaskModel model) {

    print('model ${model.taskId}');

    if (model.status == 'oncreate') {
      FirebaseFirestore.instance.collection('tasks').doc(model.taskId)
          .update({'status':status.complete.name }).then((value) {
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

        emit(UpDateCompleteTaskSuccessfulState());
      }).
      catchError((e) {
        print('error ${e.toString()}');
        emit(UpDateCompleteTaskErrorState());
      });

    }

  }




  editTask({
    @required String? taskId,
    @required String? taskname,
    @required String? totime,
    @required String? fromtime,
    @required String? taskDescription,
    @required String? parentTaskId ,
    @required String? status

  }) {
    emit(EditTaskLoadingState());
    TaskModel taskEditModel = TaskModel(
      uid: uId,
      taskName: taskname,
      todateTask: totime,
      fromdateTask: fromtime,
      taskDes: taskDescription,
      taskParent: '',
      status: status ,
      parentTaskId: parentTaskId ?? '' ,


    );


    FirebaseFirestore.instance.collection('tasks').doc(taskId).update(taskEditModel.toJson()).
    then((value) {
      emit(EditTaskSuccessfulState());
    }).
    catchError((e) {
      print('error in edit ${e.toString()}');
      emit(EditTaskErrorState());
    });
  }


  deleteTask(TaskModel model) {
    FirebaseFirestore.instance.collection('tasks').
    doc(model.taskId).update({'status': status.remove.name}).
    then((value) {
      emit(DeleteTaskSuccessfulState());
    }).
    catchError((e) {
      print('Error in delete ${e.toString()}');
      emit(DeleteTaskErrorState());
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

    FirebaseFirestore.instance.collection('subTasks').add(subtaskModel.toJson()).
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

      FirebaseFirestore.instance.collection('subTasks').
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



  checkDonSubTask(TaskModel model)
  {

    if (model.status == 'oncreate') {
      FirebaseFirestore.instance.collection('subTasks').
      doc(model.taskId)
          .update({'status': status.complete.name}).then((value) {
        emit(UpDateCompleteSubTaskSuccessfulState());
      }).
      catchError((e) {
        print('error ${e.toString()}');
        emit(UpDateCompleteSubTaskErrorState());
      });
    }

    else if (model.status == 'complete') {
      FirebaseFirestore.instance.
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


  int numofsubTasks =0 ;
  void getSubTasks() {
    emit(GetSubTasksLoadingState());
    if(! subtasks.isEmpty)
      subtasks = [];

    FirebaseFirestore.instance.collection('subTasks').where('uid' , isEqualTo: uId ).snapshots().listen((value) {
      subtasks = [];

      value.docs.forEach((element){
        subtasks.add(TaskModel.fromJson(element.data()));
        numofsubTasks ++ ;

      });

      subtasks.forEach((element) {
      //  print('## ${element.taskId}');

      });
      emit(GetSubTasksSuccessfulState());

    });

  }


  deleteSubTask(TaskModel model) {
    FirebaseFirestore.instance.collection('subTasks').
    doc(model.taskId).update({'status': status.remove.name}).
    then((value) {
      emit(DeleteSubTaskSuccessfulState());
    }).
    catchError((e) {
      print('Error in delete ${e.toString()}');
      emit(DeleteSubTaskErrorState());
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
    @required String? status ,

  }) {
    emit(EditSubTaskLoadingState());
    TaskModel subtaskEditModel = TaskModel(
      uid: uId,
      taskName: taskname,
      todateTask: totime,
      fromdateTask: fromtime,
      taskDes: taskDescription,
      taskParent: parentTask ,
      parentTaskId:parentId ,
      status: status ,

    );

    FirebaseFirestore.instance.collection('subTasks').
    doc(taskId).update(subtaskEditModel.toJson()).
    then((value) {
      emit(EditSubTaskSuccessfulState());
    }).
    catchError((e) {
      print('error in edit ${e.toString()}');
      emit(EditSubTaskErrorState());
    });
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }




  List<TaskModel> AllTASKS =[];
  filterationFunc( DateTime dt)
  {
    emit(FilterTaskLoadingState());
   // AllTASKS = [] ;

    if(! AllTASKS.isEmpty)
      AllTASKS = [];

    FirebaseFirestore.instance.collection('tasks').
    where('uid' , isEqualTo: uId ).snapshots().listen((value) {
      AllTASKS= [];

      value.docs.forEach((element){
        if(TaskModel.fromJson(element.data()).todateTask == DateFormat('yy-MM-dd').format(dt))
          {
            AllTASKS.add(TaskModel.fromJson(element.data()));
          }


      });

       emit(FilterTaskSuccessfulState());
        });
    }

}



