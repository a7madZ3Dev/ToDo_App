import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder/conditional_builder.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/components/constants.dart';
import '../../shared/components/components.dart';

class DoneTasks extends StatelessWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
            condition: appCubit.doneTasks.length > 0,
            fallback: (context) => NoTasks(),
            builder: (context) => Container(
              child: ListView.separated(
                itemCount: appCubit.doneTasks.length,
                itemBuilder: (context, index) => SingleTaskItem(
                  id: appCubit.doneTasks[index]['id'] as int,
                  time: appCubit.doneTasks[index]['time'] as String,
                  title: appCubit.doneTasks[index]['title'] as String,
                  date: appCubit.doneTasks[index]['date'] as String,
                  archiveFunction: () => appCubit.updateTask(
                      map: appCubit.doneTasks[index], status: kStatusArchive),
                  deleteFunction: () => appCubit
                      .deleteTask(appCubit.doneTasks[index]['id'] as int),
                  isShowDone: false,
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
