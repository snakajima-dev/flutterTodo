import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_todo_application/model/task.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

var logger = Logger();

/// TODO追加画面
class TodoAdd extends StatefulWidget {
  const TodoAdd({super.key});

  @override
  State<TodoAdd> createState() => _TodoAddState();
}

class _TodoAddState extends State<TodoAdd> {
  String _text = '';
  String _deadLine = '';
  DateTime dateTime = DateTime.now();

  bool _isVisible = false;
  bool isActiveDatePicker = false;
  Random random = Random();
  final labels = [
    "資料を作成する",
    "宿題をする",
    "チケットを買う",
    "番組を録画する",
    "夜ご飯を作る",
    "子供の迎えに行く"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('TODO追加'),
        ),
        body: Container(
          padding: const EdgeInsets.all(64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "タイトル",
                    hintText: labels[random.nextInt(labels.length)]),
                onChanged: (String value) {
                  setState(() {
                    _text = value;
                  });
                  validate();
                },
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  selectDate(context);
                },
                child: TextField(
                    enabled: _isVisible,
                    controller: TextEditingController(text: _deadLine),
                    decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: _deadLine.isEmpty
                                    ? Colors.grey
                                    : Colors.deepOrange,
                                width: _deadLine.isEmpty ? 1 : 2)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelStyle: TextStyle(
                            color: _deadLine.isEmpty
                                ? Colors.black54
                                : Colors.deepOrange),
                        labelText: "期限日",
                        hintText: "期限日")),
              ),
              const SizedBox(height: 40),
              Visibility(
                  visible: _isVisible,
                  child: SlideAction(
                    height: 38,
                    sliderButtonIcon:
                        const Icon(Icons.send, color: Colors.deepOrange),
                    sliderButtonIconPadding: 7,
                    sliderButtonYOffset: 0,
                    onSubmit: () {
                      Task task = Task(
                          title: _text,
                          deadLine: _deadLine,
                          dateTime: dateTime);
                      if (!task.isValidate()) {
                        Navigator.of(context).pop(task);
                      }
                    },
                    submittedIcon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    borderRadius: 5,
                    text: 'リスト追加',
                    textStyle:
                        const TextStyle(fontSize: 15, color: Colors.white),
                  )),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text('キャンセル')),
              ),
            ],
          ),
        ));
  }

  void validate() {
    _isVisible = _deadLine.isNotEmpty && _text.isNotEmpty;
  }

  void selectDate(BuildContext ctx) async {
    var firstAndNow = DateTime.now();
    var lastSelectDate = firstAndNow.add(const Duration(days: 360));
    final DateTime? picked = await showDatePicker(
        locale: const Locale("ja"),
        context: ctx,
        initialDate: firstAndNow,
        firstDate: firstAndNow,
        lastDate: lastSelectDate);
    if (picked != null) {
      setState(() {
        _deadLine = DateFormat.yMMMd('ja').format(picked);
        dateTime = picked;
        validate();
      });
    }
  }
}
