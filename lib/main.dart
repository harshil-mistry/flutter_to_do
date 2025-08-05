import 'package:flutter/material.dart';

void main(){
  runApp(TodoScreen());
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  TextEditingController tec1 = TextEditingController();
  var todos = ['demo1', 'demo2'];
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
              TextField(controller: tec1, onChanged: (value) => {updateTodo(value)},),
              ElevatedButton(onPressed: () => addTodo(), child: Text("Add To-do")),
              Text(str),
            ],
          ),
        )
      ),
    );
  }

  void updateTodo(value){
    print(value);
    this.setState(() {
      str = '';
    });
  }

  void addTodo(){
    print("To-do called");
    var todo = tec1.text;
    tec1.text = '';
    print(todo);
    this.setState(() {
      str = 'To-Do added';
    });
  }

}