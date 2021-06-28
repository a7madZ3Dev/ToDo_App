import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder/conditional_builder.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/components/constants.dart';
import '../../shared/components/components.dart';

class Tasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
            condition: appCubit.newTasks.length > 0,
            fallback: (context) => NoTasks(),
            builder: (context) => Container(
              child: ListView.separated(
                itemCount: appCubit.newTasks.length,
                itemBuilder: (context, index) => SingleTaskItem(
                  id: appCubit.newTasks[index]['id'],
                  time: appCubit.newTasks[index]['time'],
                  title: appCubit.newTasks[index]['title'],
                  date: appCubit.newTasks[index]['date'],
                  doneFunction: () => appCubit.updateTask(
                      map: appCubit.newTasks[index], status: kStatusDone),
                  archiveFunction: () => appCubit.updateTask(
                      map: appCubit.newTasks[index], status: kStatusArchive),
                  deleteFunction: () =>
                      appCubit.deleteTask(appCubit.newTasks[index]['id']),
                ),
                separatorBuilder: (context, index) => Container(
                  height: 1.0,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
              ),
            ),
          );
        });
  }
}
