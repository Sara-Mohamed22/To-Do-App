
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/layout/to-do-cubit/ToDOAppStates.dart';
import 'package:todolist/layout/to-do-cubit/ToDoAppCubit.dart';
import 'package:todolist/module/new-task/new-task.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ToDoAppCubit cubit = ToDoAppCubit.get(context) ;

    cubit.getUserData();
   // cubit.getSubTasks();
   // cubit.getAllTasks();

    return BlocConsumer<ToDoAppCubit ,ToDoAppStates >(
      listener:(context , state){
        if(state is NewTaskState)
          {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>NewTaskScreen()));
          }

      } ,

      builder: (context , state){
        return Scaffold(
          appBar: AppBar(title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${cubit.titles[cubit.currentIndex]}'),
          ),
            automaticallyImplyLeading: false,

          ),

          body: ToDoAppCubit.get(context).screens[ToDoAppCubit.get(context).currentIndex],

          bottomNavigationBar: BottomNavigationBar(
              currentIndex: ToDoAppCubit.get(context).currentIndex ,
              onTap: (index)
              {
                ToDoAppCubit.get(context).changeBottomNav(index);
              },

              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu , size: 30) , label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.add_circle , size: 60,) , label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.person , size: 30) , label: ''),
              ]

          ),
        );
      },
    );
  }
}
