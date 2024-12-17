import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _controller = TextEditingController();
  TodoPriority priority = TodoPriority.Normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.clear();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) => SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'Enter Your Task',
                            icon: Icon(Icons.folder),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('Select Priority', style: TextStyle(fontSize: 20),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio<TodoPriority>(
                                value: TodoPriority.Low,
                                groupValue: priority,
                                onChanged: (value) {
                                  setState(() {
                                    priority = value!;
                                  });
                                }),
                            Text(TodoPriority.Low.name),
                            Radio<TodoPriority>(
                                value: TodoPriority.Normal,
                                groupValue: priority,
                                onChanged: (value) {
                                  setState(() {
                                    priority = value!;
                                  });
                                }),
                            Text(TodoPriority.Normal.name),
                            Radio<TodoPriority>(
                                value: TodoPriority.High,
                                groupValue: priority,
                                onChanged: (value) {
                                  setState(() {
                                    priority = value!;
                                  });
                                }),
                            Text(TodoPriority.High.name),
                          ],
                        ),
                        const SizedBox(height: 80),
                        ElevatedButton(
                          onPressed: () {
                            if (_controller.text.isEmpty) {
                              showDialog(
                                  context: context, builder: (context) => AlertDialog(
                                    title: Text('Caution!'),
                                    content: Text('Input field must not be empty.'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context),
                                        child: Text('CLOSE'),
                                      ),
                                    ],
                                  ));
                            } else {
                              final todo = MyTodo(
                                id: DateTime.now().microsecondsSinceEpoch,
                                name: _controller.text,
                                priority: priority,
                              );
                              // Use the callback to update the parent
                              Navigator.pop(context,todo);
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent,),
                          child: const Text('SAVE', style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ).then((newTodo) {
            // Callback when modal is closed
            if (newTodo != null) {
              setState(() {
                MyTodo.todos.add(newTodo);
              });
            }
          });
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text('To-Do Application'),
        backgroundColor: Colors.blueAccent,
      ),
      body: MyTodo.todos.isEmpty ? const Center(
        child: Text('Nothing to do!'),)
          : ListView.builder(
              itemCount: MyTodo.todos.length,
              itemBuilder: (context, index) {
            final todo = MyTodo.todos[index];
            return TodoItem(
            todo: todo,
            onChanged: (value) {
              setState(() {
                MyTodo.todos[index].completed = value;
              });
            },
          );
        },
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  final MyTodo todo;
  final Function(bool) onChanged;

  const TodoItem({super.key, required this.todo, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: todo.completed ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CheckboxListTile(
        title: Text(todo.name),
        subtitle: Text('Priority: ${todo.priority.name}',style: TextStyle(color: Colors.white),),
        value: todo.completed,
        activeColor: Colors.black,
        onChanged: (value) {
          onChanged(value!);
        },
      ),
    );
  }
}

class MyTodo {
  int id;
  String name;
  bool completed;
  TodoPriority priority;

  MyTodo({
    required this.id,
    required this.name,
    this.completed = false,
    required this.priority,
  });

  static List<MyTodo> todos = [];
}

enum TodoPriority { Low, Normal, High }
