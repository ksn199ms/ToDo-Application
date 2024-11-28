import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data/database.dart';
import 'package:todo/utils/dialog_box.dart';
import 'package:todo/utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _mybox = Hive.box('mybox');
  final _controller = TextEditingController();
  ToDoDatabase db = ToDoDatabase();
  @override
  void initState() {
    super.initState();
    // if this is the 1st time ever open in the app, then create default data
    if (_mybox.get("TODOLIST") == null) {
      db.createIntialData();
    } else {
      // there already exists data
      db.loadData();
    }
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.ToDoList[index][1] = !db.ToDoList[index][1];
    });
    db.updateDatabase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void saveNewTask() {
    setState(() {
      db.ToDoList.add([_controller.text, false]);
    });
    Navigator.of(context).pop();
    _controller.clear();
    db.updateDatabase();
  }

  void deleteTask(int index) {
    setState(() {
      db.ToDoList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[300],
      appBar: AppBar(
        title: Text('To Do'),
        centerTitle: true,
        backgroundColor: Colors.yellow,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.ToDoList.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: db.ToDoList[index][0],
            taskCompleted: db.ToDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
