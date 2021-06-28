import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder/conditional_builder.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/components/constants.dart';
import '../../shared/components/components.dart';

class ArchiveTasks extends StatelessWidget {
  const ArchiveTasks({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
            condition: appCubit.archivedTasks.length > 0,
            fallback: (context) => NoTasks(),
            builder: (context) => Container(
              child: ListView.separated(
                itemCount: appCubit.archivedTasks.length,
                itemBuilder: (context, index) => SingleTaskItem(
                  id: appCubit.archivedTasks[index]['id'],
                  time: appCubit.archivedTasks[index]['time'],
                  title: appCubit.archivedTasks[index]['title'],
                  date: appCubit.archivedTasks[index]['date'],
                  doneFunction: () => appCubit.updateTask(
                      map: appCubit.archivedTasks[index], status: kStatusDone),
                  deleteFunction: () =>
                      appCubit.deleteTask(appCubit.archivedTasks[index]['id']),
                  isShowArchive: false,
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
