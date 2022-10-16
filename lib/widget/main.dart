import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_todo_application/const/sort_enum.dart';
import 'package:flutter_todo_application/widget/add.dart';
import 'package:flutter_todo_application/model/task.dart';
import 'package:logger/logger.dart';

var logger = Logger();

void main() {
  runApp(const MyApp());
}

/// メイン画面
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(title: 'TODO一覧'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale("ja")],
    );
  }
}

/// Main画面
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> taskList = [];
  Order _order = Order.asc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => {
              setState(() {
                _order = _order == Order.asc ? Order.desc : Order.asc;
                sort();
                logger.d("Change order is $_order");
              })
            },
            icon: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(_order == Order.asc ? pi : 0),
              child: const Icon(Icons.sort, size: 35),
            ),
          )
        ],
      ),
      body: ListView.builder(
          itemCount: taskList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.task),
                iconColor: Colors.deepOrange,
                title: Text(taskList[index].title),
                subtitle: Text("期限日:${taskList[index].deadLine}"),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Task task = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return const TodoAdd();
          }));
          setState(() {
            logger.d(task);
            taskList.add(task);
            sort();
          });
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color.fromARGB(255, 227, 227, 227),
    );
  }

  void sort() {
    setState(() {
      if (_order == Order.asc) {
        taskList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      } else {
        taskList.sort((a, b) => -a.dateTime.compareTo(b.dateTime));
      }
    });
  }
}
