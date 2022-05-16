import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_bloc/scr/home/bloc/todo_bloc.dart';
import 'package:todo_list_bloc/scr/home/home_view.dart';
import 'package:todo_list_bloc/scr/service/persistence_repository.dart';

class MyApp extends StatelessWidget {
  final prefs = DataPersistenceService();

  MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoListBloc>(
      create: (_) => TodoListBloc(prefs),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {HomeView.routeName: (context) => HomeView()},
        initialRoute: HomeView.routeName,
      ),
    );
  }
}
