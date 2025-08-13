import 'package:flutter/material.dart';

void main() {
  runApp(TodoScreen());
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TextEditingController tec1 = TextEditingController();
  var todos = <Map<String, dynamic>>[];
  String str = '';
  int? editingIndex;
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
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
        //Basic Padding
        body: Padding(
          padding: EdgeInsetsGeometry.all(15),
          child: Center(
            child: Column(
              children: [

                //Input Field for the todos
                TextField(
                  controller: tec1,
                  onChanged: (value) => updateTodo(value),
                  decoration: InputDecoration(
                    hintText: isEditing
                        ? 'Edit your todo...'
                        : 'Add a new todo...',
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),

                //Padding between buttons and Input Filed
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
                    //For adding some space between Buttons
                    SizedBox(width: 35),
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
                Padding(padding: EdgeInsets.all(10)),
                Text(str, style: TextStyle(color: Colors.pink)),
                Padding(padding: EdgeInsets.all(10)),

                // Actual Todo List
                Expanded(
                  child: Card(
                    child: todos.isEmpty
                        //In case no todos are added yet
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.task_alt,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "No todos yet!",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Add your first todo above",
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          )

                        //When todos are added
                        : ListView.builder(
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              final todo = todos[index];
                              final isImportant = todo['important'] ?? false;
                              final isCompleted = todo['completed'] ?? false;

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
                                        Expanded(
                                          child: Text(
                                            todo['text'],
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
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              toggleImportant(index),
                                          child: Icon(
                                            isImportant
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () => startEdit(index),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () => deleteTodo(index),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
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
    setState(() {
      todos = [];
      str = 'Bus badhu khatam have 💔';
    });
  }

  void deleteTodo(index) {
    setState(() {
      todos.removeAt(index);
      str = 'Todo deleted successfully!';
    });
  }

  void updateTodo(value) {
    setState(() {
      str = '';
    });
  }

  void addTodo() {
    var todo = tec1.text;
    if (todo == '') {
      setState(() {
        str = 'Gandu todo nakh pehla';
      });
    } else {
      setState(() {
        str = 'Todo added successfully!';
        todos.add({'text': todo, 'important': false, 'completed': false});
        tec1.clear();
      });
    }
  }

  void startEdit(int index) {
    setState(() {
      isEditing = true;
      editingIndex = index;
      tec1.text = todos[index]['text'];
      str = 'Party badal liya sala';
    });
  }

  void saveEdit() {
    var todo = tec1.text;
    if (todo.isEmpty) {
      setState(() {
        str = 'Gandu To-do nakh pehla!';
      });
    } else if (editingIndex != null) {
      setState(() {
        todos[editingIndex!]['text'] = todo;
        isEditing = false;
        editingIndex = null;
        tec1.clear();
        str = 'Done che bhai!';
      });
    }
  }

  void cancelEdit() {
    setState(() {
      isEditing = false;
      editingIndex = null;
      tec1.clear();
      str = 'Bus ne bhai, cancel kari didhu';
    });
  }

  void toggleImportant(int index) {
    setState(() {
      todos[index]['important'] = !todos[index]['important'];
      str = todos[index]['important']
          ? 'Todo is def imp'
          : 'Chal hatt b.k.l...';
    });
  }

  void toggleComplete(int index) {
    setState(() {
      todos[index]['completed'] = !todos[index]['completed'];
      str = todos[index]['completed']
          ? 'Hais Patyu'
          : 'Not yet brother';
    });
  }
}
