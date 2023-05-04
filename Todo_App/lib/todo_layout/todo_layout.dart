import 'dart:ffi';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';


import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../shared/components/component.dart';

class Home_Layout extends StatelessWidget
{



  var scaffoldKey= GlobalKey<ScaffoldState>();
  var formKey= GlobalKey<FormState>();
  var controller_task=TextEditingController();
  var controller_time=TextEditingController();
  var controller_date=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
         listener: (context,state) {
           if (state is AppInsertDatabaseState){
             Navigator.pop(context);
           }
         },
        builder: (context,state) {
           AppCubit cubit=AppCubit.get(context);
           return Scaffold(
             key: scaffoldKey,
             appBar: AppBar(
               title: Text(cubit.titles[cubit.currentIndex]),
             ),
             body: ConditionalBuilder(
               condition: state is! AppGetDatabaseLoadingState,
               fallback: (BuildContext context) => Center(child: const CircularProgressIndicator(),),
               builder: (BuildContext context) => cubit.screens[cubit.currentIndex],
             ),
             bottomNavigationBar: BottomNavigationBar(
               currentIndex: AppCubit.get(context).currentIndex,
               onTap: (index){
                 cubit.changeIndex(index);
               },
               items: const [
                 BottomNavigationBarItem(icon: Icon(Icons.menu),label: 'Tasks'),
                 BottomNavigationBarItem(icon: Icon(Icons.done_outline),label: 'Done'),
                 BottomNavigationBarItem(icon: Icon(Icons.archive_outlined),label: 'Archived'),
               ],

             ),
             floatingActionButton:  FloatingActionButton(
               onPressed: () {
                 if(cubit.isBottomSheetShown){
                   if(formKey.currentState!.validate()){
                     cubit.insertDatabase(title: controller_task.text, time: controller_time.text, date: controller_date.text);
                   }
                 } else{
                   scaffoldKey.currentState!.showBottomSheet(
                           (context) => Container(
                         color: Colors.white,
                         padding: const EdgeInsets.all(20),
                         child: Form(
                           key: formKey,
                           child: Column(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               defaultFormField(controller: controller_task,
                                   type: TextInputType.text,
                                   label: 'Task Title',
                                   prefix: Icons.title,
                                   validate: (value)
                                   {
                                     if(value.isEmpty){
                                       return 'title must not be empty';
                                     }
                                     return null;
                                   },
                                   onTap: (){
                                   }
                               ),
                               const SizedBox(
                                 height: 15,
                               ),
                               defaultFormField(
                                   controller: controller_time,
                                   type: TextInputType.datetime,
                                   label: 'Task Time',
                                   prefix: Icons.watch_later_outlined,
                                   validate: (value)
                                   {
                                     if(value.isEmpty){
                                       return 'time must not be empty';
                                     }
                                     return null;
                                   },
                                   onTap: (){
                                     showTimePicker(context: context,
                                       initialTime:TimeOfDay.now(),
                                     ).then((value) {
                                       controller_time.text=value!.format(context);
                                     });
                                   }
                               ),
                               const SizedBox(
                                 height: 15,
                               ),
                               defaultFormField(
                                   controller: controller_date,
                                   type: TextInputType.datetime,
                                   label: 'Task Date',
                                   prefix: Icons.calendar_today,
                                   validate: (value)
                                   {
                                     if(value.isEmpty){
                                       return 'date must not be empty';
                                     }
                                     return null;
                                   },
                                   onTap: (){
                                     showDatePicker(
                                       context: context,
                                       initialDate: DateTime.now() ,
                                       firstDate: DateTime.now(),
                                       lastDate: DateTime.parse('2022-09-09') ,
                                     ).then((value) {
                                       controller_date.text=DateFormat.yMMMd().format(value!);
                                     });
                                   }
                               )
                             ],
                           ),
                         ),
                       ),
                       elevation: 20.0
                   ).closed.then((value) {
                     cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                   });
                   cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                 }

               },
               child: Icon(cubit.fabIcon),

             ),

           );
        },
      ),
    );
  }
}
