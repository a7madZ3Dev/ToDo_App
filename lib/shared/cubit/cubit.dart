import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/components/constants.dart';

import '../cubit/states.dart';
import '../helpers/data_helper.dart';
import '../../modules/tasks/tasks.dart';
import '../../modules/done_tasks/done_tasks.dart';
import '../../modules/archive_tasks/archive_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);

  final List<Map<String, Object>> pages = [
    {
      'page': Tasks(),
      'title': 'New Tasks',
    },
    {
      'page': DoneTasks(),
      'title': 'Done Tasks',
    },
    {
      'page': ArchiveTasks(),
      'title': 'Archive Tasks',
    },
  ];

  int selectedPageIndex = 0;

  bool isBottomSheetShown = false;
  List<Map<String, Object>> newTasks = [];
  List<Map<String, Object>> doneTasks = [];
  List<Map<String, Object>> archivedTasks = [];

  /// change number for pages
  void changeIndex(int index) {
    selectedPageIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  /// change state for floatingActionButton
  void changeFloatingActionButtonState(bool state) {
    isBottomSheetShown = state;
    emit(AppChangeFloatingActionButtonState());
  }

  /// operation (get) in the dataBase
  void getFromDataBase() {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    DBHelper().getTasks().then((value) {
      value.forEach((element) {
        if (element['status'] == '$kStatusNew')
          newTasks.add(element as Map<String, Object>);
        else if (element['status'] == '$kStatusDone')
          doneTasks.add(element as Map<String, Object>);
        else
          archivedTasks.add(element as Map<String, Object>);
      });

      emit(AppGetDatabaseState());
    });
  }

  /// operation (add) in the dataBase
  void addTask({required Map<String, Object> map}) {
    DBHelper().insertTasks(map).then((value) {
      print('inserted successfully');
      emit(AppInsertDatabaseState());
      getFromDataBase();
    }).catchError((error) {
      print('Error When Inserting New Record ${error.toString()}');
    });
  }

  /// operation (delete) in the dataBase
  void deleteTask(int id) {
    DBHelper().deleteTasks(id).then((value) {
      print('deleted done with successfully');
      getFromDataBase();
      emit(AppDeleteDatabaseState());
    });
  }

  /// operation (update) in the dataBase
  void updateTask({required Map<String, Object> map, required String status}) {
    Map<String, Object> updateMap = {
      '$kIdColumn': map['$kIdColumn']!,
      '$kTitleColumn': map['$kTitleColumn']!,
      '$kDateColumn': map['$kDateColumn']!,
      '$kTimeColumn': map['$kTimeColumn']!,
      '$kStatusColumn': status
    };
    DBHelper().updateTasks(updateMap).then((value) {
      print('update done successfully');
      emit(AppUpdateDatabaseState());
      getFromDataBase();
    }).catchError((error) {
      print('Error When Inserting New Record ${error.toString()}');
    });
  }
}
