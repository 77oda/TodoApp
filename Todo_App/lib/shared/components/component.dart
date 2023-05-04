import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../cubit/cubit.dart';




Widget buildTaskItem(Map model, context) => Dismissible(
  background: Container(
    color: Colors.red,
    child: const Center(child: Text('Delete',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 40),)),
  ),
  key: Key(model['id'].toString()),
  onDismissed: (dicoration) {
    AppCubit.get(context).deleteData(id: model['id']);
  },
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40,
          child: Text('${model['time']}'),
        ),
        const SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${model['title']}',
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold)),
              Text(
                '${model['date']}',
                style: const TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
        IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateData(status: 'done', id: model['id']);
            },
            icon: const Icon(
              Icons.check_box,
              color: Colors.green,
            )),
        IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateData(status: 'archive', id: model['id']);
            },
            icon: const Icon(
              Icons.archive,
              color: Colors.black45,
            )),
      ],
    ),
  ),
);



Widget taskBuilder({required List<Map> tasks}) => ConditionalBuilder(
    condition: tasks.isNotEmpty,
    builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsetsDirectional.only(start: 20.0),
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],
          ),
        ),
        itemCount: tasks.length),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.menu,
            size: 100,
            color: Colors.grey,
          ),
          Text(
            'No Tasks Yet, Please Add Some Tasks',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          )
        ],
      ),
    ));


Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  onSubmit,
  onChange,
  required label,
  required IconData prefix,
  bool isPassword = false,
  IconData? suffix,
  suffixPressed,
  required validate,
  onTap,
}) =>
    TextFormField(
      style: const TextStyle( color: Colors.black),
      onTap: onTap,
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmit,
      obscureText: isPassword,
      onChanged: onChange,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(onPressed: suffixPressed, icon: Icon(suffix))
            : null,
        border: const OutlineInputBorder(),
      ),
    );
