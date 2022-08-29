import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../archive_tasks/archive_tasks.dart';
import '../done_tasks/done_tasks.dart';
import '../new_tasks/new_tasks.dart';
import '../shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {

  List<Widget> screen =
  [
    NewTasks(),
    DoneTasks(),
    ArchiveTasks(),
  ];
  List<String> titles =
  [
    'New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];



  var keyScaffold = GlobalKey<ScaffoldState>();
  var keyForm = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ToDoCubit()..createDataBase(),
      child: BlocConsumer<ToDoCubit, ToDoStates>(
        listener: ( context, state) {
          if(state is InsertState){
            Navigator.pop(context);
          }
        },
        builder: ( context,  state) =>
            Scaffold(
              key: keyScaffold,
              appBar: AppBar(
                title: Text(
                  titles[ToDoCubit.getB(context).currentIndex],
                ),
              ),
              body: (state is GetLoadingState)?const Center(
                child: CircularProgressIndicator(),
              ):screen[ToDoCubit.getB(context).currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: ToDoCubit.getB(context).currentIndex,
                onTap: (index) {
                  ToDoCubit.getB(context).changeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.menu,
                      ),
                      label: 'Tasks'
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.check_circle_outline,
                      ),
                      label: 'Done'
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.archive_outlined,
                      ),
                      label: 'Archive'
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (ToDoCubit.getB(context).show == true) {
                    if (keyForm.currentState!.validate()) {
                      ToDoCubit.getB(context).changeShow(false);
                      ToDoCubit.getB(context).insertDataBase(title: titleController.text,
                          date: dateController.text,
                          time: timeController.text);
                      timeController.text='';
                      titleController.text='';
                      dateController.text='';
                    }
                  } else {
                    keyScaffold.currentState?.showBottomSheet((context) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: keyForm,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defultTextFormFeild(
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'Task title must be not empty';
                                  } else {
                                    return null;
                                  }
                                },
                                control: titleController,
                                type: TextInputType.text,
                                lable: 'Task Title',
                                prefix: Icons.title,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              defultTextFormFeild(
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Task date must be not empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  control: dateController,
                                  type: TextInputType.datetime,
                                  lable: 'Task Date',
                                  prefix: Icons.calendar_month,
                                  tap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2023),
                                    ).then((value) {
                                      dateController.text = DateFormat.yMMMd().format(value!);
                                      print(dateController.text);
                                    });
                                  }
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              defultTextFormFeild(
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'Task time must be not empty';
                                  } else {
                                    return null;
                                  }
                                },
                                control: timeController,
                                type: TextInputType.datetime,
                                lable: 'Task Time',
                                prefix: Icons.watch_later,
                                tap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text = value!.format(context);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                      elevation: 20.0,
                    ).closed.then((value) {
                      ToDoCubit.getB(context).changeShow(false);
                    });
                    ToDoCubit.getB(context).changeShow(true);
                  }
                },
                child: (ToDoCubit.getB(context).show) ? const Icon(
                  Icons.add,
                ) :
                const Icon(
                  Icons.edit,
                ),
              ),
            ),
      ),
    );
  }
}


