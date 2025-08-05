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
          title: Text("Asli maal niche che"),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => addTodo(),
                    child: Text("Add To-do"),
                  ),
                  const SizedBox(width: 35),
                  ElevatedButton(
                    onPressed: () => resetTodo(),
                    child: Text("Reset To-do"),
                  ),
                ],
              ),
              Text(str),
              Expanded(
                child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.arrow_circle_right),
                      title: Text(todos[index]),
                      trailing: TextButton(
                        onPressed: () => {deleteTodo(index)},
                        child: Icon(Icons.delete),
                      ),
                    );
                  },
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
    });
  }

  void deleteTodo(index) {
    print(index);
    this.setState(() {
      todos.removeAt(index);
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
        str = 'Please enter a To-Do first';
      });
    } else {
      this.setState(() {
        str = 'To-Do added';
        todos.add(todo);
      });
    }
  }
}
