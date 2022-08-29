import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';

class ToDoCubit extends Cubit<ToDoStates>
{
  ToDoCubit() : super(ToDoInitialState());
  static ToDoCubit getB(context)=>BlocProvider.of(context);

  ///Tasks App
  int currentIndex=0;
  late Database database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archiveTasks=[];

  void changeIndex(int x)
  {
    currentIndex=x;
    emit(ToDoChangeState());
  }

  bool show=false;
  void changeShow(bool y)
  {
    show = y;
    emit(ToDoChangeState());
  }

  void createDataBase()async
  {
    openDatabase(
      'dataBase.db',
      version: 1,
      onCreate: (database,version){
        database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY ,title TEXT ,date TEXT ,time TEXT ,status TEXT)').then((value)
        {
          print("create done");
        }).catchError((error){
          print('error in on create is ${error.toString()}') ;
        });
      },
      onOpen: (database){
        getData(database);
        print("database is opened");
      },
    ).then((value) {
      database=value;
      emit(CreateDataState());
    }) ;

  }

  Future insertDataBase({
    required String title,
    required String date,
    required String time,
  })async
  {
    await database.transaction((txn) async{
      txn.rawInsert('INSERT INTO tasks (title, date, time, status) VALUES("$title", "$date", "$time", "new")').then((value)
      {
        emit(InsertState());
        getData(database);
        print('task num $value is insert');
      }).catchError((error){
        print('error in insert is ${error.toString()}');
      });
      return null;
    });
  }

  void getData(database)
  {
    doneTasks=[];
    archiveTasks=[];
    newTasks=[];
    emit(GetLoadingState());
    database.rawQuery('SELECT * FROM tasks' ).then((value) {
      value.forEach((element){
        if(element['status']=='new')
        {
          newTasks.add(element);
        }else if(element['status']=='Done')
          {
            doneTasks.add(element);
          }else
            {
              archiveTasks.add(element);
            }
      });

      print(newTasks);
      emit(GetState());
    });

  }

  void updateData({
    required String status,
    required int id,
  })async
  {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          getData(database);
      emit(UpdateState());

    });
  }

  void deleteData(int id)
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', ['$id']).then((value) {
      getData(database);
      emit(DeleteState());
    });
  }
}
