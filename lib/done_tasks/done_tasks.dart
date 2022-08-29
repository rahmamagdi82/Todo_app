import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class DoneTasks extends StatefulWidget
{
  @override
  State<DoneTasks> createState() => _DoneTasksState();
}

class _DoneTasksState extends State<DoneTasks> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit,ToDoStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        return taskList(ToDoCubit.getB(context).doneTasks);
      },
    );
  }
}