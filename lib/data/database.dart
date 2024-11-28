import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List ToDoList = [];
  final _mybox = Hive.box('mybox');
  void createIntialData() {
    ToDoList = [
      ["Do Coding", false],
      ["Go To Gym", false],
    ];
  }

  void loadData() {
    ToDoList = _mybox.get('TODOLIST');
  }

  void updateDatabase() {
    _mybox.put('TODOLIST', ToDoList);
  }
}
