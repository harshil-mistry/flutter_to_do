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
  var todos = [];
  String str = '';

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
        body: Center(
          child: Column(
            children: [
              // TextField(controller: tec1, onChanged: (value) => {print(value)}, )
              TextField(
                controller: tec1,
                onChanged: (value) => {updateTodo(value)},
              ),
              Padding(padding: EdgeInsetsGeometry.all(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => addTodo(),
                    child: Text("Add To-do"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.pink),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 35),
                  ElevatedButton(
                    onPressed: () => resetTodo(),
                    child: Text("Reset To-do"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsetsGeometry.all(10)),
              Text(str, style: TextStyle(color: Colors.pink)),
              Padding(padding: EdgeInsetsGeometry.all(10)),
              Expanded(
                child: Card(
                  child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(5),
                          child: ListTile(
                            leading: Icon(
                              Icons.check_circle,
                              color: Colors.pink,
                            ),
                            title: Text(todos[index]),
                            trailing: TextButton(
                              onPressed: () => {deleteTodo(index)},
                              child: Icon(Icons.delete, color: Colors.red),
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
    );
  }

  void resetTodo() {
    this.setState(() {
      todos = [];
      str = 'Khatam tata bye bye';
    });
  }

  void deleteTodo(index) {
    print(index);
    this.setState(() {
      todos.removeAt(index);
      str = 'Bhai ne bole delete matlab delete';
    });
  }

  void updateTodo(value) {
    print(value);
    this.setState(() {
      str = '';
    });
  }

  void addTodo() {
    print("To-do called");
    var todo = tec1.text;
    tec1.text = '';
    print(todo);
    if (todo == '') {
      this.setState(() {
        str = 'Gandu To-Do nakh pehla';
      });
    } else {
      this.setState(() {
        str = 'To-Do added';
        todos.add(todo);
      });
    }
  }
}
