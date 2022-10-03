import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import '../shared/components/constants.dart';
import '../shared/components/components.dart';

class Home extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  /// when submit button
  void submitFunction(BuildContext context) {
    if (formKey.currentState!.validate()) {
      AppCubit.get(context).addTask(map: {
        '$kTitleColumn': titleController.text,
        '$kTimeColumn': timeController.text,
        '$kDateColumn': dateController.text,
        '$kStatusColumn': '$kStatusNew'
      });
      AppCubit.get(context).changeFloatingActionButtonState(false);
      Navigator.of(context).pop();
      timeController.clear();
      dateController.clear();
      titleController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The Task Was Added With Success',
              textAlign: TextAlign.center),
          backgroundColor: Colors.green[300],
        ),
      );
    }
  }

  /// create form fields for input information
  void _addTask(BuildContext context) {
    scaffoldKey.currentState!
        .showBottomSheet(
          (context) => // handle back button
              WillPopScope(
            onWillPop: () async {
              if (AppCubit.get(context).isBottomSheetShown) {
                AppCubit.get(context).changeFloatingActionButtonState(false);
                timeController.clear();
                dateController.clear();
                titleController.clear();
              }
              return true;
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                    topRight: Radius.circular(35.0)),
                color: Colors.white,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    defaultFormField(
                      controller: titleController,
                      type: TextInputType.text,
                      validate: (String? value) {
                        if (value!.trim().isEmpty) {
                          return 'title must not be empty';
                        }
                      },
                      textInputAction: TextInputAction.none,
                      label: 'Task Title',
                      prefix: Icons.title,
                      context: context,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    defaultFormField(
                      controller: dateController,
                      type: TextInputType.datetime,
                      validate: (String? value) {
                        if (value!.trim().isEmpty) {
                          return 'date must not be empty';
                        }
                      },
                      onTap: () async {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 90)),
                        ).then((value) {
                          if (value == null) {
                            return;
                          }
                          dateController.text =
                              DateFormat.yMMMd().format(value);
                        });
                      },
                      label: 'Task Date',
                      prefix: Icons.calendar_today,
                      showCursor: false,
                      readOnly: true,
                      context: context,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    defaultFormField(
                      controller: timeController,
                      type: TextInputType.datetime,
                      validate: (String? value) {
                        if (value!.trim().isEmpty) {
                          return 'time must not be empty';
                        }
                      },
                      // textInputAction: TextInputAction.done,
                      // onSubmit: (_) {
                      //   return submitFunction(context);
                      // },
                      onTap: () {
                        showTimePicker(
                                context: context, initialTime: TimeOfDay.now())
                            .then((value) {
                          if (value == null) {
                            return;
                          }
                          timeController.text = value.format(context);
                        });
                      },
                      label: 'Task Time',
                      prefix: Icons.watch_later_outlined,
                      showCursor: false,
                      readOnly: true,
                      context: context,
                    ),
                    SizedBox(height: 15.0),
                    defaultButton(
                      function: () {
                        submitFunction(context);
                      },
                      text: 'ADD',
                      background: Colors.amber[600],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
        .closed
        .then((value) {
      // when close bottom sheet by finger
      AppCubit.get(context).changeFloatingActionButtonState(false);
      timeController.clear();
      dateController.clear();
      titleController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (BuildContext context) => AppCubit()..getFromDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {},
          builder: (BuildContext context, AppStates state) {
            AppCubit appCubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(appCubit.pages[appCubit.selectedPageIndex]['title']
                    as String),
                automaticallyImplyLeading: false, // deleting back arrow
              ),
              body: ConditionalBuilder(
                condition: state is! AppGetDatabaseLoadingState,
                builder: (context) => appCubit.pages[appCubit.selectedPageIndex]
                    ['page'] as Widget,
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
              bottomNavigationBar: BottomNavigationBar(
                onTap: appCubit.changeIndex,
                backgroundColor: Theme.of(context).primaryColor,
                showUnselectedLabels: true,
                unselectedItemColor: Colors.white,
                selectedItemColor: Theme.of(context).colorScheme.secondary,
                currentIndex: appCubit.selectedPageIndex,
                type: BottomNavigationBarType.shifting,
                items: [
                  BottomNavigationBarItem(
                    backgroundColor: Theme.of(context).primaryColor,
                    icon: Icon(Icons.menu_rounded),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Theme.of(context).primaryColor,
                    icon: Icon(Icons.check_circle_outline_rounded),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Theme.of(context).primaryColor,
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archive',
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                    appCubit.isBottomSheetShown ? Icons.close : Icons.edit),
                onPressed: () {
                  if (appCubit.isBottomSheetShown) {
                    // when close bottom sheet by press floating Action Button
                    appCubit.changeFloatingActionButtonState(false);
                    Navigator.of(context).pop();
                    timeController.clear();
                    dateController.clear();
                    titleController.clear();
                  } else {
                    appCubit.changeFloatingActionButtonState(true);
                    _addTask(context);
                  }
                },
              ),
            );
          }),
    );
  }
}
