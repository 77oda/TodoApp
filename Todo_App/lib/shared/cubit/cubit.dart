import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../modules/todo_app/archived tasks/archived_tasks.dart';
import '../../modules/todo_app/done tasks/done_tasks.dart';
import '../../modules/todo_app/new tasks/new_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  late Database database;
  int currentIndex = 0;
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  List<Widget> screens = [NewTasks(), DoneTasks(), ArchivedTasks()];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print('database created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('Error when creating table ${error.toString()}');
      });
    }, onOpen: (database) {
      getData(database);
      print('database opened');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }

   void insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getData(database);
      }).catchError((error) {
        print('Error when inserting new record ${error.toString()}');
      });
    });
  }

  void getData(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
        emit(AppGetDatabaseState());
      });
    });
  }

  void updateData({required String status, required int id}) {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', ['$status', id]).then((value) {
      getData(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({ required int id}) {
    database.rawDelete(
        'DELETE FROM tasks  WHERE id = ?', [id]).then((value) {
      getData(database);
      emit(AppDeleteDatabaseState());
    });
  }

  // bool isDark = false;
  // void changeAppMode({bool? fromShared})
  // {
  //   if (fromShared != null)
  //   {
  //      isDark = fromShared;
  //     emit(AppChangeModeState());
  //   } else
  //   {
  //      isDark = !isDark;
  //     CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
  //       emit(AppChangeModeState());
  //     });
  //   }
  // }
}


