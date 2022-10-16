class Task {
  Task({required this.title, required this.deadLine, required this.dateTime});

  String title;
  String deadLine;
  DateTime dateTime;

  bool isValidate() {
    bool isError = false;
    if (title.isEmpty || deadLine.isEmpty) {
      isError = true;
      throw Exception("Title or date entry is empty!");
    }
    return isError;
  }

  @override
  String toString() {
    return "Task(title:$title, deadLine:$deadLine, dateTime:$dateTime)";
  }
}
