import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo.dart';

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
      theme: ThemeData(primarySwatch: Colors.pink, fontFamily: 'Roboto'),
      home: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text(
            "Asli maal niche che",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          shadowColor: Colors.black,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Enhanced TextField with modern styling
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: tec1,
                    onChanged: (value) => {updateTodo(value)},
                    decoration: InputDecoration(
                      hintText: isEditing
                          ? 'Edit your todo...'
                          : 'Add a new todo...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        isEditing ? Icons.edit : Icons.add_task,
                        color: Colors.pink,
                        size: 24,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 20),
                // Enhanced Buttons with modern styling
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => isEditing ? saveEdit() : addTodo(),
                          child: Text(
                            isEditing ? "Save Edit" : "Add To-do",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: Colors.pink.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    if (isEditing)
                      Expanded(
                        child: Container(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => cancelEdit(),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[600],
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: Colors.grey.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (!isEditing)
                      Expanded(
                        child: Container(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => resetTodo(),
                            child: Text(
                              "Reset To-do",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              elevation: 4,
                              shadowColor: Colors.red.withOpacity(0.2),
                              side: BorderSide(color: Colors.red, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 15),
                // Enhanced status message with better styling
                if (str.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.pink.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.pink, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            str,
                            style: TextStyle(
                              color: Colors.pink[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: Hive.box<Todo>('todosBox').listenable(),
                      builder: (context, Box<Todo> todos, child) {
                        if (todos.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.task_alt_rounded,
                                  size: 80,
                                  color: Colors.pink.withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Koi todo nathi haji",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Upar thi todo nakh pehla",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.all(8),
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            final todo = todos.getAt(index);
                            final isImportant = todo!.isImp;
                            final isCompleted = todo.isDone;

                            return Container(
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                border: isImportant
                                    ? Border.all(
                                        color: Colors.orange.withOpacity(0.5),
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: GestureDetector(
                                  onTap: () => toggleComplete(index),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isCompleted
                                          ? Colors.green[500]
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isCompleted
                                            ? Colors.green[500]!
                                            : Colors.pink,
                                        width: 2,
                                      ),
                                    ),
                                    child: isCompleted
                                        ? Icon(
                                            Icons.check,
                                            size: 18,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    if (isImportant)
                                      Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.orange[600],
                                          size: 18,
                                        ),
                                      ),
                                    Expanded(
                                      child: Text(
                                        todo.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          decoration: isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          color: isCompleted
                                              ? Colors.grey[500]
                                              : Colors.grey[800],
                                          fontWeight: isImportant
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: SizedBox(
                                  width: 110,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () => toggleImportant(index),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(
                                            isImportant
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.orange[600],
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => toggleEdit(index),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.blue[600],
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      if (index != editingIndex)
                                        InkWell(
                                          onTap: () => deleteTodo(index),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red[500],
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
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
    final todosBox = Hive.box<Todo>('todosBox');
    todosBox.clear();
    this.setState(() {
      str = 'Khatam tata bye bye';
    });
  }

  void deleteTodo(index) {
    final todosBox = Hive.box<Todo>('todosBox');
    todosBox.deleteAt(index);
    print("$index : Deleted");
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

  void toggleEdit(int index) {
    setState(() {
      if (isEditing && editingIndex == index) {
        cancelEdit();
      } else {
        isEditing = true;
        editingIndex = index;
        final todosBox = Hive.box<Todo>('todosBox');
        tec1.text = todosBox.getAt(index)!.title;
        str = 'Editing todo...';
      }
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

      str = is_cmpleted ? 'Todo completed!' : 'Todo marked as incomplete!';
    });
  }
}
