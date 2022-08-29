import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/cubit/cubit.dart';
import '../shared/components/components.dart';
import '../shared/cubit/states.dart';

class ArchiveTasks extends StatefulWidget
{
  @override
  State<ArchiveTasks> createState() => _ArchiveTasksState();
}

class _ArchiveTasksState extends State<ArchiveTasks> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit,ToDoStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        return taskList(ToDoCubit.getB(context).archiveTasks);
      },

    );
  }
}