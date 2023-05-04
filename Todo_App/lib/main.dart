import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/Bloc_Observer.dart';
import 'package:todo_app/todo_layout/todo_layout.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home_Layout(),
      debugShowCheckedModeBanner: false,
    );
  }
}



