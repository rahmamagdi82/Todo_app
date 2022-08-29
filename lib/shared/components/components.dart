import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../cubit/cubit.dart';

Widget defultTextFormFeild({
  required String? Function(String?) validate,
  required TextEditingController control,
  required TextInputType type,
  bool obscure = false,
  required String lable,
  required IconData prefix,
  IconData? suffix,
  Function? show,
  Function? tap,
  Function? submit,
}) =>
    TextFormField(
      validator: validate,
      controller: control,
      keyboardType: type,
      obscureText: obscure,
      onTap: () {
        tap!();
      },
      onFieldSubmitted: (s) {
        submit!(s);
      },
      decoration: InputDecoration(
        labelText: lable,
        prefixIcon: Icon(prefix),
        suffixIcon: (suffix == null)
            ? null
            : IconButton(
                onPressed: () {
                  show!();
                },
                icon: Icon(suffix),
              ),
        border: OutlineInputBorder(),
      ),
    );

//UniqueKey(),
Widget buildTasks(Map data, context) => Padding(
  padding: const EdgeInsets.all(15.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 40.0,
        backgroundColor: Colors.blue,
        child: Text(
          '${data['time']}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
      ),
      const SizedBox(
        width: 10.0,
      ),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${data['title']}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              '${data['date']}',
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
      IconButton(
        iconSize: 25.0,
        onPressed: () {
          ToDoCubit.getB(context)
              .updateData(status: 'Done', id: data['id']);
        },
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
      ),
      IconButton(
        iconSize: 25.0,
        onPressed: () {
          ToDoCubit.getB(context)
              .updateData(status: 'Archive', id: data['id']);
        },
        icon: const Icon(
          Icons.archive,
          color: Colors.black54,
        ),
      ),
      IconButton(
        iconSize: 25.0,
        onPressed: () {
          ToDoCubit.getB(context).deleteData(data['id']);
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),

    ],
  ),
);

Widget taskList(List<Map> myList) => ConditionalBuilder(
      builder: (BuildContext context) {
        return ListView.separated(
          itemBuilder: (context, index) {
            return buildTasks(myList[index], context);
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                width: double.infinity,
                height: 1.5,
                color: Colors.grey,
              ),
            );
          },
          itemCount: myList.length,
        );
      },
      condition: myList.length > 0,
      fallback: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.menu,
                size: 40.0,
                color: Colors.grey,
              ),
              Text(
                'No Tasks Yet, Please Enter Some Tasks',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        );
      },
    );
