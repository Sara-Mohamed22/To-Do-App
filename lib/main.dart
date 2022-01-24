


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/share/constant.dart';

import 'data/local/cashHelper.dart';
import 'layout/home.dart';
import 'layout/to-do-cubit/ToDoAppCubit.dart';
import 'module/login/login.dart';
import 'observer.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();


  await CashHelper.init();

  uId = CashHelper.getData(key: 'uId');
  print('uid $uId');

  Widget? Start ;

  if(uId != null)
  {
    Start = HomeScreen();
  }

  else
  {

    Start = LoginScreen();
  }


  runApp( MyApp(start: Start , ));
}


class MyApp extends StatelessWidget {

  final Widget? start ;

  MyApp({@required this.start});


  @override
  Widget build(BuildContext context) {

    return KeyedSubtree(
      child:MultiBlocProvider(
        providers: [
          BlocProvider(create: (context)=> ToDoAppCubit()..getUserData()..getSubTasks()..getAllTasks()
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home:
          //SplashScreen() ,
            start,
          theme:  ThemeData(

            primarySwatch: Colors.deepPurple,
              appBarTheme: AppBarTheme(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                titleTextStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 21
                ),
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Colors.black,

                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                unselectedItemColor: Colors.grey,
                //selectedItemColor: Colors.deepPurple ,

              )



          ),
        ),
      ) ,
    );
    /* return  MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=> ToDoAppCubit()..getUserData()..gatAllSubTasks()..getAllTasks()
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          home:
          //SplashScreen() ,
         widget.start,
        theme:  ThemeData(

            appBarTheme: AppBarTheme(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                titleTextStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontSize: 21
                ),
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Colors.black,

                ),
            ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            //selectedItemColor: Colors.deepPurple ,

          )



        ),
        ),
    );*/

  }
}

