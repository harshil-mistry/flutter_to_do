import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/todo.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todosBox');
  runApp(TodoScreen());
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TextEditingController tec1 = TextEditingController();
  String str = '';
  int? editingIndex;
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    print("Method called");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text(
            "Asli maal niche che",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          shadowColor: Colors.black,
          elevation: 5,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                // TextField(controller: tec1, onChanged: (value) => {print(value)}, )
                TextField(
                  controller: tec1,
                  onChanged: (value) => {updateTodo(value)},
                  decoration: InputDecoration(
                    hintText: isEditing
                        ? 'Edit your todo...'
                        : 'Add a new todo...',
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => isEditing ? saveEdit() : addTodo(),
                      child: Text(isEditing ? "Save Edit" : "Add To-do"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.pink),
                        foregroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 35),
                    if (isEditing)
                      ElevatedButton(
                        onPressed: () => cancelEdit(),
                        child: Text("Cancel"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.grey,
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                        ),
                      ),
                    if (!isEditing)
                      ElevatedButton(
                        onPressed: () => resetTodo(),
                        child: Text("Reset To-do"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(padding: EdgeInsetsGeometry.all(10)),
                Text(str, style: TextStyle(color: Colors.pink)),
                Padding(padding: EdgeInsetsGeometry.all(10)),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box<Todo>('todosBox').listenable(),
                    builder: (context, Box<Todo> todos, child) {
                      return ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todos.getAt(index);
                          final isImportant = todo!.isImp;
                          final isCompleted = todo.isDone;

                          return Card(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: ListTile(
                                leading: GestureDetector(
                                  onTap: () => toggleComplete(index),
                                  child: Icon(
                                    isCompleted
                                        ? Icons.check_circle
                                        : Icons.check_circle_outline,
                                    color: isCompleted
                                        ? Colors.green
                                        : Colors.pink,
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    if (isImportant)
                                      Padding(
                                        padding: EdgeInsets.only(right: 4),
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.orange,
                                          size: 16,
                                        ),
                                      ),
                                    Expanded(
                                      child: Text(
                                        todo.title,
                                        style: TextStyle(
                                          decoration: isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          color: isCompleted
                                              ? Colors.grey[500]
                                              : Colors.black,
                                          fontWeight: isImportant
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () => toggleImportant(index),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Icon(
                                            isImportant
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.orange,
                                            size: 23,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => startEdit(index),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                            size: 23,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => deleteTodo(index),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 23,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resetTodo() {
    final todosBox = Hive.box<Todo>('todosBox');
    todosBox.clear();
    this.setState(() {
      str = 'Khatam tata bye bye';
    });
  }

  void deleteTodo(index) {
    final todosBox = Hive.box<Todo>('todosBox');
    todosBox.deleteAt(index);
    print(index + " : Deleted");
    this.setState(() {
      str = 'Bhai ne bole delete matlab delete';
    });
  }

  //This is not the actual update function
  void updateTodo(value) {
    print(value);
    this.setState(() {
      str = '';
    });
  }

  void addTodo() async {
    print("To-do called");
    var todo = tec1.text;

    tec1.text = '';
    print(todo);
    if (todo == '') {
      this.setState(() {
        str = 'Gandu To-Do nakh pehla';
      });
    } else {
      var newTodo = Todo(title: todo);
      final todosBox = Hive.box<Todo>('todosBox');
      int key = await todosBox.add(newTodo);
      print("Key : $key");
      this.setState(() {
        str = 'To-Do added';
      });
    }
  }

  void startEdit(int index) {
    setState(() {
      isEditing = true;
      editingIndex = index;
      final todosBox = Hive.box<Todo>('todosBox');
      tec1.text = todosBox.getAt(index)!.title;
      str = 'Editing todo...';
    });
  }

  void saveEdit() {
    var todo = tec1.text;
    if (todo.isEmpty) {
      setState(() {
        str = 'Gandu To-Do nakh pehla';
      });
    } else if (editingIndex != null) {
      setState(() {
        final todosBox = Hive.box<Todo>('todosBox');
        final old_todo = todosBox.getAt(editingIndex!);
        old_todo!.title = todo;
        old_todo.save();
        isEditing = false;
        editingIndex = null;
        tec1.text = '';
        str = 'To-Do updated';
      });
    }
  }

  void cancelEdit() {
    setState(() {
      isEditing = false;
      editingIndex = null;
      tec1.text = '';
      str = 'Edit cancelled';
    });
  }

  void toggleImportant(int index) {
    setState(() {
      final todosBox = Hive.box<Todo>('todosBox');
      final temptodo = todosBox.getAt(index)!;
      temptodo.isImp = !temptodo.isImp; 
      temptodo.save();
      bool is_imp = temptodo.isImp;
      str = is_imp
          ? 'Todo marked as important!'
          : 'Todo removed from important!';
    });
  }

  void toggleComplete(int index) {
    setState(() {
      final todosBox = Hive.box<Todo>('todosBox');
      final temptodo = todosBox.getAt(index);
      temptodo!.isDone = !temptodo.isDone;
      temptodo.save();
      bool is_cmpleted = temptodo.isDone;

      str = is_cmpleted
          ? 'Todo completed!'
          : 'Todo marked as incomplete!';
    });
  }
}
